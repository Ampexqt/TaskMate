---
description: Firebase Firestore Integration Guide
---

# Firebase Firestore Integration for TaskMate

This workflow guides you through integrating Firebase Firestore into your TaskMate Flutter application.

## Prerequisites
- Firebase CLI installed
- Flutter SDK installed
- Active Firebase account

---

## Part 1: Firebase Project Setup

### Step 1: Create Firebase Project (Web Console)

1. Go to [Firebase Console](https://console.firebase.google.com/)
2. Click "Create a project" (or use your current screen)
3. Enter project name: `task-mate` or `taskmate-app`
4. Click **Continue**
5. Enable/Disable Google Analytics (optional)
6. Click **Create Project**
7. Wait for project creation to complete

### Step 2: Enable Firestore Database

1. In Firebase Console, click on **Firestore Database** in the left sidebar
2. Click **Create Database**
3. Select **Start in test mode** (we'll secure it later)
4. Choose your Cloud Firestore location (select closest to your users)
5. Click **Enable**

### Step 3: Register Flutter Apps

#### For Android:
1. Click the **Android icon** in Firebase Console
2. Enter Android package name: `com.example.task_mate` (check `android/app/build.gradle` for actual package)
3. Enter app nickname: `TaskMate Android`
4. Click **Register app**
5. Download `google-services.json`
6. **Important**: Save this file, we'll place it later

#### For iOS (if targeting iOS):
1. Click the **iOS icon** in Firebase Console
2. Enter iOS bundle ID (check `ios/Runner.xcodeproj/project.pbxproj`)
3. Enter app nickname: `TaskMate iOS`
4. Click **Register app**
5. Download `GoogleService-Info.plist`
6. **Important**: Save this file, we'll place it later

#### For Web (if targeting Web):
1. Click the **Web icon** in Firebase Console
2. Enter app nickname: `TaskMate Web`
3. Click **Register app**
4. Copy the Firebase configuration object
5. Click **Continue to console**

---

## Part 2: Fix PowerShell Execution Policy

### Step 4: Enable PowerShell Scripts

Run this command in PowerShell as Administrator:

```powershell
Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope CurrentUser
```

**Note**: This allows you to run Firebase CLI commands.

---

## Part 3: Firebase CLI Setup

### Step 5: Login to Firebase

```bash
firebase login
```

This will open a browser window. Sign in with your Google account.

### Step 6: Install FlutterFire CLI

```bash
dart pub global activate flutterfire_cli
```

### Step 7: Configure FlutterFire

// turbo
```bash
flutterfire configure
```

This command will:
- Detect your Flutter platforms (Android, iOS, Web, etc.)
- Let you select your Firebase project
- Automatically generate configuration files
- Create `firebase_options.dart` file

**Select your project** when prompted (the one you created in Step 1)

---

## Part 4: Update Flutter Dependencies

### Step 8: Add Firebase Dependencies

Add these to your `pubspec.yaml`:

```yaml
dependencies:
  # Existing dependencies...
  
  # Firebase
  firebase_core: ^3.6.0
  cloud_firestore: ^5.4.4
```

### Step 9: Install Dependencies

// turbo
```bash
flutter pub get
```

---

## Part 5: Platform-Specific Configuration

### Step 10: Android Configuration

1. **Place google-services.json**:
   - Copy `google-services.json` to `android/app/` directory

2. **Update android/build.gradle**:
   ```gradle
   buildscript {
       dependencies {
           // Add this line
           classpath 'com.google.gms:google-services:4.4.0'
       }
   }
   ```

3. **Update android/app/build.gradle**:
   ```gradle
   // Add at the bottom of the file
   apply plugin: 'com.google.gms.google-services'
   ```

4. **Update minSdkVersion** in `android/app/build.gradle`:
   ```gradle
   defaultConfig {
       minSdkVersion 21  // Changed from 16 or lower
   }
   ```

### Step 11: iOS Configuration (if applicable)

1. **Place GoogleService-Info.plist**:
   - Open Xcode: `open ios/Runner.xcworkspace`
   - Drag `GoogleService-Info.plist` into the Runner folder in Xcode
   - Ensure "Copy items if needed" is checked

2. **Update ios/Podfile**:
   ```ruby
   platform :ios, '13.0'  # Minimum iOS 13
   ```

3. **Install CocoaPods**:
   ```bash
   cd ios
   pod install
   cd ..
   ```

### Step 12: Web Configuration (if applicable)

1. **Update web/index.html**:
   Add before `</body>`:
   ```html
   <script src="https://www.gstatic.com/firebasejs/10.7.0/firebase-app-compat.js"></script>
   <script src="https://www.gstatic.com/firebasejs/10.7.0/firebase-firestore-compat.js"></script>
   ```

---

## Part 6: Initialize Firebase in Flutter

### Step 13: Update main.dart

The `main.dart` will be updated to initialize Firebase before running the app.

---

## Part 7: Create Firestore Repository

### Step 14: Create Firestore Task Repository

A new repository will be created: `lib/data/repositories/firestore_task_repository.dart`

This will replace the SharedPreferences implementation with Firestore.

---

## Part 8: Update Firestore Security Rules

### Step 15: Configure Security Rules

1. Go to Firebase Console → Firestore Database → Rules
2. Update rules for production:

```
rules_version = '2';
service cloud.firestore {
  match /databases/{database}/documents {
    match /tasks/{taskId} {
      allow read, write: if request.auth != null;
    }
  }
}
```

**Note**: For now, you can use test mode, but implement authentication later.

---

## Part 9: Testing

### Step 16: Test the Integration

// turbo
```bash
flutter run
```

### Step 17: Verify Data in Firebase Console

1. Open Firebase Console
2. Go to Firestore Database
3. Check if tasks are being created/updated/deleted

---

## Part 10: Optional - Add Authentication

### Step 18: Enable Firebase Authentication (Future Enhancement)

1. Firebase Console → Authentication
2. Click **Get Started**
3. Enable **Email/Password** or **Google Sign-In**
4. Add `firebase_auth` package to `pubspec.yaml`

---

## Troubleshooting

### Common Issues:

1. **Multidex Error (Android)**:
   - Add to `android/app/build.gradle`:
   ```gradle
   defaultConfig {
       multiDexEnabled true
   }
   ```

2. **CocoaPods Error (iOS)**:
   ```bash
   cd ios
   pod repo update
   pod install
   cd ..
   ```

3. **Firebase not initialized**:
   - Ensure `Firebase.initializeApp()` is called before `runApp()`

4. **Permission denied (Firestore)**:
   - Check Firestore security rules
   - Ensure test mode is enabled during development

---

## Next Steps After Integration

1. ✅ Test CRUD operations
2. ✅ Implement offline persistence
3. ✅ Add user authentication
4. ✅ Implement data sync across devices
5. ✅ Add cloud backup/restore functionality
6. ✅ Optimize Firestore queries
7. ✅ Implement proper error handling

---

## Resources

- [FlutterFire Documentation](https://firebase.flutter.dev/)
- [Firestore Documentation](https://firebase.google.com/docs/firestore)
- [Firebase Console](https://console.firebase.google.com/)
