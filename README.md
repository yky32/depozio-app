# Depozio Flutter App

A production-ready Flutter starter template with enterprise-grade features and best practices.
v2

## 🚀 Core Features

- Theming scaffolding with [`ThemeExtension`](https://api.flutter.dev/flutter/material/ThemeExtension-class.html)
- Routing scaffolding with [`go_router`](https://pub.dev/packages/go_router)
- Localization scaffolding with [`flutter_localizations`](https://pub.dev/packages/flutter_localizations)
- State management with [`flutter_bloc`](https://pub.dev/packages/flutter_bloc)
- Forms with [`flutter_form_builder`](https://pub.dev/packages/flutter_form_builder) and [`form_builder_validators`](https://pub.dev/packages/form_builder_validators)
- Toggle environment variables with a single argument (`--dart-define=ENV=dev`, `--dart-define=ENV=stag`, `--dart-define=ENV=prod`)

## 📋 Prerequisites

Before setting up the project, ensure you have the following installed:

- **Flutter SDK** (3.6.2 or higher)
- **Dart SDK** (included with Flutter)
- **IntelliJ IDEA** (Community or Ultimate edition)
- **Android Studio** (for Android development)
- **Xcode** (for iOS development on macOS)
- **Git** (for version control)

## 🛠️ Flutter Development Setup with IntelliJ IDEA

### Step 1: Install Flutter SDK

1. **Download Flutter SDK**:
   - Visit [flutter.dev](https://flutter.dev/docs/get-started/install)
   - Download the latest stable release for your operating system
   - Extract to a location like `/Users/yourusername/development/flutter`

2. **Add Flutter to PATH**:
   ```bash
   # Add to your shell profile (~/.zshrc, ~/.bashrc, etc.)
   export PATH="$PATH:/Users/yourusername/development/flutter/bin"
   ```

3. **Verify Installation**:
   ```bash
   flutter doctor
   ```

### Step 2: Install IntelliJ IDEA

1. **Download IntelliJ IDEA**:
   - [IntelliJ IDEA Community Edition](https://www.jetbrains.com/idea/download/) (Free)
   - [IntelliJ IDEA Ultimate](https://www.jetbrains.com/idea/download/) (Paid, with more features)

2. **Install Flutter and Dart Plugins**:
   - Open IntelliJ IDEA
   - Go to `File` → `Settings` (Windows/Linux) or `IntelliJ IDEA` → `Preferences` (macOS)
   - Navigate to `Plugins`
   - Search for and install:
     - **Flutter** (includes Dart plugin)
     - **Dart** (if not included with Flutter plugin)

### Step 3: Configure Flutter SDK in IntelliJ

1. **Set Flutter SDK Path**:
   - Go to `File` → `Settings` → `Languages & Frameworks` → `Flutter`
   - Set the Flutter SDK path to your Flutter installation directory
   - Example: `/Users/yourusername/development/flutter`

2. **Configure Dart SDK**:
   - The Dart SDK path should be automatically detected
   - If not, set it to: `{Flutter SDK path}/bin/cache/dart-sdk`

### Step 4: Set Up Android Development (for Android builds)

1. **Install Android Studio**:
   - Download from [developer.android.com](https://developer.android.com/studio)
   - Follow the installation wizard
   - Install Android SDK, Android SDK Platform-Tools, and Android SDK Build-Tools

2. **Configure Android SDK**:
   - In IntelliJ: `File` → `Settings` → `Languages & Frameworks` → `Android SDK`
   - Set Android SDK location (usually `~/Android/Sdk` on macOS/Linux)

3. **Accept Android Licenses**:
   ```bash
   flutter doctor --android-licenses
   ```

### Step 5: Set Up iOS Development (macOS only)

1. **Install Xcode**:
   - Download from the Mac App Store
   - Install Xcode Command Line Tools: `xcode-select --install`

2. **Configure iOS Simulator**:
   ```bash
   # Open iOS Simulator
   open -a Simulator
   ```

### Step 6: Project Setup

1. **Clone the Repository**:
   ```bash
   git clone https://github.com/yky32/depozio-app.git
   cd depozio-app
   ```

2. **Install Dependencies**:
   ```bash
   flutter pub get
   ```

3. **Open in IntelliJ IDEA**:
   - Open IntelliJ IDEA
   - Select `Open` and choose the `depozio-app` folder
   - IntelliJ will automatically detect it as a Flutter project

### Step 7: Configure IntelliJ for Flutter Development

1. **Enable Flutter Support**:
   - IntelliJ should automatically detect the Flutter project
   - If not, right-click on `pubspec.yaml` → `Open Module Settings` → `Modules` → `Add` → `Flutter`

2. **Configure Run Configurations**:
   - Go to `Run` → `Edit Configurations`
   - Add a new Flutter configuration:
     - **Name**: `Depozio App`
     - **Dart entrypoint**: `lib/main.dart`
     - **Additional arguments**: `--dart-define=ENV=dev`

3. **Set Up Debugging**:
   - IntelliJ provides excellent debugging support
   - Set breakpoints by clicking in the gutter
   - Use the debug toolbar to step through code

### Step 8: Environment Configuration

1. **Environment Files**:
   - The project uses environment-specific configuration
   - Edit files in the `env/` directory for different environments

2. **Run with Environment Variables**:
   ```bash
   # Development
   flutter run --dart-define=ENV=dev
   
   # Staging
   flutter run --dart-define=ENV=stag
   
   # Production
   flutter run --dart-define=ENV=prod
   ```

## 🚀 Running the App

### Using IntelliJ IDEA

1. **Select Target Device**:
   - Use the device selector in the toolbar
   - Choose from available simulators/emulators or physical devices

2. **Run the App**:
   - Click the green play button in the toolbar
   - Or use `Shift + F10` (Windows/Linux) or `Ctrl + R` (macOS)

3. **Debug the App**:
   - Click the debug button (bug icon) in the toolbar
   - Or use `Shift + F9` (Windows/Linux) or `Ctrl + D` (macOS)

### Using Command Line

```bash
# List available devices
flutter devices

# Run on specific device
flutter run -d <device-id>

# Run with specific environment
flutter run --dart-define=ENV=dev

# Run in debug mode
flutter run --debug

# Run in release mode
flutter run --release
```

## 🧪 Testing

```bash
# Run all tests
flutter test

# Run tests with coverage
flutter test --coverage

# Run specific test file
flutter test test/widget_test.dart
```

## 📱 Building the App

### Android

```bash
# Debug APK
flutter build apk --debug

# Release APK
flutter build apk --release

# App Bundle (for Play Store)
flutter build appbundle --release
```

### iOS

```bash
# Debug build
flutter build ios --debug

# Release build
flutter build ios --release
```

## 🔧 IntelliJ IDEA Tips for Flutter Development

### Essential Shortcuts

- **Quick Actions**: `Alt + Enter` (Windows/Linux) or `Option + Enter` (macOS)
- **Go to Definition**: `Ctrl + B` (Windows/Linux) or `Cmd + B` (macOS)
- **Find Usages**: `Alt + F7` (Windows/Linux) or `Option + F7` (macOS)
- **Refactor**: `Shift + F6` (Windows/Linux) or `Shift + F6` (macOS)
- **Generate Code**: `Alt + Insert` (Windows/Linux) or `Cmd + N` (macOS)

### Useful Plugins

- **Flutter** (essential)
- **Dart** (essential)
- **Git Integration** (built-in)
- **Database Tools** (if using databases)
- **REST Client** (for API testing)

### Code Generation

The project uses code generation for localization. Run:

```bash
# Generate localization files
flutter gen-l10n

# Generate other code (if using build_runner)
flutter packages pub run build_runner build
```

## 🐛 Troubleshooting

### Common Issues

1. **Flutter SDK not detected**:
   - Check Flutter SDK path in IntelliJ settings
   - Restart IntelliJ after changing SDK path

2. **Dependencies not resolved**:
   ```bash
   flutter clean
   flutter pub get
   ```

3. **Build errors**:
   ```bash
   flutter clean
   flutter pub get
   flutter build apk --debug
   ```

4. **iOS build issues**:
   ```bash
   cd ios
   pod install
   cd ..
   flutter run
   ```

### Performance Tips

- **Enable Dart Analysis**: `File` → `Settings` → `Languages & Frameworks` → `Dart` → Enable analysis
- **Use Flutter Inspector**: Available in IntelliJ for debugging UI
- **Hot Reload**: Use `Ctrl + S` (Windows/Linux) or `Cmd + S` (macOS) for quick iterations

## 📚 Additional Resources

- [Flutter Documentation](https://flutter.dev/docs)
- [Dart Language Tour](https://dart.dev/guides/language/language-tour)
- [IntelliJ IDEA Documentation](https://www.jetbrains.com/help/idea/)
- [Flutter Widget Catalog](https://flutter.dev/docs/development/ui/widgets)

## 🤝 Contributing

1. Fork the repository
2. Create a feature branch: `git checkout -b feature/your-feature-name`
3. Commit your changes: `git commit -m 'Add some feature'`
4. Push to the branch: `git push origin feature/your-feature-name`
5. Submit a pull request

## 📄 License

This project is licensed under the MIT License - see the LICENSE file for details.

---

**Happy Flutter Development! 🎉**