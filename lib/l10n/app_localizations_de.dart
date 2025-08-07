// lib/l10n/app_localizations_de.dart

import 'app_localizations.dart';

/// The translations for German (`de`).
class AppLocalizationsDe extends AppLocalizations {
  AppLocalizationsDe([String locale = 'de']) : super(locale);

  // Common
  @override
  String get appName => 'Idememory';

  @override
  String get language => 'Sprache';

  @override
  String get settings => 'Einstellungen';

  @override
  String get cancel => 'Abbrechen';

  @override
  String get save => 'Speichern';

  @override
  String get delete => 'Löschen';

  @override
  String get edit => 'Bearbeiten';

  @override
  String get add => 'Hinzufügen';

  @override
  String get refresh => 'Aktualisieren';

  @override
  String get loading => 'Lädt';

  @override
  String get error => 'Fehler';

  @override
  String get success => 'Erfolg';

  @override
  String get warning => 'Warnung';

  @override
  String get retry => 'Wiederholen';

  @override
  String get back => 'Zurück';

  @override
  String get next => 'Weiter';

  @override
  String get done => 'Fertig';

  @override
  String get ok => 'OK';

  @override
  String get yes => 'Ja';

  @override
  String get no => 'Nein';

  // Navigation
  @override
  String get stories => 'Erinnerungen';

  @override
  String get home => 'Startseite';

  @override
  String get memories => 'Erinnerungen';

  @override
  String get questionnaire => 'Fragebogen';

  @override
  String get figures => 'Zahlen';

  @override
  String get profile => 'Profil';

  // Account & Authentication
  @override
  String get account => 'Konto';

  @override
  String get signOut => 'Abmelden';

  @override
  String get signOutConfirmation => 'Sind Sie sicher, dass Sie sich abmelden möchten?';

  // Stories
  @override
  String get aiGeneratedStories => 'Bewahre deine Erinnerungen';

  @override
  String get createNewStory => 'Neue Erinnerungen';

  @override
  String get editStory => 'Geschichte bearbeiten';

  @override
  String get updateStory => 'Geschichte aktualisieren';

  @override
  String get generateStoryAndAudio => 'Geschichte & Audio generieren';

  @override
  String get storytellerName => 'Name des Erzählers';

  @override
  String get whatIsYourName => '1. Wie ist Ihr Name?';

  @override
  String get whatIsYourFavoritePlace => '2. Was ist Ihr Lieblingsort?';

  @override
  String get connectionQuestion => '3. Was ist Ihre Verbindung zu diesem Ort?';

  @override
  String get interestingFactQuestion =>
      '4. Erzählen Sie mir eine interessante Tatsache über diesen Ort (Optional)'; // Updated to show optional

  @override
  String get aiGeneratedStoriesDescription =>
      'Erzählen Sie uns von Ihren besonderen Momenten, und wir verwandeln sie in eine persönliche Geschichte, die von einer warmen Stimme vorgelesen wird.';

  @override
  String get enterYourName =>
      'Geben Sie Ihren vollständigen Namen ein oder wie Sie angesprochen werden möchten';

  @override
  String get enterFavoritePlace =>
      'Das kann überall sein - eine Stadt, ein Park, ein Gebäude oder ein besonderer Ort';

  @override
  String get describePlaceConnection =>
      'Beschreiben Sie, warum dieser Ort für Sie bedeutsam ist (mindestens 3 Wörter)';

  @override
  String get shareInterestingFact =>
      'Teilen Sie etwas Einzigartiges, Historisches oder Faszinierendes über diesen Ort';

  @override
  String get shareInterestingFactOptional =>
      'Teilen Sie etwas Einzigartiges, Historisches oder Faszinierendes über diesen Ort (optional)'; // New optional version

  @override
  String get minimumWordsConnection =>
      'Bitte schreiben Sie mindestens 5 Wörter';

  @override
  String get minimumWordsInterestingFact =>
      'Bitte geben Sie mehr Details an (mindestens 3 Wörter)';

  @override
  String get noStoriesYet => 'Noch keine Geschichten';

  @override
  String get createFirstStory => 'Ihre erste Geschichte erstellen';

  @override
  String get createFirstStoryDescription =>
      'Erstellen Sie Ihre erste KI-generierte Geschichte, indem Sie Ihren Lieblingsort und Ihre Verbindung dazu teilen.';

  @override
  String get generatedStory => 'Ihre Erinnerungen';

  @override
  String get personalConnection => 'Persönliche Verbindung';

