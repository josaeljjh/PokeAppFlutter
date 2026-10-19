import 'package:dio/dio.dart';
import 'package:poke_app/src/core/resources/data_state.dart';
import 'package:poke_app/src/core/tools/connection_info.dart';
import 'package:poke_app/src/data/remote/api/poke_api/pokemon/poke_api_pokemon_data_source.dart';
import 'package:poke_app/src/data/remote/dto/region/region_dto.dart';

import '../../../helpers/test_helpers.dart';

class MockDio extends Mock implements Dio {}

class MockConnectionInfo extends Mock implements ConnectionInfo {}

void main() {
  late MockDio dio;
  late MockConnectionInfo connectionInfo;
  late PokeApiPokemonDataSourceImpl sut;

  setUp(() {
    dio = MockDio();
    connectionInfo = MockConnectionInfo();
    sut =
        PokeApiPokemonDataSourceImpl(dio: dio, connectionInfo: connectionInfo);
    when(() => connectionInfo.isConnected).thenAnswer((_) async => true);
  });

  Response<Map<String, dynamic>> response(Map<String, dynamic> data) =>
      Response(data: data, requestOptions: RequestOptions(), statusCode: 200);

  test('sin conexión devuelve no_internet y no llama a la red', () async {
    when(() => connectionInfo.isConnected).thenAnswer((_) async => false);

    final result = await sut.getRegions();

    expect(result, isA<DataError<RegionListDto>>());
    expect(result.error, noInternetError);
    verifyNever(() => dio.get<Map<String, dynamic>>(any()));
  });

  test('getRegions parsea la respuesta de PokeAPI', () async {
    when(() => dio.get<Map<String, dynamic>>(
          'region/',
          queryParameters: any(named: 'queryParameters'),
        )).thenAnswer((_) async => response({
          'count': 1,
          'results': [
            {'name': 'kanto', 'url': 'https://pokeapi.co/api/v2/region/1/'},
          ],
        }));

    final result = await sut.getRegions();

    expect(result, isA<DataSuccess<RegionListDto>>());
    expect(result.data!.results!.single.name, 'kanto');
  });

  test('getPokedex parsea pokemon_entries (snake_case)', () async {
    when(() => dio.get<Map<String, dynamic>>(
          'pokedex/2/',
          queryParameters: any(named: 'queryParameters'),
        )).thenAnswer((_) async => response({
          'id': 2,
          'name': 'kanto',
          'pokemon_entries': [
            {
              'entry_number': 1,
              'pokemon_species': {
                'name': 'bulbasaur',
                'url': 'https://pokeapi.co/api/v2/pokemon-species/1/',
              },
            },
          ],
        }));

    final result = await sut.getPokedex(2);

    final entry = result.data!.pokemonEntries!.single;
    expect(entry.entryNumber, 1);
    expect(entry.pokemonSpecies!.name, 'bulbasaur');
  });

  test('getPokemon parsea official-artwork', () async {
    when(() => dio.get<Map<String, dynamic>>(
          'pokemon/25/',
          queryParameters: any(named: 'queryParameters'),
        )).thenAnswer((_) async => response({
          'id': 25,
          'name': 'pikachu',
          'sprites': {
            'front_default': 'front.png',
            'other': {
              'official-artwork': {'front_default': 'art.png'},
            },
          },
        }));

    final result = await sut.getPokemon(25);

    expect(
        result.data!.sprites!.other!.officialArtwork!.frontDefault, 'art.png');
  });

  test('DioException se convierte en DataError', () async {
    when(() => dio.get<Map<String, dynamic>>(
          any(),
          queryParameters: any(named: 'queryParameters'),
        )).thenThrow(DioException(
      requestOptions: RequestOptions(),
      message: '404',
    ));

    final result = await sut.getRegion(99);

    expect(result.error, '404');
  });
}
