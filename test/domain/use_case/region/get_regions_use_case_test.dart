import 'package:poke_app/src/core/extensions/base/use_case.dart';
import 'package:poke_app/src/core/resources/data_state.dart';
import 'package:poke_app/src/domain/repository/region/region_repository.dart';
import 'package:poke_app/src/domain/uses_cases/region/get_regions_use_case.dart';

import '../../../helpers/fixtures.dart';
import '../../../helpers/test_helpers.dart';

class MockRegionRepository extends Mock implements RegionRepository {}

void main() {
  late MockRegionRepository repository;
  late GetRegionsUseCase sut;

  setUp(() {
    repository = MockRegionRepository();
    sut = GetRegionsUseCase(repository);
  });

  test('mapea regiones en éxito', () async {
    when(() => repository.getRegions())
        .thenAnswer((_) async => const DataSuccess(data: tRegionListDto));

    final result = await sut.call(NoParams());

    expect(result.data!.map((r) => r.displayName), ['Kanto', 'Johto']);
  });

  test('propaga el error', () async {
    when(() => repository.getRegions())
        .thenAnswer((_) async => const DataError(error: 'boom'));

    final result = await sut.call(NoParams());

    expect(result, isA<DataError>());
    expect(result.error, 'boom');
  });
}
