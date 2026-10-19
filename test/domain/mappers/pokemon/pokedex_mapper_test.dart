import 'package:flutter_test/flutter_test.dart';
import 'package:poke_app/src/data/remote/dto/pokemon/pokemon_dto.dart';
import 'package:poke_app/src/data/remote/dto/pokemon/pokemon_species_dto.dart';
import 'package:poke_app/src/data/remote/dto/region/named_resource_dto.dart';
import 'package:poke_app/src/domain/mappers/pokemon/pokedex_mapper.dart';
import 'package:poke_app/src/domain/mappers/pokemon/pokemon_detail_mapper.dart';
import 'package:poke_app/src/domain/model/data/pokemon/pokemon_detail.dart';

import '../../../helpers/fixtures.dart';

void main() {
  test('PokedexMapper usa el id de species para la imagen', () {
    final result = PokedexMapper(artworkBaseUrl: tArtworkUrl).call(tPokedexDto);

    expect(result, hasLength(2));
    expect(result.last.id, 25);
    expect(result.last.entryNumber, 25);
    expect(result.last.displayName, 'Pikachu');
    expect(result.last.imageUrl, '${tArtworkUrl}25.png');
  });

  group('PokemonDetailMapper', () {
    const pokemon = PokemonDto(
      id: 6,
      name: 'charizard',
      height: 17,
      weight: 905,
      types: [
        PokemonTypeSlotDto(slot: 2, type: NamedResourceDto(name: 'flying')),
        PokemonTypeSlotDto(slot: 1, type: NamedResourceDto(name: 'fire')),
      ],
      stats: [
        PokemonStatDto(baseStat: 78, stat: NamedResourceDto(name: 'hp')),
      ],
      sprites: SpritesDto(
        frontDefault: 'front.png',
        other: OtherSpritesDto(
          officialArtwork: ArtworkDto(frontDefault: 'art.png'),
        ),
      ),
    );

    test('ordena tipos por slot, convierte unidades y prefiere artwork', () {
      final result = PokemonDetailMapper().call(pokemon, null);

      expect(result.name, 'Charizard');
      expect(result.types, ['fire', 'flying']);
      expect(result.heightMeters, 1.7);
      expect(result.weightKg, 90.5);
      expect(result.imageUrl, 'art.png');
      expect(result.stats, const [PokemonStat(name: 'hp', value: 78)]);
      expect(result.description, isEmpty);
    });

    test('elige descripción en español y limpia saltos de línea', () {
      const species = PokemonSpeciesDto(
        flavorTextEntries: [
          FlavorTextDto(
            flavorText: 'English text',
            language: NamedResourceDto(name: 'en'),
          ),
          FlavorTextDto(
            flavorText: 'Escupe\nfuego\fabrasador.',
            language: NamedResourceDto(name: 'es'),
          ),
        ],
      );

      final result = PokemonDetailMapper().call(pokemon, species);

      expect(result.description, 'Escupe fuego abrasador.');
    });

    test('usa inglés si no hay español', () {
      const species = PokemonSpeciesDto(
        flavorTextEntries: [
          FlavorTextDto(
            flavorText: 'English text',
            language: NamedResourceDto(name: 'en'),
          ),
        ],
      );

      expect(
        PokemonDetailMapper().call(pokemon, species).description,
        'English text',
      );
    });
  });
}
