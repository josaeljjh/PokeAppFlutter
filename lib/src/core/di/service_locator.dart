import 'package:dio/dio.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:get_it/get_it.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:logarte/logarte.dart';
import 'package:share_plus/share_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../config/constants/env_constant.dart';
import '../../data/local/dao/team_dao.dart';
import '../../data/local/preferences/settings_local_data_source.dart';
import '../../data/remote/api/firebase/auth/firebase_auth_data_source.dart';
import '../../data/remote/api/poke_api/pokemon/poke_api_pokemon_data_source.dart';
import '../../data/remote/api/remote/auth/auth_data_source.dart';
import '../../data/remote/api/remote/pokemon/pokemon_data_source.dart';
import '../../data/repository/auth/auth_repo_impl.dart';
import '../../data/repository/pokemon/pokemon_repo_impl.dart';
import '../../data/repository/region/region_repo_impl.dart';
import '../../data/repository/settings/settings_repo_impl.dart';
import '../../data/repository/team/team_repo_impl.dart';
import '../../data/tools/dio_factory.dart';
import '../../domain/model/data/pokemon/pokemon.dart';
import '../../domain/repository/auth/auth_repository.dart';
import '../../domain/repository/pokemon/pokemon_repository.dart';
import '../../domain/repository/region/region_repository.dart';
import '../../domain/repository/settings/settings_repository.dart';
import '../../domain/repository/team/team_repository.dart';
import '../../domain/uses_cases/auth/get_current_user_use_case.dart';
import '../../domain/uses_cases/auth/sign_in_google_use_case.dart';
import '../../domain/uses_cases/auth/sign_out_use_case.dart';
import '../../domain/uses_cases/pokemon/get_pokemon_detail_use_case.dart';
import '../../domain/uses_cases/region/get_region_pokemon_use_case.dart';
import '../../domain/uses_cases/region/get_regions_use_case.dart';
import '../../domain/uses_cases/settings/theme_mode_use_cases.dart';
import '../../domain/uses_cases/team/delete_team_use_case.dart';
import '../../domain/uses_cases/team/get_teams_use_case.dart';
import '../../domain/uses_cases/team/rename_team_use_case.dart';
import '../../domain/uses_cases/team/save_team_use_case.dart';
import '../../ui/features/dashboard/cubit/logout_cubit.dart';
import '../../ui/features/init/cubit/splash_cubit.dart';
import '../../ui/features/login/cubit/login_cubit.dart';
import '../../ui/features/pokemon_detail/cubit/pokemon_detail_cubit.dart';
import '../../ui/features/region/cubit/region_cubit.dart';
import '../../ui/features/select/cubit/select_cubit.dart';
import '../../ui/features/team/cubit/team_cubit.dart';
import '../../ui/features/theme/cubit/theme_cubit.dart';
import '../routes/navigation_service.dart';
import '../tools/connection_info.dart';

final GetIt sl = GetIt.instance;

final Logarte logarte = Logarte(onShare: (String message) {
  Share.share(message);
});

/// DI de producción/desarrollo: PokeAPI (Dio) + Firebase Auth + sqflite.
Future<void> init() async {
  await initInfrastructure();

  // ── Data Sources ─────────────────────────────────────────────────────────
  if (!sl.isRegistered<Dio>()) {
    sl.registerLazySingleton<Dio>(
      () => getDio(EnvConstants.pokeApiUrl, logarte: logarte),
    );
  }

  if (!sl.isRegistered<PokemonDataSource>()) {
    sl.registerLazySingleton<PokemonDataSource>(
      () => PokeApiPokemonDataSourceImpl(dio: sl(), connectionInfo: sl()),
    );
  }

  if (!sl.isRegistered<AuthDataSource>()) {
    sl.registerLazySingleton<AuthDataSource>(
      () => FirebaseAuthDataSourceImpl(
        authProvider: () =>
            Firebase.apps.isEmpty ? null : FirebaseAuth.instance,
        googleSignIn: GoogleSignIn(scopes: ['email']),
      ),
    );
  }

  registerAppDependencies();
}

/// Infraestructura compartida entre modo real y mock.
Future<void> initInfrastructure() async {
  if (!sl.isRegistered<NavigationService>()) {
    sl.registerLazySingleton(() => NavigationService());
  }

  if (!sl.isRegistered<InternetConnectionChecker>()) {
    sl.registerLazySingleton(() => InternetConnectionChecker());
  }

  if (!sl.isRegistered<ConnectionInfo>()) {
    sl.registerLazySingleton<ConnectionInfo>(() => ConnectionInfoImpl(sl()));
  }

  await registerLocalDependencies();
}

/// Persistencia local: SharedPreferences (tema) y sqflite (equipos).
Future<void> registerLocalDependencies() async {
  if (!sl.isRegistered<SharedPreferences>()) {
    final preferences = await SharedPreferences.getInstance();
    sl.registerSingleton<SharedPreferences>(preferences);
  }

  if (!sl.isRegistered<SettingsLocalDataSource>()) {
    sl.registerLazySingleton<SettingsLocalDataSource>(
      () => SettingsLocalDataSourceImpl(sl()),
    );
  }

  if (!sl.isRegistered<TeamDao>()) {
    sl.registerLazySingleton<TeamDao>(() => SqfliteTeamDao());
  }
}

