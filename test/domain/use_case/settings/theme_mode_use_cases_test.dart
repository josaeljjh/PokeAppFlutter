import 'package:flutter/material.dart';
import 'package:poke_app/src/core/extensions/base/use_case.dart';
import 'package:poke_app/src/domain/repository/settings/settings_repository.dart';
import 'package:poke_app/src/domain/uses_cases/settings/theme_mode_use_cases.dart';

import '../../../helpers/test_helpers.dart';

class MockSettingsRepository extends Mock implements SettingsRepository {}

void main() {
  late MockSettingsRepository repository;

  setUp(() => repository = MockSettingsRepository());

  test('lee el modo guardado', () async {
    when(() => repository.getThemeMode()).thenAnswer((_) async => 'dark');

    expect(
      await GetThemeModeUseCase(repository).call(NoParams()),
      ThemeMode.dark,
    );
  });

  test('usa system si no hay valor o es inválido', () async {
    when(() => repository.getThemeMode()).thenAnswer((_) async => 'otro');

    expect(
      await GetThemeModeUseCase(repository).call(NoParams()),
      ThemeMode.system,
    );
  });

  test('guarda el nombre del modo', () async {
    when(() => repository.saveThemeMode('light')).thenAnswer((_) async {});

    await SaveThemeModeUseCase(repository).call(ThemeMode.light);

    verify(() => repository.saveThemeMode('light')).called(1);
  });
}
