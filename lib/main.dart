import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'src/config/constants/env_constant.dart';
import 'src/core/config/firebase_initializer.dart';
import 'src/core/di/service_locator.dart';
import 'src/ui/app.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  EnvConstants.setup(flavorName: EnvConstants.production);
  EnvConstants.showingHttpsLog(false);

  await initFirebase();

  await SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);

  await init();

  runApp(const App());
}
