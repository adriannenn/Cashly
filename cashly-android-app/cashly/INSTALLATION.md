# Cashly - Installation Guide

## Prerequisites

Before you begin, ensure you have the following installed:

1. **Flutter SDK** (version 3.0.0 or higher)
   - Download from: https://flutter.dev/docs/get-started/install
   - Add Flutter to your PATH

2. **Dart SDK** (version 3.0.0 or higher)
   - Comes bundled with Flutter

3. **Android Studio** or **VS Code**
   - Android Studio: https://developer.android.com/studio
   - VS Code: https://code.visualstudio.com/

4. **Android SDK**
   - Install via Android Studio
   - Minimum SDK: 21
   - Target SDK: 34

5. **JDK** (Java Development Kit)
   - Version 11 or higher

## Installation Steps

### 1. Verify Flutter Installation

Open a terminal and run:

\`\`\`bash
flutter doctor
\`\`\`

This will check your environment and display a report of the status. Make sure all required dependencies are installed.

### 2. Clone or Extract the Project

Navigate to the `cashly` directory:

\`\`\`bash
cd cashly
\`\`\`

### 3. Install Dependencies

Run the following command to install all required packages:

\`\`\`bash
flutter pub get
\`\`\`

This will download all dependencies specified in `pubspec.yaml`.

### 4. Generate Launcher Icons (Optional)

To generate the app launcher icons:

\`\`\`bash
flutter pub run flutter_launcher_icons
\`\`\`

### 5. Configure Android

#### Update Android SDK Path

If needed, set the Android SDK path in `local.properties`:

```properties
sdk.dir=/path/to/your/android/sdk
flutter.sdk=/path/to/your/flutter/sdk
