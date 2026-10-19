import 'package:poke_app/src/core/resources/data_state.dart';
import 'package:poke_app/src/data/remote/dto/region/region_dto.dart';
import 'package:poke_app/src/domain/repository/region/region_repository.dart';
import 'package:poke_app/src/domain/uses_cases/region/get_region_pokemon_use_case.dart';

import '../../../helpers/fixtures.dart';
import '../../../helpers/test_helpers.dart';

class MockRegionRepository extends Mock implements RegionRepository {}

void main() {
  late MockRegionRepository repository;
  late GetRegionPokemonUseCase sut;

  setUp(() {
    repository = MockRegionRepository();
    sut = GetRegionPokemonUseCase(repository, artworkBaseUrl: tArtworkUrl);
  });

  test('consulta la primera pokédex de la región y mapea los pokémon',
      () async {
    when(() => repository.getRegion(1))
        .thenAnswer((_) async => const DataSuccess(data: tRegionDto));
    when(() => repository.getPokedex(2))
        .thenAnswer((_) async => const DataSuccess(data: tPokedexDto));

    final result = await sut.call(const RegionParams(regionId: 1));

    expect(result, isA<DataSuccess>());
    expect(result.data!.region, tRegion);
    expect(result.data!.pokemon.map((p) => p.name), ['bulbasaur', 'pikachu']);
    verify(() => repository.getPokedex(2)).called(1);
  });

  test('región sin pokédex devuelve region_without_pokedex', () async {
    when(() => repository.getRegion(11)).thenAnswer(
      (_) async => const DataSuccess(
          data: RegionDto(id: 11, name: 'orre', pokedexes: [])),
    );

    final result = await sut.call(const RegionParams(regionId: 11));

    expect(result.error, regionWithoutPokedexError);
    verifyNever(() => repository.getPokedex(any()));
  });

  test('propaga error de la región', () async {
    when(() => repository.getRegion(1))
        .thenAnswer((_) async => const DataError(error: 'no_internet'));

    final result = await sut.call(const RegionParams(regionId: 1));

    expect(result.error, 'no_internet');
  });

  test('propaga error de la pokédex', () async {
    when(() => repository.getRegion(1))
        .thenAnswer((_) async => const DataSuccess(data: tRegionDto));
    when(() => repository.getPokedex(2))
        .thenAnswer((_) async => const DataError(error: 'timeout'));

    final result = await sut.call(const RegionParams(regionId: 1));

    expect(result.error, 'timeout');
  });
}
