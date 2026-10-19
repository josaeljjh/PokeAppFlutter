import '../../../data/remote/dto/pokedex/pokedex_dto.dart';
import '../../../data/remote/dto/pokemon/pokemon_dto.dart';
import '../../../data/remote/dto/pokemon/pokemon_species_dto.dart';
import '../../../data/remote/dto/region/named_resource_dto.dart';
import '../../../data/remote/dto/region/region_dto.dart';

const _api = 'https://pokeapi.co/api/v2';

const _regionNames = ['kanto', 'johto', 'hoenn', 'sinnoh', 'orre'];

/// `orre` no tiene pokédex: sirve para probar el flujo de error.
final RegionListDto regionsMockData = RegionListDto(
  count: _regionNames.length,
  results: [
    for (var i = 0; i < _regionNames.length; i++)
      NamedResourceDto(name: _regionNames[i], url: '$_api/region/${i + 1}/'),
  ],
);

RegionDto regionMockData(int id) {
  final name =
      id >= 1 && id <= _regionNames.length ? _regionNames[id - 1] : 'kanto';
  return RegionDto(
    id: id,
    name: name,
    pokedexes: name == 'orre'
        ? []
        : [NamedResourceDto(name: name, url: '$_api/pokedex/$id/')],
  );
}

const _kanto = [
  'bulbasaur',
  'ivysaur',
  'venusaur',
  'charmander',
  'charmeleon',
  'charizard',
  'squirtle',
  'wartortle',
  'blastoise',
  'caterpie',
  'metapod',
  'butterfree',
  'weedle',
  'kakuna',
  'beedrill',
  'pidgey',
  'pidgeotto',
  'pidgeot',
  'rattata',
  'raticate',
  'spearow',
  'fearow',
  'ekans',
  'arbok',
  'pikachu',
];

PokedexDto pokedexMockData(int id) => PokedexDto(
      id: id,
      name: 'kanto',
      pokemonEntries: [
        for (var i = 0; i < _kanto.length; i++)
          PokemonEntryDto(
            entryNumber: i + 1,
            pokemonSpecies: NamedResourceDto(
              name: _kanto[i],
              url: '$_api/pokemon-species/${i + 1}/',
            ),
          ),
      ],
    );

const _types = {
  1: ['grass', 'poison'],
  2: ['grass', 'poison'],
  3: ['grass', 'poison'],
  4: ['fire'],
  5: ['fire'],
  6: ['fire', 'flying'],
  7: ['water'],
  8: ['water'],
  9: ['water'],
  10: ['bug'],
  11: ['bug'],
  12: ['bug', 'flying'],
  13: ['bug', 'poison'],
  14: ['bug', 'poison'],
  15: ['bug', 'poison'],
  16: ['normal', 'flying'],
  17: ['normal', 'flying'],
  18: ['normal', 'flying'],
  19: ['normal'],
  20: ['normal'],
  21: ['normal', 'flying'],
  22: ['normal', 'flying'],
  23: ['poison'],
  24: ['poison'],
  25: ['electric'],
};

PokemonDto pokemonMockData(int id) {
  final index = (id - 1).clamp(0, _kanto.length - 1);
  return PokemonDto(
    id: id,
    name: _kanto[index],
    height: 4 + index,
    weight: 60 + index * 10,
    types: [
      for (final (slot, type) in (_types[id] ?? ['normal']).indexed)
        PokemonTypeSlotDto(
          slot: slot + 1,
          type: NamedResourceDto(name: type, url: '$_api/type/$type/'),
        ),
    ],
    stats: [
      for (final (i, stat) in const [
        'hp',
        'attack',
        'defense',
        'special-attack',
        'special-defense',
        'speed',
      ].indexed)
        PokemonStatDto(
          baseStat: 40 + ((id * 7 + i * 13) % 80),
          stat: NamedResourceDto(name: stat, url: '$_api/stat/${i + 1}/'),
        ),
    ],
    sprites: SpritesDto(
      other: OtherSpritesDto(
        officialArtwork: ArtworkDto(
          frontDefault:
              'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/other/official-artwork/$id.png',
        ),
      ),
    ),
  );
}

PokemonSpeciesDto speciesMockData(int id) => PokemonSpeciesDto(
      id: id,
      flavorTextEntries: const [
        FlavorTextDto(
          flavorText: 'Pokémon de prueba cargado desde datos mock\nlocales.',
          language: NamedResourceDto(name: 'es', url: '$_api/language/7/'),
        ),
      ],
    );
