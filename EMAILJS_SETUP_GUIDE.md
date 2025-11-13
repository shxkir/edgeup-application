# EmailJS Setup Guide - FREE Email Sending for 2FA

## Why EmailJS?

✅ **Completely FREE** - 200 emails/month forever
✅ **No credit card required**
✅ **No backend/Cloud Functions needed**
✅ **Works directly from Flutter app**
✅ **No Firebase Blaze plan upgrade needed**
✅ **5 minutes setup**

---

## Step 1: Create EmailJS Account (2 minutes)

### 1. Sign Up
1. Go to: **https://www.emailjs.com/**
2. Click **"Sign Up Free"**
3. Enter your email and create password
4. Verify your email

### 2. Login
- Go to: **https://dashboard.emailjs.com/**
- Login with your credentials

---

## Step 2: Add Email Service (3 minutes)

### 1. Connect Your Email
1. In dashboard, click **"Email Services"** (left sidebar)
2. Click **"Add New Service"**
3. Choose your email provider:

#### Option A: Gmail (Recommended - Easy)
- Select **"Gmail"**
- Click **"Connect Account"**
- Sign in with your Gmail account
- Allow EmailJS permissions
- Click **"Create Service"**

#### Option B: Outlook/Yahoo/Other
- Select your provider
- Follow the authentication steps

### 2. Save Service ID
After creating service, you'll see:
- **Service ID**: `service_xxxxxxx`
- **📝 Copy this ID** - you'll need it!

---

## Step 3: Create Email Template (5 minutes)

### 1. Navigate to Templates
1. Click **"Email Templates"** (left sidebar)
2. Click **"Create New Template"**

### 2. Set Up Template

**Template Name**: `2fa_verification_code`

**Subject**:
```
EdgeUp UPSC - Your Login Verification Code
```

**Content** (HTML):
```html
<!DOCTYPE html>
<html>
<head>
  <style>
    body {
      font-family: Arial, sans-serif;
      background-color: #f4f4f4;
      margin: 0;
      padding: 0;
    }
    .container {
      max-width: 600px;
      margin: 40px auto;
      background: white;
      border-radius: 12px;
      overflow: hidden;
      box-shadow: 0 4px 12px rgba(0,0,0,0.1);
    }
    .header {
      background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
      color: white;
      padding: 30px;
      text-align: center;
    }
    .header h1 {
      margin: 0;
      font-size: 28px;
    }
    .content {
      padding: 40px 30px;
      text-align: center;
    }
    .code-box {
      background: #f8f9fa;
      border: 2px dashed #667eea;
      border-radius: 8px;
      padding: 20px;
      margin: 30px 0;
    }
    .code {
      font-size: 36px;
      font-weight: bold;
      color: #667eea;
      letter-spacing: 8px;
      font-family: 'Courier New', monospace;
    }
    .expiry {
      color: #666;
      font-size: 14px;
      margin-top: 20px;
    }
    .footer {
      background: #f8f9fa;
      padding: 20px;
      text-align: center;
      color: #666;
      font-size: 12px;
    }
  </style>
</head>
<body>
  <div class="container">
    <div class="header">
      <h1>🎓 EdgeUp UPSC</h1>
      <p>Login Verification</p>
    </div>
    <div class="content">
      <h2>Hello {{user_name}},</h2>
      <p>Enter this code to complete your login:</p>
      <div class="code-box">
        <div class="code">{{verification_code}}</div>
      </div>
      <p class="expiry">⏰ This code will expire in <strong>5 minutes</strong></p>
      <p style="color: #999; font-size: 14px; margin-top: 30px;">
        If you didn't request this code, please ignore this email.
      </p>
    </div>
    <div class="footer">
      <p>© 2025 EdgeUp UPSC. All rights reserved.</p>
      <p>This is an automated email. Please do not reply.</p>
    </div>
  </div>
</body>
</html>
```

### 3. Configure Template Variables

