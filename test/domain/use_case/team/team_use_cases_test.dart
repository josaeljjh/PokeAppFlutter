import 'package:poke_app/src/core/extensions/base/use_case.dart';
import 'package:poke_app/src/core/resources/data_state.dart';
import 'package:poke_app/src/data/local/entity/team_entity.dart';
import 'package:poke_app/src/domain/mappers/team/team_mapper.dart';
import 'package:poke_app/src/domain/repository/team/team_repository.dart';
import 'package:poke_app/src/domain/uses_cases/team/delete_team_use_case.dart';
import 'package:poke_app/src/domain/uses_cases/team/get_teams_use_case.dart';
import 'package:poke_app/src/domain/uses_cases/team/rename_team_use_case.dart';
import 'package:poke_app/src/domain/uses_cases/team/save_team_use_case.dart';

import '../../../helpers/fixtures.dart';
import '../../../helpers/test_helpers.dart';

class MockTeamRepository extends Mock implements TeamRepository {}

void main() {
  late MockTeamRepository repository;

  setUpAll(() {
    registerFallbackValue(TeamToEntityMapper().call(tTeam()));
  });

  setUp(() => repository = MockTeamRepository());

  group('SaveTeamUseCase', () {
    test('guarda equipos de 3 a 6 y devuelve el id asignado', () async {
      when(() => repository.saveTeam(any())).thenAnswer((_) async => 42);

      final result = await SaveTeamUseCase(repository)
          .call(tTeam(id: null, name: '  Kanto  ', size: 6));

      expect(result.data!.id, 42);
      expect(result.data!.name, 'Kanto');
      final saved = verify(() => repository.saveTeam(captureAny()))
          .captured
          .single as TeamEntity;
      expect(saved.name, 'Kanto');
    });

    test('rechaza menos de 3 pokémon', () async {
      final result = await SaveTeamUseCase(repository).call(tTeam(size: 2));

      expect(result.error, invalidTeamSizeError);
      verifyNever(() => repository.saveTeam(any()));
    });

    test('rechaza más de 6 pokémon', () async {
      final result = await SaveTeamUseCase(repository).call(tTeam(size: 7));

      expect(result.error, invalidTeamSizeError);
    });

    test('rechaza nombre vacío', () async {
      final result = await SaveTeamUseCase(repository).call(tTeam(name: '   '));

      expect(result.error, emptyTeamNameError);
    });
  });

  test('GetTeamsUseCase mapea entidades', () async {
    when(() => repository.getTeams()).thenAnswer(
      (_) async => [TeamToEntityMapper().call(tTeam())],
    );

    final result = await GetTeamsUseCase(repository).call(NoParams());

    expect(result.data, [tTeam()]);
  });

  test('GetTeamsUseCase convierte excepciones en DataError', () async {
    when(() => repository.getTeams()).thenThrow(Exception('db'));

    final result = await GetTeamsUseCase(repository).call(NoParams());

    expect(result, isA<DataError>());
  });

  test('RenameTeamUseCase valida y recorta el nombre', () async {
    when(() => repository.renameTeam(1, 'Nuevo')).thenAnswer((_) async {});

    final ok = await RenameTeamUseCase(repository)
        .call(const RenameParams(id: 1, name: ' Nuevo '));
    final empty = await RenameTeamUseCase(repository)
        .call(const RenameParams(id: 1, name: ''));

    expect(ok.data, isTrue);
    expect(empty.error, emptyTeamNameError);
    verify(() => repository.renameTeam(1, 'Nuevo')).called(1);
  });

  test('DeleteTeamUseCase elimina por id', () async {
    when(() => repository.deleteTeam(3)).thenAnswer((_) async {});

    final result = await DeleteTeamUseCase(repository).call(3);

    expect(result.data, isTrue);
  });
}
