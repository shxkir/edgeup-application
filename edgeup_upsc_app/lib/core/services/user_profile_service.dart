import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'firestore_service.dart';
import 'firebase_storage_service.dart';

/// Complete example service demonstrating Firebase integration
/// Handles user profiles with Auth, Firestore, and Storage
class UserProfileService {
  final FirestoreService _firestoreService;
  final FirebaseStorageService _storageService;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  static const String _usersCollection = 'users';

  UserProfileService({
    required FirestoreService firestoreService,
    required FirebaseStorageService storageService,
  })  : _firestoreService = firestoreService,
        _storageService = storageService;

  // ==================== AUTH HELPERS ====================

  /// Get current user ID
  String? get currentUserId => _auth.currentUser?.uid;

  /// Check if user is authenticated
  bool get isAuthenticated => _auth.currentUser != null;

  // ==================== CREATE ====================

  /// Create user profile after signup
  Future<void> createUserProfile({
    required String userId,
    required String email,
    required String displayName,
    String? phoneNumber,
    Map<String, dynamic>? additionalData,
  }) async {
    final data = {
      'email': email,
      'displayName': displayName,
      'phoneNumber': phoneNumber,
      'photoUrl': null,
      'bio': '',
      'preferences': {
        'notifications': true,
        'darkMode': false,
      },
      'stats': {
        'testsCompleted': 0,
        'studyHours': 0,
        'rank': 0,
      },
      ...?additionalData,
    };

    await _firestoreService.setDocument(_usersCollection, userId, data);
  }

  // ==================== READ ====================

  /// Get user profile by ID
  Future<Map<String, dynamic>?> getUserProfile(String userId) async {
    return await _firestoreService.getDocument(_usersCollection, userId);
  }

  /// Get current user's profile
  Future<Map<String, dynamic>?> getCurrentUserProfile() async {
    if (currentUserId == null) return null;
    return await getUserProfile(currentUserId!);
  }

  /// Stream current user's profile (real-time updates)
  Stream<Map<String, dynamic>?> streamCurrentUserProfile() {
    if (currentUserId == null) {
      return Stream.value(null);
    }
    return _firestoreService.streamDocument(_usersCollection, currentUserId!);
  }

  /// Search users by display name
  Future<List<Map<String, dynamic>>> searchUsers(String displayName) async {
    return await _firestoreService.queryDocuments(
      _usersCollection,
      whereField: 'displayName',
      whereValue: displayName,
      limit: 20,
    );
  }

  /// Get top users by rank
  Future<List<Map<String, dynamic>>> getTopUsers({int limit = 10}) async {
    return await _firestoreService.queryDocuments(
      _usersCollection,
      orderByField: 'stats.rank',
      descending: true,
      limit: limit,
    );
  }

  // ==================== UPDATE ====================

  /// Update user profile
  Future<void> updateUserProfile(
    String userId,
    Map<String, dynamic> data,
  ) async {
    await _firestoreService.updateDocument(_usersCollection, userId, data);
  }

  /// Update display name
  Future<void> updateDisplayName(String userId, String displayName) async {
    await updateUserProfile(userId, {'displayName': displayName});

    // Also update Firebase Auth profile
    await _auth.currentUser?.updateDisplayName(displayName);
  }

  /// Update bio
  Future<void> updateBio(String userId, String bio) async {
    await updateUserProfile(userId, {'bio': bio});
  }

  /// Update preferences
  Future<void> updatePreferences(
    String userId,
    Map<String, dynamic> preferences,
  ) async {
    await updateUserProfile(userId, {'preferences': preferences});
  }

  /// Increment test count
  Future<void> incrementTestsCompleted(String userId) async {
    await _firestoreService.incrementField(
      _usersCollection,
      userId,
      'stats.testsCompleted',
      1,
    );
  }

  /// Update study hours
  Future<void> addStudyHours(String userId, double hours) async {
    await _firestoreService.incrementField(
      _usersCollection,
      userId,
      'stats.studyHours',
      hours,
    );
  }

  // ==================== PROFILE PHOTO ====================

  /// Upload profile photo
  Future<String> uploadProfilePhoto(String userId, File imageFile) async {
    final path = 'users/$userId/profile_photo.jpg';
    final downloadUrl = await _storageService.uploadFile(imageFile, path);

    // Update Firestore with photo URL
    await updateUserProfile(userId, {'photoUrl': downloadUrl});

    // Also update Firebase Auth profile
    await _auth.currentUser?.updatePhotoURL(downloadUrl);

    return downloadUrl;
  }

  /// Delete profile photo
  Future<void> deleteProfilePhoto(String userId) async {
    final path = 'users/$userId/profile_photo.jpg';

    try {
      await _storageService.deleteFile(path);
      await updateUserProfile(userId, {'photoUrl': null});
      await _auth.currentUser?.updatePhotoURL(null);
    } catch (e) {
      // Photo might not exist, just update Firestore
      await updateUserProfile(userId, {'photoUrl': null});
    }
  }

  // ==================== DELETE ====================

  /// Delete user profile and all associated data
  Future<void> deleteUserProfile(String userId) async {
    // Delete profile photo if exists
    try {
      await deleteProfilePhoto(userId);
    } catch (e) {
      // Ignore if photo doesn't exist
    }

    // Delete Firestore document
    await _firestoreService.deleteDocument(_usersCollection, userId);

    // Delete user from Firebase Auth
    await _auth.currentUser?.delete();
  }

  // ==================== BATCH OPERATIONS ====================

  /// Batch update multiple users (admin function)
  Future<void> batchUpdateUsers(
    List<String> userIds,
    Map<String, dynamic> data,
  ) async {
    final operations = userIds
        .map(
          (userId) => BatchOperation(
            collection: _usersCollection,
            docId: userId,
            type: BatchOperationType.update,
            data: data,
          ),
        )
        .toList();

    await _firestoreService.batchWrite(operations);
  }
}