  @override
  String get interestingFact => 'Interessante Tatsache';

  @override
  String get audioAvailable => 'Audio verfügbar';

  @override
  String get audioNotAvailable => 'Audio nicht verfügbar für diese Geschichte';

  @override
  String get playAudio => 'Audio abspielen';

  @override
  String get viewStory => 'Anzeigen';

  @override
  String get regenerateAudio => 'Audio regenerieren';

  @override
  String get audioWillBeRegenerated => 'Audio wird beim Speichern regeneriert';

  @override
  String get generatingStoryAndAudio =>
      'Geschichte & Audio werden generiert...';

  @override
  String get testServices => 'Services testen';

  @override
  String get serviceStatus => 'Service-Status';

  @override
  String get mistralAi => 'Mistral KI';

  @override
  String get elevenLabs => 'ElevenLabs';

  @override
  String get connected => 'Verbunden';

  @override
  String get failed => 'Fehlgeschlagen';

  @override
  String get serviceTestFailed => 'Service-Test fehlgeschlagen';

  @override
  String get storyCreatedSuccessfully => 'Geschichte erfolgreich erstellt!';

  @override
  String get storyUpdatedSuccessfully => 'Geschichte erfolgreich aktualisiert!';

  @override
  String get storyDeletedSuccessfully => 'Geschichte erfolgreich gelöscht';

  @override
  String get deleteStory => 'Geschichte löschen';

  @override
  String get deleteStoryConfirmation =>
      'Sind Sie sicher, dass Sie diese Geschichte löschen möchten? Dies löscht auch den generierten Inhalt und die Audiodateien. Diese Aktion kann nicht rückgängig gemacht werden.';

  @override
  String get failedToCreateStory => 'Geschichte konnte nicht erstellt werden';

  @override
  String get failedToUpdateStory =>
      'Geschichte konnte nicht aktualisiert werden';

  @override
  String get failedToDeleteStory => 'Geschichte konnte nicht gelöscht werden';

  @override
  String get pleaseEnterYourName => 'Bitte geben Sie Ihren Namen ein';

  @override
  String get pleaseEnterFavoritePlace =>
      'Bitte geben Sie Ihren Lieblingsort ein';

  @override
  String get pleaseDescribeConnection =>
      'Bitte beschreiben Sie Ihre Verbindung zu diesem Ort';

  @override
  String get pleaseShareInterestingFact =>
      'Bitte teilen Sie eine interessante Tatsache über diesen Ort';

  @override
  String get audioPlaybackWouldStart => 'Audio-Wiedergabe würde hier starten';

  // Language Selection
  @override
  String get selectLanguage => 'Sprache auswählen';

  @override
  String get english => 'Englisch';

  @override
  String get german => 'Deutsch';

  @override
  String get languageChanged => 'Sprache erfolgreich geändert';

  // Registration
  @override
  String get register => 'Registrieren';
  
  @override
  String get whatIsYourEmail => 'Wie ist deine E-Mail Adresse?';
  
  @override
  String get emailPlaceholder => 'E-Mail';
  
  @override
  String get acceptTerms => 'Ich akzeptiere die Allgemeinen Geschäftsbedingungen und Datenschutzbestimmungen.';
  
  @override
  String get stayLoggedIn => 'Angemeldet bleiben';
  
  @override
  String get continueButton => 'Weiter';
  
  @override
  String get createPassword => 'Passwort erstellen';
  
  @override
  String get registrationAs => 'Registrierung als:';
  
  @override
  String get personWithDementia => 'Person mit Demenz';
  
  @override
  String get caregiver => 'Betreuungsperson';
  
  @override
  String get fullName => 'Vollständiger Name';
  
  @override
  String get selectBirthDate => 'Geburtsdatum auswählen';
  
  @override
  String get gender => 'Geschlecht';
  
  @override
  String get languagePreference => 'Sprachpräferenz';
  
  @override
  String get male => 'Männlich';
  
  @override
  String get female => 'Weiblich';
  
  @override
  String get nonBinary => 'Nicht-binär';
  
  @override
  String get preferNotToSay => 'Keine Angabe';
  
  @override
  String get password => 'Passwort';
  
  @override
  String get confirmPassword => 'Passwort bestätigen';
  
  @override
  String get createAccount => 'Konto erstellen';
  
  @override
  String get createAccountSubtitle => 'Erstellen Sie Ihr Konto, um zu beginnen';
  
  @override
  String get email => 'E-Mail-Adresse';
  
