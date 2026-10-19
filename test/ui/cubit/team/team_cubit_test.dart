import 'package:poke_app/src/core/extensions/base/use_case.dart';
import 'package:poke_app/src/core/resources/data_state.dart';
import 'package:poke_app/src/domain/model/ui/team_ui_state.dart';
import 'package:poke_app/src/domain/uses_cases/team/delete_team_use_case.dart';
import 'package:poke_app/src/domain/uses_cases/team/get_teams_use_case.dart';
import 'package:poke_app/src/domain/uses_cases/team/rename_team_use_case.dart';
import 'package:poke_app/src/ui/features/team/cubit/team_cubit.dart';

import '../../../helpers/fixtures.dart';
import '../../../helpers/test_helpers.dart';

class MockGetTeamsUseCase extends Mock implements GetTeamsUseCase {}

class MockRenameTeamUseCase extends Mock implements RenameTeamUseCase {}

class MockDeleteTeamUseCase extends Mock implements DeleteTeamUseCase {}

void main() {
  late MockGetTeamsUseCase getTeams;
  late MockRenameTeamUseCase renameTeam;
  late MockDeleteTeamUseCase deleteTeam;

  final team1 = tTeam(id: 1, name: 'Uno');
  final team2 = tTeam(id: 2, name: 'Dos');

  setUpAll(() {
    registerFallbackValue(NoParams());
    registerFallbackValue(const RenameParams(id: 0, name: ''));
  });

  setUp(() {
    getTeams = MockGetTeamsUseCase();
    renameTeam = MockRenameTeamUseCase();
    deleteTeam = MockDeleteTeamUseCase();
  });

  TeamCubit build() => TeamCubit(
        getTeamsUseCase: getTeams,
        renameTeamUseCase: renameTeam,
        deleteTeamUseCase: deleteTeam,
      );

  blocTest<TeamCubit, TeamUiState>(
    'loadTeams emite [loading] → [teams]',
    build: () {
      when(() => getTeams.call(any()))
          .thenAnswer((_) async => DataSuccess(data: [team1, team2]));
      return build();
    },
    act: (cubit) => cubit.loadTeams(),
    expect: () => [
      const TeamUiState(isLoading: true),
      TeamUiState(teams: [team1, team2]),
    ],
  );

  blocTest<TeamCubit, TeamUiState>(
    'rename actualiza el nombre en la lista',
    build: () {
      when(() => renameTeam.call(any()))
          .thenAnswer((_) async => const DataSuccess(data: true));
      return build();
    },
    seed: () => TeamUiState(teams: [team1, team2]),
    act: (cubit) => cubit.rename(team1, ' Nuevo '),
    expect: () => [
      TeamUiState(teams: [team1.copyWith(name: 'Nuevo'), team2]),
    ],
  );

  blocTest<TeamCubit, TeamUiState>(
    'delete quita el equipo de la lista',
    build: () {
      when(() => deleteTeam.call(1))
          .thenAnswer((_) async => const DataSuccess(data: true));
      return build();
    },
    seed: () => TeamUiState(teams: [team1, team2]),
    act: (cubit) => cubit.delete(team1),
    expect: () => [
      TeamUiState(teams: [team2]),
    ],
  );

  blocTest<TeamCubit, TeamUiState>(
    'delete con error emite errorCode y conserva la lista',
    build: () {
      when(() => deleteTeam.call(1))
          .thenAnswer((_) async => const DataError(error: 'db'));
      return build();
    },
    seed: () => TeamUiState(teams: [team1]),
    act: (cubit) => cubit.delete(team1),
    expect: () => [
      TeamUiState(teams: [team1], errorCode: 'db'),
    ],
  );
}
