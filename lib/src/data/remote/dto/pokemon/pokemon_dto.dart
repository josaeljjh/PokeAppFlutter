import 'package:freezed_annotation/freezed_annotation.dart';

import '../region/named_resource_dto.dart';

part 'pokemon_dto.freezed.dart';
part 'pokemon_dto.g.dart';

/// `GET pokemon/{id}/`
@freezed
abstract class PokemonDto with _$PokemonDto {
  const factory PokemonDto({
    @Default(0) int? id,
    @Default('') String? name,
    @Default(0) int? height,
    @Default(0) int? weight,
    @Default([]) List<PokemonTypeSlotDto>? types,
    @Default([]) List<PokemonStatDto>? stats,
    SpritesDto? sprites,
  }) = _PokemonDto;

  factory PokemonDto.fromJson(Map<String, dynamic> json) =>
      _$PokemonDtoFromJson(json);
}

@freezed
abstract class PokemonTypeSlotDto with _$PokemonTypeSlotDto {
  const factory PokemonTypeSlotDto({
    @Default(0) int? slot,
    NamedResourceDto? type,
  }) = _PokemonTypeSlotDto;

  factory PokemonTypeSlotDto.fromJson(Map<String, dynamic> json) =>
      _$PokemonTypeSlotDtoFromJson(json);
}

@freezed
abstract class PokemonStatDto with _$PokemonStatDto {
  const factory PokemonStatDto({
    @Default(0) int? baseStat,
    NamedResourceDto? stat,
  }) = _PokemonStatDto;

  factory PokemonStatDto.fromJson(Map<String, dynamic> json) =>
      _$PokemonStatDtoFromJson(json);
}

@freezed
abstract class SpritesDto with _$SpritesDto {
  const factory SpritesDto({
    @Default('') String? frontDefault,
    OtherSpritesDto? other,
  }) = _SpritesDto;

  factory SpritesDto.fromJson(Map<String, dynamic> json) =>
      _$SpritesDtoFromJson(json);
}

@freezed
abstract class OtherSpritesDto with _$OtherSpritesDto {
  const factory OtherSpritesDto({
    @JsonKey(name: 'official-artwork') ArtworkDto? officialArtwork,
  }) = _OtherSpritesDto;

  factory OtherSpritesDto.fromJson(Map<String, dynamic> json) =>
      _$OtherSpritesDtoFromJson(json);
}

@freezed
abstract class ArtworkDto with _$ArtworkDto {
  const factory ArtworkDto({
    @Default('') String? frontDefault,
  }) = _ArtworkDto;

  factory ArtworkDto.fromJson(Map<String, dynamic> json) =>
      _$ArtworkDtoFromJson(json);
}
