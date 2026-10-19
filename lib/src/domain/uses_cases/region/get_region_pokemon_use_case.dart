import 'package:equatable/equatable.dart';

import '../../../core/extensions/base/use_case.dart';
import '../../../core/resources/data_state.dart';
import '../../mappers/pokemon/pokedex_mapper.dart';
import '../../mappers/region/region_mapper.dart';
import '../../mappers/resource_id.dart';
import '../../model/data/pokemon/pokemon.dart';
import '../../repository/region/region_repository.dart';

const regionWithoutPokedexError = 'region_without_pokedex';

/// Región → primera pokédex → entradas de pokémon.
/// Migrado de `ViewModelRegion.obtenerPokedex` / `obtenerPokemon`.
class GetRegionPokemonUseCase
    implements UseCase<DataState<RegionPokedex>, RegionParams> {
  GetRegionPokemonUseCase(this._repository, {required this.artworkBaseUrl});

  final RegionRepository _repository;
  final String artworkBaseUrl;

  @override
  Future<DataState<RegionPokedex>> call(RegionParams params) async {
    final regionResult = await _repository.getRegion(params.regionId);
    if (regionResult is! DataSuccess) {
      return DataError(error: regionResult.error ?? 'Unknown error');
    }
    final region = regionResult.data!;
    final pokedexes = region.pokedexes ?? [];
    if (pokedexes.isEmpty) {
      return const DataError(error: regionWithoutPokedexError);
    }

    final pokedexResult =
        await _repository.getPokedex(resourceIdFromUrl(pokedexes.first.url));
    if (pokedexResult is! DataSuccess) {
      return DataError(error: pokedexResult.error ?? 'Unknown error');
    }
    final pokemon =
        PokedexMapper(artworkBaseUrl: artworkBaseUrl).call(pokedexResult.data!);
    if (pokemon.isEmpty) {
      return const DataError(error: regionWithoutPokedexError);
    }

    return DataSuccess(
      data: RegionPokedex(
        region: RegionMapper().call(region),
        pokemon: pokemon,
      ),
    );
  }
}

class RegionParams extends Equatable {
  const RegionParams({required this.regionId});

  final int regionId;

  @override
  List<Object> get props => [regionId];
}
