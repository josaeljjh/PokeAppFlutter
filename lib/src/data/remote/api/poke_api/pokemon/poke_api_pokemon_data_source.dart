import 'package:dio/dio.dart';

import '../../../../../core/resources/data_state.dart';
import '../../../../../core/tools/connection_info.dart';
import '../../../dto/pokedex/pokedex_dto.dart';
import '../../../dto/pokemon/pokemon_dto.dart';
import '../../../dto/pokemon/pokemon_species_dto.dart';
import '../../../dto/region/region_dto.dart';
import '../../remote/pokemon/pokemon_data_source.dart';

const noInternetError = 'no_internet';

class PokeApiPokemonDataSourceImpl implements PokemonDataSource {
  PokeApiPokemonDataSourceImpl({
    required this.dio,
    required this.connectionInfo,
  });

  final Dio dio;
  final ConnectionInfo connectionInfo;

  @override
  Future<DataState<RegionListDto>> getRegions() =>
      _get('region/', RegionListDto.fromJson, query: {'limit': 50});

  @override
  Future<DataState<RegionDto>> getRegion(int id) =>
      _get('region/$id/', RegionDto.fromJson);

  @override
  Future<DataState<PokedexDto>> getPokedex(int id) =>
      _get('pokedex/$id/', PokedexDto.fromJson);

  @override
  Future<DataState<PokemonDto>> getPokemon(int id) =>
      _get('pokemon/$id/', PokemonDto.fromJson);

  @override
  Future<DataState<PokemonSpeciesDto>> getPokemonSpecies(int id) =>
      _get('pokemon-species/$id/', PokemonSpeciesDto.fromJson);

  Future<DataState<T>> _get<T>(
    String path,
    T Function(Map<String, dynamic> json) fromJson, {
    Map<String, dynamic>? query,
  }) async {
    if (!await connectionInfo.isConnected) {
      return const DataError(error: noInternetError);
    }
    try {
      final response = await dio.get<Map<String, dynamic>>(
        path,
        queryParameters: query,
      );
      final body = response.data;
      if (body == null) {
        return const DataError(error: 'Empty response');
      }
      return DataSuccess(data: fromJson(body));
    } on DioException catch (e) {
      return DataError(error: e.message ?? e.type.name);
    } catch (e) {
      return DataError(error: e.toString());
    }
  }
}
