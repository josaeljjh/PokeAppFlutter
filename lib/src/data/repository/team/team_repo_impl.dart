import '../../../domain/repository/team/team_repository.dart';
import '../../local/dao/team_dao.dart';
import '../../local/entity/team_entity.dart';

class TeamRepositoryImpl implements TeamRepository {
  TeamRepositoryImpl(this.dao);

  final TeamDao dao;

  @override
  Future<List<TeamEntity>> getTeams() => dao.findAll();

  @override
  Future<int> saveTeam(TeamEntity team) => dao.insert(team);

  @override
  Future<void> renameTeam(int id, String name) => dao.rename(id, name);

  @override
  Future<void> deleteTeam(int id) => dao.deleteById(id);
}
