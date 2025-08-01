// lib/l10n/app_localizations_en.dart

import 'app_localizations.dart';

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  // Common
  @override
  String get appName => 'Idememory';

  @override
  String get language => 'Language';

  @override
  String get settings => 'Settings';

  @override
  String get cancel => 'Cancel';

  @override
  String get save => 'Save';

  @override
  String get delete => 'Delete';

  @override
  String get edit => 'Edit';

  @override
  String get add => 'Add';

  @override
  String get refresh => 'Refresh';

  @override
  String get loading => 'Loading';

  @override
  String get error => 'Error';

  @override
  String get success => 'Success';

  @override
  String get warning => 'Warning';

  @override
  String get retry => 'Retry';

  @override
  String get back => 'Back';

  @override
  String get next => 'Next';

  @override
  String get done => 'Done';

  @override
  String get ok => 'OK';

  @override
  String get yes => 'Yes';

  @override
  String get no => 'No';

  // Navigation
  @override
  String get stories => 'Memories';


  // Stories
  @override
  String get aiGeneratedStories => 'Preserve your memories';

  @override
  String get createNewStory => 'Create New Memory';

  @override
  String get editStory => 'Edit Memory';

  @override
  String get updateStory => 'Update Memory';

  @override
  String get generateStoryAndAudio => 'Generate Memory & Audio';

  @override
  String get storytellerName => 'Storyteller\'s Name';

  @override
  String get whatIsYourName => '1. What is your name?';

  @override
  String get whatIsYourFavoritePlace => '2. What is your favourite place?';

  @override
  String get connectionQuestion => '3. What is your connection to this place?';

  @override
  String get interestingFactQuestion =>
      '4. Tell me an interesting fact about this place (Optional)'; // Updated to show optional

  @override
  String get aiGeneratedStoriesDescription =>
      'Tell us about your special moments, and we will turn them into a personal story read aloud by a warm voice.';

  @override
  String get enterYourName =>
      'Enter your full name or how you\'d like to be addressed';

  @override
  String get enterFavoritePlace =>
      'This could be anywhere - a city, park, building, or special location';

  @override
  String get describePlaceConnection =>
      'Describe why this place is meaningful to you (minimum 3 words)';

  @override
  String get shareInterestingFact =>
      'Share something unique, historical, or fascinating about this place';

  @override
  String get shareInterestingFactOptional =>
      'Share something unique, historical, or fascinating about this place (optional)'; // New optional version

  @override
  String get minimumWordsConnection => 'Please write at least 5 words';

  @override
  String get minimumWordsInterestingFact =>
      'Please provide more detail (at least 10 words)';

  @override
  String get noStoriesYet => 'No Stories Yet';

  @override
  String get createFirstStory => 'Create Your first memory';

  @override
  String get createFirstStoryDescription =>
      'Create your first memory by sharing your favorite place and connection to it.';

  @override
  String get generatedStory => 'Your Memory';

  @override
  String get personalConnection => 'Personal Connection';

  @override
  String get interestingFact => 'Interesting Fact';

  @override
  String get audioAvailable => 'Audio Available';

  @override
  String get audioNotAvailable => 'Audio not available for this story';

  @override
  String get playAudio => 'Play Audio';

  @override
  String get viewStory => 'View';

  @override
  String get regenerateAudio => 'Regenerate audio';

  @override
  String get audioWillBeRegenerated =>
      'Audio will be regenerated when you save';

  @override
  String get generatingStoryAndAudio => 'Generating Story & Audio...';

  @override
  String get testServices => 'Test Services';

  @override
  String get serviceStatus => 'Service Status';

  @override
  String get mistralAi => 'Mistral AI';

  @override
  String get elevenLabs => 'ElevenLabs';

  @override
  String get connected => 'Connected';

  @override
  String get failed => 'Failed';

  @override
  String get serviceTestFailed => 'Service test failed';

  @override
  String get storyCreatedSuccessfully => 'Story created successfully!';

  @override
  String get storyUpdatedSuccessfully => 'Story updated successfully!';

  @override
  String get storyDeletedSuccessfully => 'Story deleted successfully';

  @override
  String get deleteStory => 'Delete Story';

  @override
  String get deleteStoryConfirmation =>
      'Are you sure you want to delete this story? This will also delete the generated content and audio files. This action cannot be undone.';

  @override
  String get failedToCreateStory => 'Failed to create story';

  @override
  String get failedToUpdateStory => 'Failed to update story';

  @override
  String get failedToDeleteStory => 'Failed to delete story';

  @override
  String get pleaseEnterYourName => 'Please enter your name';

  @override
  String get pleaseEnterFavoritePlace => 'Please enter your favorite place';

  @override
  String get pleaseDescribeConnection =>
      'Please describe your connection to this place';

  @override
  String get pleaseShareInterestingFact =>
      'Please share an interesting fact about this place';

  @override
  String get audioPlaybackWouldStart => 'Audio playback would start here';

  // Language Selection
  @override
  String get selectLanguage => 'Select Language';

  @override
  String get english => 'English';

  @override
  String get german => 'German';

  @override
  String get languageChanged => 'Language changed successfully';

  // Registration
  @override
  String get register => 'Register';
  
  @override
  String get whatIsYourEmail => 'What is your email address?';
  
  @override
  String get emailPlaceholder => 'Email';
  
  @override
  String get acceptTerms => 'I accept the Terms and Conditions and Privacy Policy.';
  
  @override
  String get stayLoggedIn => 'Stay logged in';
  
  @override
  String get continueButton => 'Continue';
  
  @override
  String get createPassword => 'Create password';
  
  @override
  String get registrationAs => 'Registration as:';
  
  @override
  String get personWithDementia => 'Person with Dementia';
  
  @override
  String get caregiver => 'Caregiver';
  
  @override
  String get fullName => 'Full Name';
  
  @override
  String get selectBirthDate => 'Select birth date';
  
  @override
  String get gender => 'Gender';
  
  @override
  String get languagePreference => 'Language Preference';
  
  @override
  String get male => 'Male';
  
  @override
  String get female => 'Female';
  
  @override
  String get nonBinary => 'Non-binary';
  
  @override
  String get preferNotToSay => 'Prefer not to say';
  
  @override
  String get password => 'Password';
  
  @override
  String get confirmPassword => 'Confirm Password';
  
  @override
  String get createAccount => 'Create Account';
  
  @override
  String get createAccountSubtitle => 'Create your account to get started';
  
  @override
  String get email => 'Email Address';
  
  @override
  String get alreadyHaveAccount => 'Already have an account? ';
  
  @override
  String get signIn => 'Sign In';
  
  @override
  String get enterFullName => 'Please enter your full name';
  
  @override
  String get nameMinLength => 'Name must be at least 2 characters';
  
  @override
  String get enterPassword => 'Please enter a password';
  
  @override
  String get passwordMinLength => 'Password must be at least 6 characters';
  
  @override
  String get confirmYourPassword => 'Please confirm your password';
  
  @override
  String get passwordsDoNotMatch => 'Passwords do not match';
  
  @override
  String get registrationFailed => 'Registration failed';
  
  // Validation messages
  @override
  String get pleaseEnterEmail => 'Please enter your email address';
  
  @override
  String get pleaseEnterValidEmail => 'Please enter a valid email address';
  
  @override
  String get pleaseEnterPassword => 'Please enter a password';
  
  @override
  String get passwordMinLengthMessage => 'Password must be at least 6 characters';
  
  @override
  String get pleaseConfirmPassword => 'Please confirm your password';
  
  @override
  String get passwordsDontMatch => 'Passwords do not match';
  
  @override
  String get pleaseAcceptTerms => 'Please accept the terms and conditions';
  
  // Story screen messages
  @override
  String get failedToLoadStories => 'Failed to load stories';
  
  @override
  String get unknownPlace => 'Unknown Place';
  
  @override
  String get unknown => 'Unknown';
  
  @override
  String get germanStory => 'German Story';
  
  @override
  String get englishStory => 'English Story';
  
  @override
  String get audioGenerated => 'Audio Generated';
  
  @override
  String get audioFileAvailable => 'Audio file available for NFC playback system';
  
  // Story form messages
  @override
  String get close => 'Close';
  
  @override
  String get stepOf => 'Step {current} of {total}';
  
  @override
  String get readyToCreateMemory => 'Ready to Create Your Memory';
  
  @override
  String get favoritePlace => 'Favorite Place';
  
  @override
  String get audioGenerated2 => 'Audio has been generated for this story';
  
  // Login screen messages
  @override
  String get welcomeBack => 'Welcome back';
  
  @override
  String get signInToAccount => 'Sign in to your account to continue';
  
  @override
  String get forgotPassword => 'Forgot Password?';
  
  @override
  String get or => 'or';
  
  @override
  String get createNewAccount => 'Create New Account';
  
  @override
  String get loginFailed => 'Login failed';
  
  @override
  String get forgotPasswordComingSoon => 'Forgot password feature coming soon';
  
  // Onboarding screen messages
  @override
  String get setupYourProfile => 'Setup your profile';
  
  @override
  String get howWillYouUse => 'How will you be using the app?';
  
  @override
  String get selectRoleToPersonalize => 'Please select your role to personalize your experience';
  
  @override
  String get continueText => 'Continue';
  
  @override
  String get whatsYourName => 'What\'s your name?';
  
  @override
  String get personalizeExperience => 'This will help us personalize your experience';
  
  @override
  String get whenWereYouBorn => 'When were you born?';
  
  @override
  String get ageAppropriateContent => 'This helps us provide age-appropriate content';
  
  @override
  String get howDoYouIdentify => 'How do you identify?';
  
  @override
  String get other => 'Other';
  
  @override
  String get completeSetup => 'Complete Setup';
  
  @override
  String get pleaseCompleteAllFields => 'Please complete all fields';
  
  @override
  String get failedToCompleteSetup => 'Failed to complete setup';
}