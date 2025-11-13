# Firebase Setup Guide for EdgeUp UPSC App

This guide will walk you through setting up Firebase authentication with 2FA email verification and email history tracking for the EdgeUp UPSC application.

## Table of Contents
1. [Firebase Console Setup](#firebase-console-setup)
2. [Enable Authentication Methods](#enable-authentication-methods)
3. [Create Firestore Database](#create-firestore-database)
4. [Set Up Email History Collection](#set-up-email-history-collection)
5. [Configure Email Templates](#configure-email-templates)
6. [Security Rules](#security-rules)
7. [Testing Your Setup](#testing-your-setup)

---

## 1. Firebase Console Setup

### Step 1: Access Firebase Console
1. Go to [Firebase Console](https://console.firebase.google.com/)
2. Sign in with your Google account
3. You should see your project: **edgeup-upsc-app**

### Step 2: Verify Project Configuration
1. Click on your **edgeup-upsc-app** project
2. Click the gear icon ⚙️ next to "Project Overview"
3. Select "Project settings"
4. Verify your project is configured for:
   - Web
   - Android
   - iOS
   - macOS

---

## 2. Enable Authentication Methods

### Step 1: Navigate to Authentication
1. In the Firebase Console left sidebar, click **"Authentication"**
2. Click on the **"Sign-in method"** tab

### Step 2: Enable Email/Password Authentication
1. Click on **"Email/Password"**
2. Toggle the **"Enable"** switch to ON
3. Make sure **"Email link (passwordless sign-in)"** is OFF (we're using password-based auth)
4. Click **"Save"**

### Step 3: Enable Google Sign-In (Optional)
1. Click on **"Google"**
2. Toggle the **"Enable"** switch to ON
3. Enter a support email (your email address)
4. Click **"Save"**

### Step 4: Configure Email Verification Settings
1. In the Authentication section, click on **"Templates"** tab
2. Click on **"Email address verification"**
3. Customize the email template (optional):
   - **Sender name**: EdgeUp UPSC
   - **From**: Your domain email (if you have a custom domain)
   - Customize the email body to match your brand
4. Click **"Save"**

---

## 3. Create Firestore Database

### Step 1: Navigate to Firestore
1. In the Firebase Console left sidebar, click **"Firestore Database"**
2. Click **"Create database"** (if not already created)

### Step 2: Choose Database Mode
1. Select **"Start in production mode"** (we'll add security rules later)
2. Click **"Next"**

### Step 3: Select Database Location
1. Choose a location close to your users:
   - **us-central** (for USA)
   - **europe-west** (for Europe)
   - **asia-south1** (for India - recommended for UPSC app)
2. Click **"Enable"**

---

## 4. Set Up Email History Collection

### Step 1: Create the Collection Manually (Optional)
The collection will be created automatically when the first email event is logged, but you can create it manually:

1. In Firestore Database, click **"Start collection"**
2. Collection ID: **email_history**
3. Click **"Next"**
4. Add a sample document:
   - Document ID: Leave as "Auto-ID"
   - Add fields:
     - `email` (string): "test@example.com"
     - `eventType` (string): "test_event"
     - `status` (string): "success"
     - `reason` (string): "Test document"
     - `timestamp` (timestamp): Click "Current time"
     - `ipAddress` (string): "N/A"
     - `deviceInfo` (string): "Flutter App"
5. Click **"Save"**

### Step 2: Understanding Email History Fields

The `email_history` collection tracks all authentication-related email events:

| Field | Type | Description |
|-------|------|-------------|
| `email` | String | The user's email address |
| `eventType` | String | Type of event (see Event Types below) |
| `status` | String | "success", "failed", or "error" |
| `reason` | String | Description of what happened |
| `timestamp` | Timestamp | When the event occurred (server time) |
| `ipAddress` | String | IP address (currently "N/A", can be enhanced) |
| `deviceInfo` | String | Device/platform information |

### Step 3: Event Types Tracked

Your app automatically logs these events:

#### Registration Events
- `registration_success` - User account created successfully
- `registration_verification_sent` - Verification email sent to new user
- `registration_verification_failed` - Failed to send verification email

#### Login Events
- `login_success` - User logged in successfully (email verified)
- `login_attempt_unverified` - Login attempt with unverified email
- `login_attempt_failed` - Login failed (wrong credentials)
- `login_error` - Login error occurred

#### Password Reset Events
- `password_reset_requested` - Password reset email sent
- `password_reset_failed` - Failed to send password reset email

---

## 5. Configure Email Templates

### Step 1: Customize Verification Email
1. Go to **Authentication** → **Templates**
2. Click **"Email address verification"**
3. Customize:
   ```
   Subject: Verify your email for EdgeUp UPSC

   Body:
   Hello,

   Follow this link to verify your email address for your EdgeUp UPSC account.

   %LINK%

   If you didn't create an account with EdgeUp UPSC, you can ignore this email.

   Thanks,
   The EdgeUp Team
   ```
4. Click **"Save"**

### Step 2: Customize Password Reset Email
1. Click **"Password reset"**
2. Customize:
   ```
   Subject: Reset your password for EdgeUp UPSC

   Body:
   Hello,

   Follow this link to reset your password for your EdgeUp UPSC account.

   %LINK%

   If you didn't request a password reset, you can ignore this email.

   Thanks,
   The EdgeUp Team
   ```
3. Click **"Save"**

### Step 3: Set Up Custom Email Domain (Optional)
For a professional look:
1. Go to **Authentication** → **Settings** → **Email Enumeration Protection**
2. Follow Firebase documentation to verify your domain
3. Use your custom domain (e.g., noreply@edgeup.com) instead of the default Firebase email

---

## 6. Security Rules

### Step 1: Set Up Firestore Security Rules
1. Go to **Firestore Database** → **Rules** tab
2. Replace the default rules with:

```javascript
rules_version = '2';
service cloud.firestore {
  match /databases/{database}/documents {

    // Users collection - users can only read/write their own data
    match /users/{userId} {
      allow read, write: if request.auth != null && request.auth.uid == userId;
    }

    // Email history collection - write-only for authenticated users
    // Only admins can read (implement admin check as needed)
    match /email_history/{documentId} {
      // Allow authenticated users to write their own email events
      allow create: if request.auth != null;

      // Only allow reading if it's your own email or you're an admin
      // For now, only the server should read this
      allow read: if false; // Change this based on your admin requirements

      // No updates or deletes allowed
      allow update, delete: if false;
    }
  }
}
```

3. Click **"Publish"**

### Step 2: Understand Security Rules

- **Users Collection**: Users can only access their own user document
- **Email History Collection**:
  - Write-only for authenticated users
  - No public read access (for privacy)
  - No updates or deletes (audit trail integrity)
  - You can modify read rules to allow admins to view all logs

---

## 7. Testing Your Setup

### Step 1: Test User Registration
1. Run your Flutter app: `flutter run`
2. Navigate to the Sign Up page
3. Create a new account with a real email address
4. Check the following:
   - ✅ Account created successfully
   - ✅ Verification email received in inbox
   - ✅ Success message displayed

### Step 2: Verify Email History Logging
1. Go to Firebase Console → **Firestore Database**
2. Open the `email_history` collection
3. You should see 2 new documents:
   - One with `eventType: "registration_success"`
   - One with `eventType: "registration_verification_sent"`

### Step 3: Test Email Verification (2FA)
1. Check your email inbox
2. Click the verification link in the email
3. You should see: "Your email has been verified"
4. Try to log in with your new account
5. ✅ Login should succeed now

### Step 4: Test Unverified Login Attempt
1. Create another account but DON'T verify the email
2. Try to log in
3. You should see: "Please verify your email before logging in"
4. Check Firestore - you should see:
   - `eventType: "login_attempt_unverified"`

### Step 5: Test Forgot Password
1. On the login page, enter your email
2. Click **"Forgot Password?"**
3. Check the following:
   - ✅ Password reset email received
   - ✅ Firestore shows `eventType: "password_reset_requested"`
4. Click the link in the email
5. Reset your password
6. Log in with the new password
7. ✅ Login should succeed

### Step 6: Test Failed Login
1. Try to log in with wrong credentials
2. Check Firestore for:
   - `eventType: "login_attempt_failed"`
   - `status: "failed"`
   - `reason: "Invalid email or password"`

---

## Viewing Email History Data

### Option 1: Firebase Console
1. Go to **Firestore Database**
2. Click on `email_history` collection
3. Browse documents manually
4. Use the filter button to search by specific fields

### Option 2: Query by Email
To see all events for a specific email:
1. Click on the **Filter** button
2. Add filter: `email == "user@example.com"`
3. Click **Apply**

### Option 3: Export Data
1. Click the **⋮** menu in Firestore
2. Select **"Export"**
3. Choose format (JSON or CSV)
4. Download the data

### Option 4: Build an Admin Dashboard (Future Enhancement)
You can create an admin page in your Flutter app to:
- View all email events
- Filter by email, event type, or date range
- Export reports
- Monitor authentication activity

---

## Email Event Schema Reference

### Example Document in `email_history` Collection

```json
{
  "email": "john.doe@example.com",
  "eventType": "login_success",
  "status": "success",
  "reason": "User logged in successfully",
  "timestamp": "2025-11-13T10:30:45.123Z",
  "ipAddress": "N/A",
  "deviceInfo": "Flutter App"
}
```

### All Possible Event Types

| Event Type | Status | When It Occurs |
|------------|--------|----------------|
| `registration_success` | success | User account created |
| `registration_verification_sent` | success | Verification email sent |
| `registration_verification_failed` | failed | Failed to send verification |
| `login_success` | success | Successful login |
| `login_attempt_unverified` | failed | Login with unverified email |
| `login_attempt_failed` | failed | Wrong credentials |
| `login_error` | error | Login system error |
| `password_reset_requested` | success | Password reset email sent |
| `password_reset_failed` | failed | Failed to send reset email |

---

## Monitoring and Analytics

### Set Up Email Templates Analytics
1. Go to **Authentication** → **Templates**
2. Each template shows statistics:
   - Number of emails sent
   - Delivery rate
   - Open rate (if using custom domain)

### Monitor Failed Attempts
Regularly check `email_history` for:
- High volume of `login_attempt_failed` from same email (possible brute force)
- `registration_verification_failed` events (email delivery issues)
- Unusual patterns in timestamps

---

## Troubleshooting

### Issue 1: Emails Not Sending
**Symptoms**: Users not receiving verification or password reset emails

**Solutions**:
1. Check spam/junk folder
2. Verify email provider allows emails from Firebase (noreply@your-project.firebaseapp.com)
3. Go to Firebase Console → Authentication → Settings
4. Check "Authorized domains" includes your app's domain
5. Consider setting up a custom email domain

### Issue 2: Email History Not Logging
**Symptoms**: No documents appearing in `email_history` collection

**Solutions**:
1. Check Firestore security rules allow writes
2. Look for errors in Flutter debug console
3. Verify internet connection is active
4. Check Firebase project is correctly configured in `firebase_options.dart`

### Issue 3: "Too Many Requests" Error
**Symptoms**: Users getting rate-limited

**Solutions**:
1. Go to Authentication → Settings → User actions
2. Adjust rate limits for:
   - Email verification requests
   - Password reset requests
   - Sign-up attempts

---

## Best Practices

### Security
✅ Never expose Firebase API keys in public repositories (they're already in your .gitignore)
✅ Use proper security rules for Firestore
✅ Implement rate limiting for authentication attempts
✅ Monitor email_history for suspicious patterns
✅ Regularly review Firebase Authentication logs

### Performance
✅ Index email_history collection by `email` and `timestamp` for faster queries
✅ Consider data retention policy (delete old logs after X months)
✅ Use Firebase Local Emulator for development testing

### User Experience
✅ Provide clear error messages
✅ Allow users to resend verification emails
✅ Send welcome emails after successful verification
✅ Implement email change verification workflow

---

## Creating Indexes for Better Performance

If you plan to query email_history frequently:

1. Go to **Firestore Database** → **Indexes** tab
2. Click **"Add index"**
3. Create composite index:
   - Collection: `email_history`
   - Fields:
     - `email` (Ascending)
     - `timestamp` (Descending)
   - Query scope: Collection
4. Click **"Create"**

This allows fast queries like "show me all events for this email, most recent first"

---

## Next Steps

Now that your Firebase authentication with email history tracking is set up:

1. ✅ Test all authentication flows thoroughly
2. ✅ Set up backup/export automation for email_history
3. ✅ Create an admin dashboard to view email history (optional)
4. ✅ Implement additional security features:
   - Account lockout after multiple failed attempts
   - Email notifications for suspicious login attempts
   - Two-factor authentication with SMS (requires Firebase Blaze plan)
5. ✅ Monitor Firebase usage and costs
6. ✅ Set up Firebase Cloud Functions for advanced features (optional)

---

## Support

If you encounter issues:
- Check [Firebase Documentation](https://firebase.google.com/docs)
- Review [FlutterFire Documentation](https://firebase.flutter.dev/docs/overview)
- Check Firebase Console → **Help** → **Support**

---

**Last Updated**: November 13, 2025
**Firebase Project**: edgeup-upsc-app
**App Version**: 1.0.0