In the template editor, you'll see these variables:
- `{{user_name}}` - Recipient's name
- `{{verification_code}}` - The 6-digit code
- `{{to_email}}` - Recipient email (auto-filled)

### 4. Save Template
- Click **"Save"**
- **📝 Copy the Template ID**: `template_xxxxxxx`

---

## Step 4: Get API Keys (1 minute)

### 1. Navigate to Account
1. Click **"Account"** in left sidebar
2. Find **"API Keys"** section

### 2. Copy Keys
You'll see three important values:

**📝 Copy these:**
1. **Public Key**: `xxxxxxxxxxxxx`
2. **Service ID**: `service_xxxxxxx` (from Step 2)
3. **Template ID**: `template_xxxxxxx` (from Step 3)

---

## Step 5: Add EmailJS to Flutter (10 minutes)

### 1. Add Dependency

Edit `edgeup_upsc_app/pubspec.yaml`:

```yaml
dependencies:
  flutter:
    sdk: flutter

  # Existing dependencies...
  firebase_auth: ^4.15.3
  cloud_firestore: ^4.14.0

  # Add this for EmailJS
  http: ^1.1.0  # Add this line
```

Run:
```bash
cd edgeup_upsc_app
flutter pub get
```

### 2. Create EmailJS Service

Create new file: `lib/features/auth/services/emailjs_service.dart`

```dart
import 'dart:convert';
import 'package:http/http.dart' as http;

class EmailJSService {
  // Replace with your EmailJS credentials
  static const String serviceId = 'YOUR_SERVICE_ID';  // e.g., service_abc123
  static const String templateId = 'YOUR_TEMPLATE_ID'; // e.g., template_xyz789
  static const String publicKey = 'YOUR_PUBLIC_KEY';   // e.g., abcdefghijk123

  /// Send verification code email via EmailJS
  static Future<bool> sendVerificationCode({
    required String toEmail,
    required String userName,
    required String verificationCode,
  }) async {
    try {
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
        print('Email sent successfully to $toEmail');
        return true;
      } else {
        print('Failed to send email: ${response.statusCode}');
        print('Response: ${response.body}');
        return false;
      }
    } catch (e) {
      print('Error sending email: $e');
      return false;
    }
  }
}
```

**⚠️ Important**: Replace `YOUR_SERVICE_ID`, `YOUR_TEMPLATE_ID`, and `YOUR_PUBLIC_KEY` with your actual values from EmailJS dashboard!

---

## Step 6: Update Login Page (5 minutes)

Edit `lib/features/auth/presentation/pages/login_page.dart`:

### 1. Add Import
Add this at the top with other imports:

```dart
import 'package:edgeup_upsc_app/features/auth/services/emailjs_service.dart';
```

### 2. Update Login Handler

Find this code (around line 117-135):

```dart
// Generate and send 2FA verification code
final codeService = VerificationCodeService(_firestore);
final verificationCode = await codeService.storeVerificationCode(
  email: email,
  userId: user.uid,
);

// Show notification that code was "sent" (in real app, this would be sent via email)
if (mounted) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text('Verification code sent to $email\n\nDEV MODE: Your code is $verificationCode'),
      backgroundColor: AppTheme.primaryViolet,
      behavior: SnackBarBehavior.floating,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      duration: const Duration(seconds: 8),
    ),
  );
}
```

**Replace with:**

```dart
// Generate and send 2FA verification code
final codeService = VerificationCodeService(_firestore);
final verificationCode = await codeService.storeVerificationCode(
  email: email,
  userId: user.uid,
);

// Get user name for email
String userName = firstName.isNotEmpty ? firstName : 'User';
if (userDoc.exists) {
  final data = userDoc.data();
  final name = data?['name'] as String? ?? 'User';
  userName = name.split(' ').first;
}

// Send email via EmailJS
final emailSent = await EmailJSService.sendVerificationCode(
  toEmail: email,
  userName: userName,
  verificationCode: verificationCode,
);

if (mounted) {
  if (emailSent) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Verification code sent to $email\n\nPlease check your email inbox.'),
        backgroundColor: AppTheme.primaryViolet,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        duration: const Duration(seconds: 5),
      ),
    );
  } else {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text('Failed to send email. Please try again.'),
        backgroundColor: Colors.orange,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        duration: const Duration(seconds: 5),
      ),
    );
  }
}
```