  @override
  String get alreadyHaveAccount => 'Haben Sie bereits ein Konto? ';
  
  @override
  String get signIn => 'Anmelden';
  
  @override
  String get enterFullName => 'Bitte geben Sie Ihren vollständigen Namen ein';
  
  @override
  String get nameMinLength => 'Name muss mindestens 2 Zeichen haben';
  
  @override
  String get enterPassword => 'Bitte geben Sie ein Passwort ein';
  
  @override
  String get passwordMinLength => 'Passwort muss mindestens 6 Zeichen haben';
  
  @override
  String get confirmYourPassword => 'Bitte bestätigen Sie Ihr Passwort';
  
  @override
  String get passwordsDoNotMatch => 'Passwörter stimmen nicht überein';
  
  @override
  String get registrationFailed => 'Registrierung fehlgeschlagen';
  
  // Validation messages
  @override
  String get pleaseEnterEmail => 'Bitte geben Sie Ihre E-Mail-Adresse ein';
  
  @override
  String get pleaseEnterValidEmail => 'Bitte geben Sie eine gültige E-Mail-Adresse ein';
  
  @override
  String get pleaseEnterPassword => 'Bitte geben Sie ein Passwort ein';
  
  @override
  String get passwordMinLengthMessage => 'Passwort muss mindestens 6 Zeichen haben';
  
  @override
  String get pleaseConfirmPassword => 'Bitte bestätigen Sie Ihr Passwort';
  
  @override
  String get passwordsDontMatch => 'Passwörter stimmen nicht überein';
  
  @override
  String get pleaseAcceptTerms => 'Bitte akzeptieren Sie die Geschäftsbedingungen';
  
  // Story screen messages
  @override
  String get failedToLoadStories => 'Geschichten konnten nicht geladen werden';
  
  @override
  String get unknownPlace => 'Unbekannter Ort';
  
  @override
  String get unknown => 'Unbekannt';
  
  @override
  String get germanStory => 'Deutsche Geschichte';
  
  @override
  String get englishStory => 'Englische Geschichte';
  
  @override
  String get audioGenerated => 'Audio Generiert';
  
  @override
  String get audioFileAvailable => 'Audio-Datei für NFC-Wiedergabesystem verfügbar';
  
  // Story form messages
  @override
  String get close => 'Schließen';
  
  @override
  String get stepOf => 'Schritt {current} von {total}';
  
  @override
  String get readyToCreateMemory => 'Bereit, Ihre Erinnerung zu erstellen';
  
  @override
  String get favoritePlace => 'Lieblingsort';
  
  @override
  String get audioGenerated2 => 'Audio wurde für diese Geschichte generiert';
  
  // Login screen messages
  @override
  String get welcomeBack => 'Willkommen zurück';
  
  @override
  String get signInToAccount => 'Melden Sie sich in Ihrem Konto an, um fortzufahren';
  
  @override
  String get forgotPassword => 'Passwort vergessen?';
  
  @override
  String get or => 'oder';
  
  @override
  String get createNewAccount => 'Neues Konto erstellen';
  
  @override
  String get loginFailed => 'Anmeldung fehlgeschlagen';
  
  @override
  String get forgotPasswordComingSoon => 'Passwort vergessen Funktion kommt bald';
  
  // Onboarding screen messages
  @override
  String get setupYourProfile => 'Richten Sie Ihr Profil ein';
  
  @override
  String get howWillYouUse => 'Wie werden Sie die App verwenden?';
  
  @override
  String get selectRoleToPersonalize => 'Bitte wählen Sie Ihre Rolle, um Ihr Erlebnis zu personalisieren';
  
  @override
  String get continueText => 'Weiter';
  
  @override
  String get whatsYourName => 'Wie ist Ihr Name?';
  
  @override
  String get personalizeExperience => 'Dies hilft uns, Ihr Erlebnis zu personalisieren';
  
  @override
  String get whenWereYouBorn => 'Wann wurden Sie geboren?';
  
  @override
  String get ageAppropriateContent => 'Dies hilft uns, altersgerechte Inhalte bereitzustellen';
  
  @override
  String get howDoYouIdentify => 'Wie identifizieren Sie sich?';
  
  @override
  String get other => 'Andere';
  
  @override
  String get completeSetup => 'Setup abschließen';
  
  @override
  String get pleaseCompleteAllFields => 'Bitte füllen Sie alle Felder aus';
  
  @override
  String get failedToCompleteSetup => 'Setup konnte nicht abgeschlossen werden';
}