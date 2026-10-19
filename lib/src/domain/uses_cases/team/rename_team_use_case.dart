import 'package:equatable/equatable.dart';

import '../../../core/extensions/base/use_case.dart';
import '../../../core/resources/data_state.dart';
import '../../repository/team/team_repository.dart';
import 'save_team_use_case.dart';

class RenameTeamUseCase implements UseCase<DataState<bool>, RenameParams> {
  RenameTeamUseCase(this._repository);

  final TeamRepository _repository;

  @override
  Future<DataState<bool>> call(RenameParams params) async {
    final name = params.name.trim();
    if (name.isEmpty) return const DataError(error: emptyTeamNameError);
    try {
      await _repository.renameTeam(params.id, name);
      return const DataSuccess(data: true);
    } catch (e) {
      return DataError(error: e.toString());
    }
  }
}

class RenameParams extends Equatable {
  const RenameParams({required this.id, required this.name});

  final int id;
  final String name;

  @override
  List<Object> get props => [id, name];
}
