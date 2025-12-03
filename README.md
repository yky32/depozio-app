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

## 🎨 Design Practices

### BLoC Stateless Widget Design Principle

**Core Principle:** All widget interactions should use BLoC (Business Logic Component) pattern with stateless widgets. This ensures predictable state management, testability, and maintainability across the entire application.

#### Why BLoC Stateless Design?

1. **Predictable State Management**: State changes flow through events and states, making the app behavior predictable
2. **Testability**: Business logic is separated from UI, making unit testing straightforward
3. **Reusability**: BLoC can be shared across multiple widgets
4. **Maintainability**: Clear separation of concerns between UI and business logic
5. **Performance**: Stateless widgets are more efficient and enable better Flutter optimizations
6. **Debugging**: State transitions are traceable and debuggable

#### Implementation Guidelines

**1. Always Use StatelessWidget for UI Components**

```dart
// ✅ CORRECT: Stateless widget with BLoC
class MyPage extends StatelessWidget {
  const MyPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => MyBloc()..add(LoadData()),
      child: _MyPageContent(),
    );
  }
}

// ❌ AVOID: StatefulWidget for state management
class MyPage extends StatefulWidget {
  // Don't use setState for business logic
}
```

**2. Use BlocProvider for Dependency Injection**

```dart
// Provide BLoC at the appropriate level in widget tree
BlocProvider(
  create: (context) => MyBloc()..add(InitialEvent()),
  child: MyWidget(),
)
```

**3. Use BlocBuilder for Reactive UI Updates**

```dart
BlocBuilder<MyBloc, MyState>(
  buildWhen: (previous, current) {
    // Only rebuild when specific conditions are met
    return previous.runtimeType != current.runtimeType;
  },
  builder: (context, state) {
    if (state is LoadingState) {
      return LoadingWidget();
    }
    if (state is LoadedState) {
      return ContentWidget(data: state.data);
    }
    return ErrorWidget(error: state.error);
  },
)
```

**4. Use BlocListener for Side Effects**

```dart
BlocListener<MyBloc, MyState>(
  listenWhen: (previous, current) {
    // Only listen to specific state changes
    return current is ErrorState && previous is! ErrorState;
  },
  listener: (context, state) {
    // Handle side effects (navigation, dialogs, etc.)
    if (state is ErrorState) {
      // Show error dialog
    }
  },
  child: MyWidget(),
)
```

**5. Dispatch Events Instead of Direct Method Calls**

```dart
// ✅ CORRECT: Dispatch events
onPressed: () {
  context.read<MyBloc>().add(RefreshData());
}

// ❌ AVOID: Direct method calls or setState
onPressed: () {
  setState(() {
    // Don't manage state in UI
  });
}
```

**6. State Structure Pattern**

```dart
// Standard state structure
abstract class MyState extends Equatable {
  const MyState();
}

class MyInitial extends MyState {}
class MyLoading extends MyState {}
class MyRefreshing extends MyState {
  final List<Data> existingData;
  const MyRefreshing({required this.existingData});
}
class MyLoaded extends MyState {
  final List<Data> data;
  final DateTime refreshTimestamp;
  const MyLoaded({
    required this.data,
    DateTime? refreshTimestamp,
  }) : refreshTimestamp = refreshTimestamp ?? DateTime.now();
}
class MyError extends MyState {
  final String error;
  const MyError({required this.error});
}
```

**7. Event Structure Pattern**

```dart
// Standard event structure
abstract class MyEvent extends Equatable {
  const MyEvent();
}

class LoadData extends MyEvent {
  const LoadData();
}

class RefreshData extends MyEvent {
  const RefreshData();
}
```

#### When to Use StatefulWidget

StatefulWidget should **ONLY** be used for:
- Managing UI-only state (e.g., scroll position, animation controllers, form field focus)
- Widget lifecycle management (e.g., StreamSubscription cleanup)
- Local UI interactions that don't affect business logic

```dart
// ✅ ACCEPTABLE: StatefulWidget for UI-only state
class _MyFormState extends State<MyForm> {
  final _formKey = GlobalKey<FormState>();
  final _scrollController = ScrollController();
  
  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }
  
  // UI-only state management
}
```

#### Skeleton Loading Pattern

When implementing loading states with skeleton animations:

1. **Use same widget structure** for skeleton and loaded states to prevent layout shifts
2. **Toggle Skeletonizer enabled/disabled** instead of replacing widgets
3. **Use BlocBuilder** to react to state changes (Loading → Loaded)

```dart
BlocBuilder<MyBloc, MyState>(
  builder: (context, state) {
    final isSkeletonEnabled = state is MyLoading || state is MyRefreshing;
    
    return Skeletonizer(
      enabled: isSkeletonEnabled,
      child: RefreshIndicator(
        onRefresh: () {
          context.read<MyBloc>().add(RefreshData());
        },
        child: SingleChildScrollView(
          child: _buildContent(context),
        ),
      ),
    );
  },
)
```

