import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/extensions/base/use_case.dart';
import '../../../../core/resources/data_state.dart';
import '../../../../domain/model/data/team/team.dart';
import '../../../../domain/model/ui/team_ui_state.dart';
import '../../../../domain/uses_cases/team/delete_team_use_case.dart';
import '../../../../domain/uses_cases/team/get_teams_use_case.dart';
import '../../../../domain/uses_cases/team/rename_team_use_case.dart';

class TeamCubit extends Cubit<TeamUiState> {
  TeamCubit({
    required this.getTeamsUseCase,
    required this.renameTeamUseCase,
    required this.deleteTeamUseCase,
  }) : super(const TeamUiState());

  final GetTeamsUseCase getTeamsUseCase;
  final RenameTeamUseCase renameTeamUseCase;
  final DeleteTeamUseCase deleteTeamUseCase;

  Future<void> loadTeams() async {
    emit(state.copyWith(isLoading: true, isError: false, errorCode: null));
    final result = await getTeamsUseCase.call(NoParams());
    if (result is DataSuccess) {
      emit(state.copyWith(isLoading: false, teams: result.data!));
    } else {
      emit(state.copyWith(
        isLoading: false,
        isError: true,
        errorCode: result.error,
      ));
    }
  }

  Future<void> rename(Team team, String name) async {
    if (team.id == null) return;
    final result =
        await renameTeamUseCase.call(RenameParams(id: team.id!, name: name));
    if (result is DataSuccess) {
      emit(state.copyWith(
        teams: [
          for (final t in state.teams)
            t.id == team.id ? t.copyWith(name: name.trim()) : t,
        ],
      ));
    } else {
      emit(state.copyWith(errorCode: result.error));
    }
  }

  Future<void> delete(Team team) async {
    if (team.id == null) return;
    final result = await deleteTeamUseCase.call(team.id!);
    if (result is DataSuccess) {
      emit(state.copyWith(
        teams: state.teams.where((t) => t.id != team.id).toList(),
      ));
    } else {
      emit(state.copyWith(errorCode: result.error));
    }
  }

  void clearError() => emit(state.copyWith(errorCode: null));
}
