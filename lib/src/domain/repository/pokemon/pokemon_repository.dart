import '../../../core/resources/data_state.dart';
import '../../../data/remote/dto/pokemon/pokemon_dto.dart';
import '../../../data/remote/dto/pokemon/pokemon_species_dto.dart';

abstract class PokemonRepository {
  Future<DataState<PokemonDto>> getPokemon(int id);

  Future<DataState<PokemonSpeciesDto>> getPokemonSpecies(int id);
}
