import 'package:device_preview/device_preview.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'src/config/constants/env_constant.dart';
import 'src/core/config/firebase_initializer.dart';
import 'src/core/di/service_locator.dart';
import 'src/ui/app.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  EnvConstants.setup(flavorName: EnvConstants.development);
  EnvConstants.showingHttpsLog(true);

  await initFirebase();

  await SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);

  await init();

  runApp(
    DevicePreview(
      enabled: false,
      tools: [...DevicePreview.defaultTools],
      builder: (context) => const App(),
    ),
  );
}
