# 🎓 EdgeUp UPSC - Student Application

A comprehensive Flutter application for UPSC students with secure authentication, 2FA email verification, and modern UI/UX.

![Flutter](https://img.shields.io/badge/Flutter-02569B?style=for-the-badge&logo=flutter&logoColor=white)
![Firebase](https://img.shields.io/badge/Firebase-FFCA28?style=for-the-badge&logo=firebase&logoColor=black)
![Dart](https://img.shields.io/badge/Dart-0175C2?style=for-the-badge&logo=dart&logoColor=white)

---

## ✨ Features

### 🔐 Authentication & Security
- **Email/Password Authentication** with Firebase
- **2-Factor Authentication (2FA)** with email verification codes
- **Email Verification** requirement for new accounts
- **Forgot Password** functionality with email reset links
- **Secure Session Management** with Firebase Auth
- **6-digit Verification Codes** with 5-minute expiry
- **One-time Use Codes** - codes can't be reused
- **Email History Tracking** - all auth events logged in Firestore

### 🎨 User Interface
- **Beautiful Material Design** with custom theme
- **Dark/Light Mode** support
- **Smooth Animations** and page transitions
- **Responsive Layout** for all screen sizes
- **Custom 6-digit Code Input** dialog with auto-focus
- **Gradient Buttons** and modern UI elements
- **Glassmorphism Effects** for premium feel

### 📱 Multi-Platform Support
- ✅ Android
- ✅ iOS
- ✅ Web
- ✅ Windows
- ✅ macOS
- ✅ Linux

### 🏗️ Architecture
- **Clean Architecture** (Domain, Data, Presentation layers)
- **BLoC Pattern** for state management
- **Dependency Injection** with GetIt
- **Repository Pattern** for data access
- **SOLID Principles** throughout codebase

---

## 🚀 Quick Start

### Prerequisites

- **Flutter SDK**: ^3.9.2
- **Dart**: ^3.9.2
- **Firebase Project** (free tier works)
- **Node.js** (for Firebase Functions - optional)

### Installation

1. **Clone the repository**:
```bash
git clone https://github.com/shxkir/edgeup-application.git
cd edgeup-application/edgeup_upsc_app
```

2. **Install dependencies**:
```bash
flutter pub get
```

3. **Configure Firebase**:
   - Follow: [FIREBASE_SETUP_GUIDE.md](FIREBASE_SETUP_GUIDE.md)
   - Add your `google-services.json` (Android)
   - Add your `GoogleService-Info.plist` (iOS)

4. **Run the app**:
```bash
flutter run
```

---

## 📧 Email Sending Setup

The app uses **2-Factor Authentication** with email verification codes. To enable email sending:

### Option 1: Firebase Cloud Functions (Recommended)

**Best for production** - Server-side email sending with Gmail SMTP

📖 **Follow**: [FIREBASE_FUNCTIONS_SIMPLE_SETUP.md](FIREBASE_FUNCTIONS_SIMPLE_SETUP.md)

**Time**: 20 minutes
**Cost**: $0-2/month (mostly free)

### Option 2: Manual Testing (Development)

For testing without emails, retrieve codes from Firestore:

1. Login with email/password
2. Go to Firebase Console → Firestore Database
3. Open `verification_codes` collection
4. Find your user document
5. Copy the `code` field
6. Enter in the app dialog

📖 **Full Guide**: [2FA_IMPLEMENTATION_GUIDE.md](2FA_IMPLEMENTATION_GUIDE.md)

---

## 📚 Documentation

| File | Description |
|------|-------------|
| [FIREBASE_SETUP_GUIDE.md](FIREBASE_SETUP_GUIDE.md) | Complete Firebase configuration |
| [2FA_IMPLEMENTATION_GUIDE.md](2FA_IMPLEMENTATION_GUIDE.md) | 2FA system details and testing |
| [FIREBASE_FUNCTIONS_SIMPLE_SETUP.md](FIREBASE_FUNCTIONS_SIMPLE_SETUP.md) | Email sending with Cloud Functions |
| [QUICK_START.md](QUICK_START.md) | Quick reference guide |
| [IMPLEMENTATION_SUMMARY.md](IMPLEMENTATION_SUMMARY.md) | Technical implementation details |

---

## 🏗️ Project Structure

```
edgeup-application/
├── edgeup_upsc_app/
│   ├── lib/
│   │   ├── core/
│   │   │   ├── error/
│   │   │   ├── usecases/
│   │   │   └── utils/
│   │   │       ├── app_theme.dart          # Custom theme
│   │   │       ├── theme_manager.dart      # Dark/Light mode
│   │   │       └── page_transitions.dart   # Animations
│   │   ├── features/
│   │   │   ├── auth/
│   │   │   │   ├── data/
│   │   │   │   │   ├── datasources/
│   │   │   │   │   │   └── auth_remote_data_source.dart
│   │   │   │   │   ├── models/
│   │   │   │   │   └── repositories/
│   │   │   │   ├── domain/
│   │   │   │   │   ├── entities/
│   │   │   │   │   ├── repositories/
│   │   │   │   │   └── usecases/
│   │   │   │   ├── presentation/
│   │   │   │   │   ├── pages/
│   │   │   │   │   │   ├── login_page.dart
│   │   │   │   │   │   └── signup_page.dart
│   │   │   │   │   ├── widgets/
│   │   │   │   │   │   └── verification_code_dialog.dart
│   │   │   │   │   └── bloc/
│   │   │   │   └── services/
│   │   │   │       ├── verification_code_service.dart
│   │   │   │       └── emailjs_service.dart
│   │   │   └── dashboard/
│   │   │       ├── data/
│   │   │       ├── domain/
│   │   │       └── presentation/
│   │   │           └── pages/
│   │   │               └── dashboard_page.dart
│   │   └── injection_container.dart    # Dependency injection
│   ├── test/
│   ├── pubspec.yaml
│   └── README.md
├── functions/                          # Firebase Cloud Functions (optional)
│   ├── index.js
│   └── package.json
└── Documentation files (.md)
```

---

## 🔥 Firebase Collections

### `users`
Stores user profile data:
```javascript
{
  uid: "user_id",
  email: "user@example.com",
  firstName: "John",
  lastName: "Doe",
  createdAt: Timestamp,
  emailVerified: true
}
```

### `verification_codes`
Temporary 2FA codes (5-minute expiry):
```javascript
{
  email: "user@example.com",
  code: "123456",
  expiryTime: Timestamp,
  createdAt: Timestamp,
  verified: false,
  verifiedAt: Timestamp // after verification
}
```

### `email_history`
Email event tracking:
```javascript
{
  email: "user@example.com",
  eventType: "2fa_code_generated",
  status: "success",
  reason: "Verification code sent",
  timestamp: Timestamp,
  ipAddress: "N/A",
  deviceInfo: "Flutter App"
}
```

---

## 🔒 Security Features

✅ **Firebase Authentication** - Industry-standard security
✅ **Email Verification** - Prevents fake accounts
✅ **2FA Codes** - 6-digit random codes (1 in 1 million)
✅ **Time-based Expiry** - Codes expire after 5 minutes
✅ **One-time Use** - Codes can't be reused
✅ **Firestore Security Rules** - User-specific data access
✅ **Password Reset** - Secure email-based recovery
✅ **Event Logging** - All auth attempts tracked
✅ **Rate Limiting** - Built-in Firebase protection

---

## 📦 Dependencies

### Core
- `flutter: sdk: flutter`
- `cupertino_icons: ^1.0.8`

### State Management
- `flutter_bloc: ^8.1.6`
- `equatable: ^2.0.5`
- `provider: ^6.1.2`

### Firebase
- `firebase_core: ^3.3.0`
- `firebase_auth: ^5.1.4`
- `cloud_firestore: ^5.2.1`
- `firebase_storage: ^12.1.3`
- `firebase_messaging: ^15.0.4`
- `google_sign_in: ^6.2.1`

### Utilities
- `get_it: ^7.7.0` - Dependency injection
- `shared_preferences: ^2.2.3` - Local storage
- `url_launcher: ^6.3.0` - External links
- `dartz: ^0.10.1` - Functional programming
- `intl: ^0.19.0` - Internationalization
- `http: ^1.1.0` - HTTP requests

### Development
- `flutter_test: sdk: flutter`
- `flutter_lints: ^5.0.0`
- `mockito: ^5.4.4`
- `build_runner: ^2.4.11`
- `bloc_test: ^9.1.7`

---

## 🧪 Testing

### Run Tests
```bash
# Unit tests
flutter test

# Widget tests
flutter test test/widget_test.dart

# Integration tests
flutter test integration_test/
```

### Test Coverage
- ✅ Unit tests for services
- ✅ Widget tests for UI components
- ✅ BLoC tests for state management
- ✅ Integration tests for flows

---

## 🎨 Theming

### Custom Theme
The app uses a custom gradient theme with purple/violet accent:

```dart
// Primary Colors
primaryViolet: Color(0xFF667eea)
secondaryPurple: Color(0xFF764ba2)

// Gradient
premiumGradient: LinearGradient(
  colors: [Color(0xFF667eea), Color(0xFF764ba2)],
  begin: Alignment.topLeft,
  end: Alignment.bottomRight,
)

// Dark/Light Mode Support
✅ Dark theme with custom card colors
✅ Light theme with gradient elements
✅ Smooth theme transitions
```

---

## 📱 Screenshots

### Login Screen
- Email/password input with validation
- Forgot password link
- Beautiful gradient buttons
- Smooth animations

### Verification Dialog
- 6-digit code input with auto-focus
- Resend functionality
- Loading states
- Error handling

### Dashboard
- Personalized greeting
- Feature cards with icons
- Smooth navigation
- Premium UI elements

---

## 🚀 Deployment

### Android
```bash
flutter build apk --release
# or
flutter build appbundle --release
```

### iOS
```bash
flutter build ios --release
```

### Web
```bash
flutter build web --release
```

### Windows
```bash
flutter build windows --release
```

---

## 🛠️ Troubleshooting

### Common Issues

**Q: Email verification not working?**
A: Ensure Firebase email settings are enabled in Authentication settings

**Q: 2FA codes not generating?**
A: Check Firestore security rules allow `verification_codes` collection access

**Q: "Permission denied" error?**
A: Update Firestore rules as shown in [2FA_IMPLEMENTATION_GUIDE.md](2FA_IMPLEMENTATION_GUIDE.md)

**Q: Emails not sending?**
A: Set up Firebase Cloud Functions following [FIREBASE_FUNCTIONS_SIMPLE_SETUP.md](FIREBASE_FUNCTIONS_SIMPLE_SETUP.md)

---

## 📈 Roadmap

### Upcoming Features
- [ ] SMS-based 2FA as alternative
- [ ] Biometric authentication
- [ ] Remember trusted devices (30-day bypass)
- [ ] Admin dashboard for user management
- [ ] Email notifications for suspicious logins
- [ ] OAuth providers (Google, Facebook, Apple)
- [ ] Profile management with photo upload
- [ ] Push notifications
- [ ] Study progress tracking
- [ ] Mock test module
- [ ] Discussion forum
- [ ] Offline mode support

---

## 👨‍💻 Development

### Prerequisites for Development
- Flutter SDK: ^3.9.2
- Dart SDK: ^3.9.2
- Android Studio / VS Code with Flutter extensions
- Firebase CLI (for Cloud Functions)
- Git

### Development Setup
1. Fork the repository
2. Create feature branch: `git checkout -b feature/your-feature`
3. Make changes and test thoroughly
4. Commit: `git commit -m "Add your feature"`
5. Push: `git push origin feature/your-feature`
6. Create Pull Request

### Code Style
- Follow Flutter style guide
- Use `flutter analyze` before committing
- Run `flutter format .` for consistent formatting
- Write tests for new features

---

## 📄 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

---

## 🤝 Contributing

Contributions are welcome! Please follow these steps:

1. Fork the Project
2. Create your Feature Branch (`git checkout -b feature/AmazingFeature`)
3. Commit your Changes (`git commit -m 'Add some AmazingFeature'`)
4. Push to the Branch (`git push origin feature/AmazingFeature`)
5. Open a Pull Request

---

## 📞 Support

For questions and support:

- **Issues**: [GitHub Issues](https://github.com/shxkir/edgeup-application/issues)
- **Documentation**: Check the `.md` files in the repository
- **Email**: Contact repository owner

---

## 🙏 Acknowledgments

- **Flutter Team** - Amazing framework
- **Firebase** - Backend infrastructure
- **Material Design** - UI/UX inspiration
- **Community** - Open source contributors

---

## 📊 Project Status

**Version**: 1.0.0
**Status**: ✅ Active Development
**Last Updated**: November 13, 2025

### Recent Updates
- ✅ Complete 2FA email authentication
- ✅ Firebase integration
- ✅ Beautiful UI with dark mode
- ✅ Email verification flow
- ✅ Forgot password functionality
- ✅ Comprehensive documentation

---

## 🔗 Links

- **Repository**: https://github.com/shxkir/edgeup-application
- **Firebase Console**: https://console.firebase.google.com/
- **Flutter Docs**: https://flutter.dev/docs
- **Firebase Docs**: https://firebase.google.com/docs

---

**Built with ❤️ using Flutter and Firebase**

🎓 **EdgeUp UPSC** - Empowering UPSC aspirants with modern technology

---

*This README was generated with assistance from Claude Code*
