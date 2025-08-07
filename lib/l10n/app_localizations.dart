// lib/l10n/app_localizations.dart

import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_de.dart';
import 'app_localizations_en.dart';

/// Callers can lookup localized strings with Localizations.of<AppLocalizations>(context)!.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationsDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
abstract class AppLocalizations {
  AppLocalizations(String locale)
      : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates to be used in MaterialApp or
  /// CupertinoApp.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
    delegate,
    GlobalMaterialLocalizations.delegate,
    GlobalCupertinoLocalizations.delegate,
    GlobalWidgetsLocalizations.delegate,
  ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('de')
  ];

  // Common
  String get appName;
  String get language;
  String get settings;
  String get cancel;
  String get save;
  String get delete;
  String get edit;
  String get add;
  String get refresh;
  String get loading;
  String get error;
  String get success;
  String get warning;
  String get retry;
  String get back;
  String get next;
  String get done;
  String get ok;
  String get yes;
  String get no;

  // Navigation
  String get stories;
  String get home;
  String get memories;
  String get questionnaire;
  String get figures;
  String get profile;


  // Stories
  String get aiGeneratedStories;
  String get createNewStory;
  String get editStory;
  String get updateStory;
  String get generateStoryAndAudio;
  String get storytellerName;
  String get whatIsYourName;
  String get whatIsYourFavoritePlace;
  String get connectionQuestion;
  String get interestingFactQuestion;
  String get aiGeneratedStoriesDescription;
  String get enterYourName;
  String get enterFavoritePlace;
  String get describePlaceConnection;
  String get shareInterestingFact;
  String get shareInterestingFactOptional; // New optional version
  String get minimumWordsConnection;
  String get minimumWordsInterestingFact;
  String get noStoriesYet;
  String get createFirstStory;
  String get createFirstStoryDescription;
  String get generatedStory;
  String get personalConnection;
  String get interestingFact;
  String get audioAvailable;
  String get audioNotAvailable;
  String get playAudio;
  String get viewStory;
  String get regenerateAudio;
  String get audioWillBeRegenerated;
  String get generatingStoryAndAudio;
  String get testServices;
  String get serviceStatus;
  String get mistralAi;
  String get elevenLabs;
  String get connected;
  String get failed;
  String get serviceTestFailed;
  String get storyCreatedSuccessfully;
  String get storyUpdatedSuccessfully;
  String get storyDeletedSuccessfully;
  String get deleteStory;
  String get deleteStoryConfirmation;
  String get failedToCreateStory;
  String get failedToUpdateStory;
  String get failedToDeleteStory;
  String get pleaseEnterYourName;
  String get pleaseEnterFavoritePlace;
  String get pleaseDescribeConnection;
  String get pleaseShareInterestingFact;
  String get audioPlaybackWouldStart;

  // Language Selection
  String get selectLanguage;
  String get english;
  String get german;
  String get languageChanged;

  // Registration
  String get register;
  String get whatIsYourEmail;
  String get emailPlaceholder;
  String get acceptTerms;
  String get stayLoggedIn;
  String get continueButton;
  String get createPassword;
  String get registrationAs;
  String get personWithDementia;
  String get caregiver;
  String get fullName;
  String get selectBirthDate;
  String get gender;
  String get languagePreference;
  String get male;
  String get female;
  String get nonBinary;
  String get preferNotToSay;
  String get password;
  String get confirmPassword;
  String get createAccount;
  String get createAccountSubtitle;
  String get email;
  String get alreadyHaveAccount;
  String get signIn;
  String get enterFullName;
  String get nameMinLength;
  String get enterPassword;
  String get passwordMinLength;
  String get confirmYourPassword;
  String get passwordsDoNotMatch;
  String get registrationFailed;
  
  // Validation messages
  String get pleaseEnterEmail;
  String get pleaseEnterValidEmail;
  String get pleaseEnterPassword;
  String get passwordMinLengthMessage;
  String get pleaseConfirmPassword;
  String get passwordsDontMatch;
  String get pleaseAcceptTerms;
  
  // Story screen messages
  String get failedToLoadStories;
  String get unknownPlace;
  String get unknown;
  String get germanStory;
  String get englishStory;
  String get audioGenerated;
  String get audioFileAvailable;
  
  // Story form messages
  String get close;
  String get stepOf;
  String get readyToCreateMemory;
  String get favoritePlace;
  String get audioGenerated2;
  
  // Login screen messages
  String get welcomeBack;
  String get signInToAccount;
  String get forgotPassword;
  String get or;
  String get createNewAccount;
  String get loginFailed;
  String get forgotPasswordComingSoon;
  
  // Onboarding screen messages
  String get setupYourProfile;
  String get howWillYouUse;
  String get selectRoleToPersonalize;
  String get continueText;
  String get whatsYourName;
  String get personalizeExperience;
  String get whenWereYouBorn;
  String get ageAppropriateContent;
  String get howDoYouIdentify;
  String get other;
  String get completeSetup;
  String get pleaseCompleteAllFields;
  String get failedToCompleteSetup;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['de', 'en'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'de':
      return AppLocalizationsDe();
    case 'en':
      return AppLocalizationsEn();
  }

  throw FlutterError(
      'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
      'an issue with the localizations generation tool. Please file an issue on GitHub with a '
      'reproducible example of the issue and mention that the locale that could not be loaded.');
}