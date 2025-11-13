import 'dart:convert';
import 'package:http/http.dart' as http;

/// EmailJS Service for sending verification code emails
///
/// Free tier: 200 emails/month
/// No backend required - sends emails directly from Flutter app
///
/// Setup Required:
/// 1. Create account at https://www.emailjs.com/
/// 2. Connect Gmail service
/// 3. Create email template
/// 4. Get API keys and replace below
class EmailJSService {
  // ✅ EmailJS credentials configured
  // Get them from: https://dashboard.emailjs.com/
  static const String serviceId = 'service_dknkiv9';
  static const String templateId = 'template_z047whk';
  static const String publicKey = 'c5CEubgqvcGAXMmUe';

  /// Send verification code email via EmailJS
  ///
  /// Parameters:
  /// - [toEmail]: Recipient's email address
  /// - [userName]: User's name (from Firebase user profile)
  /// - [verificationCode]: 6-digit verification code
  ///
  /// Returns:
  /// - true if email sent successfully
  /// - false if sending failed
  static Future<bool> sendVerificationCode({
    required String toEmail,
    required String userName,
    required String verificationCode,
  }) async {
    try {
      print('📧 Attempting to send email to $toEmail');

      final url = Uri.parse('https://api.emailjs.com/api/v1.0/email/send');

      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'service_id': serviceId,
          'template_id': templateId,
          'user_id': publicKey,
          'template_params': {
            'to_email': toEmail,
            'user_name': userName,
            'verification_code': verificationCode,
          },
        }),
      );

      if (response.statusCode == 200) {
        print('✅ Email sent successfully to $toEmail');
        return true;
      } else {
        print('❌ Failed to send email: ${response.statusCode}');
        print('Response body: ${response.body}');
        return false;
      }
    } catch (e) {
      print('❌ Error sending email: $e');
      return false;
    }
  }

  /// Send password reset email via EmailJS
  ///
  /// This is a placeholder for future implementation
  /// Currently using Firebase's built-in sendPasswordResetEmail
  static Future<bool> sendPasswordResetEmail({
    required String toEmail,
    required String userName,
    required String resetLink,
  }) async {
    // TODO: Implement if custom password reset emails are needed
    // For now, Firebase handles password reset emails automatically
    return false;
  }

  /// Check if EmailJS is properly configured
  ///
  /// Returns true if API keys are set (not default values)
  static bool isConfigured() {
    return serviceId != 'YOUR_SERVICE_ID' &&
        templateId != 'YOUR_TEMPLATE_ID' &&
        publicKey != 'YOUR_PUBLIC_KEY';
  }
}