### 3. Update Resend Handler

Find the resend code section (around line 186-202):

```dart
onResend: () async {
  // Generate new code
  final newCode = await codeService.storeVerificationCode(
    email: email,
    userId: user.uid,
  );

  if (context.mounted) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('New code sent!\n\nDEV MODE: Your code is $newCode'),
        backgroundColor: AppTheme.primaryViolet,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        duration: const Duration(seconds: 8),
      ),
    );
  }
},
```

**Replace with:**

```dart
onResend: () async {
  // Generate new code
  final newCode = await codeService.storeVerificationCode(
    email: email,
    userId: user.uid,
  );

  // Send new email
  final emailSent = await EmailJSService.sendVerificationCode(
    toEmail: email,
    userName: userName,
    verificationCode: newCode,
  );

  if (context.mounted) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(emailSent
          ? 'New verification code sent! Check your email.'
          : 'Failed to send email. Please try again.'),
        backgroundColor: emailSent ? AppTheme.primaryViolet : Colors.orange,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        duration: const Duration(seconds: 5),
      ),
    );
  }
},
```

---

## Step 7: Test Email Sending! 🎉

### 1. Run Your App
```bash
flutter run
```

### 2. Test Login
1. Enter your email and password
2. Click **"Login"**
3. ✅ **Check your email inbox!**
4. You should receive a beautiful email with your 6-digit code
5. Enter the code in the app
6. ✅ **Login successful!**

### 3. Check Spam
If you don't see the email in inbox, **check spam folder**

---

## Troubleshooting

### Issue 1: Email Not Received

**Solutions**:
1. **Check spam/junk folder**
2. **Wait 1-2 minutes** (first email may be slower)
3. **Verify EmailJS service** is connected to your Gmail
4. **Check EmailJS dashboard**:
   - Go to: https://dashboard.emailjs.com/
   - Click "History" to see sent emails
5. **Try different email address** (Yahoo, Outlook, etc.)

### Issue 2: "Failed to send email" Error

**Check**:
1. **Verify API keys** in `emailjs_service.dart`:
   - Service ID
   - Template ID
   - Public Key
2. **Check internet connection**
3. **View EmailJS dashboard** for errors
4. **Check email service** is still connected

### Issue 3: Template Variables Not Working

**Solution**:
1. Go to EmailJS dashboard
2. Open your template
3. Make sure variable names match:
   - `{{to_email}}`
   - `{{user_name}}`
   - `{{verification_code}}`

### Issue 4: Email Rate Limit

EmailJS free tier: **200 emails/month**

**Solutions**:
1. **Upgrade EmailJS** plan ($9/month for 1,000 emails)
2. **Use multiple EmailJS accounts** (not recommended)
3. **Implement caching** to reduce email sends

---

## EmailJS Dashboard - Monitoring

### View Sent Emails
1. Go to: https://dashboard.emailjs.com/
2. Click **"History"** (left sidebar)
3. See all sent emails with:
   - Status (Success/Failed)
   - Recipient
   - Timestamp
   - Error messages (if any)

### Usage Stats
1. Click **"Account"** → **"Usage"**
2. See:
   - Emails sent this month
   - Remaining emails
   - Usage graph

---

## Costs & Limits

### EmailJS Free Plan
- ✅ **200 emails/month** - FREE forever
- ✅ **No credit card required**
- ✅ **2 email services** (Gmail + Outlook)
- ✅ **Unlimited templates**

### Paid Plans (Optional)
- **Personal**: $9/month - 1,000 emails
- **Professional**: $25/month - 5,000 emails
- **Business**: $60/month - 20,000 emails

