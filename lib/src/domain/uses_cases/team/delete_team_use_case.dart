import '../../../core/extensions/base/use_case.dart';
import '../../../core/resources/data_state.dart';
import '../../repository/team/team_repository.dart';

class DeleteTeamUseCase implements UseCase<DataState<bool>, int> {
  DeleteTeamUseCase(this._repository);

  final TeamRepository _repository;

  @override
  Future<DataState<bool>> call(int params) async {
    try {
      await _repository.deleteTeam(params);
      return const DataSuccess(data: true);
    } catch (e) {
      return DataError(error: e.toString());
    }
  }
}