/// Repositorios, casos de uso y cubits. Comunes a todos los flavors:
/// solo cambian los data sources registrados antes de llamar esta función.
void registerAppDependencies() {
  // ── Repositories ──────────────────────────────────────────────────────────
  if (!sl.isRegistered<RegionRepository>()) {
    sl.registerFactory<RegionRepository>(() => RegionRepositoryImpl(sl()));
  }
  if (!sl.isRegistered<PokemonRepository>()) {
    sl.registerFactory<PokemonRepository>(() => PokemonRepositoryImpl(sl()));
  }
  if (!sl.isRegistered<TeamRepository>()) {
    sl.registerFactory<TeamRepository>(() => TeamRepositoryImpl(sl()));
  }
  if (!sl.isRegistered<AuthRepository>()) {
    sl.registerFactory<AuthRepository>(() => AuthRepositoryImpl(sl()));
  }
  if (!sl.isRegistered<SettingsRepository>()) {
    sl.registerFactory<SettingsRepository>(() => SettingsRepositoryImpl(sl()));
  }

  // ── Use Cases ─────────────────────────────────────────────────────────────
  if (!sl.isRegistered<GetRegionsUseCase>()) {
    sl.registerFactory(() => GetRegionsUseCase(sl()));
  }
  if (!sl.isRegistered<GetRegionPokemonUseCase>()) {
    sl.registerFactory(
      () => GetRegionPokemonUseCase(
        sl(),
        artworkBaseUrl: EnvConstants.artworkUrl,
      ),
    );
  }
  if (!sl.isRegistered<GetPokemonDetailUseCase>()) {
    sl.registerFactory(() => GetPokemonDetailUseCase(sl()));
  }
  if (!sl.isRegistered<GetTeamsUseCase>()) {
    sl.registerFactory(() => GetTeamsUseCase(sl()));
  }
  if (!sl.isRegistered<SaveTeamUseCase>()) {
    sl.registerFactory(() => SaveTeamUseCase(sl()));
  }
  if (!sl.isRegistered<RenameTeamUseCase>()) {
    sl.registerFactory(() => RenameTeamUseCase(sl()));
  }
  if (!sl.isRegistered<DeleteTeamUseCase>()) {
    sl.registerFactory(() => DeleteTeamUseCase(sl()));
  }
  if (!sl.isRegistered<GetCurrentUserUseCase>()) {
    sl.registerFactory(() => GetCurrentUserUseCase(sl()));
  }
  if (!sl.isRegistered<SignInGoogleUseCase>()) {
    sl.registerFactory(() => SignInGoogleUseCase(sl()));
  }
  if (!sl.isRegistered<SignOutUseCase>()) {
    sl.registerFactory(() => SignOutUseCase(sl()));
  }
  if (!sl.isRegistered<GetThemeModeUseCase>()) {
    sl.registerFactory(() => GetThemeModeUseCase(sl()));
  }
  if (!sl.isRegistered<SaveThemeModeUseCase>()) {
    sl.registerFactory(() => SaveThemeModeUseCase(sl()));
  }

  // ── ViewModels / Cubits ──────────────────────────────────────────────────
  if (!sl.isRegistered<ThemeCubit>()) {
    sl.registerFactory(
      () => ThemeCubit(
        getThemeModeUseCase: sl(),
        saveThemeModeUseCase: sl(),
      ),
    );
  }
  if (!sl.isRegistered<SplashCubit>()) {
    sl.registerFactory(() => SplashCubit(getCurrentUserUseCase: sl()));
  }
  if (!sl.isRegistered<LoginCubit>()) {
    sl.registerFactory(() => LoginCubit(signInGoogleUseCase: sl()));
  }
  if (!sl.isRegistered<LogoutCubit>()) {
    sl.registerFactory(() => LogoutCubit(signOutUseCase: sl()));
  }
  if (!sl.isRegistered<RegionCubit>()) {
    sl.registerFactory(
      () => RegionCubit(
        getRegionsUseCase: sl(),
        getRegionPokemonUseCase: sl(),
      ),
    );
  }
  if (!sl.isRegistered<SelectCubit>()) {
    sl.registerFactoryParam<SelectCubit, RegionPokedex, void>(
      (pokedex, _) => SelectCubit(pokedex: pokedex, saveTeamUseCase: sl()),
    );
  }
  if (!sl.isRegistered<PokemonDetailCubit>()) {
    sl.registerFactory(
      () => PokemonDetailCubit(getPokemonDetailUseCase: sl()),
    );
  }
  if (!sl.isRegistered<TeamCubit>()) {
    sl.registerFactory(
      () => TeamCubit(
        getTeamsUseCase: sl(),
        renameTeamUseCase: sl(),
        deleteTeamUseCase: sl(),
      ),
    );
  }
}
