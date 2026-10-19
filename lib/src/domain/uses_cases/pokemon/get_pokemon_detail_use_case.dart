import 'package:equatable/equatable.dart';

import '../../../core/extensions/base/use_case.dart';
import '../../../core/resources/data_state.dart';
import '../../mappers/pokemon/pokemon_detail_mapper.dart';
import '../../model/data/pokemon/pokemon_detail.dart';
import '../../repository/pokemon/pokemon_repository.dart';

class GetPokemonDetailUseCase
    implements UseCase<DataState<PokemonDetail>, PokemonParams> {
  GetPokemonDetailUseCase(this._repository);

  final PokemonRepository _repository;

  @override
  Future<DataState<PokemonDetail>> call(PokemonParams params) async {
    final (pokemon, species) = await (
      _repository.getPokemon(params.id),
      _repository.getPokemonSpecies(params.id),
    ).wait;

    if (pokemon is! DataSuccess) {
      return DataError(error: pokemon.error ?? 'Unknown error');
    }
    // La descripción es opcional: si species falla se muestra el resto.
    return DataSuccess(
      data: PokemonDetailMapper().call(
        pokemon.data!,
        species is DataSuccess ? species.data : null,
      ),
    );
  }
}

class PokemonParams extends Equatable {
  const PokemonParams({required this.id});

  final int id;

  @override
  List<Object> get props => [id];
}
