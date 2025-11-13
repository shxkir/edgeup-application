# Firebase Cloud Functions - Email Sending Setup

## Complete Guide to Send 2FA Codes via Email

This guide will help you set up Firebase Cloud Functions to send real verification codes via email.

---

## Prerequisites

### 1. Upgrade to Blaze Plan (Pay-as-you-go)

Firebase Cloud Functions require the **Blaze Plan**.

**Don't worry! It's still mostly free:**
- **Functions**: First 2 million invocations/month FREE
- **Email sending**: Costs ~$0.001 per email
- **Monthly cost for small app**: Usually $0-$5

#### Upgrade Steps:
1. Go to [Firebase Console](https://console.firebase.google.com/)
2. Select your project: **edgeup-upsc-app**
3. Click the gear icon ⚙️ → **"Usage and billing"**
4. Click **"Modify plan"**
5. Select **"Blaze (Pay as you go)"**
6. Add a credit/debit card (won't be charged unless you exceed free tier)
7. Set a **budget alert** (recommended: $10/month)

### 2. Install Required Tools

#### Install Node.js (if not already installed)
- Download from: https://nodejs.org/
- Choose LTS version (e.g., v20.x.x)
- Verify installation:
  ```bash
  node --version
  npm --version
  ```

#### Install Firebase CLI
```bash
npm install -g firebase-tools
```

Verify:
```bash
firebase --version
```

---

## Step 1: Initialize Firebase Functions

### 1. Navigate to Your Project
```bash
cd C:\Users\ismai\Documents\edgeup-application
```

### 2. Login to Firebase
```bash
firebase login
```
- Opens browser for Google authentication
- Select your Google account

### 3. Initialize Cloud Functions
```bash
firebase init functions
```

You'll be asked:

**1. Select a default Firebase project**
- Choose: **edgeup-upsc-app**

**2. What language would you like to use?**
- Choose: **TypeScript** (recommended) or JavaScript

**3. Do you want to use ESLint?**
- Choose: **Yes** (recommended)

**4. Install dependencies now?**
- Choose: **Yes**

This creates:
```
edgeup-application/
├── functions/
│   ├── src/
│   │   └── index.ts (your functions code)
│   ├── package.json
│   ├── tsconfig.json
│   └── .eslintrc.js
├── firebase.json
└── .firebaserc
```

---

## Step 2: Choose Email Service

You have several options:

### Option A: SendGrid (Recommended - Easy Setup)

**Free Tier**: 100 emails/day forever

#### Setup SendGrid:

1. **Create Account**
   - Go to: https://sendgrid.com/
   - Sign up for free account

2. **Verify Sender Email**
   - Go to **Settings** → **Sender Authentication**
   - Click **"Verify a Single Sender"**
   - Enter your email (e.g., noreply@yourdomain.com or your Gmail)
   - Verify email via link sent to inbox

3. **Create API Key**
   - Go to **Settings** → **API Keys**
   - Click **"Create API Key"**
   - Name: "EdgeUp UPSC 2FA"
   - Permission: **Full Access**
   - Copy the API key (save it securely!)

4. **Set Firebase Config**
   ```bash
   firebase functions:config:set sendgrid.key="YOUR_SENDGRID_API_KEY"
   firebase functions:config:set sendgrid.from="your-verified-email@example.com"
   ```

### Option B: Gmail SMTP (Simple but Limited)

**Limit**: 500 emails/day

#### Setup Gmail:

1. **Enable 2-Step Verification** on your Gmail account
2. **Create App Password**:
   - Go to: https://myaccount.google.com/apppasswords
   - Select **Mail** and **Other (Custom name)**
   - Name: "EdgeUp UPSC App"
   - Copy the generated password

3. **Set Firebase Config**
   ```bash
   firebase functions:config:set gmail.user="your-gmail@gmail.com"
   firebase functions:config:set gmail.password="your-app-password"
   ```

### Option C: Mailgun (Developer Friendly)

**Free Tier**: 5,000 emails/month for 3 months, then pay-as-you-go

---

## Step 3: Install Dependencies

```bash
cd functions
npm install @sendgrid/mail
npm install nodemailer  # If using Gmail/SMTP
```

---

## Step 4: Write Cloud Function Code

### Edit `functions/src/index.ts`:

```typescript
import * as functions from "firebase-functions";
import * as admin from "firebase-admin";
import * as sgMail from "@sendgrid/mail";

admin.initializeApp();

// Initialize SendGrid
const SENDGRID_API_KEY = functions.config().sendgrid.key;
const FROM_EMAIL = functions.config().sendgrid.from;
sgMail.setApiKey(SENDGRID_API_KEY);

// Cloud Function to send verification code email
export const send2FACode = functions.firestore
  .document("verification_codes/{userId}")
  .onCreate(async (snap, context) => {
    try {
      const data = snap.data();
      const email = data.email;
      const code = data.code;
      const userId = context.params.userId;

      console.log(`Sending 2FA code to ${email}, code: ${code}`);

      // Email content
      const msg = {
        to: email,
        from: FROM_EMAIL,
        subject: "EdgeUp UPSC - Your Login Verification Code",
        text: `Your verification code is: ${code}\n\nThis code will expire in 5 minutes.\n\nIf you didn't request this code, please ignore this email.`,
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
      };

      // Send email
      await sgMail.send(msg);

      // Log success to email_history
      await admin.firestore().collection("email_history").add({
        email: email,
        eventType: "2fa_code_email_sent",
        status: "success",
        reason: "Verification code sent via SendGrid",
        code: code, // In production, consider not logging the actual code
        timestamp: admin.firestore.FieldValue.serverTimestamp(),
        userId: userId,
      });

      console.log(`Email sent successfully to ${email}`);
      return {success: true};
    } catch (error: any) {
      console.error("Error sending email:", error);

      // Log failure
      const data = snap.data();
      await admin.firestore().collection("email_history").add({
        email: data.email,
        eventType: "2fa_code_email_failed",
        status: "failed",
        reason: `Failed to send email: ${error.message}`,
        timestamp: admin.firestore.FieldValue.serverTimestamp(),
      });

      throw new functions.https.HttpsError(
        "internal",
        "Failed to send email"
      );
    }
  });

