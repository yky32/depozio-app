import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sample_app/core/localization/app_localizations.dart';
import 'package:sample_app/features/login/bloc/login_bloc.dart';
import 'package:sample_app/core/environment.dart';
import 'package:sample_app/router/app_router.dart';
import 'package:sample_app/core/theme/theme.dart';
import 'package:form_builder_validators/form_builder_validators.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Environment.load();
  runApp(const MyApp());
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
        title: 'Flutter',
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
      ),
    );
  }
}
