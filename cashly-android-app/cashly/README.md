# Cashly - Budget & Finance Tracking App

A comprehensive budget and finance tracking Android application built with Flutter and Dart.

## Features

- **User Authentication**: Secure login and registration system
- **Budget Management**: Create, read, update, and delete budgets
- **Transaction Tracking**: Log income and expenses with categories
- **Visual Analytics**: Interactive charts and graphs (pie charts, bar charts, line graphs)
- **Dark Mode**: Beautiful blue/yellow/white color scheme with dark theme support
- **Profile Management**: User profile customization
- **Settings**: App preferences and configuration
- **About Section**: App information and credits

## Technical Stack

- **Language**: Dart
- **Framework**: Flutter
- **Database**: SQLite (sqflite)
- **State Management**: Provider
- **Charts**: FL Chart & Syncfusion Charts
- **API Integration**: Dio & HTTP
- **Architecture**: MVC with OOP principles

## Project Structure

\`\`\`
cashly/
├── lib/
│   ├── core/
│   │   ├── constants/
│   │   ├── models/
│   │   ├── providers/
│   │   ├── routes/
│   │   ├── services/
│   │   ├── theme/
│   │   └── utils/
│   ├── features/
│   │   ├── auth/
│   │   ├── dashboard/
│   │   ├── budget/
│   │   ├── transactions/
│   │   ├── profile/
│   │   ├── settings/
│   │   └── about/
│   ├── widgets/
│   └── main.dart
├── assets/
│   ├── icons/
│   ├── images/
│   └── fonts/
└── android/
\`\`\`

## Getting Started

### Prerequisites

- Flutter SDK (>= 3.0.0)
- Dart SDK (>= 3.0.0)
- Android Studio or VS Code
- Android SDK

### Installation

1. Clone the repository
2. Navigate to the cashly directory
3. Run `flutter pub get` to install dependencies
4. Run `flutter run` to start the app

### Build APK

\`\`\`bash
flutter build apk --release
\`\`\`

## Database Schema

- **Users**: User authentication and profile data
- **Budgets**: Budget information and limits
- **Transactions**: Income and expense records
- **Categories**: Transaction categories

## API Integration

The app includes a simple REST API layer for potential cloud sync features:
- Authentication endpoints
- Budget CRUD operations
- Transaction management

## License

MIT License - Feel free to use this project for learning and development.
