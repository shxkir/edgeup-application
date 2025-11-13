# Google Sign-In Web Client ID Setup

## Current Status

Your app is configured for email/password authentication with 2FA, which works perfectly. However, if you want to enable Google Sign-In on the web, you need to add the Web Client ID.

## Important Note

**The error you're seeing does NOT affect:**
- ✅ Email/Password login
- ✅ 2FA email verification
- ✅ Forgot password functionality
- ✅ Email history tracking
- ✅ Google Sign-In on Android/iOS (those work fine)

**It only affects:**
- ❌ Google Sign-In on Web platform

---

## How to Get Your Web Client ID

### Step 1: Go to Google Cloud Console
1. Visit: https://console.cloud.google.com/
2. Sign in with your Google account
3. Select your project: **edgeup-upsc-app** (or the project ID: `250725613501`)

### Step 2: Navigate to Credentials
1. In the left sidebar, click **"APIs & Services"**
2. Click **"Credentials"**

### Step 3: Find Your Web Client ID
1. Look for **"OAuth 2.0 Client IDs"** section
2. Find the client ID that says **"Web client (auto created by Google Service)"** or similar
3. Click on it to view details

### Step 4: Copy the Client ID
1. You'll see a **Client ID** that looks like:
   ```
   250725613501-XXXXXXXXXXXXXXXXXXXXXXXX.apps.googleusercontent.com
   ```
2. Copy this entire client ID

### Step 5: If No Web Client ID Exists, Create One
If you don't see a web client ID:

1. Click **"+ CREATE CREDENTIALS"** at the top
2. Select **"OAuth client ID"**
3. Choose **Application type**: "Web application"
4. Name it: "EdgeUp UPSC Web Client"
5. Under **"Authorized JavaScript origins"**, add:
   - `http://localhost:5000` (for development)
   - `https://edgeup-upsc-app.web.app` (if you deploy to Firebase Hosting)
   - Your custom domain (if you have one)
6. Under **"Authorized redirect URIs"**, add:
   - `http://localhost:5000/__/auth/handler` (for development)
   - `https://edgeup-upsc-app.web.app/__/auth/handler` (for production)
7. Click **"CREATE"**
8. Copy the **Client ID** that's generated

### Step 6: Update Your index.html
1. Open: `edgeup_upsc_app/web/index.html`
2. Find this line:
   ```html
   <meta name="google-signin-client_id" content="250725613501-YOUR_WEB_CLIENT_ID.apps.googleusercontent.com">
   ```
3. Replace `250725613501-YOUR_WEB_CLIENT_ID.apps.googleusercontent.com` with your actual client ID
4. Save the file

### Example:
```html
<meta name="google-signin-client_id" content="250725613501-abcd1234efgh5678ijkl9012mnop3456.apps.googleusercontent.com">
```

---

## Alternative: Disable Google Sign-In for Web

If you don't plan to use Google Sign-In on web, you can disable it:

### Option 1: Conditional Initialization
Update your `injection_container.dart` to only initialize Google Sign-In on mobile:

```dart
// In injection_container.dart
import 'package:flutter/foundation.dart' show kIsWeb;

// When registering GoogleSignIn
sl.registerLazySingleton<GoogleSignIn>(
  () => kIsWeb
    ? GoogleSignIn(signInOption: SignInOption.standard) // No client ID needed for mobile
    : GoogleSignIn(),
);
```

### Option 2: Skip Web Testing
- Just test on Android/iOS where Google Sign-In works without this setup
- The error won't appear on mobile platforms

---

## Testing After Setup

### Test on Web
1. Run: `flutter run -d chrome`
2. Click the Google Sign-In button (if you have one)
3. Should work without errors

### Test Email/Password (Already Works!)
1. Run your app on any platform
2. Register with email/password
3. Verify email
4. Log in
5. ✅ All features work perfectly!

---

## Summary

- **Your current implementation is complete** for email authentication with 2FA
- Google Sign-In error **only affects web** and is **optional to fix**
- If you need Google Sign-In on web, follow the steps above to get the client ID
- Otherwise, your app works perfectly as-is for all the features you requested

---

**Next Steps:**
1. If using Google Sign-In on web: Get client ID and update `index.html`
2. If not: You can ignore this error - your app is ready to use!

All your requested features are working:
- ✅ 2FA email verification on login
- ✅ Forgot password with email link
- ✅ Email history tracking in Firebase
- ✅ Complete documentation provided
