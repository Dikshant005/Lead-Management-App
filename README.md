# Mini Lead Management App - README

## 📱 App Overview

**Mini Lead Manager** is a CRM-style mobile application built with Flutter for managing sales leads and customer contacts. The app allows users to efficiently track leads through their entire lifecycle—from initial contact to conversion or loss.

### Key Features

- **Complete Lead Management**: Add, view, edit, and delete leads with essential contact information
- **Status Tracking**: Track lead progression through four stages (New → Contacted → Converted / Lost)
- **Smart Filtering**: Filter leads by status (All, New, Contacted, Converted, Lost) with visual chips
- **Real-time Search**: Search leads instantly by name with dynamic filtering
- **Persistent Storage**: Local SQLite database ensures data persists across app sessions
- **Clean UI**: Material Design 3 interface with status badges, color coding, and intuitive navigation
- **Timestamps**: Automatic tracking of creation and update times for each lead

### Target Use Cases

This app is designed for:
- Sales representatives tracking potential customers
- Insurance agents managing policy leads
- Small business owners tracking client prospects
- Anyone needing a lightweight CRM solution

---

## 🚀 How to Run

### Prerequisites

Before running the app, ensure you have the following installed:

- **Flutter SDK** (3.0.0 or higher): [Install Flutter](https://flutter.dev/docs/get-started/install)
- **Dart SDK** (included with Flutter)
- **Android Studio** or **VS Code** with Flutter extensions
- **Android Emulator** or **Physical Android Device** (app is Android-only)
- **Git** for cloning the repository

### Installation Steps

**1. Clone the Repository**
git clone https://github.com/Dikshant005/Lead-Management-App.git
cd lead_manager

**2. Install Dependencies**
flutter pub get

**3. Verify Flutter Installation**
flutter doctor
Ensure all checkmarks are green (at least for Flutter and Android toolchain)

**4. Connect Device or Start Emulator**
# List available devices
flutter devices

# Start Android emulator (if needed)
flutter emulators
flutter emulators --launch <emulator_id>

**5. Run the App**
flutter run

Or for release build:
flutter run --release

### Building APK

To create an installable APK file:

# Debug APK
flutter build apk --debug

# Release APK
flutter build apk --release

# Split APKs by architecture
flutter build apk --split-per-abi

APK files will be located in `build/app/outputs/flutter-apk/`

---

## 🏗️ Architecture Explanation

The app follows **Clean Architecture** principles with clear separation of concerns, ensuring maintainability, testability, and scalability.

### Architectural Layers

┌─────────────────────────────────────────┐
│         Presentation Layer              │
│  (Screens, Widgets, UI Components)      │
└─────────────────┬───────────────────────┘
                  │
┌─────────────────▼───────────────────────┐
│      State Management Layer             │
│         (Provider - LeadProvider)       │
└─────────────────┬───────────────────────┘
                  │
┌─────────────────▼───────────────────────┐
│         Business Logic Layer            │
│    (Models, Data Transformation)        │
└─────────────────┬───────────────────────┘
                  │
┌─────────────────▼───────────────────────┐
│          Data Layer                     │
│  (DatabaseService - SQLite Operations)  │
└─────────────────────────────────────────┘

### Project Structure

lib/
├── main.dart                  # App entry point, Provider setup
├── models/                    # Data models
│   └── lead_model.dart       # Lead entity with serialization
├── providers/                 # State management
│   └── lead_provider.dart    # ChangeNotifier for lead operations
├── services/                  # Business logic & data access
│   └── database_service.dart # SQLite CRUD operations
├── screens/                   # UI screens
│   ├── lead_list_screen.dart    # Main list view with filters
│   ├── add_lead_screen.dart     # Form for creating leads
│   └── lead_detail_screen.dart  # View/edit individual lead
├── widgets/                   # Reusable UI components
│   ├── lead_card.dart        # List item component
│   └── status_badge.dart     # Status indicator widget
└── utils/                     # Constants & helpers
    └── constants.dart        # Status enums, colors, icons

### Design Patterns Used

1. **Singleton Pattern**: `DatabaseService.instance` ensures single database connection
2. **Repository Pattern**: `DatabaseService` abstracts data access logic
3. **Observer Pattern**: Provider's `ChangeNotifier` for reactive state updates
4. **Factory Pattern**: `Lead.fromMap()` for object creation from database
5. **Separation of Concerns**: Each layer has single responsibility

### Data Flow

1. **User Action** → Screen widget triggers event
2. **Provider Method** → `LeadProvider` receives request
3. **Service Call** → `DatabaseService` performs CRUD operation
4. **Database Update** → SQLite stores/retrieves data
5. **State Update** → Provider calls `notifyListeners()`
6. **UI Rebuild** → Consumer widgets automatically update

### State Management Strategy

**Provider Pattern** was chosen for its:
- Simplicity and minimal boilerplate
- Built-in dependency injection via context
- Efficient widget rebuilding with `Consumer`
- Easy testing and debugging
- Official Flutter recommendation for medium-sized apps

---

## 📦 Packages Used

### Core Dependencies

| Package | Version | Purpose |
|---------|---------|---------|
| **provider** | ^6.1.1 | State management - manages app state and notifies listeners |
| **sqflite** | ^2.3.0 | Local SQLite database for persistent storage |
| **path** | ^1.8.3 | File path manipulation for database location |
| **intl** | ^0.18.1 | Date/time formatting (e.g., "Nov 20, 2025") |

### Package Details

#### 1. Provider (State Management)
provider: ^6.1.1
- **Purpose**: Manages application state and provides reactive updates to UI
- **Key Features**:
  - `ChangeNotifier`: Base class for `LeadProvider`
  - `Consumer`: Rebuilds widgets when state changes
  - `context.read()`: Access provider methods without rebuilding
- **Usage**: Handles lead list, filtering, search, and CRUD operations

#### 2. SQLite (sqflite)
sqflite: ^2.3.0
- **Purpose**: Local relational database for persistent lead storage
- **Key Features**:
  - Full SQL support with CRUD operations
  - Async/await API for non-blocking operations
  - Support for complex queries (WHERE, ORDER BY, LIKE)
- **Database Schema**:
  CREATE TABLE leads (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    name TEXT NOT NULL,
    contact TEXT NOT NULL,
    status TEXT NOT NULL,
    notes TEXT,
    createdAt TEXT NOT NULL,
    updatedAt TEXT NOT NULL
  )

#### 3. Path
path: ^1.8.3
- **Purpose**: Cross-platform path manipulation
- **Usage**: Locates database file in device storage
- **Example**: `join(getDatabasesPath(), 'leads.db')`

#### 4. Intl
intl: ^0.18.1
- **Purpose**: Internationalization and date formatting
- **Usage**: Formats timestamps for display
- **Example**: `DateFormat('MMM dd, yyyy').format(date)`

### Development Dependencies

dev_dependencies:
  flutter_test:
    sdk: flutter
  flutter_lints: ^3.0.0 

---

## 🎯 Features Checklist

### Core Requirements ✅
- [x] Lead list screen with scrollable view
- [x] Display name, contact, status for each lead
- [x] Status filtering (All, New, Contacted, Converted, Lost)
- [x] Add lead form with validation
- [x] Lead detail page with edit capability
- [x] Update lead status functionality
- [x] Delete lead with confirmation dialog
- [x] SQLite local storage with CRUD operations
- [x] Provider state management

### Bonus Features ✅
- [x] Search leads by name
- [x] Status badges with color coding
- [x] Smooth card animations
- [x] Polished UI with Material Design 3
- [x] Timestamps (created/updated)
- [x] Form validation
- [x] Empty state handling
- [x] Loading indicators

---

## 🧪 Testing the App

### Manual Testing Checklist

1. **Add Lead**: Create leads with various status types
2. **View Leads**: Verify all fields display correctly
3. **Filter**: Test each status filter (All, New, Contacted, etc.)
4. **Search**: Search by partial name matches
5. **Edit**: Update lead information and status
6. **Delete**: Remove leads with confirmation
7. **Persistence**: Close and reopen app to verify data persists




