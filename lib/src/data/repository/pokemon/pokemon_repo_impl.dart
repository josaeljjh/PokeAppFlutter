import '../../../core/resources/data_state.dart';
import '../../../domain/repository/pokemon/pokemon_repository.dart';
import '../../remote/api/remote/pokemon/pokemon_data_source.dart';
import '../../remote/dto/pokemon/pokemon_dto.dart';
import '../../remote/dto/pokemon/pokemon_species_dto.dart';

class PokemonRepositoryImpl implements PokemonRepository {
  PokemonRepositoryImpl(this.dataSource);

  final PokemonDataSource dataSource;

  @override
  Future<DataState<PokemonDto>> getPokemon(int id) => dataSource.getPokemon(id);

  @override
  Future<DataState<PokemonSpeciesDto>> getPokemonSpecies(int id) =>
      dataSource.getPokemonSpecies(id);
}
