// lib/services/mistral_service.dart - Updated to handle optional interesting fact

import 'dart:convert';
import 'dart:async';
import 'package:http/http.dart' as http;
import 'package:flutter/foundation.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class MistralService {
  // Get API key from environment variables
  static String getApiKey() {
    final envKey = dotenv.env['MISTRAL_API_KEY'];
    if (envKey != null &&
        envKey.isNotEmpty &&
        envKey != 'your_mistral_api_key_here') {
      debugPrint('Using Mistral API key from environment variables');
      return envKey;
    }
    debugPrint('WARNING: Mistral API key not found!');
    return '';
  }

  // Mistral API base URL
  static const String baseUrl = 'https://api.mistral.ai/v1';

  /// Verify API key is valid
  static Future<bool> verifyApiKey() async {
    try {
      final apiKey = getApiKey();
      if (apiKey.isEmpty) {
        debugPrint('❌ Mistral API key is empty');
        return false;
      }

      final response = await http.post(
        Uri.parse('$baseUrl/chat/completions'),
        headers: {
          'Authorization': 'Bearer $apiKey',
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'model': 'mistral-tiny',
          'messages': [
            {'role': 'user', 'content': 'Hello'}
          ],
          'max_tokens': 5,
        }),
      );

      return response.statusCode == 200;
    } catch (error) {
      debugPrint('❌ Error verifying Mistral API key: $error');
      return false;
    }
  }

  /// Generate a story from questionnaire inputs
  /// interestingFact is now optional and can be null or empty
  static Future<String?> generateStory({
    required String name,
    required String place,
    required String connection,
    String? interestingFact, // Made optional
    required String language,
  }) async {
    try {
      debugPrint('🔄 Generating story in language: $language');

      final apiKey = getApiKey();
      if (apiKey.isEmpty) {
        debugPrint('❌ Mistral API key is empty');
        return null;
      }

      final prompt =
          _createPrompt(name, place, connection, interestingFact, language);
      final systemPrompt = _getSystemPrompt(language);

      final response = await http
          .post(
            Uri.parse('$baseUrl/chat/completions'),
            headers: {
              'Authorization': 'Bearer $apiKey',
              'Content-Type': 'application/json',
            },
            body: jsonEncode({
              'model': 'mistral-tiny',
              'messages': [
                {'role': 'system', 'content': systemPrompt},
                {'role': 'user', 'content': prompt}
              ],
              'max_tokens': 200,
              'temperature': 0.1,
            }),
          )
          .timeout(const Duration(seconds: 30));

      if (response.statusCode == 200) {
        final responseData = jsonDecode(response.body);
        final story =
            responseData['choices'][0]['message']['content'].toString().trim();
        debugPrint('✅ Story generated successfully');
        return story;
      } else {
        debugPrint('❌ Failed to generate story (${response.statusCode})');
        return null;
      }
    }on TimeoutException catch (_)
    {
      debugPrint('❌ timeout error');
      return null;
    }
      catch (error) {
      debugPrint('❌ Error generating story: $error');
      return null;
    }
  }

  /// Create language-specific prompt with optional interesting fact
  static String _createPrompt(String name, String place, String connection,
      String? interestingFact, String language) {
    // Check if interesting fact is provided and not empty
    final hasInterestingFact =
        interestingFact != null && interestingFact.trim().isNotEmpty;

    if (language == 'de') {
      String prompt = '''
Erstelle eine schöne Geschichte von 4 Sätzen über die Verbindung einer Person zu ihrem Lieblingsort.

Name: $name
Lieblingsort: $place
Persönliche Verbindung: $connection''';

      // Only include interesting fact if provided
      if (hasInterestingFact) {
        prompt += '\nInteressante Tatsache: $interestingFact';
      }

      prompt +=
          '\n\nSchreibe die Geschichte in der erste Person auf Deutsch.';

      if (!hasInterestingFact) {
        prompt += ' Konzentriere dich auf die persönliche Verbindung zum Ort.';
      }

      return prompt;
    } else {
      String prompt = '''
Create a beautiful 4 sentence story about a person's connection to their favorite place.

Name: $name
Favorite Place: $place
Personal Connection: $connection''';

      // Only include interesting fact if provided
      if (hasInterestingFact) {
        prompt += '\nInteresting Fact: $interestingFact';
      }

      prompt += '\n\nWrite the story in first person.';

      if (!hasInterestingFact) {
        prompt += ' Focus on the personal connection to the place.';
      }

      return prompt;
    }
  }

  /// Get language-specific system prompt
  static String _getSystemPrompt(String language) {
    if (language == 'de') {
      return 'Sie sind ein Mitglied der Familie und teilen Ihre persönlichen Geschichten mit Ihren Lieben. Verwenden Sie die bereitgestellten Informationen, um herzliche, persönliche Geschichten zu schreiben. Schreiben Sie die Geschichte im Stil eines Erzählers, in der ersten Person, mit 4 Sätzen, und fügen Sie keine neuen Elemente hinzu.';
    } else {
      return 'You are a member of the family and share your personal stories with your loved ones. Use the information provided to write heartfelt, personal stories. Write the story in the style of a narrator, as first person, using 4 sentences, and do not add any new elements.';
    }
  }
}