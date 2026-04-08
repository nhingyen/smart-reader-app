# 🔥 HƯỚNG DẪN SETUP FIREBASE CHO SMART READER APP

## 📋 BƯỚC 1: TẠO FIREBASE PROJECT

1. **Truy cập Firebase Console:**

   ```
   https://console.firebase.google.com
   ```

2. **Tạo project mới:**
   - Nhấp "Add project"
   - Tên project: `smart-reader-app`
   - Enable Google Analytics (tuỳ chọn)
   - Chọn Analytics account hoặc tạo mới
   - Nhấp "Create project"

## 📱 BƯỚC 2: THÊM ANDROID APP

1. **Trong Firebase Console:**

   - Nhấp biểu tượng Android
   - Android package name: `com.example.smart_reader`
   - App nickname: `Smart Reader Android`
   - SHA-1 certificate (tuỳ chọn, cần cho Google Sign-In)

2. **Lấy SHA-1 certificate:**

   ```bash
   cd android
   ./gradlew signingReport
   ```

   Copy SHA-1 từ debug keystore

3. **Download google-services.json:**

   - Download file `google-services.json`
   - Đặt vào: `android/app/google-services.json`

4. **Cấu hình Android:**

   **File: android/build.gradle**

   ```gradle
   buildscript {
     dependencies {
       classpath 'com.google.gms:google-services:4.3.15'
     }
   }
   ```

   **File: android/app/build.gradle**

   ```gradle
   apply plugin: 'com.google.gms.google-services'

   android {
     compileSdk 34
     defaultConfig {
       minSdk 21
       targetSdk 34
     }
   }
   ```

## 🍎 BƯỚC 3: THÊM iOS APP (TUỲ CHỌN)

1. **Trong Firebase Console:**

   - Nhấp biểu tượng iOS
   - iOS bundle ID: `com.example.smartReader`
   - App nickname: `Smart Reader iOS`

2. **Download GoogleService-Info.plist:**
   - Download file `GoogleService-Info.plist`
   - Đặt vào: `ios/Runner/GoogleService-Info.plist`

## 🔐 BƯỚC 4: ENABLE AUTHENTICATION

1. **Trong Firebase Console > Authentication:**

   - Nhấp "Get started"
   - Tab "Sign-in method"

2. **Enable Email/Password:**

   - Nhấp "Email/Password"
   - Enable "Email/Password"
   - Enable "Email link (passwordless sign-in)" (tuỳ chọn)
   - Save

3. **Enable Google Sign-In:**

   - Nhấp "Google"
   - Enable "Google"
   - Project support email: [your-email]
   - Save

4. **Thêm SHA fingerprints:**
   - Vào Project Settings > General
   - Phần "Your apps" > Android app
   - Thêm SHA-1 certificate fingerprints

## 💾 BƯỚC 5: ENABLE FIRESTORE DATABASE

1. **Trong Firebase Console > Firestore Database:**

   - Nhấp "Create database"
   - Chọn "Start in test mode" (development)
   - Chọn location (asia-southeast1 cho Việt Nam)
   - Enable

2. **Firestore Security Rules (Development):**
   ```javascript
   rules_version = '2';
   service cloud.firestore {
     match /databases/{database}/documents {
       // Users can read/write their own data
       match /users/{userId} {
         allow read, write: if request.auth != null && request.auth.uid == userId;
       }

       // Public read for books, categories
       match /books/{bookId} {
         allow read: if true;
         allow write: if request.auth != null;
       }

       match /categories/{categoryId} {
         allow read: if true;
         allow write: if request.auth != null;
       }
     }
   }
   ```

## 🔧 BƯỚC 6: CẬP NHẬT FIREBASE OPTIONS

1. **Cài đặt FlutterFire CLI:**

   ```bash
   npm install -g firebase-tools
   dart pub global activate flutterfire_cli
   ```

2. **Configure Firebase:**

   ```bash
   firebase login
   flutterfire configure
   ```

3. **Hoặc cập nhật thủ công file `lib/firebase_options.dart`:**
   - Lấy config từ Firebase Console > Project Settings
   - Cập nhật các giá trị API key, App ID, etc.

## 📚 BƯỚC 7: COLLECTION STRUCTURE

### **Users Collection (`users`):**

```json
{
  "uid": "user_id",
  "email": "user@example.com",
  "displayName": "User Name",
  "photoURL": "https://...",
  "createdAt": "timestamp",
  "lastLoginAt": "timestamp",
  "isEmailVerified": true,
  "phone": "+84xxxxxxxxx",
  "preferences": {
    "theme": "light",
    "language": "vi",
    "notifications": true
  }
}
```

### **Books Collection (`books`):**

```json
{
  "id": "book_id",
  "title": "Book Title",
  "author": "Author Name",
  "description": "Book description",
  "coverUrl": "https://...",
  "pdfUrl": "https://...",
  "category": "fiction",
  "tags": ["tag1", "tag2"],
  "createdAt": "timestamp",
  "updatedAt": "timestamp"
}
```

## 🧪 BƯỚC 8: TEST SETUP

1. **Chạy app:**

   ```bash
   flutter clean
   flutter pub get
   flutter run
   ```

2. **Test Authentication:**

   - Đăng ký tài khoản mới
   - Đăng nhập
   - Google Sign-In
   - Password reset

3. **Test Firestore:**
   - Kiểm tra user data trong Firebase Console
   - Verify user creation, login tracking

## 🚨 PRODUCTION SETUP

### **Security Rules (Production):**

```javascript
rules_version = '2';
service cloud.firestore {
  match /databases/{database}/documents {
    // Authenticated users only
    match /users/{userId} {
      allow read, write: if request.auth != null
        && request.auth.uid == userId
        && request.auth.token.email_verified == true;
    }

    // Admin-only write access for books
    match /books/{bookId} {
      allow read: if request.auth != null;
      allow write: if request.auth != null
        && request.auth.token.admin == true;
    }
  }
}
```

### **Environment Variables:**

- Tạo `.env` file cho production keys
- Sử dụng different Firebase projects cho dev/prod

## ✅ VERIFICATION CHECKLIST

- [ ] Firebase project created
- [ ] Android app added with correct package name
- [ ] google-services.json downloaded và đặt đúng vị trí
- [ ] Android build.gradle configured
- [ ] Authentication methods enabled
- [ ] Firestore database created
- [ ] Security rules configured
- [ ] Firebase options updated
- [ ] App runs without Firebase errors
- [ ] User registration works
- [ ] User login works
- [ ] Google Sign-In works (nếu enabled)
- [ ] User data saved to Firestore
- [ ] Password reset works

## 🆘 TROUBLESHOOTING

### **Lỗi "Default FirebaseApp is not initialized":**

```dart
await Firebase.initializeApp(
  options: DefaultFirebaseOptions.currentPlatform,
);
```

### **Lỗi Google Sign-In:**

- Kiểm tra SHA-1 certificate
- Verify package name
- Enable Google Sign-In in Firebase Console

### **Lỗi Firestore permissions:**

- Kiểm tra Security Rules
- Verify user authentication
- Check Firestore collection/document structure

### **Build errors:**

- `flutter clean && flutter pub get`
- Update Android Gradle Plugin
- Check minimum SDK versions
