# URGENT: Create Firestore Database

## The Problem

Your Firestore database doesn't exist yet! That's why you're getting errors.

## Quick Fix (5 minutes)

### Step 1: Go to Firebase Console
1. Visit: https://console.firebase.google.com/
2. Click on your project: **edgeup-upsc-app**

### Step 2: Create Firestore Database
1. In the left sidebar, click **"Firestore Database"**
2. Click **"Create database"** button

### Step 3: Choose Database Mode
1. Select **"Start in production mode"**
2. Click **"Next"**

### Step 4: Select Location
Choose a location closest to your users:
- **asia-south1** (Mumbai, India) - **RECOMMENDED for UPSC app**
- **us-central1** (Iowa, USA)
- **europe-west1** (Belgium, Europe)

Click **"Enable"**

### Step 5: Wait for Database Creation
- Wait 1-2 minutes for database to be created
- You'll see a screen saying "Creating database..."
- Once done, you'll see an empty database

### Step 6: Set Up Security Rules
1. Click on **"Rules"** tab
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
    match /email_history/{documentId} {
      // Allow authenticated users to create email event logs
      allow create: if request.auth != null;

      // No public read access (for privacy)
      allow read: if false;

      // No updates or deletes (audit trail integrity)
      allow update, delete: if false;
    }
  }
}
```

3. Click **"Publish"**

---

## Fix for "Too Many Requests" Error

Firebase has temporarily blocked your device. To fix:

### Option 1: Wait (Recommended)
- Wait 1-2 hours before trying again
- Firebase will automatically unblock your device

### Option 2: Use a Different Device/Emulator
- Test on a different Android emulator
- Or test on a physical device
- Or use a different Google account for testing

### Option 3: Stop Clicking "Forgot Password" Repeatedly
- Only click it once and wait for the email
- Multiple rapid clicks trigger Firebase's spam protection

---

## After Creating Database, Test Again

### Test Registration
```bash
flutter run
```

1. Click "Sign Up"
2. Enter your details
3. Submit
4. ✅ Should work now!

### Test Login
1. Check your email for verification link
2. Click the verification link
3. Go back to app and log in
4. ✅ Should work!

### Check Email History
1. Go to Firebase Console
2. Click "Firestore Database"
3. Look for `email_history` collection
4. ✅ You should see event logs!

---

## Why This Happened

When you run `flutter run` for the first time:
- Firebase Authentication is automatically enabled
- But Firestore Database must be **manually created** in the console
- Your app tried to write to a database that doesn't exist yet

---

## Summary

1. ✅ Create Firestore Database in Firebase Console (5 minutes)
2. ✅ Set up security rules
3. ✅ Wait 1-2 hours if you got "too many requests" error
4. ✅ Test your app again

**After creating the database, everything will work perfectly!**
