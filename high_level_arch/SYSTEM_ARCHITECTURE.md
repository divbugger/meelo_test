# Meelo Flutter App - System Architecture

## Overview
The Meelo mobile application is a Flutter-based system designed to help people with dementia and their caregivers manage memories and stories. The architecture follows a layered approach with clear separation of concerns and robust backend integration.

## Architecture Layers

### 1. Flutter Mobile Application Layer
**Technology:** Flutter SDK, Dart
**Purpose:** User interface and user experience

#### UI Components:
- **Auth Screens**: Login, registration, user mode selection
- **Home Dashboard**: Personalized greeting, quick actions
- **Memories Screen**: Story management (CRUD operations)
- **Profile Screen**: Settings, language selection, account management
- **Questionnaire Screen**: Future cognitive assessments (placeholder)
- **Figures Screen**: Future analytics/data visualization (placeholder)

#### Key Features:
- Multi-tab bottom navigation with IndexedStack
- Real-time UI updates via Provider state management
- Full localization support (English/German)
- Responsive design for elderly users

### 2. Service Layer
**Technology:** Dart classes with ChangeNotifier pattern
**Purpose:** Business logic and external API integration

#### Core Services:

##### AuthService (`lib/services/auth_service.dart`)
- **Communication:** Supabase Auth API
- **Protocol:** HTTPS/REST
- **Functions:**
  - `signUp()` - User registration
  - `signIn()` - User authentication
  - `signOut()` - Session termination
  - `completeUserProfile()` - Profile setup
  - `checkEmailVerification()` - Email verification status
- **Data Flow:** Flutter UI ↔ AuthService ↔ Supabase Auth ↔ PostgreSQL (profiles table)

##### StoryService (`lib/services/story_service.dart`)
- **Communication:** Supabase Database, Mistral AI, ElevenLabs
- **Protocol:** HTTPS/REST, WebSocket (real-time)
- **Functions:**
  - `fetchStories()` - Retrieve user stories
  - `createStory()` - Generate new story with AI and audio
  - `updateStory()` - Modify existing stories
  - `deleteStory()` - Remove stories and audio files
- **Data Flow:** UI ↔ StoryService ↔ [MistralService + ElevenLabsService] → Supabase (database + storage)

##### MistralService (`lib/services/mistral_service.dart`)
- **Communication:** Mistral AI API
- **Protocol:** HTTPS/JSON
- **Endpoint:** `https://api.mistral.ai/v1/chat/completions`
- **Functions:**
  - `generateStory()` - Create personalized stories from user inputs
  - `verifyApiKey()` - Validate API key
- **Features:**
  - Multi-language story generation (English/German)
  - Optional interesting facts integration
  - Timeout handling and error management

##### ElevenLabsService (`lib/services/elevenlabs_service.dart`)
- **Communication:** ElevenLabs API
- **Protocol:** HTTPS/JSON
- **Endpoint:** `https://api.elevenlabs.io/v1/text-to-speech/{voice_id}`
- **Functions:**
  - `generateAudio()` - Convert text to speech
  - `verifyApiKey()` - Validate API key
  - `getVoices()` - Retrieve available voices
- **Features:**
  - Language-specific voices (English: Charlotte, German: Arabella)
  - Multi-language model selection
  - Binary audio data handling (MP3 format)

##### LanguageService (`lib/services/language_service.dart`)
- **Communication:** SharedPreferences (local storage)
- **Protocol:** Local I/O
- **Functions:**
  - Locale management (English/German)
  - Persistent language preference storage
  - Real-time language switching

##### UserPreferencesService (`lib/services/user_preferences_service.dart`)
- **Communication:** SharedPreferences
- **Protocol:** Local I/O
- **Purpose:** General user settings and preferences management

### 3. Backend Layer

#### Supabase Backend
**Technology:** Supabase (PostgreSQL + Real-time + Auth + Storage)
**Communication:** HTTPS/REST API, WebSocket

##### Authentication Module:
- **JWT-based authentication**
- **Email/password authentication**
- **Row-level security (RLS)**
- **Email verification workflow**

##### Database (PostgreSQL):
- **profiles table**: User data (name, birth_date, gender, language, user_mode)
- **stories table**: Story content, metadata, audio URLs
- **Real-time subscriptions**: Live data synchronization

##### File Storage:
- **story_audio bucket**: MP3 audio files
- **Public URL generation**: Direct access to audio files
- **Automatic cleanup**: File deletion on story removal

#### External AI Services:

##### Mistral AI API:
- **Model**: mistral-tiny
- **Purpose**: Story generation from user inputs
- **Input**: Name, favorite place, personal connection, optional interesting fact
- **Output**: 4-sentence personalized story
- **Languages**: English, German
- **Authentication**: Bearer token

