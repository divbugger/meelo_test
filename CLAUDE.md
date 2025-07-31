# CLAUDE.md - Project Context for idememory Flutter App

## Project Overview
**idememory** is a Flutter mobile application designed to help people with dementia and their caregivers manage memories and stories. The app supports both English and German languages and uses a purple branding theme.

## Recent Changes (2025-01-30)
- **App Simplification**: Removed events and email address features to focus on core story/memory functionality
- **Navigation Streamlined**: Eliminated bottom navigation bar; app now shows Stories screen directly
- **Localization Cleanup**: Removed all event and email-related text strings from English and German translations
- **Codebase Cleanup**: Deleted `/screens/event/` and `/screens/email/` directories completely
- **Backend Verification**: Confirmed Supabase database contains no events/email tables - no backend changes needed
- **Figma Design Integration**: Successfully integrated Figma MCP Server for design-to-code workflow
- **Registration Flow Redesign**: Completely redesigned user registration with modern UI matching Figma designs
- **Two-Step Registration**: Split registration into Email Registration → Password Setup flow
- **German Localization**: Added German text throughout the new registration screens
- **UI Overflow Fixes**: Resolved RenderFlex overflow issues in user mode selection and password setup screens
- **Enhanced User Experience**: Improved card layouts, keyboard handling, and responsive design

## Project Structure

