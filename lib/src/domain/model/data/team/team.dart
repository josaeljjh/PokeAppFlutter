import 'package:freezed_annotation/freezed_annotation.dart';

import '../pokemon/pokemon.dart';

part 'team.freezed.dart';

@freezed
abstract class Team with _$Team {
  const factory Team({
    int? id,
    required String name,
    required String region,
    required List<Pokemon> pokemon,
    required DateTime createdAt,
  }) = _Team;
}
