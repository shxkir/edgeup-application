import 'dart:math';
import 'package:cloud_firestore/cloud_firestore.dart';

class VerificationCodeService {
  final FirebaseFirestore _firestore;

  VerificationCodeService(this._firestore);

  /// Generate a 6-digit verification code
  String generateCode() {
    final random = Random();
    final code = random.nextInt(900000) + 100000; // Ensures 6 digits
    return code.toString();
  }

  /// Store verification code in Firestore with 5-minute expiry
  Future<String> storeVerificationCode({
    required String email,
    required String userId,
  }) async {
    final code = generateCode();
    final expiryTime = DateTime.now().add(const Duration(minutes: 5));

    await _firestore.collection('verification_codes').doc(userId).set({
      'email': email,
      'code': code,
      'expiryTime': Timestamp.fromDate(expiryTime),
      'createdAt': FieldValue.serverTimestamp(),
      'verified': false,
    });

    // Log to email_history
    await _firestore.collection('email_history').add({
      'email': email,
      'eventType': '2fa_code_generated',
      'status': 'success',
      'reason': 'Verification code generated for login',
      'code': code, // Store code for tracking (in production, don't store plaintext)
      'timestamp': FieldValue.serverTimestamp(),
      'ipAddress': 'N/A',
      'deviceInfo': 'Flutter App',
    });

    return code;
  }

  /// Verify the code entered by user
  Future<bool> verifyCode({
    required String userId,
    required String enteredCode,
  }) async {
    try {
      final doc = await _firestore.collection('verification_codes').doc(userId).get();

      if (!doc.exists) {
        return false;
      }

      final data = doc.data()!;
      final storedCode = data['code'] as String;
      final expiryTime = (data['expiryTime'] as Timestamp).toDate();
      final verified = data['verified'] as bool;

      // Check if already verified
      if (verified) {
        return false;
      }

      // Check if expired
      if (DateTime.now().isAfter(expiryTime)) {
        return false;
      }

      // Check if code matches
      if (storedCode == enteredCode) {
        // Mark as verified
        await _firestore.collection('verification_codes').doc(userId).update({
          'verified': true,
          'verifiedAt': FieldValue.serverTimestamp(),
        });
        return true;
      }

      return false;
    } catch (e) {
      print('Error verifying code: $e');
      return false;
    }
  }

  /// Clean up old verification codes (optional, for maintenance)
  Future<void> cleanupExpiredCodes() async {
    final now = Timestamp.now();
    final expiredCodes = await _firestore
        .collection('verification_codes')
        .where('expiryTime', isLessThan: now)
        .get();

    for (var doc in expiredCodes.docs) {
      await doc.reference.delete();
    }
  }
}
