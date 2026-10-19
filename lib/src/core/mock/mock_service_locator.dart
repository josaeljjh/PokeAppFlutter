import '../../data/remote/api/remote/auth/auth_data_source.dart';
import '../../data/remote/api/remote/pokemon/pokemon_data_source.dart';
import '../di/service_locator.dart';
import '../tools/connection_info.dart';
import 'data_sources/auth_mock_data_source.dart';
import 'data_sources/pokemon_mock_data_source.dart';
import 'mock_connection_info.dart';

/// DI para modo mock. Sustituye data sources remotos (PokeAPI, Firebase)
/// por implementaciones locales. No requiere red ni credenciales.
/// Los equipos siguen guardándose en sqflite.
Future<void> initMock() async {
  if (!sl.isRegistered<ConnectionInfo>()) {
    sl.registerLazySingleton<ConnectionInfo>(() => MockConnectionInfo());
  }

  await initInfrastructure();

  // ── Data Sources (mock) ───────────────────────────────────────────────────
  if (!sl.isRegistered<PokemonDataSource>()) {
    sl.registerLazySingleton<PokemonDataSource>(() => PokemonMockDataSource());
  }
  if (!sl.isRegistered<AuthDataSource>()) {
    sl.registerLazySingleton<AuthDataSource>(() => AuthMockDataSource());
  }

  registerAppDependencies();
}
