import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/extensions/base/use_case.dart';
import '../../../../domain/uses_cases/settings/theme_mode_use_cases.dart';

/// Modo oscuro persistido (migrado de `AppCompatDelegate` + SharedPreferences).
class ThemeCubit extends Cubit<ThemeMode> {
  ThemeCubit({
    required this.getThemeModeUseCase,
    required this.saveThemeModeUseCase,
  }) : super(ThemeMode.system);

  final GetThemeModeUseCase getThemeModeUseCase;
  final SaveThemeModeUseCase saveThemeModeUseCase;

  Future<void> load() async {
    emit(await getThemeModeUseCase.call(NoParams()));
  }

  Future<void> setDarkMode({required bool enabled}) async {
    final mode = enabled ? ThemeMode.dark : ThemeMode.light;
    emit(mode);
    await saveThemeModeUseCase.call(mode);
  }
}
