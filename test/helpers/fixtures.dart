import 'package:poke_app/src/data/remote/dto/pokedex/pokedex_dto.dart';
import 'package:poke_app/src/data/remote/dto/region/named_resource_dto.dart';
import 'package:poke_app/src/data/remote/dto/region/region_dto.dart';
import 'package:poke_app/src/domain/model/data/pokemon/pokemon.dart';
import 'package:poke_app/src/domain/model/data/region/region.dart';
import 'package:poke_app/src/domain/model/data/team/team.dart';

const tArtworkUrl = 'https://art.test/';

const tRegion = Region(id: 1, name: 'kanto', displayName: 'Kanto');

const tRegionListDto = RegionListDto(
  count: 2,
  results: [
    NamedResourceDto(name: 'kanto', url: 'https://pokeapi.co/api/v2/region/1/'),
    NamedResourceDto(name: 'johto', url: 'https://pokeapi.co/api/v2/region/2/'),
  ],
);

const tRegionDto = RegionDto(
  id: 1,
  name: 'kanto',
  pokedexes: [
    NamedResourceDto(
        name: 'kanto', url: 'https://pokeapi.co/api/v2/pokedex/2/'),
  ],
);

const tPokedexDto = PokedexDto(
  id: 2,
  name: 'kanto',
  pokemonEntries: [
    PokemonEntryDto(
      entryNumber: 1,
      pokemonSpecies: NamedResourceDto(
        name: 'bulbasaur',
        url: 'https://pokeapi.co/api/v2/pokemon-species/1/',
      ),
    ),
    PokemonEntryDto(
      entryNumber: 25,
      pokemonSpecies: NamedResourceDto(
        name: 'pikachu',
        url: 'https://pokeapi.co/api/v2/pokemon-species/25/',
      ),
    ),
  ],
);

Pokemon tPokemon(int id) => Pokemon(
      id: id,
      entryNumber: id,
      name: 'poke$id',
      displayName: 'Poke$id',
      imageUrl: '$tArtworkUrl$id.png',
    );

RegionPokedex tRegionPokedex({int size = 8}) => RegionPokedex(
      region: tRegion,
      pokemon: List.generate(size, (i) => tPokemon(i + 1)),
    );

Team tTeam({int? id = 1, String name = 'Team', int size = 3}) => Team(
      id: id,
      name: name,
      region: 'Kanto',
      pokemon: List.generate(size, (i) => tPokemon(i + 1)),
      createdAt: DateTime(2026, 10, 19),
    );
