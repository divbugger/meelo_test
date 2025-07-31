// lib/screens/story/story_form_screen.dart - Complete multi-page form with all updates

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:meelo/services/story_service.dart';
import 'package:meelo/services/language_service.dart';
import 'package:meelo/l10n/app_localizations.dart';

class StoryFormScreen extends StatefulWidget {
  final bool isEditing;
  final Map<String, dynamic>? story;

  const StoryFormScreen({
    Key? key,
    required this.isEditing,
    this.story,
  }) : super(key: key);

  @override
  State<StoryFormScreen> createState() => _StoryFormScreenState();
}

class _StoryFormScreenState extends State<StoryFormScreen> {
  final _pageController = PageController();
  late StoryService _storyService;

  // Form Controllers
  final _nameController = TextEditingController();
  final _placeController = TextEditingController();
  final _connectionController = TextEditingController();
  final _interestingFactController = TextEditingController();

  // Form Keys for each page
  final _nameFormKey = GlobalKey<FormState>();
  final _placeFormKey = GlobalKey<FormState>();
  final _connectionFormKey = GlobalKey<FormState>();
  final _interestingFactFormKey = GlobalKey<FormState>();

  // State Variables
  bool _isLoading = false;
  bool _audioExists = false;
  String? _generatedStory;
  String? _audioUrl;
  int _currentPage = 0;
  final int _totalPages = 5; // 4 questions + 1 summary page

  @override
  void initState() {
    super.initState();
    _initializeFormData();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Initialize story service with language service
    final languageService =
        Provider.of<LanguageService>(context, listen: false);
    _storyService = StoryService(languageService);
  }

  @override
  void dispose() {
    _pageController.dispose();
    _nameController.dispose();
    _placeController.dispose();
    _connectionController.dispose();
    _interestingFactController.dispose();
    super.dispose();
  }

  /// Helper method to dismiss keyboard
  void _dismissKeyboard() {
    FocusScope.of(context).unfocus();
  }

  /// Initialize form data when editing existing story
  void _initializeFormData() {
    if (widget.isEditing && widget.story != null) {
      final story = widget.story!;
      _nameController.text = story['storyteller_name'] ?? '';
      _placeController.text = story['place_name'] ?? '';
      _connectionController.text = story['personal_connection'] ?? '';
      _interestingFactController.text = story['interesting_fact'] ?? '';
      _generatedStory = story['generated_story'];
      _audioUrl = story['audio_url'];
      _audioExists = _audioUrl != null;
    }
  }

