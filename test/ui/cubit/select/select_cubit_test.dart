import 'package:poke_app/src/core/resources/data_state.dart';
import 'package:poke_app/src/domain/model/data/team/team.dart';
import 'package:poke_app/src/domain/model/ui/select_ui_state.dart';
import 'package:poke_app/src/domain/uses_cases/team/save_team_use_case.dart';
import 'package:poke_app/src/ui/features/select/cubit/select_cubit.dart';

import '../../../helpers/fixtures.dart';
import '../../../helpers/test_helpers.dart';

class MockSaveTeamUseCase extends Mock implements SaveTeamUseCase {}

void main() {
  late MockSaveTeamUseCase saveTeam;
  final pokedex = tRegionPokedex();
  final now = DateTime(2026, 10, 19);

  setUpAll(() => registerFallbackValue(tTeam()));

  setUp(() => saveTeam = MockSaveTeamUseCase());

  SelectCubit build() => SelectCubit(
        pokedex: pokedex,
        saveTeamUseCase: saveTeam,
        clock: () => now,
      );

  blocTest<SelectCubit, SelectUiState>(
    'toggle agrega y quita pokémon',
    build: build,
    act: (cubit) => cubit
      ..toggle(tPokemon(1))
      ..toggle(tPokemon(2))
      ..toggle(tPokemon(1)),
    expect: () => [
      SelectUiState(pokedex: pokedex, selectedIds: const [1]),
      SelectUiState(pokedex: pokedex, selectedIds: const [1, 2]),
      SelectUiState(pokedex: pokedex, selectedIds: const [2]),
    ],
  );

  blocTest<SelectCubit, SelectUiState>(
    'no permite más de 6 pokémon',
    build: build,
    seed: () => SelectUiState(
      pokedex: pokedex,
      selectedIds: const [1, 2, 3, 4, 5, 6],
    ),
    act: (cubit) => cubit.toggle(tPokemon(7)),
    expect: () => [
      SelectUiState(
        pokedex: pokedex,
        selectedIds: const [1, 2, 3, 4, 5, 6],
        errorCode: maxTeamReachedError,
      ),
    ],
  );

  test('canSave solo entre 3 y 6', () {
    final cubit = build();
    expect(cubit.canSave, isFalse);
    cubit
      ..toggle(tPokemon(1))
      ..toggle(tPokemon(2));
    expect(cubit.canSave, isFalse);
    cubit.toggle(tPokemon(3));
    expect(cubit.canSave, isTrue);
  });

  test('visiblePokemon filtra por nombre o número', () {
    final state = SelectUiState(pokedex: pokedex, query: 'poke3');
    expect(state.visiblePokemon.map((p) => p.id), [3]);
    expect(
      state.copyWith(query: '5').visiblePokemon.map((p) => p.id),
      [5],
    );
  });

  blocTest<SelectCubit, SelectUiState>(
    'saveTeam envía los pokémon seleccionados en orden y emite savedTeam',
    build: () {
      when(() => saveTeam.call(any())).thenAnswer(
        (invocation) async => DataSuccess(
          data: (invocation.positionalArguments.first as Team).copyWith(id: 9),
        ),
      );
      return build();
    },
    seed: () => SelectUiState(pokedex: pokedex, selectedIds: const [3, 1, 2]),
    act: (cubit) => cubit.saveTeam('Mi equipo'),
    verify: (_) {
      final team =
          verify(() => saveTeam.call(captureAny())).captured.single as Team;
      expect(team.pokemon.map((p) => p.id), [3, 1, 2]);
      expect(team.region, 'Kanto');
      expect(team.createdAt, now);
    },
    expect: () => [
      SelectUiState(
        pokedex: pokedex,
        selectedIds: const [3, 1, 2],
        isSaving: true,
      ),
      isA<SelectUiState>()
          .having((s) => s.isSaving, 'isSaving', false)
          .having((s) => s.savedTeam?.id, 'savedTeam.id', 9),
    ],
  );

  blocTest<SelectCubit, SelectUiState>(
    'saveTeam emite errorCode en fallo',
    build: () {
      when(() => saveTeam.call(any()))
          .thenAnswer((_) async => const DataError(error: emptyTeamNameError));
      return build();
    },
    seed: () => SelectUiState(pokedex: pokedex, selectedIds: const [1, 2, 3]),
    act: (cubit) => cubit.saveTeam(''),
    skip: 1,
    expect: () => [
      SelectUiState(
        pokedex: pokedex,
        selectedIds: const [1, 2, 3],
        errorCode: emptyTeamNameError,
      ),
    ],
  );
}
