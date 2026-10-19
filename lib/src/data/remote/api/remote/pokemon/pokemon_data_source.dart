import '../../../../../core/resources/data_state.dart';
import '../../../dto/pokedex/pokedex_dto.dart';
import '../../../dto/pokemon/pokemon_dto.dart';
import '../../../dto/pokemon/pokemon_species_dto.dart';
import '../../../dto/region/region_dto.dart';

abstract class PokemonDataSource {
  Future<DataState<RegionListDto>> getRegions();

  Future<DataState<RegionDto>> getRegion(int id);

  Future<DataState<PokedexDto>> getPokedex(int id);

  Future<DataState<PokemonDto>> getPokemon(int id);

  Future<DataState<PokemonSpeciesDto>> getPokemonSpecies(int id);
}
