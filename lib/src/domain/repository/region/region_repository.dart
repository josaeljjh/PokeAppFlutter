import '../../../core/resources/data_state.dart';
import '../../../data/remote/dto/pokedex/pokedex_dto.dart';
import '../../../data/remote/dto/region/region_dto.dart';

abstract class RegionRepository {
  Future<DataState<RegionListDto>> getRegions();

  Future<DataState<RegionDto>> getRegion(int id);

  Future<DataState<PokedexDto>> getPokedex(int id);
}
