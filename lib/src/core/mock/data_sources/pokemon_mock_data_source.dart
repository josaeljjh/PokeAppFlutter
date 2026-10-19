import '../../../data/remote/api/remote/pokemon/pokemon_data_source.dart';
import '../../../data/remote/dto/pokedex/pokedex_dto.dart';
import '../../../data/remote/dto/pokemon/pokemon_dto.dart';
import '../../../data/remote/dto/pokemon/pokemon_species_dto.dart';
import '../../../data/remote/dto/region/region_dto.dart';
import '../../resources/data_state.dart';
import '../data/pokemon_mock_data.dart';

class PokemonMockDataSource implements PokemonDataSource {
  static const _latency = Duration(milliseconds: 500);

  @override
  Future<DataState<RegionListDto>> getRegions() async {
    await Future<void>.delayed(_latency);
    return DataSuccess(data: regionsMockData);
  }

  @override
  Future<DataState<RegionDto>> getRegion(int id) async {
    await Future<void>.delayed(_latency);
    return DataSuccess(data: regionMockData(id));
  }

  @override
  Future<DataState<PokedexDto>> getPokedex(int id) async {
    await Future<void>.delayed(_latency);
    return DataSuccess(data: pokedexMockData(id));
  }

  @override
  Future<DataState<PokemonDto>> getPokemon(int id) async {
    await Future<void>.delayed(_latency);
    return DataSuccess(data: pokemonMockData(id));
  }

  @override
  Future<DataState<PokemonSpeciesDto>> getPokemonSpecies(int id) async {
    return DataSuccess(data: speciesMockData(id));
  }
}
