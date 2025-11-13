import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'firestore_service.dart';
import 'firebase_storage_service.dart';
import 'user_profile_service.dart';

/// Complete example demonstrating Firebase integration
/// Copy these examples to your actual implementation
class FirebaseExampleUsage {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirestoreService _firestore = FirestoreService();
  final FirebaseStorageService _storage = FirebaseStorageService();
  late final UserProfileService _userProfile;

  FirebaseExampleUsage() {
    _userProfile = UserProfileService(
      firestoreService: _firestore,
      storageService: _storage,
    );
  }

  // ==================== AUTHENTICATION EXAMPLES ====================

  /// Example: Sign up with email and password
  Future<User?> exampleSignUp(
    String email,
    String password,
    String displayName,
  ) async {
    try {
      // 1. Create Firebase Auth account
      final credential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      final user = credential.user;
      if (user != null) {
        // 2. Update display name
        await user.updateDisplayName(displayName);

        // 3. Create Firestore profile
        await _userProfile.createUserProfile(
          userId: user.uid,
          email: email,
          displayName: displayName,
        );

        // 4. Send email verification
        await user.sendEmailVerification();
      }

      return user;
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        throw Exception('The password provided is too weak.');
      } else if (e.code == 'email-already-in-use') {
        throw Exception('An account already exists for that email.');
      }
      rethrow;
    }
  }

  /// Example: Sign in with email and password
  Future<User?> exampleSignIn(String email, String password) async {
    try {
      final credential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      return credential.user;
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        throw Exception('No user found for that email.');
      } else if (e.code == 'wrong-password') {
        throw Exception('Wrong password provided.');
      }
      rethrow;
    }
  }

  /// Example: Sign out
  Future<void> exampleSignOut() async {
    await _auth.signOut();
  }

  /// Example: Reset password
  Future<void> exampleResetPassword(String email) async {
    await _auth.sendPasswordResetEmail(email: email);
  }

  // ==================== FIRESTORE EXAMPLES ====================

  /// Example: Create a study note
  Future<String> exampleCreateNote({
    required String title,
    required String content,
    required List<String> tags,
  }) async {
    final userId = _auth.currentUser?.uid;
    if (userId == null) throw Exception('User not authenticated');

    final noteData = {
      'userId': userId,
      'title': title,
      'content': content,
      'tags': tags,
      'isFavorite': false,
      'views': 0,
    };

    return await _firestore.createDocument('notes', noteData);
  }

  /// Example: Get all user's notes
  Future<List<Map<String, dynamic>>> exampleGetUserNotes() async {
    final userId = _auth.currentUser?.uid;
    if (userId == null) return [];

    return await _firestore.queryDocuments(
      'notes',
      whereField: 'userId',
      whereValue: userId,
      orderByField: 'createdAt',
      descending: true,
    );
  }

  /// Example: Update note
  Future<void> exampleUpdateNote(String noteId, String newContent) async {
    await _firestore.updateDocument('notes', noteId, {
      'content': newContent,
    });
  }

  /// Example: Delete note
  Future<void> exampleDeleteNote(String noteId) async {
    await _firestore.deleteDocument('notes', noteId);
  }

  /// Example: Favorite a note
  Future<void> exampleToggleFavorite(String noteId, bool isFavorite) async {
    await _firestore.updateDocument('notes', noteId, {
      'isFavorite': isFavorite,
    });
  }

  /// Example: Increment note views
  Future<void> exampleIncrementViews(String noteId) async {
    await _firestore.incrementField('notes', noteId, 'views', 1);
  }

  /// Example: Stream notes (real-time updates)
  Stream<List<Map<String, dynamic>>> exampleStreamUserNotes() {
    final userId = _auth.currentUser?.uid;
    if (userId == null) return Stream.value([]);

    return _firestore.streamCollection(
      'notes',
      orderByField: 'createdAt',
      descending: true,
      limit: 50,
    );
  }

  // ==================== STORAGE EXAMPLES ====================

  /// Example: Upload study material PDF
  Future<String> exampleUploadStudyMaterial(File pdfFile) async {
    final userId = _auth.currentUser?.uid;
    if (userId == null) throw Exception('User not authenticated');

    final timestamp = DateTime.now().millisecondsSinceEpoch;
    final path = 'study_materials/$userId/material_$timestamp.pdf';

    return await _storage.uploadFile(pdfFile, path);
  }

  /// Example: Upload profile photo
  Future<String> exampleUploadProfilePhoto(File imageFile) async {
    final userId = _auth.currentUser?.uid;
    if (userId == null) throw Exception('User not authenticated');

    return await _userProfile.uploadProfilePhoto(userId, imageFile);
  }

  /// Example: Delete file
  Future<void> exampleDeleteFile(String path) async {
    await _storage.deleteFile(path);
  }

  // ==================== USER PROFILE EXAMPLES ====================

  /// Example: Get current user profile
  Future<Map<String, dynamic>?> exampleGetProfile() async {
    return await _userProfile.getCurrentUserProfile();
  }

  /// Example: Update profile
  Future<void> exampleUpdateProfile({
    String? displayName,
    String? bio,
    String? phoneNumber,
  }) async {
    final userId = _auth.currentUser?.uid;
    if (userId == null) throw Exception('User not authenticated');

    final updates = <String, dynamic>{};
    if (displayName != null) updates['displayName'] = displayName;
    if (bio != null) updates['bio'] = bio;
    if (phoneNumber != null) updates['phoneNumber'] = phoneNumber;

    await _userProfile.updateUserProfile(userId, updates);
  }

  /// Example: Stream user profile (real-time)
  Stream<Map<String, dynamic>?> exampleStreamProfile() {
    return _userProfile.streamCurrentUserProfile();
  }

  /// Example: Complete a test
  Future<void> exampleCompleteTest(double studyHours) async {
    final userId = _auth.currentUser?.uid;
    if (userId == null) throw Exception('User not authenticated');

    await _userProfile.incrementTestsCompleted(userId);
    await _userProfile.addStudyHours(userId, studyHours);
  }

  // ==================== COMPLEX EXAMPLES ====================

  /// Example: Create a complete study session
  Future<void> exampleCreateStudySession({
    required String subject,
    required int durationMinutes,
    required List<String> topicsCovered,
  }) async {
    final userId = _auth.currentUser?.uid;
    if (userId == null) throw Exception('User not authenticated');

    // 1. Create session document
    await _firestore.createDocument('study_sessions', {
      'userId': userId,
      'subject': subject,
      'durationMinutes': durationMinutes,
      'topicsCovered': topicsCovered,
      'date': DateTime.now().toIso8601String(),
    });

    // 2. Update user stats
    final hours = durationMinutes / 60.0;
    await _userProfile.addStudyHours(userId, hours);

    // 3. Update subject progress
    await _firestore.updateDocument('users', userId, {
      'recentSubjects': FieldValue.arrayUnion([subject]),
    });
  }

  /// Example: Transaction - Transfer points between users
  Future<void> exampleTransferPoints(
    String fromUserId,
    String toUserId,
    int points,
  ) async {
    await _firestore.runTransaction((transaction) async {
      // Get both user documents
      final fromDoc = await transaction.get(
        FirebaseFirestore.instance.collection('users').doc(fromUserId),
      );
      final toDoc = await transaction.get(
        FirebaseFirestore.instance.collection('users').doc(toUserId),
      );

      if (!fromDoc.exists || !toDoc.exists) {
        throw Exception('User not found');
      }

      final fromPoints = fromDoc.data()?['points'] ?? 0;
      if (fromPoints < points) {
        throw Exception('Insufficient points');
      }

      // Update both users
      transaction.update(fromDoc.reference, {
        'points': fromPoints - points,
      });
      transaction.update(toDoc.reference, {
        'points': (toDoc.data()?['points'] ?? 0) + points,
      });
    });
  }

  /// Example: Batch delete old notes
  Future<void> exampleDeleteOldNotes(DateTime beforeDate) async {
    final userId = _auth.currentUser?.uid;
    if (userId == null) throw Exception('User not authenticated');

    // Get old notes
    final notes = await _firestore.queryDocuments(
      'notes',
      whereField: 'userId',
      whereValue: userId,
    );

    final oldNoteIds = notes
        .where((note) {
          final createdAt = note['createdAt'] as Timestamp?;
          if (createdAt == null) return false;
          return createdAt.toDate().isBefore(beforeDate);
        })
        .map((note) => note['id'] as String)
        .toList();

    if (oldNoteIds.isNotEmpty) {
      await _firestore.batchDelete('notes', oldNoteIds);
    }
  }
}

/// Example: Using in a Flutter Widget
///
/// ```dart
/// class ProfilePage extends StatelessWidget {
///   final FirebaseExampleUsage _firebase = FirebaseExampleUsage();
///
///   @override
///   Widget build(BuildContext context) {
///     return StreamBuilder<Map<String, dynamic>?>(
///       stream: _firebase.exampleStreamProfile(),
///       builder: (context, snapshot) {
///         if (snapshot.connectionState == ConnectionState.waiting) {
///           return CircularProgressIndicator();
///         }
///
///         final profile = snapshot.data;
///         if (profile == null) {
///           return Text('No profile found');
///         }
///
///         return Column(
///           children: [
///             Text('Name: ${profile['displayName']}'),
///             Text('Email: ${profile['email']}'),
///             Text('Tests: ${profile['stats']['testsCompleted']}'),
///             ElevatedButton(
///               onPressed: () async {
///                 await _firebase.exampleCompleteTest(1.5);
///               },
///               child: Text('Complete Test'),
///             ),
///           ],
///         );
///       },
///     );
///   }
/// }
/// ```
