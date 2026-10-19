import 'package:freezed_annotation/freezed_annotation.dart';

import '../region/named_resource_dto.dart';

part 'pokemon_species_dto.freezed.dart';
part 'pokemon_species_dto.g.dart';

/// `GET pokemon-species/{id}/`
@freezed
abstract class PokemonSpeciesDto with _$PokemonSpeciesDto {
  const factory PokemonSpeciesDto({
    @Default(0) int? id,
    @Default([]) List<FlavorTextDto>? flavorTextEntries,
  }) = _PokemonSpeciesDto;

  factory PokemonSpeciesDto.fromJson(Map<String, dynamic> json) =>
      _$PokemonSpeciesDtoFromJson(json);
}

@freezed
abstract class FlavorTextDto with _$FlavorTextDto {
  const factory FlavorTextDto({
    @Default('') String? flavorText,
    NamedResourceDto? language,
  }) = _FlavorTextDto;

  factory FlavorTextDto.fromJson(Map<String, dynamic> json) =>
      _$FlavorTextDtoFromJson(json);
}
