import 'package:collection/collection.dart';
import 'package:design_system/design_system.dart';

import '../../../data/remote/dto/pokemon/pokemon_dto.dart';
import '../../../data/remote/dto/pokemon/pokemon_species_dto.dart';
import '../../model/data/pokemon/pokemon_detail.dart';

/// Combina `pokemon/{id}` + `pokemon-species/{id}` en [PokemonDetail].
class PokemonDetailMapper {
  PokemonDetailMapper({this.languages = const ['es', 'en']});

  /// Idiomas preferidos para la descripción, en orden de prioridad.
  final List<String> languages;

  PokemonDetail call(PokemonDto pokemon, PokemonSpeciesDto? species) {
    final types = [...pokemon.types.orEmptyList]
      ..sort((a, b) => a.slot.orIntZero.compareTo(b.slot.orIntZero));
    final artwork =
        pokemon.sprites?.other?.officialArtwork?.frontDefault.orEmptyString ??
            '';

    return PokemonDetail(
      id: pokemon.id.orIntZero,
      name: pokemon.name.orEmptyString.capitalize,
      imageUrl: artwork.isNotEmpty
          ? artwork
          : pokemon.sprites?.frontDefault.orEmptyString ?? '',
      heightMeters: pokemon.height.orIntZero / 10,
      weightKg: pokemon.weight.orIntZero / 10,
      types: types
          .map((slot) => slot.type?.name.orEmptyString ?? '')
          .where((type) => type.isNotEmpty)
          .toList(),
      stats: pokemon.stats.orEmptyList
          .map((stat) => PokemonStat(
                name: stat.stat?.name.orEmptyString ?? '',
                value: stat.baseStat.orIntZero,
              ))
          .toList(),
      description: _description(species),
    );
  }

  String _description(PokemonSpeciesDto? species) {
    final entries = species?.flavorTextEntries.orEmptyList ?? [];
    for (final language in languages) {
      final entry = entries.firstWhereOrNull(
        (e) => e.language?.name == language,
      );
      if (entry != null) return entry.flavorText.orEmptyString.cleanFlavorText;
    }
    return '';
  }
}