### Core Architecture
- **State Management**: Provider pattern for global state
- **Backend**: Supabase for authentication and database
- **Fonts**: Manrope font family (Regular, Medium, SemiBold, Bold)
- **Theme**: Purple primary color (#483FA9) with white backgrounds
- **Platforms**: iOS, Android

### Key Directories
```
lib/
├── main.dart                      # App entry point with theme and providers
├── screens/
│   ├── auth/                      # Authentication screens
│   │   ├── login_screen.dart      # Login with email/password
│   │   ├── user_mode_selection_screen.dart  # Choose user type
│   │   ├── email_registration_screen.dart   # NEW: Figma-designed email step
│   │   ├── password_setup_screen.dart       # NEW: Password and profile setup
│   │   ├── signup_screen.dart               # Redirects to new flow
│   │   └── signup_screen_legacy.dart        # Legacy backup
│   ├── main_tabs_screen.dart      # Main app navigation (Stories only)
│   ├── splash_screen.dart         # App startup screen
│   └── story/                     # Story screens
├── services/
│   ├── auth_service.dart          # Supabase authentication
│   ├── language_service.dart      # Localization management
│   ├── user_preferences_service.dart  # User settings
│   ├── elevenlabs_service.dart    # Text-to-speech
│   └── mistral_service.dart       # AI text processing
├── widgets/
│   ├── idem_logo.dart             # App logo component
│   └── language_selector.dart     # Language switcher
└── l10n/                          # Localization files
    ├── app_localizations.dart
    ├── app_localizations_en.dart
    └── app_localizations_de.dart
```

## Authentication Flow

### Current User Registration Flow
1. **Login Screen** → "Create New Account" button
2. **User Mode Selection** → Choose "Person with Dementia" or "Caregiver"
3. **Email Registration** (Figma design) → Email input + terms acceptance
4. **Password Setup** → Name, birthdate, gender, language, password
5. **Stories Screen** → Direct access to memory management (simplified single-screen interface)

### User Types (UserMode enum)
- `UserMode.personWithDementia` - Primary users with dementia
- `UserMode.caregiver` - Family members, friends, professional caregivers

## Design System

### Colors
- **Primary Purple**: `#483FA9` (Color(0xFF483FA9))
- **Light Purple**: `#E6EEFE` (borders, backgrounds)
- **Background**: `#FFFFFF` (white)
- **Text Dark**: `#040506` (primary text)
- **Disabled**: `#D4D2D1` (disabled buttons)

### Typography
- **Font Family**: Manrope
- **Sizes**: 48px (nav), 32px (headers), 20px (subheaders), 16px (body), 14px (small)
- **Weights**: Regular (400), Medium (500), SemiBold (600), Bold (700)

### Layout Standards
- **Screen Padding**: 24px horizontal, 16px vertical
- **Element Spacing**: 16px standard, 32px large gaps
- **Corner Radius**: 12px standard, 100px for pills
- **Button Height**: 56px for primary actions
- **Card Design**: 48x48px icons, 16px titles, 12-13px body text with proper overflow handling

## Key Services

### AuthService
- **Location**: `lib/services/auth_service.dart`
- **Functions**: `signUp()`, `signIn()`, `signOut()`
- **Integration**: Supabase authentication
- **User Data**: Name, email, birthdate, gender, language, user mode

### LanguageService
- **Location**: `lib/services/language_service.dart`
- **Supported Languages**: English ('en'), German ('de')
- **Storage**: SharedPreferences for persistence

### StoryService
- **Location**: `lib/services/story_service.dart`
- **Functions**: `fetchStories()`, `createStory()`, `updateStory()`, `deleteStory()`
- **Integration**: Supabase database with AI story generation (Mistral) and text-to-speech (ElevenLabs)
- **Features**: Multi-language support, audio generation, optional interesting facts

### UserPreferencesService
- **Location**: `lib/services/user_preferences_service.dart`
- **Purpose**: User settings and preferences management

## Environment Configuration

### Required Environment Variables (.env)
```
SUPABASE_URL=your_supabase_url
SUPABASE_KEY=your_supabase_anon_key
MISTRAL_API_KEY=your_mistral_api_key
ELEVENLABS_API_KEY=your_elevenlabs_api_key
```

### Figma Integration
- **MCP Server**: Configured for design-to-code workflow
- **API Token**: Set up for accessing Figma designs
- **Usage**: Generate Flutter widgets from Figma frames

## Development Guidelines

### Code Standards
- **Naming**: Use descriptive variable names in English
- **Comments**: German user-facing text, English code comments
- **Error Handling**: Always wrap async operations in try-catch
- **State Management**: Use Provider for global state, setState for local state
- **UI Responsiveness**: Always handle overflow with proper constraints and flexible layouts
- **Mobile UX**: Implement keyboard dismissal and tap-outside interactions for better usability

### Testing
- **Unit Tests**: Located in `test/` directory
- **Widget Tests**: Test UI components individually
- **Integration Tests**: Test complete user flows

### Common Commands
```bash
# Run the app
flutter run

# Run tests
flutter test

# Build for release
flutter build apk
flutter build ios

# Analyze code
flutter analyze

# Format code
flutter format .
```

## Database Schema (Supabase)

### Tables
- **profiles**: User profile information (name, birth_date, gender, language, user_mode)
- **stories**: AI-generated stories and memories with audio files

### Storage Buckets
- **story_audio**: MP3 audio files generated by ElevenLabs text-to-speech

### Policies
- Row-level security enabled
- Users can only access their own data
- Caregivers can access linked patient data (if implemented)

## Recent Integrations

### Figma MCP Server Setup
1. **Enabled**: Figma Dev Mode MCP Server in desktop app
2. **Connected**: Successfully integrated with Claude Code
3. **Usage**: Generated `email_registration_screen.dart` from Figma design
4. **Benefits**: Pixel-perfect design implementation, faster development

### New Registration Screens
1. **EmailRegistrationScreen**: Figma-designed email input with terms acceptance
2. **PasswordSetupScreen**: Complete user profile setup with German localization and improved keyboard handling
3. **UserModeSelectionScreen**: Enhanced layout with responsive card design and proper overflow handling
4. **Navigation**: Seamless flow between screens with proper data passing

## Core Features

### Story Management
- **AI Story Generation**: Uses Mistral AI to create personalized stories from user inputs
- **Multi-language Support**: Stories generated in English or German based on user language preference
- **Text-to-Speech**: ElevenLabs integration for audio narration of stories
- **User Inputs**: Name, favorite place, personal connection, optional interesting facts
- **Storage**: Stories and audio files stored in Supabase with real-time synchronization

### Simplified User Experience
- **Single Screen Focus**: Direct access to story creation and management
- **No Navigation Complexity**: Removed multi-tab interface for elderly user accessibility
- **Streamlined Workflow**: Create → Generate → Listen to stories in simple steps

## Known Issues & TODOs

### Current Issues
- None currently identified

### Recently Fixed Issues
- **RenderFlex Overflow**: Fixed overflow errors in user mode selection cards and password setup form
- **Card Layout**: Improved responsive design for user type selection cards with proper height management
- **Keyboard Handling**: Added tap-outside-to-dismiss functionality for better mobile UX

### Future Enhancements
- [ ] Add forgot password functionality
- [ ] Implement email verification step
- [ ] Add social login options (Google, Apple)
- [ ] Enhance error messages with better localization
- [ ] Add accessibility features (screen reader support)
- [ ] Implement dark mode theme
- [ ] Add story sharing capabilities
- [ ] Implement offline story playback

## Deployment

### Android
- **Build**: `flutter build apk --release`
- **Signing**: Configure in `android/app/build.gradle`

### iOS
- **Build**: `flutter build ios --release`
- **Signing**: Configure in Xcode project

### Web
- **Build**: `flutter build web`
- **Hosting**: Can be deployed to any static hosting service

## Support & Maintenance

### Dependencies
- **Flutter SDK**: >=3.0.0 <4.0.0
- **Key Packages**: supabase_flutter, provider, flutter_dotenv, http, uuid
- **AI Services**: Mistral AI for story generation, ElevenLabs for text-to-speech
- **Dev Dependencies**: flutter_test, flutter_lints

### Monitoring
- **Analytics**: Not currently implemented
- **Crash Reporting**: Not currently implemented
- **Performance**: Monitor app startup time and memory usage

## Contact & Resources

### Development Team
- **Primary Language**: German (user-facing), English (code)
- **Target Users**: German-speaking dementia patients and caregivers
- **Accessibility**: Important for elderly users with varying technical skills

### External Resources
- **Figma Design**: MVP-Design project with registration flow
- **Supabase**: Backend infrastructure and real-time database
- **ElevenLabs**: Text-to-speech service for audio narration
- **Mistral AI**: Large language model for story generation
- **Storage**: Supabase Storage for audio file management

---

*Last Updated: January 30, 2025*
*Project: idememory Flutter App*
*Version: 1.0.0+1*