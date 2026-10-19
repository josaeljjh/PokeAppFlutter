import 'package:design_system/design_system.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:localization/localization.dart';
import 'package:logarte/logarte.dart';
import 'package:responsive_framework/responsive_framework.dart';

import '../core/di/service_locator.dart';
import '../core/routes/navigation_service.dart';
import '../core/routes/routes.dart';
import 'features/theme/cubit/theme_cubit.dart';
import 'tools/utils.dart';

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    final navigator = sl.get<NavigationService>();
    LocalJsonLocalization.delegate.directories = ['res/i18n'];
    return BlocProvider<ThemeCubit>(
      create: (_) => sl.get<ThemeCubit>()..load(),
      child: BlocBuilder<ThemeCubit, ThemeMode>(
        builder: (context, themeMode) {
          return MaterialApp(
            title: 'PokeApp',
            debugShowCheckedModeBanner: kDebugMode,
            onGenerateRoute: (settings) => Routes().routes(settings),
            navigatorKey: navigator.navigatorKey,
            builder: (context, widget) {
              changeNotificationBarColorIcon(
                isLight: Theme.of(context).brightness == Brightness.dark,
              );
              return ResponsiveBreakpoints.builder(
                child: widget!,
                breakpoints: [
                  const Breakpoint(start: 0, end: 450, name: MOBILE),
                  const Breakpoint(start: 451, end: 800, name: TABLET),
                  const Breakpoint(start: 801, end: 1920, name: DESKTOP),
                  const Breakpoint(
                    start: 1921,
                    end: double.infinity,
                    name: '4K',
                  ),
                ],
              );
            },
            localeResolutionCallback: (locale, supportedLocales) {
              if (locale?.languageCode == 'en') {
                return const Locale('en', 'US');
              }
              return const Locale('es', 'ES');
            },
            localizationsDelegates: [
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
              LocalJsonLocalization.delegate,
            ],
            supportedLocales: const [
              Locale('es', 'ES'),
              Locale('en', 'US'),
            ],
            theme: DSTheme.lightTheme,
            darkTheme: DSTheme.darkTheme,
            themeMode: themeMode,
            navigatorObservers: [LogarteNavigatorObserver(logarte)],
          );
        },
      ),
    );
  }
}
