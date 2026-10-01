# EzFinanz

EzFinanz is a Flutter financial-app prototype with an onboarding flow introducing loan applications, payment tracking, and account security. The welcome screen provides login and account-creation entry points.

The current build is a UI prototype. Login and account-creation actions are placeholders; authentication, loan applications, and payment services are not connected to a backend.

## Features

- Three swipeable onboarding slides with next, back, and skip navigation
- Welcome screen with login and create-account buttons
- Responsive Flutter UI for mobile, web, and desktop window sizes
- Motion-aware transitions that respect the device's reduced-animation setting

## Supported Flutter Targets

The repository contains Flutter platform projects for Android, iOS, web, Windows, macOS, and Linux. Each target requires its platform's development tools; for example, iOS builds require macOS and Xcode.

## Requirements

- Flutter SDK with Dart SDK `^3.13.0`
- Platform toolchain for the target device or operating system

Check your Flutter installation with:

```sh
flutter doctor
```

## Run Locally

Clone the repository and enter the project directory:

```sh
git clone https://github.com/BugataPravallika/Ezfinanz_loginapp.git
cd Ezfinanz_loginapp
flutter pub get
flutter run
```

To launch in a specific target, for example:

```sh
flutter run -d chrome
flutter run -d <device-id>
```

List available devices with `flutter devices`.

## Tests and Analysis

Run the widget tests and static analysis with:

```sh
flutter test
flutter analyze
```

## Build

Build a release APK for Android:

```sh
flutter build apk --release
```

The generated APK is written to `build/app/outputs/flutter-apk/app-release.apk`. A copy included in this repository is available at [`apk_folder/app-release.apk`](apk_folder/app-release.apk).

Other common build commands:

```sh
flutter build appbundle
flutter build ios
flutter build web
flutter build windows
flutter build macos
flutter build linux
```

Some platform builds can only be produced on their supported operating systems and with the required toolchains installed.

## Project Layout

- `lib/main.dart`: app entry point, onboarding flow, welcome screen, and reusable UI components
- `assets/`: app logo, onboarding illustrations, and other image assets
- `test/`: Flutter widget tests
- `android/`, `ios/`, `web/`, `windows/`, `macos/`, `linux/`: platform-specific Flutter project files
- `apk_folder/`: checked-in Android release APK
