import 'package:freezed_annotation/freezed_annotation.dart';

part 'pokemon_detail.freezed.dart';

@freezed
abstract class PokemonDetail with _$PokemonDetail {
  const factory PokemonDetail({
    required int id,
    required String name,
    required String imageUrl,
    @Default(0) double heightMeters,
    @Default(0) double weightKg,
    @Default([]) List<String> types,
    @Default([]) List<PokemonStat> stats,
    @Default('') String description,
  }) = _PokemonDetail;
}

@freezed
abstract class PokemonStat with _$PokemonStat {
  const factory PokemonStat({
    required String name,
    required int value,
  }) = _PokemonStat;
}