#### BLoC-Managed Reactive Subscriptions Pattern

When you need to watch external data sources (like Hive streams, Firebase streams, etc.) for automatic UI updates, manage subscriptions within the BLoC, not in the widget. This keeps widgets as pure StatelessWidgets.

**Key Principles:**

1. **Keep widgets as StatelessWidget** - No StatefulWidget needed for subscriptions
2. **Manage subscriptions in BLoC** - Handle `StreamSubscription` in the BLoC, not the widget
3. **Auto-refresh via streams** - Subscribe to data changes (e.g., `TransactionService.watchTransactions()`) in the BLoC constructor
4. **Automatic event dispatch** - When the stream emits, dispatch a refresh event (e.g., `RefreshHome()`) from within the BLoC
5. **Cleanup in `close()`** - Cancel subscriptions in the BLoC's `close()` method

**Implementation Pattern:**

```dart
class MyBloc extends Bloc<MyEvent, MyState> {
  StreamSubscription? _dataSubscription;

  MyBloc() : super(MyInitial()) {
    on<LoadData>(_handleLoadData);
    on<RefreshData>(_handleRefreshData);
    
    // Start watching for automatic refresh
    _startDataWatcher();
  }

  void _startDataWatcher() {
    DataService.init().then((_) {
      final service = DataService();
      _dataSubscription = service.watchData().listen((_) {
        // Data changed, automatically refresh
        LoggerUtil.d('🔄 Data changed, refreshing');
        add(const RefreshData());
      });
    });
  }

  @override
  Future<void> close() {
    _dataSubscription?.cancel();
    return super.close();
  }
}
```

**Benefits:**

- ✅ Pure StatelessWidget pattern - No StatefulWidget needed
- ✅ Centralized state management - All reactive logic in BLoC
- ✅ Automatic reactive updates - UI updates automatically when data changes
- ✅ Proper resource cleanup - Subscriptions cancelled in `close()`
- ✅ Clean separation of concerns - Widgets remain pure UI components

**Example in Codebase:**

- **HomeBloc**: `lib/features/home/presentation/bloc/home_bloc.dart` - Watches `TransactionService.watchTransactions()` and automatically refreshes recent activities when transactions change

#### Best Practices Checklist

- ✅ All pages use `StatelessWidget` with `BlocProvider`
- ✅ State management handled by BLoC, not `setState`
- ✅ UI updates through `BlocBuilder` reacting to state changes
- ✅ Side effects (navigation, dialogs) handled by `BlocListener`
- ✅ Events dispatched instead of direct method calls
- ✅ State classes extend `Equatable` for proper comparison
- ✅ `buildWhen` used to optimize rebuilds
- ✅ `listenWhen` used to optimize side effects
- ✅ Skeleton loading uses same widget structure
- ✅ Error states properly handled with retry functionality

#### Migration Guide

When converting existing StatefulWidget to BLoC pattern:

1. **Extract state management** to a BLoC
2. **Convert setState calls** to event dispatches
3. **Replace StatefulWidget** with StatelessWidget
4. **Wrap with BlocProvider** at appropriate level
5. **Use BlocBuilder** for reactive UI updates
6. **Use BlocListener** for side effects

#### Examples in Codebase

- **HomePage**: `lib/features/home/presentation/pages/home_page.dart`
- **DepositPage**: `lib/features/deposit/presentation/pages/deposit_page.dart`
- **HomeBloc**: `lib/features/home/presentation/bloc/home_bloc.dart`
- **DepositBloc**: `lib/features/deposit/presentation/bloc/deposit_bloc.dart`

### Common Reusable Widgets Naming Convention

All common reusable widgets that are shared across multiple features or used in different parts of the application should be placed in the `lib/widgets/` directory and documented with comments indicating their shared usage.

**Examples:**
- `SelectCurrencyBottomSheet` - Currency selector used across multiple features (located in `lib/widgets/bottom_sheets/`)
- `SelectCategoryBottomSheet` - Category selector used in transaction forms (located in `lib/widgets/` or feature-specific location)

**Guidelines:**
- Place common reusable widgets in `lib/widgets/` directory
- Add documentation comments indicating the widget is shared/common
- Use clear, descriptive names without special prefixes
- Feature-specific widgets should be placed in their respective feature directories

**When a widget is considered "common/reusable":**
- ✅ Widget is located in `lib/widgets/` (shared widgets directory)
- ✅ Widget is used in 2+ different features or unrelated parts of the app
- ✅ Widget provides generic functionality that can be reused
- ✅ Widget has documentation indicating it's a shared component

**When a widget is feature-specific:**
- ❌ Widget is only used within one feature (place in feature directory)
- ❌ Widget is a private implementation detail (use single `_` for private, library-scoped)
- ❌ Widget is a one-off component with no reuse potential

**Note:** Dart's privacy rules mean that `_` prefix makes classes library-private (only accessible within the same file). For cross-file reusable widgets, use public class names without special prefixes and rely on directory structure and documentation to indicate their shared nature.

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