  /// Navigate to next page with validation
  void _nextPage() {
    // Dismiss keyboard first
    _dismissKeyboard();

    bool canProceed = false;

    switch (_currentPage) {
      case 0:
        canProceed = _nameFormKey.currentState?.validate() ?? false;
        break;
      case 1:
        canProceed = _placeFormKey.currentState?.validate() ?? false;
        break;
      case 2:
        canProceed = _connectionFormKey.currentState?.validate() ?? false;
        break;
      case 3:
        canProceed = true; // Interesting fact is optional
        break;
      default:
        canProceed = true;
    }

    if (canProceed && _currentPage < _totalPages - 1) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  /// Navigate to previous page
  void _previousPage() {
    // Dismiss keyboard first
    _dismissKeyboard();

    if (_currentPage > 0) {
      _pageController.previousPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  /// Save or update story with AI generation
  Future<void> _saveStory() async {
    // Dismiss keyboard before starting the save process
    _dismissKeyboard();

    final l10n = AppLocalizations.of(context)!;
    final languageService =
        Provider.of<LanguageService>(context, listen: false);

    debugPrint(
        '🔄 Creating story in language: ${languageService.currentLocale.languageCode}');

    setState(() {
      _isLoading = true;
    });

    try {
      final storyData = {
        'storyteller_name': _nameController.text.trim(),
        'place_name': _placeController.text.trim(),
        'personal_connection': _connectionController.text.trim(),
        'interesting_fact': _interestingFactController.text.trim().isEmpty
            ? null
            : _interestingFactController.text.trim(),
        'structured_narrative': 'Generated story',
      };

      if (widget.isEditing && widget.story != null) {
        // Update existing story
        final hasChanged = _hasStoryDataChanged();
        await _storyService.updateStory(
          widget.story!['id'],
          storyData,
          regenerateStory: hasChanged || !_audioExists,
          regenerateAudio: !_audioExists,
        );

        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(l10n.storyUpdatedSuccessfully)),
          );
        }
      } else {
        // Create new story
        await _storyService.createStory(storyData);

        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(l10n.storyCreatedSuccessfully)),
          );
        }
      }

      if (mounted) {
        Navigator.pop(context, true);
      }
    } catch (error) {
      setState(() {
        _isLoading = false;
      });

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
                '${l10n.failedToCreateStory}: ${error.toString().replaceAll('Exception: ', '')}'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  /// Check if story data has changed (for editing)
  bool _hasStoryDataChanged() {
    if (widget.story == null) return true;

    return _nameController.text.trim() !=
            (widget.story!['storyteller_name'] ?? '') ||
        _placeController.text.trim() != (widget.story!['place_name'] ?? '') ||
        _connectionController.text.trim() !=
            (widget.story!['personal_connection'] ?? '') ||
        _interestingFactController.text.trim() !=
            (widget.story!['interesting_fact'] ?? '');
  }

  /// Test API services connectivity
  Future<void> _testServices() async {
    final l10n = AppLocalizations.of(context)!;

    setState(() => _isLoading = true);

    try {
      final results = await _storyService.testServices();

      if (mounted) {
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            backgroundColor: Colors.white,
            title: Text(l10n.serviceStatus),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildServiceStatusRow(
                    l10n.mistralAi, results['mistral'] == true, l10n),
                const SizedBox(height: 8),
                _buildServiceStatusRow(
                    l10n.elevenLabs, results['elevenlabs'] == true, l10n),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: Text(l10n.ok),
              ),
            ],
          ),
        );
      }
    } catch (error) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('${l10n.serviceTestFailed}: $error')),
        );
      }
    } finally {
      setState(() => _isLoading = false);
    }
  }

  /// Build service status row for dialog
  Widget _buildServiceStatusRow(
      String serviceName, bool isConnected, AppLocalizations l10n) {
    return Row(
      children: [
        Icon(
          isConnected ? Icons.check_circle : Icons.error,
          color: isConnected ? Colors.green : Colors.red,
        ),
        const SizedBox(width: 8),
        Text('$serviceName: ${isConnected ? l10n.connected : l10n.failed}'),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return GestureDetector(
      // Dismiss keyboard when tapping anywhere on the screen
      onTap: () => _dismissKeyboard(),
      child: Scaffold(
        backgroundColor: Colors.white,
        resizeToAvoidBottomInset: true, // Allow proper keyboard handling
        appBar: AppBar(
          leading: IconButton(
            icon: const Icon(Icons.close),
            onPressed: () {
              _dismissKeyboard();
              Navigator.of(context).pop();
            },
            tooltip: 'Close',
          ),
          title: Text(
            widget.isEditing ? l10n.editStory : l10n.createNewStory,
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w600,
              color: Colors.black87,
            ),
          ),
          backgroundColor: Colors.white,
          foregroundColor: Colors.black87,
          elevation: 1,
          shadowColor: Colors.black12,
          actions: [
            if (_currentPage == _totalPages - 1) // Only show on summary page
              IconButton(
                icon: const Icon(Icons.bug_report),
                tooltip: l10n.testServices,
                onPressed: _testServices,
              ),
          ],
        ),
        body: Container(
          color: Colors.white,
          child: Column(
            children: [
              // Progress indicator
              Container(
                padding: const EdgeInsets.all(16),
                color: Colors.white,
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Step ${_currentPage + 1} of $_totalPages',
                          style:
                              Theme.of(context).textTheme.bodyMedium?.copyWith(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black87,
                                  ),
                        ),
                        Text(
                          '${((_currentPage + 1) / _totalPages * 100).round()}%',
                          style:
                              Theme.of(context).textTheme.bodyMedium?.copyWith(
                                    color: Colors.black54,
                                  ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    LinearProgressIndicator(
                      value: (_currentPage + 1) / _totalPages,
                      backgroundColor: Colors.grey.shade300,
                      valueColor: const AlwaysStoppedAnimation<Color>(
                        Color.fromARGB(255, 72, 13, 174),
                      ),
                    ),
                  ],
                ),
              ),

              // Page content
              Expanded(
                child: GestureDetector(
                  // Dismiss keyboard when tapping outside text fields
                  onTap: () => _dismissKeyboard(),
                  child: PageView(
                    controller: _pageController,
                    physics:
                        const NeverScrollableScrollPhysics(), // Disable swipe navigation
                    onPageChanged: (index) {
                      // Dismiss keyboard when page changes
                      _dismissKeyboard();
                      setState(() {
                        _currentPage = index;
                      });
                    },
                    children: [
                      _buildNamePage(l10n),
                      _buildPlacePage(l10n),
                      _buildConnectionPage(l10n),
                      _buildInterestingFactPage(l10n),
                      _buildSummaryPage(l10n),
                    ],
                  ),
                ),
              ),

              // Navigation buttons
              Container(
                padding: const EdgeInsets.all(16),
                color: Colors.white,
                child: Row(
                  children: [
                    if (_currentPage > 0)
                      Expanded(
                        child: OutlinedButton.icon(
                          onPressed: _previousPage,
                          icon: const Icon(Icons.arrow_back),
                          label: Text(l10n.back),
                          style: OutlinedButton.styleFrom(
                            foregroundColor:
                                const Color.fromARGB(255, 72, 13, 174),
                            side: const BorderSide(
                                color: Color.fromARGB(255, 72, 13, 174)),
                          ),
                        ),
                      ),
                    if (_currentPage > 0) const SizedBox(width: 16),
                    Expanded(
                      child: _currentPage == _totalPages - 1
                          ? ElevatedButton.icon(
                              onPressed: _isLoading ? null : _saveStory,
                              icon: _isLoading
                                  ? const SizedBox(
                                      width: 20,
                                      height: 20,
                                      child: CircularProgressIndicator(
                                        strokeWidth: 2,
                                        valueColor:
                                            AlwaysStoppedAnimation<Color>(
                                                Colors.white),
                                      ),
                                    )
                                  : const Icon(Icons.auto_awesome),
                              label: Text(_isLoading
                                  ? l10n.generatingStoryAndAudio
                                  : (widget.isEditing
                                      ? l10n.updateStory
                                      : l10n.generateStoryAndAudio)),
                              style: ElevatedButton.styleFrom(
                                backgroundColor:
                                    const Color.fromARGB(255, 72, 13, 174),
                                foregroundColor: Colors.white,
                              ),
                            )
                          : ElevatedButton.icon(
                              onPressed: _nextPage,
                              icon: const Icon(Icons.arrow_forward),
                              label: Text(l10n.next),
                              style: ElevatedButton.styleFrom(
                                backgroundColor:
                                    const Color.fromARGB(255, 72, 13, 174),
                                foregroundColor: Colors.white,
                              ),
                            ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildNamePage(AppLocalizations l10n) {
    return Container(
      color: Colors.white,
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _nameFormKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 32),
              Icon(
                Icons.person,
                size: 64,
                color: const Color.fromARGB(255, 72, 13, 174),
              ),
              const SizedBox(height: 24),
              Text(
                l10n.whatIsYourName,
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
              ),
              const SizedBox(height: 16),
              Text(
                l10n.enterYourName,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: Colors.grey.shade600,
                    ),
              ),
              const SizedBox(height: 32),
              TextFormField(
                controller: _nameController,
                decoration: InputDecoration(
                  labelText: l10n.storytellerName,
                  border: const OutlineInputBorder(),
                  prefixIcon: const Icon(Icons.person_outline),
                  helperText: l10n.enterYourName,
                  focusedBorder: const OutlineInputBorder(
                    borderSide:
                        BorderSide(color: Color.fromARGB(255, 72, 13, 174)),
                  ),
                ),
                textInputAction: TextInputAction.next,
                onFieldSubmitted: (_) {
                  _dismissKeyboard();
                  _nextPage();
                },
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return l10n.pleaseEnterYourName;
                  }
                  return null;
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPlacePage(AppLocalizations l10n) {
    return Container(
      color: Colors.white,
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _placeFormKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 32),
              Icon(
                Icons.place,
                size: 64,
                color: const Color.fromARGB(255, 72, 13, 174),
              ),
              const SizedBox(height: 24),
              Text(
                l10n.whatIsYourFavoritePlace,
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
              ),
              const SizedBox(height: 16),
              Text(
                l10n.enterFavoritePlace,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: Colors.grey.shade600,
                    ),
              ),
              const SizedBox(height: 32),
              TextFormField(
                controller: _placeController,
                decoration: InputDecoration(
                  labelText: l10n.pleaseEnterFavoritePlace,
                  border: const OutlineInputBorder(),
                  prefixIcon: const Icon(Icons.location_on_outlined),
                  helperText: l10n.enterFavoritePlace,
                  focusedBorder: const OutlineInputBorder(
                    borderSide:
                        BorderSide(color: Color.fromARGB(255, 72, 13, 174)),
                  ),
                ),
                textInputAction: TextInputAction.next,
                onFieldSubmitted: (_) {
                  _dismissKeyboard();
                  _nextPage();
                },
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return l10n.pleaseEnterFavoritePlace;
                  }
                  return null;
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildConnectionPage(AppLocalizations l10n) {
    return Container(
      color: Colors.white,
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _connectionFormKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 32),
              Icon(
                Icons.favorite,
                size: 64,
                color: const Color.fromARGB(255, 72, 13, 174),
              ),
              const SizedBox(height: 24),
              Text(
                l10n.connectionQuestion,
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
              ),
              const SizedBox(height: 16),
              Text(
                l10n.describePlaceConnection,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: Colors.grey.shade600,
                    ),
              ),
              const SizedBox(height: 32),
              TextFormField(
                controller: _connectionController,
                decoration: InputDecoration(
                  labelText: l10n.personalConnection,
                  border: const OutlineInputBorder(),
                  prefixIcon: const Icon(Icons.favorite_outline),
                  helperText: l10n.describePlaceConnection,
                  alignLabelWithHint: true,
                  focusedBorder: const OutlineInputBorder(
                    borderSide:
                        BorderSide(color: Color.fromARGB(255, 72, 13, 174)),
                  ),
                ),
                maxLines: 6,
                textInputAction: TextInputAction.newline,
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return l10n.pleaseDescribeConnection;
                  }
                  final wordCount = value
                      .trim()
                      .split(RegExp(r'\s+'))
                      .where((word) => word.isNotEmpty)
                      .length;
                  if (wordCount < 3) {
                    return '${l10n.minimumWordsConnection} (currently $wordCount words)';
                  }
                  return null;
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInterestingFactPage(AppLocalizations l10n) {
    return Container(
      color: Colors.white,
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _interestingFactFormKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 32),
              Icon(
                Icons.lightbulb,
                size: 64,
                color: const Color.fromARGB(255, 72, 13, 174),
              ),
              const SizedBox(height: 24),
              Text(
                l10n.interestingFactQuestion,
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
              ),
              const SizedBox(height: 16),
              Text(
                l10n.shareInterestingFactOptional,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: Colors.grey.shade600,
                    ),
              ),
              const SizedBox(height: 32),
              TextFormField(
                controller: _interestingFactController,
                decoration: InputDecoration(
                  labelText: '${l10n.interestingFact} (Optional)',
                  border: const OutlineInputBorder(),
                  prefixIcon: const Icon(Icons.lightbulb_outline),
                  helperText: l10n.shareInterestingFactOptional,
                  alignLabelWithHint: true,
                  focusedBorder: const OutlineInputBorder(
                    borderSide:
                        BorderSide(color: Color.fromARGB(255, 72, 13, 174)),
                  ),
                ),
                maxLines: 4,
                textInputAction: TextInputAction.newline,
                // No validator - field is optional
              ),
              const SizedBox(height: 24),
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.blue.shade50,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.blue.shade200),
                ),
                child: Row(
                  children: [
                    Icon(Icons.info_outline, color: Colors.blue.shade700),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        'This question is optional. You can skip it if you prefer.',
                        style: TextStyle(
                          color: Colors.blue.shade700,
                          fontSize: 14,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSummaryPage(AppLocalizations l10n) {
    return Container(
      color: Colors.white,
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 32),
            Icon(
              Icons.auto_awesome,
              size: 64,
              color: const Color.fromARGB(255, 72, 13, 174),
            ),
            const SizedBox(height: 24),
            Text(
              'Ready to Create Your Memory',
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
            ),
            const SizedBox(height: 16),
            Text(
              l10n.aiGeneratedStoriesDescription,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Colors.grey.shade600,
                  ),
            ),
            const SizedBox(height: 32),

            // Summary cards
            _buildSummaryCard(
              icon: Icons.person,
              title: l10n.storytellerName,
              content: _nameController.text.trim(),
              color: Colors.blue,
            ),
            const SizedBox(height: 16),
            _buildSummaryCard(
              icon: Icons.place,
              title: 'Favorite Place',
              content: _placeController.text.trim(),
              color: Colors.green,
            ),
            const SizedBox(height: 16),
            _buildSummaryCard(
              icon: Icons.favorite,
              title: l10n.personalConnection,
              content: _connectionController.text.trim(),
              color: Colors.red,
              maxLines: 3,
            ),
            if (_interestingFactController.text.trim().isNotEmpty) ...[
              const SizedBox(height: 16),
              _buildSummaryCard(
                icon: Icons.lightbulb,
                title: l10n.interestingFact,
                content: _interestingFactController.text.trim(),
                color: Colors.orange,
                maxLines: 2,
              ),
            ],

            const SizedBox(height: 32),

            // Existing story info (for editing)
            if (widget.isEditing && _generatedStory != null) ...[
              Card(
                color: Colors.green.shade50,
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          const Icon(Icons.auto_stories, color: Colors.green),
                          const SizedBox(width: 8),
                          Text(
                            l10n.generatedStory,
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Text(_generatedStory!,
                          style: const TextStyle(fontSize: 16)),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),
            ],

            if (widget.isEditing && _audioExists) ...[
              Card(
                color: Colors.blue.shade50,
                child: ListTile(
                  leading: const Icon(Icons.audiotrack, color: Colors.blue),
                  title: Text(l10n.audioAvailable),
                  subtitle:
                      const Text('Audio has been generated for this story'),
                  trailing: IconButton(
                    icon: const Icon(Icons.refresh),
                    tooltip: l10n.regenerateAudio,
                    onPressed: () {
                      setState(() {
                        _audioExists = false;
                        _audioUrl = null;
                      });
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text(l10n.audioWillBeRegenerated)),
                      );
                    },
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildSummaryCard({
    required IconData icon,
    required String title,
    required String content,
    required Color color,
    int maxLines = 1,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: color, size: 24),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: color,
                    fontSize: 14,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  content,
                  style: const TextStyle(fontSize: 16, color: Colors.black87),
                  maxLines: maxLines,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}