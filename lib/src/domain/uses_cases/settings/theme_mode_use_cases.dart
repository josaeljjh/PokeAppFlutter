import 'package:flutter/material.dart';

import '../../../core/extensions/base/use_case.dart';
import '../../repository/settings/settings_repository.dart';

class GetThemeModeUseCase implements UseCase<ThemeMode, NoParams> {
  GetThemeModeUseCase(this._repository);

  final SettingsRepository _repository;

  @override
  Future<ThemeMode> call(NoParams params) async {
    final stored = await _repository.getThemeMode();
    return ThemeMode.values.firstWhere(
      (mode) => mode.name == stored,
      orElse: () => ThemeMode.system,
    );
  }
}

class SaveThemeModeUseCase implements UseCase<void, ThemeMode> {
  SaveThemeModeUseCase(this._repository);

  final SettingsRepository _repository;

  @override
  Future<void> call(ThemeMode params) => _repository.saveThemeMode(params.name);
}
