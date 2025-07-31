// lib/services/elevenlabs_service.dart - Complete ElevenLabs service with language support

import 'dart:convert';
import 'dart:async';
import 'package:http/http.dart' as http;
import 'package:flutter/foundation.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class ElevenLabsService {
  // Get API key from environment variables (more secure)
  static String getApiKey() {
    // Try to get from .env file
    final envKey = dotenv.env['ELEVENLABS_API_KEY'];

    // Log whether we found a key for debugging
    if (envKey != null && envKey.isNotEmpty && envKey != 'your_api_key_here') {
      debugPrint('Using ElevenLabs API key from environment variables');
      return envKey;
    } else {
      debugPrint(
        'WARNING: ElevenLabs API key not found or is default placeholder!',
      );
    }

    // Check if we're in debug mode
    if (kDebugMode) {
      // Only print this warning in debug mode
      debugPrint(
        '⚠️ No API key found - please add your ElevenLabs API key to dotenv.env file',
      );
    }

    // Fallback to empty key (will fail gracefully)
    return '';
  }

  // ElevenLabs API base URL
  static const String baseUrl = 'https://api.elevenlabs.io/v1';

  // Voice IDs for different languages
  static const Map<String, String> voiceIds = {
    'en': 'XB0fDUnXU5powFXDhCwa', // Charlotte - English
    'de': 'Z3R5wn05IrDiVCyEkUrK', // Arabella - German (multilingual)
  };

  /// Get voice ID based on language
  static String getVoiceId(String language) {
    return voiceIds[language] ?? voiceIds['en']!;
  }

  /// Verify API key is valid before attempting generation
  static Future<bool> verifyApiKey() async {
    try {
      final apiKey = getApiKey();

      // Early check for empty key
      if (apiKey.isEmpty) {
        debugPrint('❌ ElevenLabs API key is empty - cannot verify');
        return false;
      }

      debugPrint('🔑 Verifying API key: ${_maskApiKey(apiKey)}');

      // Call user endpoint to verify key
      final response = await http.get(
        Uri.parse('$baseUrl/user'),
        headers: {
          'xi-api-key': apiKey,
          'Accept': 'application/json',
          'User-Agent': 'Flutter/ElevenLabsApp', // Add proper user agent
        },
      );

      debugPrint('🔍 API response code: ${response.statusCode}');

      // Log verification results with more details
      if (response.statusCode == 200) {
        debugPrint('✅ ElevenLabs API key verification successful');

        // Log subscription info for debugging
        try {
          final userData = jsonDecode(response.body);
          final subscription = userData['subscription'];
          if (subscription != null) {
            debugPrint(
              '📊 ElevenLabs account status: ${subscription['status']}',
            );
            debugPrint(
              '📊 Character quota: ${subscription['character_count']} / ${subscription['character_limit']}',
            );
          }
        } catch (e) {
          // Non-critical error, so just log it
          debugPrint('Warning: Could not parse user data: $e');
        }
        return true;
      } else if (response.statusCode == 401) {
        // Common unauthorized error - clear invalid API key message
        debugPrint('❌ ElevenLabs API key is invalid or unauthorized (401)');
        debugPrint('🔑 Please check your API key format and permissions');
        return false;
      } else {
        // Print detailed error for debugging
        debugPrint(
          '❌ ElevenLabs API key verification failed (${response.statusCode})',
        );

        // Try to parse error message
        try {
          final error = jsonDecode(response.body);
          final errorDetail =
              error['detail'] ?? error['message'] ?? 'Unknown error';
          debugPrint('🔍 Error detail: $errorDetail');
        } catch (e) {
          // If can't parse JSON, use raw body
          debugPrint('🔍 Raw error (not JSON): ${_truncateLog(response.body)}');
        }

        return false;
      }
    } catch (error) {
      debugPrint('❌ Error verifying API key: $error');
      if (error.toString().contains('SocketException') ||
          error.toString().contains('Connection refused')) {
        debugPrint('🌐 Network error: Check your internet connection');
      }
      return false;
    }
  }

  /// Helper to mask API key for safe logging
  static String _maskApiKey(String apiKey) {
    if (apiKey.length <= 8) return '****';
    return '${apiKey.substring(0, 4)}...${apiKey.substring(apiKey.length - 4)}';
  }

  /// Helper to truncate log messages
  static String _truncateLog(String text) {
    const maxLength = 500;
    if (text.length <= maxLength) return text;
    return '${text.substring(0, maxLength)}... (truncated)';
  }

  /// Generates audio from text using ElevenLabs API with language support
  static Future<Uint8List?> generateAudio(String text,
      {String language = 'en'}) async {
    try {
      // Log the start of audio generation
      debugPrint('🔄 Starting audio generation with ElevenLabs...');

      final apiKey = getApiKey();

      // More comprehensive key validation
      if (apiKey.isEmpty) {
        debugPrint('❌ ERROR: ElevenLabs API key is empty or invalid');
        return null;
      }

      // Log the text length for debugging
      debugPrint('📝 Text length for TTS: ${text.length} characters');

      // Verify API key before proceeding (but don't block if it fails)
      final isKeyValid = await verifyApiKey();
      if (!isKeyValid) {
        debugPrint(
          '⚠️ WARNING: ElevenLabs API key verification failed, but will try TTS anyway',
        );
        // Continue anyway - sometimes the verification fails but TTS still works
      }

      // ElevenLabs API endpoint for text-to-speech with language-specific voice
      final voiceId = getVoiceId(language);
      final url = '$baseUrl/text-to-speech/$voiceId';
      debugPrint(
          '📤 Sending TTS request to: $url (Language: $language, Voice: $voiceId)');

      // Limit text length to prevent large requests
      if (text.length > 5000) {
        debugPrint(
          '⚠️ Text too long (${text.length} chars), truncating to 5000 chars',
        );
        text = text.substring(0, 5000);
      }

      // ElevenLabs API request body with language-specific model
      final modelId =
          language == 'de' ? 'eleven_multilingual_v2' : 'eleven_monolingual_v1';
      final body = jsonEncode({
        'text': text,
        'model_id': modelId,
        'voice_settings': {
          'stability': 0.75,
          'similarity_boost': 0.75,
          'style': 0.0,
          'use_speaker_boost': true
        },
      });

      // Set timer to track response time
      final startTime = DateTime.now();

      // Send the request to ElevenLabs API
      final response = await http
          .post(
        Uri.parse(url),
        headers: {
          'Content-Type': 'application/json',
          'xi-api-key': apiKey,
          'Accept': 'audio/mpeg', // Explicitly request MP3 format
          'User-Agent': 'Flutter/ElevenLabsApp',
        },
        body: body,
      )
          .timeout(
        const Duration(seconds: 30),
        onTimeout: () {
          debugPrint('⚠️ Request timeout after 30 seconds');
          throw TimeoutException('Request timeout after 30 seconds');
        },
      );

      // Calculate response time
      final endTime = DateTime.now();
      final duration = endTime.difference(startTime);

      debugPrint(
        '⏱️ ElevenLabs API response time: ${duration.inMilliseconds}ms',
      );
      debugPrint('🔍 Response status code: ${response.statusCode}');

      // Check if the request was successful
      if (response.statusCode == 200) {
        final contentType = response.headers['content-type'];
        debugPrint('🔍 Content-Type: $contentType');

        // Check if response is audio
        if (contentType != null && contentType.contains('audio/')) {
          final bytes = response.bodyBytes;
          debugPrint(
            '✅ Audio generated successfully (${bytes.lengthInBytes} bytes)',
          );

          // Check if we got actual audio data with a minimum expected size
          if (bytes.lengthInBytes > 100) {
            // A valid MP3 should be larger than this
            return bytes;
          } else {
            debugPrint(
              '⚠️ Audio data too small (${bytes.lengthInBytes} bytes), may be invalid',
            );
            return null;
          }
        } else {
          debugPrint('❌ Response is not audio: Content-Type=$contentType');
          debugPrint('Response body preview: ${_truncateLog(response.body)}');
          return null;
        }
      } else if (response.statusCode == 401) {
        debugPrint('❌ Authentication failed (401): Your API key is invalid');
        return null;
      } else {
        debugPrint('❌ Failed to generate audio (${response.statusCode})');

        // Try to parse error message
        try {
          final error = jsonDecode(response.body);
          final errorDetail =
              error['detail'] ?? error['message'] ?? 'Unknown error';
          debugPrint('🔍 Error detail: $errorDetail');
        } catch (e) {
          // If can't parse JSON, just log
          debugPrint('Could not parse error response: $e');
        }

        return null;
      }
    } catch (error) {
      debugPrint('❌ Error generating audio: $error');

      // Handle common errors with better messages
      if (error.toString().contains('SocketException') ||
          error.toString().contains('Connection refused')) {
        debugPrint('🌐 Network error: Check your internet connection');
      } else if (error.toString().contains('TimeoutException')) {
        debugPrint(
          '⏱️ Request timed out: ElevenLabs API may be slow or unresponsive',
        );
      }

      return null;
    }
  }

  /// Get available voices from ElevenLabs API
  static Future<List<Map<String, dynamic>>> getVoices() async {
    try {
      final apiKey = getApiKey();

      // Check for empty key
      if (apiKey.isEmpty) {
        debugPrint('❌ ElevenLabs API key is empty - cannot fetch voices');
        return [];
      }

      // ElevenLabs API endpoint for voices
      const url = '$baseUrl/voices';

      // Send the request to ElevenLabs API
      final response = await http.get(
        Uri.parse(url),
        headers: {'xi-api-key': apiKey},
      );

      // Check if the request was successful
      if (response.statusCode == 200) {
        // Parse the response
        final data = jsonDecode(response.body);

        // Extract voices
        final voices = data['voices'] as List;

        debugPrint(
          '✅ Successfully retrieved ${voices.length} voices from ElevenLabs',
        );
        return voices.map((voice) => voice as Map<String, dynamic>).toList();
      } else {
        debugPrint('❌ Failed to get voices (${response.statusCode})');
        return [];
      }
    } catch (error) {
      debugPrint('❌ Error getting voices: $error');
      return [];
    }
  }

  /// Helper to get a shorter text sample for testing
  static String getSampleText([String language = 'en']) {
    if (language == 'de') {
      return "Das ist ein Test der ElevenLabs Text-zu-Sprache API Integration. Wenn Sie diese Nachricht hören können, funktioniert die API korrekt.";
    }
    return "This is a test of the ElevenLabs text-to-speech API integration. If you can hear this message, the API is working correctly.";
  }
}