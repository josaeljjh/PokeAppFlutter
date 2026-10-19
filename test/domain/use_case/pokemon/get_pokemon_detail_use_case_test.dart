import 'package:poke_app/src/core/resources/data_state.dart';
import 'package:poke_app/src/data/remote/dto/pokemon/pokemon_dto.dart';
import 'package:poke_app/src/data/remote/dto/pokemon/pokemon_species_dto.dart';
import 'package:poke_app/src/data/remote/dto/region/named_resource_dto.dart';
import 'package:poke_app/src/domain/repository/pokemon/pokemon_repository.dart';
import 'package:poke_app/src/domain/uses_cases/pokemon/get_pokemon_detail_use_case.dart';

import '../../../helpers/test_helpers.dart';

class MockPokemonRepository extends Mock implements PokemonRepository {}

void main() {
  late MockPokemonRepository repository;
  late GetPokemonDetailUseCase sut;

  const pokemon = PokemonDto(id: 25, name: 'pikachu');
  const species = PokemonSpeciesDto(
    id: 25,
    flavorTextEntries: [
      FlavorTextDto(
        flavorText: 'Ratón eléctrico.',
        language: NamedResourceDto(name: 'es'),
      ),
    ],
  );

  setUp(() {
    repository = MockPokemonRepository();
    sut = GetPokemonDetailUseCase(repository);
  });

  test('combina pokemon y species', () async {
    when(() => repository.getPokemon(25))
        .thenAnswer((_) async => const DataSuccess(data: pokemon));
    when(() => repository.getPokemonSpecies(25))
        .thenAnswer((_) async => const DataSuccess(data: species));

    final result = await sut.call(const PokemonParams(id: 25));

    expect(result.data!.name, 'Pikachu');
    expect(result.data!.description, 'Ratón eléctrico.');
  });

  test('si species falla devuelve detalle sin descripción', () async {
    when(() => repository.getPokemon(25))
        .thenAnswer((_) async => const DataSuccess(data: pokemon));
    when(() => repository.getPokemonSpecies(25))
        .thenAnswer((_) async => const DataError(error: 'boom'));

    final result = await sut.call(const PokemonParams(id: 25));

    expect(result, isA<DataSuccess>());
    expect(result.data!.description, isEmpty);
  });

  test('si pokemon falla devuelve error', () async {
    when(() => repository.getPokemon(25))
        .thenAnswer((_) async => const DataError(error: 'boom'));
    when(() => repository.getPokemonSpecies(25))
        .thenAnswer((_) async => const DataSuccess(data: species));

    final result = await sut.call(const PokemonParams(id: 25));

    expect(result.error, 'boom');
  });
}
