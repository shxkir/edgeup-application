class AppConstants {
  // App Info
  static const String appName = 'EdgeUp UPSC';
  static const String appVersion = '1.0.0';

  // Portal URL
  static const String portalUrl = 'https://edgeupai.com/portal';

  // Firebase Collections
  static const String usersCollection = 'users';
  static const String classesCollection = 'classes';
  static const String quizzesCollection = 'quizzes';
  static const String announcementsCollection = 'announcements';

  // Local Storage Keys
  static const String userIdKey = 'user_id';
  static const String userEmailKey = 'user_email';
  static const String userNameKey = 'user_name';
  static const String isLoggedInKey = 'is_logged_in';

  // Error Messages
  static const String serverError = 'Server error occurred';
  static const String cacheError = 'Cache error occurred';
  static const String networkError = 'No internet connection';
  static const String authError = 'Authentication failed';
  static const String validationError = 'Validation failed';

  // Success Messages
  static const String loginSuccess = 'Login successful';
  static const String logoutSuccess = 'Logout successful';
}