### Comparison

For 100 users/day (3,000 emails/month):
- **EmailJS Personal**: $9/month
- **SendGrid**: Free (up to 100/day)
- **Firebase + SendGrid**: $0-5/month

---

## Security Best Practices

### ⚠️ Important: API Key Security

Your EmailJS public key is **client-side** (visible in app). To secure it:

1. **Enable reCAPTCHA** in EmailJS dashboard:
   - Go to **"Security"**
   - Enable **"reCAPTCHA v3"**
   - This prevents spam/abuse

2. **Set Domain Whitelist**:
   - Go to **"Security"**
   - Add your app's domain
   - Only allows emails from your app

3. **Monitor Usage**:
   - Check EmailJS dashboard regularly
   - Set up email alerts for unusual activity

---

## Advantages vs Firebase Cloud Functions

### EmailJS Pros ✅
- Completely free (200 emails/month)
- No backend code needed
- No Firebase upgrade needed
- 5-minute setup
- Beautiful dashboard

### EmailJS Cons ❌
- Lower email limit (200/month free)
- API keys in client code
- Dependent on third-party service
- Less customization

### Firebase Cloud Functions Pros ✅
- Higher limits (2M invocations/month)
- API keys on server (more secure)
- Full control
- Can use any email provider

### Firebase Cloud Functions Cons ❌
- Requires Blaze plan upgrade
- Need to write backend code
- More complex setup
- Small cost (~$0-5/month)

---

## Upgrading Email Limit

If you exceed 200 emails/month:

### Option 1: Upgrade EmailJS
$9/month for 1,000 emails

### Option 2: Switch to SendGrid
- 100 emails/day free (3,000/month)
- Requires Firebase Cloud Functions

### Option 3: Combine Services
- Use EmailJS for first 200
- Switch to backup service after

---

## Next Steps

After setting up EmailJS:

### Immediate
- [ ] Test email sending end-to-end
- [ ] Check spam folder
- [ ] Verify email template looks good
- [ ] Test resend functionality

### Short-term
- [ ] Enable reCAPTCHA in EmailJS
- [ ] Set up domain whitelist
- [ ] Monitor usage in dashboard
- [ ] Add email delivery confirmation

### Long-term
- [ ] Consider upgrading if needed
- [ ] Add backup email service
- [ ] Implement email queueing
- [ ] Add email analytics

---

## Complete Code Reference

### EmailJS Service
**File**: `lib/features/auth/services/emailjs_service.dart`

### Login Page Updates
**File**: `lib/features/auth/presentation/pages/login_page.dart`
- Import EmailJS service
- Send email after code generation
- Update resend handler

---

## Summary Checklist

### Setup (One-time - 15 minutes)
- [ ] Create EmailJS account
- [ ] Connect Gmail/email service
- [ ] Create email template
- [ ] Copy API keys (Service ID, Template ID, Public Key)
- [ ] Add `http` package to pubspec.yaml
- [ ] Create `emailjs_service.dart` with your API keys
- [ ] Update login page to use EmailJS
- [ ] Test email sending

### Testing
- [ ] Login triggers email send
- [ ] Email arrives in inbox (check spam)
- [ ] Email looks professional
- [ ] Code works for verification
- [ ] Resend works correctly

---

## Support

### EmailJS Help
- Documentation: https://www.emailjs.com/docs/
- Support: support@emailjs.com
- Community: https://github.com/emailjs-com/emailjs-sdk/issues

### Quick Links
- **Dashboard**: https://dashboard.emailjs.com/
- **API Docs**: https://www.emailjs.com/docs/rest-api/send/
- **Pricing**: https://www.emailjs.com/pricing/

---

**You now have FREE email sending for 2FA!** 📧🎉

**Setup Time**: 15-20 minutes
**Cost**: $0 (FREE forever for 200 emails/month)
**Difficulty**: Easy ⭐⭐☆☆☆

