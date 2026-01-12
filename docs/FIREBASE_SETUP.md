Firebase setup for this Flutter project

This project includes Firebase initialization in `lib/main.dart` (calls `Firebase.initializeApp()`). To fully configure Firebase for each platform, follow these steps:

1. Install FlutterFire CLI (if not already):

```bash
dart pub global activate flutterfire_cli
```

2. Authenticate and configure your Firebase project (run from repo root):

```bash
flutterfire configure
```

This will generate `lib/firebase_options.dart` and link your Android/iOS/web apps. It may also instruct you to download `google-services.json` (Android) and `GoogleService-Info.plist` (iOS/macOS) if necessary.

3. After generating config, run:

```bash
flutter pub get
```

4. For Web, ensure the generated `firebase_options.dart` is present and referenced if needed.

Notes:
- The app currently calls `Firebase.initializeApp()` without platform-specific `FirebaseOptions`. If you target web or get errors, regenerate `lib/firebase_options.dart` with `flutterfire configure` and modify `main.dart` to pass `DefaultFirebaseOptions.currentPlatform` to `Firebase.initializeApp()`.
- If you need authentication, database, or Firestore, add the corresponding packages to `pubspec.yaml` (e.g., `firebase_auth`, `cloud_firestore`).

If you want, I can:
- Run the necessary `flutterfire configure` commands (requires your Firebase project credentials and network access).
- Modify `main.dart` to use `DefaultFirebaseOptions` once you have the generated `lib/firebase_options.dart` file.
