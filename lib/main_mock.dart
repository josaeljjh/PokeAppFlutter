import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'src/config/constants/env_constant.dart';
import 'src/core/mock/mock_service_locator.dart';
import 'src/ui/app.dart';

/// Punto de entrada con datos locales (sin red, sin Firebase).
///
/// Lanzar con:
///   flutter run -t lib/main_mock.dart
///
/// Los datos hardcodeados están en `lib/src/core/mock/data/`.
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  EnvConstants.setup(flavorName: EnvConstants.development);
  EnvConstants.showingHttpsLog(false);

  await SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);

  await initMock();

  runApp(const App());
}
