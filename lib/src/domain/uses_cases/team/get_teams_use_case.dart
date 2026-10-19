import '../../../core/extensions/base/use_case.dart';
import '../../../core/resources/data_state.dart';
import '../../mappers/team/team_mapper.dart';
import '../../model/data/team/team.dart';
import '../../repository/team/team_repository.dart';

class GetTeamsUseCase implements UseCase<DataState<List<Team>>, NoParams> {
  GetTeamsUseCase(this._repository);

  final TeamRepository _repository;

  @override
  Future<DataState<List<Team>>> call(NoParams params) async {
    try {
      final entities = await _repository.getTeams();
      final mapper = TeamEntityMapper();
      return DataSuccess(data: entities.map(mapper.call).toList());
    } catch (e) {
      return DataError(error: e.toString());
    }
  }
}
