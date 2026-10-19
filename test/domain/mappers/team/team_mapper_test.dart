import 'package:flutter_test/flutter_test.dart';
import 'package:poke_app/src/domain/mappers/team/team_mapper.dart';

import '../../../helpers/fixtures.dart';

void main() {
  test('Team → TeamEntity → Team conserva los datos', () {
    final team = tTeam(size: 4);

    final entity = TeamToEntityMapper().call(team);
    final restored = TeamEntityMapper().call(entity);

    expect(entity.createdAt, team.createdAt.toIso8601String());
    expect(restored, team);
  });
}
