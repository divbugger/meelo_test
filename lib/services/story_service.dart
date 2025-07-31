// lib/services/story_service.dart - Updated to handle optional interesting fact

import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:flutter/foundation.dart';
import 'package:uuid/uuid.dart';
import 'package:http/http.dart' as http;
import 'package:meelo/services/elevenlabs_service.dart';
import 'package:meelo/services/mistral_service.dart';
import 'package:meelo/services/language_service.dart';

class StoryService {
  final SupabaseClient _supabase = Supabase.instance.client;
  final LanguageService _languageService;

  // Constructor that takes language service
  StoryService(this._languageService);

  /// Get current language from language service
  String get _currentLanguage => _languageService.currentLocale.languageCode;

  /// Fetches all stories from Supabase
  Future<List<Map<String, dynamic>>> fetchStories() async {
    try {
      final res = await _supabase
          .from('stories')
          .select()
          .order('created_at', ascending: false);

      return List<Map<String, dynamic>>.from(res);
    } catch (error) {
      debugPrint('Error fetching stories: $error');
      throw Exception('Failed to load stories');
    }
  }

  /// Creates a new story with AI-generated content and audio
  Future<void> createStory(Map<String, dynamic> storyData) async {
    try {
      final language = _currentLanguage;
      debugPrint('🔄 Creating story in language: $language');

      // Handle optional interesting fact
      final interestingFact = storyData['interesting_fact'] as String?;
      final hasInterestingFact =
          interestingFact != null && interestingFact.trim().isNotEmpty;

      debugPrint('📝 Interesting fact provided: $hasInterestingFact');

      // Generate story using Mistral LLM with optional interesting fact
      final generatedStory = await MistralService.generateStory(
        name: storyData['storyteller_name'],
        place: storyData['place_name'],
        connection: storyData['personal_connection'],
        interestingFact: hasInterestingFact ? interestingFact : null,
        language: language,
      );

      if (generatedStory != null) {
        storyData['generated_story'] = generatedStory;
        storyData['structured_narrative'] =
            generatedStory; // For backward compatibility
        storyData['language'] = language;

        // Generate audio using ElevenLabs
        final audioData = await ElevenLabsService.generateAudio(
          generatedStory,
          language: language,
        );

        if (audioData != null) {
          // Upload audio to Supabase Storage
          final uuid = const Uuid().v4();
          final fileName = 'story_$uuid.mp3';

          await _supabase.storage
              .from('story_audio')
              .uploadBinary(fileName, audioData);

          final audioUrl =
              _supabase.storage.from('story_audio').getPublicUrl(fileName);

          storyData['audio_url'] = audioUrl;
          debugPrint('🎵 Audio uploaded successfully');
        }

        // Insert story into Supabase
        await _supabase.from('stories').insert(storyData);
        debugPrint('✅ Story created successfully');
      } else {
        throw Exception('Failed to generate story with AI');
      }
    } catch (error) {
      debugPrint('Error creating story: $error');
      throw Exception('Failed to create story: $error');
    }
  }

  /// Updates an existing story
  Future<void> updateStory(
    int id,
    Map<String, dynamic> storyData, {
    bool regenerateStory = false,
    bool regenerateAudio = false,
  }) async {
    try {
      final language = _currentLanguage;
      debugPrint('🔄 Updating story in language: $language');

      // Check if we need to regenerate the story
      if (regenerateStory) {
        // Handle optional interesting fact
        final interestingFact = storyData['interesting_fact'] as String?;
        final hasInterestingFact =
            interestingFact != null && interestingFact.trim().isNotEmpty;

        debugPrint('📝 Updating with interesting fact: $hasInterestingFact');

        final generatedStory = await MistralService.generateStory(
          name: storyData['storyteller_name'],
          place: storyData['place_name'],
          connection: storyData['personal_connection'],
          interestingFact: hasInterestingFact ? interestingFact : null,
          language: language,
        );

        if (generatedStory != null) {
          storyData['generated_story'] = generatedStory;
          storyData['structured_narrative'] = generatedStory;
          storyData['language'] = language;
          regenerateAudio = true; // Force audio regeneration
        } else {
          throw Exception('Failed to regenerate story with AI');
        }
      }

      // Check if we need to regenerate audio
      if (regenerateAudio) {
        String storyContent;

        if (regenerateStory) {
          storyContent = storyData['generated_story'];
        } else {
          // Get existing story content
          final currentStory = await _supabase
              .from('stories')
              .select('generated_story')
              .eq('id', id)
              .single();
          storyContent = currentStory['generated_story'] ?? '';
        }

        if (storyContent.isNotEmpty) {
          // Delete old audio file
          await _deleteOldAudioFile(id);

          // Generate new audio
          final audioData = await ElevenLabsService.generateAudio(
            storyContent,
            language: language,
          );

          if (audioData != null) {
            final uuid = const Uuid().v4();
            final fileName = 'story_$uuid.mp3';

            await _supabase.storage
                .from('story_audio')
                .uploadBinary(fileName, audioData);

            final audioUrl =
                _supabase.storage.from('story_audio').getPublicUrl(fileName);

            storyData['audio_url'] = audioUrl;
          }
        }
      }

      // Update story in Supabase
      await _supabase.from('stories').update(storyData).eq('id', id);
      debugPrint('✅ Story updated successfully');
    } catch (error) {
      debugPrint('Error updating story: $error');
      throw Exception('Failed to update story: $error');
    }
  }

  /// Helper method to delete old audio file
  Future<void> _deleteOldAudioFile(int storyId) async {
    try {
      final story = await _supabase
          .from('stories')
          .select('audio_url')
          .eq('id', storyId)
          .single();

      if (story['audio_url'] != null) {
        final Uri uri = Uri.parse(story['audio_url']);
        final String path = uri.pathSegments.last;

        await _supabase.storage.from('story_audio').remove([path]);
        debugPrint('🗑️ Old audio file deleted');
      }
    } catch (e) {
      debugPrint('Warning: Could not delete old audio file: $e');
    }
  }

  /// Deletes a story and its audio file
  Future<void> deleteStory(int id) async {
    try {
      await _deleteOldAudioFile(id);
      await _supabase.from('stories').delete().eq('id', id);
      debugPrint('✅ Story deleted successfully');
    } catch (error) {
      debugPrint('Error deleting story: $error');
      throw Exception('Failed to delete story: $error');
    }
  }

  /// Downloads audio file from URL
  Future<Uint8List?> downloadAudio(String url) async {
    try {
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        return response.bodyBytes;
      }
      return null;
    } catch (error) {
      debugPrint('Error downloading audio: $error');
      return null;
    }
  }

  /// Test both Mistral and ElevenLabs services
  Future<Map<String, bool>> testServices() async {
    final results = <String, bool>{};

    try {
      results['mistral'] = await MistralService.verifyApiKey();
    } catch (e) {
      results['mistral'] = false;
    }

    try {
      results['elevenlabs'] = await ElevenLabsService.verifyApiKey();
    } catch (e) {
      results['elevenlabs'] = false;
    }

    return results;
  }
}