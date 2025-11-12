# EdgeUp UPSC Student App

A production-ready Flutter application for UPSC students built with Clean Architecture, Bloc state management, and Firebase.

## Features

- **Authentication**: Email/password and Google Sign-In via Firebase
- **Dashboard**: View next classes, upcoming quizzes, and announcements
- **Portal Access**: Quick access to EdgeUp portal at https://edgeupai.com/portal
- **Clean Architecture**: Separation of concerns with domain, data, and presentation layers
- **State Management**: Bloc pattern for predictable state management
- **Firebase Integration**: Real-time data sync with Firestore
- **Beautiful UI**: Modern, gradient-based design with countdown timers

## Architecture

This app follows Clean Architecture principles with a feature-first folder structure:

```
lib/
├── core/
│   ├── constants/       # App-wide constants
│   ├── errors/          # Error handling and failures
│   ├── usecases/        # Base use case class
│   ├── utils/           # Utilities and theme
│   └── widgets/         # Reusable widgets
├── features/
│   ├── auth/
│   │   ├── data/        # Data sources, models, repositories
│   │   ├── domain/      # Entities, repository interfaces, use cases
│   │   └── presentation/# Bloc, pages, widgets
│   └── dashboard/
│       ├── data/
│       ├── domain/
│       └── presentation/
├── injection_container.dart  # Dependency injection setup
└── main.dart           # App entry point
```

## Setup Instructions

### 1. Prerequisites

- Flutter SDK (3.9.2 or higher)
- Dart SDK
- Firebase account
- Android Studio / VS Code

### 2. Install Dependencies

```bash
flutter pub get
```

### 3. Firebase Setup

#### Option 1: Using FlutterFire CLI (Recommended)

```bash
# Install FlutterFire CLI
dart pub global activate flutterfire_cli

# Configure Firebase for your project
flutterfire configure
```

This will automatically:
- Create a Firebase project (or select existing one)
- Register your Flutter app
- Generate `firebase_options.dart` with your configuration
- Download platform-specific config files

#### Option 2: Manual Setup

1. Create a Firebase project at [Firebase Console](https://console.firebase.google.com)

2. Enable Authentication:
   - Go to Authentication > Sign-in method
   - Enable Email/Password
   - Enable Google Sign-In

3. Create Firestore Database:
   - Go to Firestore Database
   - Create database in production mode
   - Set up the following collections:
     - `users`: User profiles
     - `classes`: Class information
     - `quizzes`: Quiz data
     - `announcements`: Announcements

4. Download configuration files:
   - **Android**: Download `google-services.json` and place in `android/app/`
   - **iOS**: Download `GoogleService-Info.plist` and add to `ios/Runner/`

5. Replace the placeholder content in `lib/firebase_options.dart` with your actual Firebase configuration

### 4. Run the App

```bash
# For development
flutter run

# For release build
flutter run --release
```

## Testing

### Generate Mocks and Run Tests

```bash
# Generate mocks for testing
flutter pub run build_runner build

# Run all tests
flutter test

# Run with coverage
flutter test --coverage
```

## Sample Firestore Data

To populate your Firestore with sample data for testing:

### Classes Collection

```json
{
  "subject": "History",
  "topic": "Ancient India - Mauryan Empire",
  "startTime": "2024-11-15T10:00:00Z",
  "meetLink": "https://meet.google.com/abc-defg-hij",
  "instructor": "Dr. Sharma"
}
```

### Quizzes Collection

```json
{
  "title": "Polity Quiz 1",
  "topic": "Constitutional Bodies",
  "dueDate": "2024-11-20T23:59:59Z",
  "totalQuestions": 50,
  "duration": 60
}
```

### Announcements Collection

```json
{
  "title": "New Study Material Available",
  "message": "NCERT summaries for History are now available in the portal",
  "createdAt": "2024-11-12T08:00:00Z",
  "isImportant": true
}
```

## Key Dependencies

- **flutter_bloc** (^8.1.6): State management
- **get_it** (^7.7.0): Dependency injection
- **firebase_core** (^3.3.0): Firebase initialization
- **firebase_auth** (^5.1.4): Authentication
- **cloud_firestore** (^5.2.1): Database
- **google_sign_in** (^6.2.1): Google authentication
- **shared_preferences** (^2.2.3): Local storage
- **url_launcher** (^6.3.0): External URL handling
- **dartz** (^0.10.1): Functional programming
- **equatable** (^2.0.5): Value equality
- **intl** (^0.19.0): Date formatting

## Customization

### Update Portal URL

Edit `lib/core/constants/app_constants.dart`:

```dart
static const String portalUrl = 'https://your-portal-url.com';
```

### Modify Theme

Edit `lib/core/utils/app_theme.dart` to customize colors and styles.

## Troubleshooting

### Firebase Initialization Error

If you see "Firebase has not been initialized":
- Ensure `flutterfire configure` was run successfully
- Check that `firebase_options.dart` has valid configuration
- Verify platform-specific config files are in place

### Google Sign-In Issues

- **Android**: Ensure SHA-1 fingerprint is added in Firebase Console
- **iOS**: Check that `GoogleService-Info.plist` is properly linked in Xcode

### Build Errors

```bash
# Clean and rebuild
flutter clean
flutter pub get
flutter pub run build_runner build --delete-conflicting-outputs
flutter run
```

## Production Checklist

- [ ] Update Firebase configuration with production credentials
- [ ] Set up proper Firestore security rules
- [ ] Enable Firebase Authentication in production
- [ ] Update app icons and splash screen
- [ ] Configure Android signing
- [ ] Set up iOS provisioning profiles
- [ ] Test on physical devices
- [ ] Set up crash reporting (Firebase Crashlytics)
- [ ] Add proper error logging

---

Built with Flutter & Firebase for EdgeUp UPSC Platform
