import 'package:poke_app/src/core/extensions/base/use_case.dart';
import 'package:poke_app/src/core/resources/data_state.dart';
import 'package:poke_app/src/domain/model/ui/region_ui_state.dart';
import 'package:poke_app/src/domain/uses_cases/region/get_region_pokemon_use_case.dart';
import 'package:poke_app/src/domain/uses_cases/region/get_regions_use_case.dart';
import 'package:poke_app/src/ui/features/region/cubit/region_cubit.dart';

import '../../../helpers/fixtures.dart';
import '../../../helpers/test_helpers.dart';

class MockGetRegionsUseCase extends Mock implements GetRegionsUseCase {}

class MockGetRegionPokemonUseCase extends Mock
    implements GetRegionPokemonUseCase {}

void main() {
  late MockGetRegionsUseCase getRegions;
  late MockGetRegionPokemonUseCase getRegionPokemon;

  setUpAll(() {
    registerFallbackValue(NoParams());
    registerFallbackValue(const RegionParams(regionId: 0));
  });

  setUp(() {
    getRegions = MockGetRegionsUseCase();
    getRegionPokemon = MockGetRegionPokemonUseCase();
  });

  RegionCubit build() => RegionCubit(
        getRegionsUseCase: getRegions,
        getRegionPokemonUseCase: getRegionPokemon,
      );

  test('estado inicial', () {
    expect(build().state, const RegionUiState());
  });

  blocTest<RegionCubit, RegionUiState>(
    'loadRegions emite [loading] → [regions]',
    build: () {
      when(() => getRegions.call(any()))
          .thenAnswer((_) async => const DataSuccess(data: [tRegion]));
      return build();
    },
    act: (cubit) => cubit.loadRegions(),
    expect: () => const [
      RegionUiState(isLoading: true),
      RegionUiState(regions: [tRegion]),
    ],
  );

  blocTest<RegionCubit, RegionUiState>(
    'loadRegions emite isError con el código',
    build: () {
      when(() => getRegions.call(any()))
          .thenAnswer((_) async => const DataError(error: 'no_internet'));
      return build();
    },
    act: (cubit) => cubit.loadRegions(),
    expect: () => const [
      RegionUiState(isLoading: true),
      RegionUiState(isError: true, errorCode: 'no_internet'),
    ],
  );

  final pokedex = tRegionPokedex();

  blocTest<RegionCubit, RegionUiState>(
    'selectRegion marca la región cargando y emite la pokédex',
    build: () {
      when(() => getRegionPokemon.call(any()))
          .thenAnswer((_) async => DataSuccess(data: pokedex));
      return build();
    },
    act: (cubit) => cubit.selectRegion(tRegion),
    expect: () => [
      const RegionUiState(loadingRegionId: 1),
      RegionUiState(selectedPokedex: pokedex),
    ],
  );

  blocTest<RegionCubit, RegionUiState>(
    'selectRegion emite errorCode sin isError (snackbar)',
    build: () {
      when(() => getRegionPokemon.call(any())).thenAnswer(
        (_) async => const DataError(error: regionWithoutPokedexError),
      );
      return build();
    },
    act: (cubit) => cubit.selectRegion(tRegion),
    expect: () => const [
      RegionUiState(loadingRegionId: 1),
      RegionUiState(errorCode: regionWithoutPokedexError),
    ],
  );

  blocTest<RegionCubit, RegionUiState>(
    'clearEvents limpia navegación y error',
    build: build,
    seed: () => RegionUiState(selectedPokedex: pokedex, errorCode: 'x'),
    act: (cubit) => cubit.clearEvents(),
    expect: () => const [RegionUiState()],
  );
}
