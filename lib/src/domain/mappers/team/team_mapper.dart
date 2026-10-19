import 'dart:convert';

import '../../../data/local/entity/team_entity.dart';
import '../../model/data/pokemon/pokemon.dart';
import '../../model/data/team/team.dart';
import '../mapper.dart';

class TeamEntityMapper extends Mapper<TeamEntity, Team> {
  @override
  Team call(TeamEntity object) {
    final raw = jsonDecode(object.pokemon) as List<dynamic>;
    return Team(
      id: object.id,
      name: object.name,
      region: object.region,
      pokemon: raw
          .map((json) => Pokemon.fromJson(json as Map<String, dynamic>))
          .toList(),
      createdAt: DateTime.tryParse(object.createdAt) ?? DateTime.now(),
    );
  }
}

class TeamToEntityMapper extends Mapper<Team, TeamEntity> {
  @override
  TeamEntity call(Team object) {
    return TeamEntity(
      id: object.id,
      name: object.name,
      region: object.region,
      pokemon: jsonEncode(object.pokemon.map((p) => p.toJson()).toList()),
      createdAt: object.createdAt.toIso8601String(),
    );
  }
}
