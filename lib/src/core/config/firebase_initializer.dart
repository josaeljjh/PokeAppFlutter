import 'package:design_system/design_system.dart';
import 'package:firebase_core/firebase_core.dart';

/// Inicializa Firebase con `google-services.json` (Android) /
/// `GoogleService-Info.plist` (iOS). Si falta la configuración la app sigue
/// funcionando y el login devuelve `firebase_not_configured`.
Future<void> initFirebase() async {
  try {
    await Firebase.initializeApp();
  } catch (e) {
    'Firebase no inicializado: $e'.logE();
  }
}
