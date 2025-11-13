import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:edgeup_upsc_app/features/auth/data/models/user_model.dart';

abstract class AuthRemoteDataSource {
  Future<UserModel> registerWithEmail({
    required String email,
    required String password,
    required String name,
  });

  Future<UserModel> loginWithEmail({
    required String email,
    required String password,
  });

  Future<UserModel> loginWithGoogle();

  Future<void> logout();

  Future<UserModel?> getCurrentUser();

  Future<void> sendEmailVerification();

  Future<void> sendPasswordResetEmail(String email);

  Future<bool> isEmailVerified();
}

class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  final FirebaseAuth firebaseAuth;
  final FirebaseFirestore firestore;
  final GoogleSignIn googleSignIn;

  AuthRemoteDataSourceImpl({
    required this.firebaseAuth,
    required this.firestore,
    required this.googleSignIn,
  });

  @override
  Future<UserModel> registerWithEmail({
    required String email,
    required String password,
    required String name,
  }) async {
    try {
      // Create user account
      final userCredential = await firebaseAuth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      final user = userCredential.user;
      if (user == null) {
        throw Exception('User is null after registration');
      }

      // Update display name first
      await user.updateDisplayName(name);

      // Create user document in Firestore
      final newUser = UserModel.fromFirebaseUser(
        user.uid,
        email,
        name,
        null,
      );

      await firestore.collection('users').doc(user.uid).set(newUser.toFirestore());

      // Send email verification (don't wait for it to complete)
      user.sendEmailVerification().catchError((error) {
        // Log error but don't fail registration
        print('Email verification sending failed: $error');
      });

      return newUser;
    } on FirebaseAuthException catch (e) {
      throw Exception(_getAuthErrorMessage(e.code));
    } catch (e) {
      throw Exception('Failed to register: ${e.toString()}');
    }
  }

  @override
  Future<UserModel> loginWithEmail({
    required String email,
    required String password,
  }) async {
    try {
      final userCredential = await firebaseAuth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      final user = userCredential.user;
      if (user == null) {
        throw Exception('User is null after login');
      }

      // Check if email is verified
      if (!user.emailVerified) {
        throw Exception('Please verify your email before logging in. Check your inbox for the verification link.');
      }

      // Get user data from Firestore
      final userDoc = await firestore.collection('users').doc(user.uid).get();

      if (userDoc.exists) {
        return UserModel.fromFirestore(userDoc);
      } else {
        // Create user document if it doesn't exist
        final newUser = UserModel.fromFirebaseUser(
          user.uid,
          user.email!,
          user.displayName ?? 'UPSC Student',
          user.photoURL,
        );

        await firestore.collection('users').doc(user.uid).set(newUser.toFirestore());

        return newUser;
      }
    } on FirebaseAuthException catch (e) {
      throw Exception(_getAuthErrorMessage(e.code));
    } catch (e) {
      throw Exception('Failed to login: ${e.toString()}');
    }
  }

  @override
  Future<UserModel> loginWithGoogle() async {
    try {
      // Trigger the authentication flow
      final GoogleSignInAccount? googleUser = await googleSignIn.signIn();

      if (googleUser == null) {
        throw Exception('Google sign in was cancelled');
      }

      // Obtain the auth details from the request
      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;

      // Create a new credential
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      // Sign in to Firebase with the Google credential
      final userCredential =
          await firebaseAuth.signInWithCredential(credential);

      final user = userCredential.user;
      if (user == null) {
        throw Exception('User is null after Google login');
      }

      // Get user data from Firestore
      final userDoc = await firestore.collection('users').doc(user.uid).get();

      if (userDoc.exists) {
        return UserModel.fromFirestore(userDoc);
      } else {
        // Create user document if it doesn't exist
        final newUser = UserModel.fromFirebaseUser(
          user.uid,
          user.email!,
          user.displayName ?? 'UPSC Student',
          user.photoURL,
        );

        await firestore.collection('users').doc(user.uid).set(newUser.toFirestore());

        return newUser;
      }
    } on FirebaseAuthException catch (e) {
      throw Exception(_getAuthErrorMessage(e.code));
    } catch (e) {
      throw Exception('Failed to login with Google: ${e.toString()}');
    }
  }

  @override
  Future<void> logout() async {
    try {
      await Future.wait([
        firebaseAuth.signOut(),
        googleSignIn.signOut(),
      ]);
    } catch (e) {
      throw Exception('Failed to logout: ${e.toString()}');
    }
  }

  @override
  Future<UserModel?> getCurrentUser() async {
    try {
      final user = firebaseAuth.currentUser;
      if (user == null) return null;

      final userDoc = await firestore.collection('users').doc(user.uid).get();

      if (userDoc.exists) {
        return UserModel.fromFirestore(userDoc);
      }

      return null;
    } catch (e) {
      throw Exception('Failed to get current user: ${e.toString()}');
    }
  }

  @override
  Future<void> sendEmailVerification() async {
    try {
      final user = firebaseAuth.currentUser;
      if (user == null) {
        throw Exception('No user is currently signed in');
      }

      if (user.emailVerified) {
        throw Exception('Email is already verified');
      }

      await user.sendEmailVerification();
    } catch (e) {
      throw Exception('Failed to send verification email: ${e.toString()}');
    }
  }

  @override
  Future<void> sendPasswordResetEmail(String email) async {
    try {
      await firebaseAuth.sendPasswordResetEmail(email: email);
    } on FirebaseAuthException catch (e) {
      throw Exception(_getAuthErrorMessage(e.code));
    } catch (e) {
      throw Exception('Failed to send password reset email: ${e.toString()}');
    }
  }

  @override
  Future<bool> isEmailVerified() async {
    try {
      final user = firebaseAuth.currentUser;
      if (user == null) return false;

      // Reload user to get latest email verification status
      await user.reload();
      final refreshedUser = firebaseAuth.currentUser;

      return refreshedUser?.emailVerified ?? false;
    } catch (e) {
      throw Exception('Failed to check email verification status: ${e.toString()}');
    }
  }

  String _getAuthErrorMessage(String code) {
    switch (code) {
      case 'user-not-found':
        return 'No user found with this email.';
      case 'wrong-password':
        return 'Wrong password provided.';
      case 'email-already-in-use':
        return 'An account already exists with this email.';
      case 'invalid-email':
        return 'The email address is not valid.';
      case 'weak-password':
        return 'The password is too weak.';
      case 'user-disabled':
        return 'This user account has been disabled.';
      case 'too-many-requests':
        return 'Too many attempts. Please try again later.';
      case 'operation-not-allowed':
        return 'This operation is not allowed.';
      default:
        return 'Authentication failed. Please try again.';
    }
  }
}
