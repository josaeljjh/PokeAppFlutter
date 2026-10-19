import 'package:flutter/material.dart';
import 'package:poke_app/src/core/extensions/base/use_case.dart';
import 'package:poke_app/src/domain/uses_cases/settings/theme_mode_use_cases.dart';
import 'package:poke_app/src/ui/features/theme/cubit/theme_cubit.dart';

import '../../../helpers/test_helpers.dart';

class MockGetThemeModeUseCase extends Mock implements GetThemeModeUseCase {}

class MockSaveThemeModeUseCase extends Mock implements SaveThemeModeUseCase {}

void main() {
  late MockGetThemeModeUseCase getMode;
  late MockSaveThemeModeUseCase saveMode;

  setUpAll(() {
    registerFallbackValue(NoParams());
    registerFallbackValue(ThemeMode.system);
  });

  setUp(() {
    getMode = MockGetThemeModeUseCase();
    saveMode = MockSaveThemeModeUseCase();
  });

  ThemeCubit build() => ThemeCubit(
        getThemeModeUseCase: getMode,
        saveThemeModeUseCase: saveMode,
      );

  blocTest<ThemeCubit, ThemeMode>(
    'load emite el modo guardado',
    build: () {
      when(() => getMode.call(any())).thenAnswer((_) async => ThemeMode.dark);
      return build();
    },
    act: (cubit) => cubit.load(),
    expect: () => [ThemeMode.dark],
  );

  blocTest<ThemeCubit, ThemeMode>(
    'setDarkMode emite y persiste',
    build: () {
      when(() => saveMode.call(any())).thenAnswer((_) async {});
      return build();
    },
    act: (cubit) => cubit.setDarkMode(enabled: false),
    expect: () => [ThemeMode.light],
    verify: (_) => verify(() => saveMode.call(ThemeMode.light)).called(1),
  );
}
