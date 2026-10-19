import 'package:freezed_annotation/freezed_annotation.dart';

import '../region/region.dart';

part 'pokemon.freezed.dart';
part 'pokemon.g.dart';

@freezed
abstract class Pokemon with _$Pokemon {
  const factory Pokemon({
    required int id,
    required int entryNumber,
    required String name,
    required String displayName,
    required String imageUrl,
  }) = _Pokemon;

  factory Pokemon.fromJson(Map<String, dynamic> json) =>
      _$PokemonFromJson(json);
}

@freezed
abstract class RegionPokedex with _$RegionPokedex {
  const factory RegionPokedex({
    required Region region,
    required List<Pokemon> pokemon,
  }) = _RegionPokedex;
}
