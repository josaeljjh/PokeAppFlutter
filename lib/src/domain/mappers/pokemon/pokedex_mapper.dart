import 'package:design_system/design_system.dart';

import '../../../data/remote/dto/pokedex/pokedex_dto.dart';
import '../../model/data/pokemon/pokemon.dart';
import '../mapper.dart';
import '../resource_id.dart';

class PokemonEntryMapper extends Mapper<PokemonEntryDto, Pokemon> {
  PokemonEntryMapper({required this.artworkBaseUrl});

  final String artworkBaseUrl;

  @override
  Pokemon call(PokemonEntryDto object) {
    final id = resourceIdFromUrl(object.pokemonSpecies?.url);
    final name = object.pokemonSpecies?.name.orEmptyString ?? '';
    return Pokemon(
      id: id,
      entryNumber: object.entryNumber.orIntZero,
      name: name,
      displayName: name.capitalize,
      imageUrl: id == 0 ? '' : '$artworkBaseUrl$id.png',
    );
  }
}

class PokedexMapper extends Mapper<PokedexDto, List<Pokemon>> {
  PokedexMapper({required this.artworkBaseUrl});

  final String artworkBaseUrl;

  @override
  List<Pokemon> call(PokedexDto object) {
    final mapper = PokemonEntryMapper(artworkBaseUrl: artworkBaseUrl);
    return object.pokemonEntries.orEmptyList.map(mapper.call).toList();
  }
}
