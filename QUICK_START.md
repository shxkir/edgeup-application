# 🚀 Quick Start - EmailJS 2FA Setup

## ⚡ What I Just Did For You

✅ **Integrated EmailJS** into your app for FREE email sending (200 emails/month)
✅ **Updated login flow** to send real emails with 6-digit verification codes
✅ **Created email service** with automatic fallback to console if not configured
✅ **Updated resend feature** to send new emails

---

## 🎯 What You Need To Do (15 minutes)

### 1. Install Package (2 minutes)

```bash
cd C:\Users\ismai\Documents\edgeup-application\edgeup_upsc_app
flutter pub get
```

### 2. Get EmailJS API Keys (10 minutes)

Go to: **https://www.emailjs.com/**

**Sign up** → **Connect Gmail** → **Create template** → **Get 3 keys:**

1. **Service ID** (e.g., `service_abc123`)
2. **Template ID** (e.g., `template_xyz789`)
3. **Public Key** (e.g., `user_DEF456GHI`)

**Full detailed guide**: See `EMAILJS_CONFIGURATION_STEPS.md`

### 3. Update Code (1 minute)

Open: `lib/features/auth/services/emailjs_service.dart`

Find lines 14-16 and replace with YOUR keys:

```dart
static const String serviceId = 'service_abc123';     // ← YOUR Service ID
static const String templateId = 'template_xyz789';   // ← YOUR Template ID
static const String publicKey = 'user_DEF456GHI';     // ← YOUR Public Key
```

### 4. Test (2 minutes)

```bash
flutter run
```

Login → Check email → Enter code → Done! ✅

---

## 📧 Email Template (Copy-Paste to EmailJS)

**Subject**: `EdgeUp UPSC - Your Login Verification Code`

**Template Variables Needed**:
- `{{user_name}}`
- `{{verification_code}}`

**See full HTML template in**: `EMAILJS_CONFIGURATION_STEPS.md` (Step 2.3)

---

## 🔍 Quick Troubleshooting

| Problem | Solution |
|---------|----------|
| No email received | Check spam folder, verify API keys |
| "Email not configured" | Update emailjs_service.dart with real keys |
| Code in console instead | EmailJS keys still have default values |

---

## 📚 Documentation Files

1. **`EMAILJS_CONFIGURATION_STEPS.md`** ← **START HERE** (Complete guide)
2. **`EMAILJS_SETUP_GUIDE.md`** (Detailed reference)
3. **`2FA_IMPLEMENTATION_GUIDE.md`** (How 2FA works)
4. **`FIREBASE_SETUP_GUIDE.md`** (Firebase configuration)

---

## ✅ What's Already Done

- ✅ `http` package added to pubspec.yaml
- ✅ `emailjs_service.dart` created
- ✅ `login_page.dart` updated to send emails
- ✅ Resend functionality updated
- ✅ Beautiful email template designed
- ✅ Firestore integration complete
- ✅ 5-minute code expiry
- ✅ One-time use codes
- ✅ Email history logging

---

## 🎉 After Setup You'll Have

✅ Real emails sent on every login
✅ Beautiful HTML email template
✅ 6-digit verification codes
✅ FREE (200 emails/month)
✅ No backend/server needed
✅ Works from Flutter app directly

---

**Next Step**: Follow `EMAILJS_CONFIGURATION_STEPS.md` to get your API keys!

**Total Time**: 15-20 minutes
**Cost**: FREE
**Difficulty**: Easy ⭐⭐☆☆☆
