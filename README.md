# MFU Eventify

A feature-rich Flutter application for discovering, managing, and saving events. Built with a beautiful UI and smooth user experience across multiple platforms.

## Features

- **Event Discovery** - Browse and search events in your area
- **Event Management** - Create, edit, and manage events
- **Save Events** - Bookmark your favorite events for later
- **Authentication** - Secure user authentication and account management
- **Settings** - Customize your app preferences and notifications
- **Cross-Platform Support** - Available on iOS, Android, macOS, Linux, Windows, and Web

## Tech Stack

- **Framework**: Flutter 3.x
- **Language**: Dart
- **State Management**: [Your state management solution - e.g., Provider, Riverpod, BLoC]
- **Backend**: [Your backend service]
- **Database**: [Your database solution]
- **UI**: Material Design 3

## Prerequisites

Before running this project, ensure you have:

- Flutter SDK installed (version 3.0 or higher)
- Dart SDK (comes with Flutter)
- Android Studio / Xcode (for native development)
- Git

## Getting Started

### Installation

1. **Clone the repository**
   ```bash
   git clone <repository-url>
   cd mfu_eventify

2. **Install dependencies**
    ```bash
    flutter pub get

3. **Generate necessary files**
    ```bash
    flutter pub run build_runner build

4. **Generate necessary files**
    ```bash
    flutter run
    

## Project Structure   

```bash
lib/
├── main.dart                 # Entry point
├── core/
│   ├── constants/           # App constants
│   ├── navigation/          # Navigation setup
│   ├── theme/              # Theme configuration
│   └── widgets/            # Reusable widgets
├── features/
│   ├── auth/               # Authentication feature
│   ├── events/             # Events feature
│   ├── saved_events/       # Saved events feature
│   ├── settings/           # Settings feature
│   └── welcome/            # Welcome/onboarding feature
├── models/
│   └── event_model.dart    # Event data model
└── services/               # Business logic & API services