# Platform Setup Guide

This repository contains the Flutter **source** (`lib/`), `pubspec.yaml`, and
`assets/`. The platform scaffolding (`android/`, `ios/`, `web/`, `windows/`) is
machine-generated and intentionally not committed. Generate it once on your
machine before running.

## 1. Generate platform folders

From the project root:

```bash
flutter create .
flutter pub get
```

`flutter create .` creates the missing platform folders **without overwriting**
your `lib/` or `pubspec.yaml`.

## 2. Run

```bash
flutter run -d emulator-5554     # Android emulator
# or
flutter devices                  # list available targets
```

## 3. Required Android configuration

The app uses the camera (QR scanning), biometrics (fingerprint login), and
SQLite. After `flutter create .`, apply these edits:

### a) Permissions
In `android/app/src/main/AndroidManifest.xml`, add above `<application>`:

```xml
<uses-permission android:name="android.permission.INTERNET"/>
<uses-permission android:name="android.permission.CAMERA"/>
<uses-permission android:name="android.permission.USE_BIOMETRIC"/>
<uses-feature android:name="android.hardware.camera" android:required="false"/>
```

### b) Minimum SDK
In `android/app/build.gradle.kts` (or `build.gradle`), inside `defaultConfig`:

```kotlin
minSdk = 23
```

### c) MainActivity (required by local_auth)
In `android/app/src/main/kotlin/.../MainActivity.kt`:

```kotlin
import io.flutter.embedding.android.FlutterFragmentActivity

class MainActivity : FlutterFragmentActivity()
```

## Testing tips

- **Demo Login** works on any device/emulator with no setup.
- **Fingerprint:** enroll one in the emulator (Settings -> Security), then
  simulate a touch from the host: `adb -e emu finger touch 1`.
- **QR scanning:** enable the emulator's virtual/back camera, or test on a
  physical device.
- **VirusTotal:** leave "Mock API mode" ON in Settings for offline demos. To use
  the live API, set your key in `lib/utils/constants.dart` and disable mock mode.
