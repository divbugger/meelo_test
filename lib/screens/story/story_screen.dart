// lib/screens/story/story_screen.dart - Complete updated version with white background and consistent theming

import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:provider/provider.dart';
import 'package:meelo/screens/story/story_form_screen.dart';
import 'package:meelo/services/story_service.dart';
import 'package:meelo/services/language_service.dart';
import 'package:meelo/l10n/app_localizations.dart';

class StoryScreen extends StatefulWidget {
  const StoryScreen({super.key});

  @override
  State<StoryScreen> createState() => _StoryScreenState();
}

class _StoryScreenState extends State<StoryScreen> {
  final _supabase = Supabase.instance.client;
  late StoryService _storyService;
  List<Map<String, dynamic>> _stories = [];
  bool _isLoading = true;

  // Subscription for realtime updates
  late RealtimeChannel _channel;

  @override
  void initState() {
    super.initState();
    _initRealtimeSubscription();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Initialize story service with language service
    final languageService =
        Provider.of<LanguageService>(context, listen: false);
    _storyService = StoryService(languageService);
    _fetchStories();
  }

  @override
  void dispose() {
    _channel.unsubscribe();
    super.dispose();
  }

  void _initRealtimeSubscription() {
    _channel = _supabase
        .channel('public:stories')
        .onPostgresChanges(
          event: PostgresChangeEvent.all,
          schema: 'public',
          table: 'stories',
          callback: (payload) {
            _fetchStories();
          },
        )
        .subscribe();
  }

  Future<void> _fetchStories() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final stories = await _storyService.fetchStories();

