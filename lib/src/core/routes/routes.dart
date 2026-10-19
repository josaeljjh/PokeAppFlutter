import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../../domain/model/data/pokemon/pokemon.dart';
import '../../ui/features/dashboard/dashboard_screen.dart';
import '../../ui/features/init/splash_screen.dart';
import '../../ui/features/login/login_screen.dart';
import '../../ui/features/select/select_screen.dart';

class Routes {
  static const splash = '/';
  static const login = '/login';
  static const dashboard = '/dashboard';
  static const select = '/select';

  Route<dynamic> routes(RouteSettings settings) {
    final args = settings.arguments;

    switch (settings.name) {
      case splash:
        return _createRoute(settings, SplashScreen.create);
      case login:
        return _createRoute(settings, LoginScreen.create);
      case dashboard:
        return _createRoute(settings, DashBoardScreen.create);
      case select:
        return _createRoute(
          settings,
          (context) => SelectScreen.create(context, args! as RegionPokedex),
        );
    }
    throw Exception('This route does not exist');
  }

  Route<dynamic> _createRoute(
    RouteSettings? settings,
    Widget Function(BuildContext context) predicated,
  ) {
    // `dart:io`'s `Platform` throws on web (unsupported), so platform
    // detection goes through `defaultTargetPlatform` instead, which is
    // web-safe. `kIsWeb` is checked first so web always gets the custom
    // slide transition rather than whatever native platform the browser
    // reports as the host OS.
    if (!kIsWeb && defaultTargetPlatform == TargetPlatform.iOS) {
      return MaterialPageRoute(
        builder: (context) => predicated(context),
        settings: settings,
      );
    }
    return PageRouteBuilder(
      settings: settings,
      pageBuilder: (context, animation, secondaryAnimation) =>
          predicated(context),
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        final tween = Tween(begin: const Offset(1.0, 0.0), end: Offset.zero)
            .chain(CurveTween(curve: Curves.easeOutCubic));
        return SlideTransition(
          position: animation.drive(tween),
          child: child,
        );
      },
    );
  }
}
