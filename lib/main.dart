import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:depozio/core/localization/app_localizations.dart';
import 'package:depozio/features/login/bloc/login_bloc.dart';
import 'package:depozio/core/environment.dart';
import 'package:depozio/router/app_router.dart';
import 'package:depozio/core/theme/theme.dart';
import 'package:form_builder_validators/form_builder_validators.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
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
  runApp(
    const MyApp(),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<LoginBloc>(
          create: (BuildContext context) => LoginBloc(),
        ),
      ],
      child: MaterialApp.router(
        debugShowCheckedModeBanner: false,
        title: 'Depozio App',
        theme: CustomTheme.lightThemeData(),
        darkTheme: CustomTheme.darkThemeData(),
        themeMode: ThemeMode.dark,
        supportedLocales: AppLocalizations.supportedLocales,
        // TODO: setup locale state
        // locale: state.locale,
        routerConfig: AppRouter.router,
        localizationsDelegates: [
          ...AppLocalizations.localizationsDelegates,
          FormBuilderLocalizations.delegate,
        ],
        builder: (context, child) {
          // Add error handling widget
          return MediaQuery(
            data: MediaQuery.of(context).copyWith(textScaler: MediaQuery.of(context).textScaler.clamp(minScaleFactor: 1.0, maxScaleFactor: 1.0)),
            child: child ?? const SizedBox.shrink(),
          );
        },
      ),
    );
  }
}
