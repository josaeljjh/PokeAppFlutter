import '../../../data/local/entity/team_entity.dart';

abstract class TeamRepository {
  Future<List<TeamEntity>> getTeams();

  Future<int> saveTeam(TeamEntity team);

  Future<void> renameTeam(int id, String name);

  Future<void> deleteTeam(int id);
}
