import 'package:freezed_annotation/freezed_annotation.dart';

import '../data/team/team.dart';

part 'team_ui_state.freezed.dart';

@freezed
abstract class TeamUiState with _$TeamUiState {
  const factory TeamUiState({
    @Default(false) bool isLoading,
    @Default(false) bool isError,
    @Default([]) List<Team> teams,
    String? errorCode,
  }) = _TeamUiState;
}
