import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive_ce_flutter/hive_flutter.dart' as hive;
import 'package:depozio/core/localization/app_localizations.dart';
import 'package:depozio/features/login/bloc/login_bloc.dart';
import 'package:depozio/core/environment.dart';
import 'package:depozio/router/app_router.dart';
import 'package:depozio/core/theme/theme.dart';
import 'package:depozio/features/deposit/data/services/category_service.dart';
import 'package:depozio/features/deposit/presentation/pages/transaction/data/services/transaction_service.dart';
import 'package:depozio/core/services/app_setting_service.dart';
import 'package:depozio/core/bloc/app_core_bloc.dart';
import 'package:form_builder_validators/form_builder_validators.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Hive CE
  await hive.Hive.initFlutter();

  // Initialize AppSettingService
  await AppSettingService.init();

  // Initialize CategoryService
  await CategoryService.init();

  // Initialize TransactionService
  await TransactionService.init();

  // Set up error handling
  FlutterError.onError = (FlutterErrorDetails details) {
    FlutterError.presentError(details);
    debugPrint('Flutter Error: ${details.exception}');
    debugPrint('Stack trace: ${details.stack}');
  };

  // Load environment variables with error handling
  try {
    await Environment.load();
  } catch (e) {
    // Log error but don't crash - app can work without env vars if needed
    debugPrint('Error loading environment: $e');
  }

  // Wrap app in error boundary
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  late final AppCoreBloc _appCoreBloc;

  @override
  void initState() {
    super.initState();
    _appCoreBloc = AppCoreBloc();
    // Load initial locale
    _appCoreBloc.add(const LoadLocale());
  }

  @override
  void dispose() {
    _appCoreBloc.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<LoginBloc>(create: (BuildContext context) => LoginBloc()),
        BlocProvider<AppCoreBloc>.value(value: _appCoreBloc),
      ],
      child: BlocBuilder<AppCoreBloc, AppCoreState>(
        bloc: _appCoreBloc,
        builder: (context, appCoreState) {
          // Extract locale from state
          Locale? locale;
          if (appCoreState is AppCoreLocaleLoaded) {
            locale = appCoreState.locale;
          }

          return MaterialApp.router(
            debugShowCheckedModeBanner: false,
            title: 'Depozio App',
            theme: CustomTheme.lightThemeData(),
            darkTheme: CustomTheme.darkThemeData(),
            themeMode: ThemeMode.dark,
            supportedLocales: AppLocalizations.supportedLocales,
            locale: locale,
            routerConfig: AppRouter.router,
            localizationsDelegates: [
              ...AppLocalizations.localizationsDelegates,
              FormBuilderLocalizations.delegate,
            ],
            builder: (context, child) {
              // Add error handling widget
              return MediaQuery(
                data: MediaQuery.of(context).copyWith(
                  textScaler: MediaQuery.of(
                    context,
                  ).textScaler.clamp(minScaleFactor: 1.0, maxScaleFactor: 1.0),
                ),
                child: child ?? const SizedBox.shrink(),
              );
            },
          );
        },
      ),
    );
  }
}