// Optional: Cleanup expired codes (runs every hour)
export const cleanupExpiredCodes = functions.pubsub
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

---

## Step 5: Deploy to Firebase

### 1. Deploy Functions
```bash
firebase deploy --only functions
```

This will:
- Upload your code to Firebase
- Create the Cloud Functions
- Return URLs for your functions

### 2. Check Deployment
```bash
firebase functions:log
```

---

## Step 6: Update Flutter App

### Remove Dev Mode Snackbar

Edit `lib/features/auth/presentation/pages/login_page.dart`:

**Find this code** (around line 124):

```dart
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

**Replace with**:

```dart
// Notify user that code was sent
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

**Do the same for resend** (around line 196):

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

## Step 7: Test Email Sending

### 1. Run Your App
```bash
flutter run
```

### 2. Login
- Enter email and password
- Click "Login"

### 3. Check Email
- ✅ You should receive an email with the 6-digit code
- ✅ Email should arrive within 5-10 seconds
- ✅ Check spam folder if not in inbox

### 4. Enter Code
- Enter the code from your email
- ✅ Login successful!

---

## Monitoring & Debugging

### View Function Logs
```bash
firebase functions:log
```

### Check Function Execution
1. Firebase Console → **Functions** tab
2. See invocation count, errors, and execution time

### Check Email Delivery
**SendGrid**:
- Go to SendGrid dashboard
- **Activity** → See email delivery status

**Gmail**:
- Check "Sent" folder

---

## Costs Breakdown

### Firebase Blaze Plan (Pay-as-you-go)

**Free Tier (Monthly)**:
- 2,000,000 function invocations
- 400,000 GB-seconds compute time
- 5GB network egress

**After Free Tier**:
- $0.40 per million invocations
- $0.0000025 per GB-second

**Example Cost for 1,000 users/day**:
- 1,000 logins × 30 days = 30,000 emails/month
- Cost: ~$0.01 - $0.05/month

### SendGrid
- **Free**: 100 emails/day forever
- **Essentials**: $19.95/month for 50,000 emails

---

## Troubleshooting

### Issue 1: "Missing or insufficient permissions"
**Solution**: Make sure you updated Firestore rules (see previous fix)

### Issue 2: SendGrid "Forbidden" error
**Solution**:
1. Verify your sender email in SendGrid
2. Check API key has full access permissions
3. Ensure API key is correctly set in Firebase config

### Issue 3: Email not received
**Solutions**:
1. Check spam folder
2. Verify sender email in SendGrid
3. Check Firebase function logs: `firebase functions:log`
4. Test with different email provider (Gmail, Yahoo, etc.)

### Issue 4: Function timeout
**Solution**: Increase timeout in `functions/src/index.ts`:

```typescript
export const send2FACode = functions
  .runWith({
    timeoutSeconds: 60,
    memory: "256MB"
  })
  .firestore.document("verification_codes/{userId}")
  .onCreate(async (snap, context) => {
    // ... rest of code
  });
```

---

## Alternative: Using Gmail SMTP (No SendGrid)

If you prefer Gmail, use this code instead:

```typescript
import * as nodemailer from "nodemailer";

const transporter = nodemailer.createTransport({
  service: "gmail",
  auth: {
    user: functions.config().gmail.user,
    pass: functions.config().gmail.password,
  },
});

export const send2FACode = functions.firestore
  .document("verification_codes/{userId}")
  .onCreate(async (snap, context) => {
    const data = snap.data();

    const mailOptions = {
      from: functions.config().gmail.user,
      to: data.email,
      subject: "EdgeUp UPSC - Your Login Verification Code",
      html: `<h2>Your code is: ${data.code}</h2>`,
    };

    await transporter.sendMail(mailOptions);
    return {success: true};
  });
```

---

## Summary Checklist

### Setup (One-time)
- [ ] Upgrade to Firebase Blaze Plan
- [ ] Install Node.js and Firebase CLI
- [ ] Initialize Cloud Functions (`firebase init functions`)
- [ ] Create SendGrid account and API key
- [ ] Set Firebase config with SendGrid credentials
- [ ] Write Cloud Function code
- [ ] Deploy functions (`firebase deploy --only functions`)

### App Updates
- [ ] Remove "DEV MODE" code display from snackbars
- [ ] Test email sending end-to-end
- [ ] Monitor function logs for errors

### Production
- [ ] Set budget alerts in Firebase
- [ ] Monitor email delivery rates
- [ ] Add rate limiting if needed
- [ ] Consider custom email domain

---

**Your app will now send real emails with 2FA codes!** 📧🔐

**Estimated Time**: 30-45 minutes for complete setup
**Cost**: ~$0-5/month for small to medium usage

