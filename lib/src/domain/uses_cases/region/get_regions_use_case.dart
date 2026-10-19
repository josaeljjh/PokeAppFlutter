import '../../../core/extensions/base/use_case.dart';
import '../../../core/resources/data_state.dart';
import '../../mappers/region/region_mapper.dart';
import '../../model/data/region/region.dart';
import '../../repository/region/region_repository.dart';

class GetRegionsUseCase implements UseCase<DataState<List<Region>>, NoParams> {
  GetRegionsUseCase(this._repository);

  final RegionRepository _repository;

  @override
  Future<DataState<List<Region>>> call(NoParams params) async {
    final result = await _repository.getRegions();
    if (result is DataSuccess) {
      return DataSuccess(data: RegionListMapper().call(result.data!));
    }
    return DataError(error: result.error ?? 'Unknown error');
  }
}
