# Firebase Cloud Functions - Simple Email Setup

## 🚨 Why We Need This

EmailJS blocks mobile apps on free tier with error:
```
403: API calls are disabled for non-browser applications
```

**Solution**: Use Firebase Cloud Functions (server-side) to send emails.

---

## 💰 Cost (Still Mostly Free!)

**Firebase Blaze Plan** (Pay-as-you-go):
- ✅ First **2 million function invocations/month** = FREE
- ✅ First **400,000 GB-seconds** = FREE
- ✅ Only pay if you exceed (unlikely for small apps)

**For 1,000 logins/month**: ~$0.00 (within free tier)

---

## 🚀 Quick Setup (20 minutes)

### Step 1: Upgrade to Blaze Plan (5 minutes)

1. Go to: https://console.firebase.google.com/
2. Select your project: **edgeup-upsc-app**
3. Click gear icon ⚙️ → **"Usage and billing"**
4. Click **"Modify plan"**
5. Select **"Blaze (Pay as you go)"**
6. Add a payment method (credit/debit card)
   - **Don't worry**: Won't charge unless you exceed free tier
7. **Set a budget alert**: $5/month (recommended)
8. Click **"Continue"**

---

### Step 2: Enable Gmail App Password (5 minutes)

Since you already have a Gmail account, let's create an App Password:

1. **Enable 2-Step Verification** (if not already enabled):
   - Go to: https://myaccount.google.com/security
   - Click **"2-Step Verification"** → **"Get Started"**
   - Follow setup (verify phone, etc.)

2. **Create App Password**:
   - Go to: https://myaccount.google.com/apppasswords
   - Select app: **"Mail"**
   - Select device: **"Other (Custom name)"**
   - Enter: **"EdgeUp UPSC Cloud Function"**
   - Click **"Generate"**
   - ✅ **COPY the 16-character password** (e.g., `abcd efgh ijkl mnop`)
   - Remove spaces: `abcdefghijklmnop`
   - **Save this securely!**

---

### Step 3: Initialize Firebase Functions (5 minutes)

Open Command Prompt in your project folder:

```bash
cd C:\Users\ismai\Documents\edgeup-application
```

**Install Firebase CLI** (if not already installed):

```bash
npm install -g firebase-tools
```

**Login to Firebase**:

```bash
firebase login
```
- Opens browser → Sign in with your Google account

**Initialize Cloud Functions**:

```bash
firebase init functions
```

Answer the prompts:
- **Select project**: Choose **edgeup-upsc-app**
- **Language**: Select **JavaScript** (easier)
- **ESLint**: Yes
- **Install dependencies**: Yes

This creates:
```
edgeup-application/
├── functions/
│   ├── index.js        ← Your cloud functions code
│   ├── package.json
│   └── .eslintrc.js
```

---

### Step 4: Set Gmail Credentials (2 minutes)

In your terminal, run:

```bash
firebase functions:config:set gmail.email="ismaielshakir900@gmail.com"
firebase functions:config:set gmail.password="YOUR_APP_PASSWORD_HERE"
```

Replace `YOUR_APP_PASSWORD_HERE` with the 16-character App Password from Step 2 (no spaces).

Example:
```bash
firebase functions:config:set gmail.email="ismaielshakir900@gmail.com"
firebase functions:config:set gmail.password="abcdefghijklmnop"
```

---

### Step 5: Write Cloud Function Code (3 minutes)

Open `functions/index.js` and replace ALL content with:

```javascript
const functions = require("firebase-functions");
const admin = require("firebase-admin");
const nodemailer = require("nodemailer");

admin.initializeApp();

// Gmail transporter configuration
const gmailEmail = functions.config().gmail.email;
const gmailPassword = functions.config().gmail.password;

const transporter = nodemailer.createTransport({
  service: "gmail",
  auth: {
    user: gmailEmail,
    pass: gmailPassword,
  },
});

// Firestore trigger: Send email when verification code is created
exports.send2FACode = functions.firestore
    .document("verification_codes/{userId}")
    .onCreate(async (snap, context) => {
      try {
        const data = snap.data();
        const email = data.email;
        const code = data.code;

        console.log(`Sending 2FA code to ${email}`);

        // Email content
        const mailOptions = {
          from: `EdgeUp UPSC <${gmailEmail}>`,
          to: email,
          subject: "EdgeUp UPSC - Your Login Verification Code",
          html: `
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
                  <h2>Your Verification Code</h2>
                  <p>Enter this code to complete your login:</p>
                  <div class="code-box">
                    <div class="code">${code}</div>
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
          `,
          text: `Your EdgeUp UPSC verification code is: ${code}\n\nThis code will expire in 5 minutes.\n\nIf you didn't request this, please ignore this email.`,
        };

        // Send email
        await transporter.sendMail(mailOptions);

        // Log success
        await admin.firestore().collection("email_history").add({
          email: email,
          eventType: "2fa_code_email_sent",
          status: "success",
          reason: "Verification code sent via Gmail SMTP",
          timestamp: admin.firestore.FieldValue.serverTimestamp(),
        });

        console.log(`✅ Email sent successfully to ${email}`);
        return {success: true};
      } catch (error) {
        console.error("❌ Error sending email:", error);

        // Log failure
        const data = snap.data();
        await admin.firestore().collection("email_history").add({
          email: data.email,
          eventType: "2fa_code_email_failed",
          status: "failed",
          reason: `Failed to send email: ${error.message}`,
          timestamp: admin.firestore.FieldValue.serverTimestamp(),
        });

        throw new functions.https.HttpsError("internal", "Failed to send email");
      }
    });

