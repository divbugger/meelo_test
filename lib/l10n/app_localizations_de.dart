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

  // Home Screen
  @override
  String get welcomeToApp => 'Willkommen bei meelo';

  @override
  String get personalMemoryCompanion => 'Ihr persönlicher Erinnerungsbegleiter';

  @override
  String get quickActions => 'Schnellzugriff';

  @override
  String get viewYourStories => 'Ihre Geschichten ansehen';

  @override
  String get manageSettings => 'Einstellungen verwalten';

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
  String get welcomeBack => 'Willkommen';
  
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

  // Profile Section
  @override
  String get user => 'Benutzer';

  @override
  String get familyMembers => 'Familienmitglieder';

  @override
  String get addFamilyMember => 'Familienmitglied hinzufügen';

  @override
  String get others => 'Sonstiges';

  @override
  String get notifications => 'Benachrichtigungen';

  @override
  String get feedbackAndSupport => 'Feedback & Unterstützung';

  @override
  String get help => 'Hilfe';

  @override
  String get privacy => 'Datenschutz';

  @override
  String get imprint => 'Impressum';

  @override
  String get deleteAccount => 'Konto löschen';

  // User Profile
  @override
  String get editProfile => 'Profil bearbeiten';

  @override
  String get nickname => 'Spitzname';

  @override
  String get enterNickname => 'Spitzname eingeben (optional)';

  @override
  String get profileUpdated => 'Profil erfolgreich aktualisiert';

  @override
  String get failedToUpdateProfile => 'Profil konnte nicht aktualisiert werden';

  // Family Members
  @override
  String get noFamilyMembers => 'Noch keine Familienmitglieder verbunden';

  @override
  String get inviteFamilyMember => 'Familienmitglied einladen';

  @override
  String get familyMemberEmail => 'E-Mail des Familienmitglieds';

  @override
  String get relation => 'Beziehung';

  @override
  String get selectRelation => 'Beziehung auswählen';

  @override
  String get spouse => 'Ehepartner/in';

  @override
  String get child => 'Kind';

  @override
  String get parent => 'Elternteil';

  @override
  String get sibling => 'Geschwister';

  @override
  String get grandchild => 'Enkelkind';

  @override
  String get grandparent => 'Großelternteil';

  @override
  String get friend => 'Freund/in';

  @override
  String get professionalCaregiver => 'Professionelle Pflegekraft';

  @override
  String get familyMemberName => 'Name des Familienmitglieds';

  @override
  String get familyMemberNameOptional => 'Name (optional)';

  @override
  String get sendInvitation => 'Einladung senden';

  @override
  String get invitationSent => 'Einladung erfolgreich gesendet!';

  @override
  String get failedToSendInvitation => 'Einladung konnte nicht gesendet werden';

  @override
  String get removeFamilyMember => 'Familienmitglied entfernen';

  @override
  String get removeFamilyMemberConfirmation => 'Sind Sie sicher, dass Sie dieses Familienmitglied entfernen möchten?';

  @override
  String get pendingInvitation => 'Ausstehend';

  @override
  String get accepted => 'Angenommen';

  @override
  String get rejected => 'Abgelehnt';

  @override
  String get expired => 'Abgelaufen';

  // Figures/Healthcare
  @override
  String get figureConnections => 'Figurenverbindungen';

  @override
  String get noFigureConnections => 'Keine Gesundheitsfiguren verbunden';

  @override
  String get addFigureConnection => 'Figurenverbindung hinzufügen';

  @override
  String get figureName => 'Figurenname';

  @override
  String get figureType => 'Figurentyp';

  @override
  String get selectFigureType => 'Figurentyp auswählen';

  @override
  String get doctor => 'Arzt/Ärztin';

  @override
  String get nurse => 'Krankenpfleger/in';

  @override
  String get therapist => 'Therapeut/in';

  @override
  String get healthDevice => 'Gesundheitsgerät';

  @override
  String get description => 'Beschreibung';

  @override
  String get contactInfo => 'Kontaktinformationen';

  @override
  String get active => 'Aktiv';

  @override
  String get inactive => 'Inaktiv';

  @override
  String get pending => 'Ausstehend';

  @override
  String get disconnected => 'Getrennt';

  @override
  String get connectionGuide => 'Verbindungsleitfaden';

  @override
  String get figureConnectionAdded => 'Figurenverbindung erfolgreich hinzugefügt!';

  @override
  String get failedToAddFigureConnection => 'Figurenverbindung konnte nicht hinzugefügt werden';

  @override
  String get removeFigureConnection => 'Verbindung entfernen';

  @override
  String get removeFigureConnectionConfirmation => 'Sind Sie sicher, dass Sie diese Verbindung entfernen möchten?';

  // Figure Types
  @override
  String get lifeStory => 'Lebensgeschichte';

  @override
  String get familyAndFriends => 'Familie & Freunde';

  @override
  String get music => 'Musik';

  // Figure Connection Status
  @override
  String get boxConnectionStatus => 'Box-Verbindungsstatus';

  @override
  String get boxConnectionDescription => 'Verbinden oder trennen Sie Ihre Figuren mit der Box';

  @override
  String get connectedToBox => 'Mit Box verbunden';

  @override
  String get notConnected => 'Nicht verbunden';

  @override
  String get noFiguresConnectedToBox => 'Keine Figuren mit Box verbunden';

  @override
  String get figuresConnectedToBox => 'Figuren verbunden';

  @override
  String get failedToUpdateConnectionStatus => 'Verbindungsstatus konnte nicht aktualisiert werden';

  // Notification Settings
  @override
  String get storyNotifications => 'Geschichte-Benachrichtigungen';

  @override
  String get familyUpdateNotifications => 'Familien-Update-Benachrichtigungen';

  @override
  String get reminderNotifications => 'Erinnerungsbenachrichtigungen';

  @override
  String get generalNotifications => 'Allgemeine Benachrichtigungen';

  @override
  String get notificationSettings => 'Benachrichtigungseinstellungen';

  // Feedback & Support
  @override
  String get giveFeedback => 'Feedback geben';

  @override
  String get feedbackEmailSubject => 'meelo App Feedback';

  @override
  String get feedbackEmailBody => 'Bitte teilen Sie hier Ihr Feedback zur meelo App mit...';

  @override
  String get dataPrivacy => 'Datenschutzrichtlinien';

  @override
  String get termsOfService => 'Nutzungsbedingungen';

  // Account Management
  @override
  String get deleteAccountWarning => 'Warnung: Dies wird Ihr Konto und alle zugehörigen Daten dauerhaft löschen.';

  @override
  String get deleteAccountConfirmation => 'Sind Sie sicher, dass Sie Ihr Konto löschen möchten? Diese Aktion kann nicht rückgängig gemacht werden.';

  @override
  String get accountDeleted => 'Konto erfolgreich gelöscht';

  @override
  String get failedToDeleteAccount => 'Konto konnte nicht gelöscht werden';
}