      setState(() {
        _stories = stories;
        _isLoading = false;
      });
    } catch (error) {
      debugPrint('Error fetching stories: $error');
      setState(() {
        _isLoading = false;
      });

      if (mounted) {
        final l10n = AppLocalizations.of(context)!;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('${l10n.failedToLoadStories}: $error')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(l10n.aiGeneratedStories),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black87,
        elevation: 1,
        shadowColor: Colors.black12,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _fetchStories,
            tooltip: l10n.refresh,
          ),
        ],
      ),
      body: Container(
        color: Colors.white,
        child: _isLoading
            ? const Center(
                child: CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(
                    Color.fromARGB(255, 72, 13, 174),
                  ),
                ),
              )
            : RefreshIndicator(
                onRefresh: _fetchStories,
                color: const Color.fromARGB(255, 72, 13, 174),
                child: _stories.isEmpty
                    ? _buildEmptyState(l10n)
                    : _buildStoriesList(l10n),
              ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _addStory,
        tooltip: l10n.createNewStory,
        backgroundColor: const Color.fromARGB(255, 72, 13, 174),
        foregroundColor: Colors.white,
        icon: const Icon(Icons.add),
        label: Text(l10n.createNewStory),
      ),
    );
  }

  Widget _buildEmptyState(AppLocalizations l10n) {
    return Container(
      color: Colors.white,
      child: Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.auto_stories,
                size: 80,
                color: Colors.grey.shade400,
              ),
              const SizedBox(height: 20),
              Text(
                l10n.noStoriesYet,
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.grey.shade600,
                ),
              ),
              const SizedBox(height: 12),
              Text(
                l10n.createFirstStoryDescription,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.grey.shade600,
                ),
              ),
              const SizedBox(height: 32),
              ElevatedButton.icon(
                onPressed: _addStory,
                icon: const Icon(Icons.auto_awesome),
                label: Text(l10n.createFirstStory),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color.fromARGB(255, 72, 13, 174),
                  foregroundColor: Colors.white,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStoriesList(AppLocalizations l10n) {
    return Container(
      color: Colors.white,
      child: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: _stories.length,
        itemBuilder: (context, index) {
          final story = _stories[index];
          final hasAudio = story['audio_url'] != null;
          final hasGeneratedStory = story['generated_story'] != null;
          final storyLanguage = story['language'] ?? 'en';

          return Card(
            margin: const EdgeInsets.only(bottom: 16),
            elevation: 2,
            color: Colors.white,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header with place and name
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color:
                        const Color.fromARGB(255, 72, 13, 174).withOpacity(0.1),
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(12),
                      topRight: Radius.circular(12),
                    ),
                  ),
                  child: Row(
                    children: [
                      CircleAvatar(
                        backgroundColor: const Color.fromARGB(255, 72, 13, 174),
                        child: const Icon(Icons.place, color: Colors.white),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              story['place_name'] ?? l10n.unknownPlace,
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Colors.black87,
                              ),
                            ),
                            Text(
                              'by ${story['storyteller_name'] ?? l10n.unknown}',
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.grey.shade600,
                              ),
                            ),
                          ],
                        ),
                      ),
                      // Status indicators
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          if (hasGeneratedStory)
                            Tooltip(
                              message: 'AI Story Generated',
                              child: Icon(
                                Icons.auto_stories,
                                color: Colors.green.shade600,
                                size: 20,
                              ),
                            ),
                          const SizedBox(width: 4),
                          if (hasAudio)
                            Tooltip(
                              message: 'Audio Available for NFC',
                              child: Icon(
                                Icons.audiotrack,
                                color: Colors.blue.shade600,
                                size: 20,
                              ),
                            ),
                          const SizedBox(width: 4),
                          // Language indicator
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 6, vertical: 2),
                            decoration: BoxDecoration(
                              color: storyLanguage == 'de'
                                  ? Colors.red.shade100
                                  : Colors.blue.shade100,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Text(
                              storyLanguage.toUpperCase(),
                              style: TextStyle(
                                fontSize: 10,
                                fontWeight: FontWeight.bold,
                                color: storyLanguage == 'de'
                                    ? Colors.red.shade700
                                    : Colors.blue.shade700,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),

                // Action buttons
                Container(
                  color: Colors.white,
                  padding: const EdgeInsets.all(16),
                  child: Row(
                    children: [
                      ElevatedButton.icon(
                        onPressed: () => _showStoryDetails(story, l10n),
                        icon: const Icon(Icons.visibility),
                        label: Text(l10n.viewStory),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blue,
                          foregroundColor: Colors.white,
                        ),
                      ),
                      const SizedBox(width: 8),
                      OutlinedButton.icon(
                        onPressed: () => _editStory(story),
                        icon: const Icon(Icons.edit),
                        label: Text(l10n.edit),
                        style: OutlinedButton.styleFrom(
                          foregroundColor:
                              const Color.fromARGB(255, 72, 13, 174),
                          side: const BorderSide(
                            color: Color.fromARGB(255, 72, 13, 174),
                          ),
                        ),
                      ),
                      const Spacer(),
                      IconButton(
                        onPressed: () =>
                            _confirmAndDeleteStory(story['id'], l10n),
                        icon: const Icon(Icons.delete, color: Colors.red),
                        tooltip: l10n.deleteStory,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  void _showStoryDetails(Map<String, dynamic> story, AppLocalizations l10n) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => DraggableScrollableSheet(
        initialChildSize: 0.7,
        maxChildSize: 0.9,
        minChildSize: 0.5,
        builder: (context, scrollController) => Container(
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(20),
              topRight: Radius.circular(20),
            ),
          ),
          child: Column(
            children: [
              // Handle bar
              Container(
                margin: const EdgeInsets.symmetric(vertical: 8),
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: Colors.grey.shade300,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),

              Expanded(
                child: Container(
                  color: Colors.white,
                  child: ListView(
                    controller: scrollController,
                    padding: const EdgeInsets.all(24),
                    children: [
                      // Header
                      Row(
                        children: [
                          CircleAvatar(
                            backgroundColor:
                                const Color.fromARGB(255, 72, 13, 174),
                            radius: 25,
                            child: const Icon(Icons.place,
                                color: Colors.white, size: 30),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  story['place_name'] ?? l10n.unknownPlace,
                                  style: const TextStyle(
                                    fontSize: 24,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black87,
                                  ),
                                ),
                                Text(
                                  'by ${story['storyteller_name'] ?? l10n.unknown}',
                                  style: TextStyle(
                                    fontSize: 16,
                                    color: Colors.grey.shade600,
                                  ),
                                ),
                                // Language badge
                                const SizedBox(height: 8),
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 8, vertical: 4),
                                  decoration: BoxDecoration(
                                    color: (story['language'] == 'de')
                                        ? Colors.red.shade100
                                        : Colors.blue.shade100,
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: Text(
                                    (story['language'] == 'de')
                                        ? l10n.germanStory
                                        : l10n.englishStory,
                                    style: TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.bold,
                                      color: (story['language'] == 'de')
                                          ? Colors.red.shade700
                                          : Colors.blue.shade700,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 32),

                      // Generated Story (if available)
                      if (story['generated_story'] != null) ...[
                        _buildSection(
                          l10n.generatedStory,
                          story['generated_story'],
                          Icons.auto_stories,
                          Colors.purple,
                        ),
                        const SizedBox(height: 24),
                      ],

                      // Personal Connection
                      if (story['personal_connection'] != null) ...[
                        _buildSection(
                          l10n.personalConnection,
                          story['personal_connection'],
                          Icons.favorite,
                          Colors.red,
                        ),
                        const SizedBox(height: 24),
                      ],

                      // Interesting Fact (only show if not null/empty)
                      if (story['interesting_fact'] != null &&
                          story['interesting_fact']
                              .toString()
                              .trim()
                              .isNotEmpty) ...[
                        _buildSection(
                          l10n.interestingFact,
                          story['interesting_fact'],
                          Icons.lightbulb,
                          Colors.orange,
                        ),
                        const SizedBox(height: 24),
                      ],

                      // Audio status (info only, no playback)
                      if (story['audio_url'] != null) ...[
                        Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: Colors.blue.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(12),
                            border:
                                Border.all(color: Colors.blue.withOpacity(0.3)),
                          ),
                          child: Row(
                            children: [
                              Icon(Icons.audiotrack,
                                  color: Colors.blue, size: 20),
                              const SizedBox(width: 8),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      l10n.audioGenerated,
                                      style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.blue,
                                      ),
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      l10n.audioFileAvailable,
                                      style: TextStyle(
                                          fontSize: 14,
                                          color: Colors.grey.shade600),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 24),
                      ],

                      // Action buttons
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          ElevatedButton.icon(
                            onPressed: () {
                              Navigator.pop(context);
                              _editStory(story);
                            },
                            icon: const Icon(Icons.edit),
                            label: Text(l10n.edit),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.blue,
                              foregroundColor: Colors.white,
                            ),
                          ),
                          OutlinedButton.icon(
                            onPressed: () {
                              Navigator.pop(context);
                              _confirmAndDeleteStory(story['id'], l10n);
                            },
                            icon: const Icon(Icons.delete, color: Colors.red),
                            label: Text(
                              l10n.delete,
                              style: const TextStyle(color: Colors.red),
                            ),
                            style: OutlinedButton.styleFrom(
                              side: const BorderSide(color: Colors.red),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSection(
      String title, String content, IconData icon, Color color) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: color, size: 20),
              const SizedBox(width: 8),
              Text(
                title,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: color,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            content,
            style: const TextStyle(
                fontSize: 16, height: 1.5, color: Colors.black87),
          ),
        ],
      ),
    );
  }

  Future<void> _deleteStory(int id) async {
    try {
      await _storyService.deleteStory(id);

      if (mounted) {
        final l10n = AppLocalizations.of(context)!;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(l10n.storyDeletedSuccessfully)),
        );
      }

      _fetchStories();
    } catch (error) {
      debugPrint('Error deleting story: $error');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('${AppLocalizations.of(context)!.failedToDeleteStory}: $error'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  void _confirmAndDeleteStory(int id, AppLocalizations l10n) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Colors.white,
        title: Text(l10n.deleteStory),
        content: Text(l10n.deleteStoryConfirmation),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text(l10n.cancel),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              _deleteStory(id);
            },
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: Text(l10n.delete),
          ),
        ],
      ),
    );
  }

  void _addStory() async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const StoryFormScreen(isEditing: false),
      ),
    );

    if (result == true) {
      _fetchStories();
    }
  }

  void _editStory(Map<String, dynamic> story) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => StoryFormScreen(isEditing: true, story: story),
      ),
    );

    if (result == true) {
      _fetchStories();
    }
  }
}