// Clean up expired codes (runs every hour)
exports.cleanupExpiredCodes = functions.pubsub
    .schedule("every 1 hours")
    .onRun(async (context) => {
      const now = admin.firestore.Timestamp.now();
      const expiredCodes = await admin
          .firestore()
          .collection("verification_codes")
          .where("expiryTime", "<", now)
          .get();

      const batch = admin.firestore().batch();
      expiredCodes.forEach((doc) => {
        batch.delete(doc.ref);
      });

      await batch.commit();
      console.log(`Cleaned up ${expiredCodes.size} expired codes`);
      return null;
    });
```

**Install Nodemailer**:

```bash
cd functions
npm install nodemailer
cd ..
```

---

### Step 6: Deploy Functions (2 minutes)

```bash
firebase deploy --only functions
```

Wait for deployment to complete (1-2 minutes).

You'll see output like:
```
✔  functions[send2FACode(us-central1)] Successful create operation.
✔  functions[cleanupExpiredCodes(us-central1)] Successful create operation.
```

---

### Step 7: Update Flutter App (Remove EmailJS)

The Flutter app doesn't need any changes! The Cloud Function automatically triggers when a verification code is created in Firestore.

**Just remove the EmailJS code** since it's not working:

Open `lib/features/auth/presentation/pages/login_page.dart` and update the snackbar message:

Find lines around 135-154 and replace with:

```dart
// Show notification
if (mounted) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text('Verification code sent to $email\n\nPlease check your email inbox.'),
      backgroundColor: AppTheme.primaryViolet,
      behavior: SnackBarBehavior.floating,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      duration: const Duration(seconds: 5),
    ),
  );
}
```

And update resend (around lines 219-237):

```dart
if (context.mounted) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: const Text('New verification code sent! Check your email.'),
      backgroundColor: AppTheme.primaryViolet,
      behavior: SnackBarBehavior.floating,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      duration: const Duration(seconds: 5),
    ),
  );
}
```

---

## 🧪 Test Everything

1. Run your app:
```bash
flutter run
```

2. Login with your email/password

3. **Check your Gmail inbox** (ismaielshakir900@gmail.com)
   - Email should arrive within **5-10 seconds**
   - Beautiful HTML template
   - 6-digit verification code

4. Enter the code and complete login ✅

---

## 📊 Monitor Functions

**View logs**:
```bash
firebase functions:log
```

**Firebase Console**:
- Go to: https://console.firebase.google.com/
- Select project → **Functions** tab
- See invocation count, errors, execution time

---

## 🔍 Troubleshooting

### Email Not Received?

1. **Check spam folder**
2. **Check function logs**: `firebase functions:log`
3. **Verify App Password** is correct (no spaces)
4. **Check Gmail "Sent" folder** to confirm email was sent

### "Missing or insufficient permissions"?

Update Firestore rules (if not already done):

Firebase Console → Firestore Database → Rules:

```javascript
match /verification_codes/{userId} {
  allow create, read, update: if request.auth != null && request.auth.uid == userId;
  allow delete: if false;
}
```

### Function not triggering?

Check that Firestore path matches: `verification_codes/{userId}`

---

## 💡 Summary

**What changed:**
- ❌ Removed EmailJS (doesn't work for mobile apps)
- ✅ Added Firebase Cloud Function (server-side email sending)
- ✅ Uses Gmail SMTP with App Password
- ✅ Automatic trigger when code is created
- ✅ Still mostly FREE (within free tier limits)

**How it works:**
1. User logs in → Firebase Auth
2. Flutter app creates document in `verification_codes` collection
3. **Cloud Function automatically triggers**
4. Function sends email via Gmail SMTP
5. User receives email and enters code
6. Login complete!

---

**Estimated setup time**: 20 minutes
**Cost**: $0-2/month (for typical usage)
**Reliability**: ✅ Much better than EmailJS for mobile apps

