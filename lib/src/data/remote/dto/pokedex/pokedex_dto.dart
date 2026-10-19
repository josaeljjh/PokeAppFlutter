import 'package:freezed_annotation/freezed_annotation.dart';

import '../region/named_resource_dto.dart';

part 'pokedex_dto.freezed.dart';
part 'pokedex_dto.g.dart';

/// `GET pokedex/{id}/`
@freezed
abstract class PokedexDto with _$PokedexDto {
  const factory PokedexDto({
    @Default(0) int? id,
    @Default('') String? name,
    @Default([]) List<PokemonEntryDto>? pokemonEntries,
  }) = _PokedexDto;

  factory PokedexDto.fromJson(Map<String, dynamic> json) =>
      _$PokedexDtoFromJson(json);
}

@freezed
abstract class PokemonEntryDto with _$PokemonEntryDto {
  const factory PokemonEntryDto({
    @Default(0) int? entryNumber,
    NamedResourceDto? pokemonSpecies,
  }) = _PokemonEntryDto;

  factory PokemonEntryDto.fromJson(Map<String, dynamic> json) =>
      _$PokemonEntryDtoFromJson(json);
}
