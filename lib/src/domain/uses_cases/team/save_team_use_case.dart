import '../../../core/extensions/base/use_case.dart';
import '../../../core/resources/data_state.dart';
import '../../../core/tools/const.dart';
import '../../mappers/team/team_mapper.dart';
import '../../model/data/team/team.dart';
import '../../repository/team/team_repository.dart';

const invalidTeamSizeError = 'invalid_team_size';
const emptyTeamNameError = 'empty_team_name';

class SaveTeamUseCase implements UseCase<DataState<Team>, Team> {
  SaveTeamUseCase(this._repository);

  final TeamRepository _repository;

  @override
  Future<DataState<Team>> call(Team params) async {
    final size = params.pokemon.length;
    if (size < minTeamSize || size > maxTeamSize) {
      return const DataError(error: invalidTeamSizeError);
    }
    final name = params.name.trim();
    if (name.isEmpty) {
      return const DataError(error: emptyTeamNameError);
    }
    try {
      final team = params.copyWith(name: name);
      final id = await _repository.saveTeam(TeamToEntityMapper().call(team));
      return DataSuccess(data: team.copyWith(id: id));
    } catch (e) {
      return DataError(error: e.toString());
    }
  }
}