##### ElevenLabs API:
- **Purpose**: Text-to-speech conversion
- **Models**: eleven_monolingual_v1 (English), eleven_multilingual_v2 (German)
- **Voice IDs**: 
  - English: XB0fDUnXU5powFXDhCwa (Charlotte)
  - German: Z3R5wn05IrDiVCyEkUrK (Arabella)
- **Output Format**: MP3 audio
- **Authentication**: xi-api-key header

### 4. Local Storage Layer
**Technology:** SharedPreferences (Flutter)
**Protocol:** Local device I/O

#### Stored Data:
- User language preferences
- Authentication tokens (managed by Supabase)
- User mode selection
- App configuration settings

### 5. Data Persistence Layer

#### Database Schema (Supabase PostgreSQL):
```sql
-- profiles table
id (UUID, Primary Key)
name (VARCHAR)
birth_date (DATE)
gender (VARCHAR)
language (VARCHAR)
user_mode (VARCHAR)
created_at (TIMESTAMP)
updated_at (TIMESTAMP)

-- stories table
id (SERIAL, Primary Key)
user_id (UUID, Foreign Key)
storyteller_name (VARCHAR)
place_name (VARCHAR)
personal_connection (TEXT)
interesting_fact (TEXT, OPTIONAL)
generated_story (TEXT)
audio_url (VARCHAR)
language (VARCHAR)
created_at (TIMESTAMP)
updated_at (TIMESTAMP)
```

#### File Storage Structure:
```
story_audio/
├── story_{uuid1}.mp3
├── story_{uuid2}.mp3
└── story_{uuid3}.mp3
```

## Communication Patterns

### 1. User Authentication Flow:
```
Flutter UI → AuthService → Supabase Auth API → PostgreSQL (profiles)
```

### 2. Story Creation Flow:
```
User Input → StoryService → MistralService → Mistral API (story generation)
                          ↓
Generated Story → ElevenLabsService → ElevenLabs API (audio generation)
                          ↓
Audio File → Supabase Storage → Database (audio URL) → Real-time update → UI
```

### 3. Real-time Synchronization:
```
Database Change → Supabase Real-time → WebSocket → StoryService → Provider → UI Update
```

### 4. Language Management:
```
User Selection → LanguageService → SharedPreferences
                               ↓
                User Profile Update → Supabase → Profile sync
```

## Security Implementation

### Authentication:
- JWT tokens for session management
- Email verification required
- Row-level security (RLS) policies
- Secure password hashing (Supabase managed)

### API Security:
- API keys stored in environment variables (.env)
- HTTPS-only communication
- Request timeouts and error handling
- Input validation and sanitization

### Data Privacy:
- User data isolation via RLS
- No sensitive data logging
- Secure file storage with public URLs

## Error Handling & Resilience

### Network Resilience:
- Timeout handling for API calls (30 seconds)
- Retry mechanisms for failed requests
- Graceful degradation when services unavailable

### Error Recovery:
- Try-catch blocks around all async operations
- User-friendly error messages
- Fallback behaviors for missing data

### Performance Optimization:
- Lazy loading of stories
- Efficient state management with Provider
- Optimized real-time subscriptions
- Image and audio caching strategies

## Development Environment

### Required Environment Variables:
```bash
SUPABASE_URL=your_supabase_project_url
SUPABASE_KEY=your_supabase_anon_key
MISTRAL_API_KEY=your_mistral_api_key
ELEVENLABS_API_KEY=your_elevenlabs_api_key
```

### Dependencies:
- supabase_flutter: Backend integration
- provider: State management
- flutter_dotenv: Environment variables
- http: HTTP client
- shared_preferences: Local storage
- uuid: Unique identifier generation

## Deployment Architecture

### Mobile App:
- iOS App Store / Google Play Store distribution
- Platform-specific builds (iOS/Android)
- Code signing and release management

### Backend Services:
- Supabase: Managed PostgreSQL, Auth, Storage, Real-time
- Mistral AI: Hosted AI inference service
- ElevenLabs: Hosted text-to-speech service

### Environment Configuration:
- Development: Local Flutter development with cloud backend
- Production: Released mobile app with production backend services

## Future Scalability Considerations

### Performance:
- Database indexing for story queries
- CDN for audio file delivery
- Caching layers for frequently accessed data

### Features:
- Caregiver-patient data sharing
- Advanced analytics in Figures screen
- Cognitive assessment in Questionnaire screen
- Social features and story sharing

### Infrastructure:
- Database sharding for large user bases
- Multiple region deployment
- Advanced monitoring and alerting

This architecture provides a robust, scalable foundation for the Meelo application while maintaining security, performance, and user experience standards appropriate for elderly users and caregivers.