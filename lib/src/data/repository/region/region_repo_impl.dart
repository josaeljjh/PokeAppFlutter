import '../../../core/resources/data_state.dart';
import '../../../domain/repository/region/region_repository.dart';
import '../../remote/api/remote/pokemon/pokemon_data_source.dart';
import '../../remote/dto/pokedex/pokedex_dto.dart';
import '../../remote/dto/region/region_dto.dart';

class RegionRepositoryImpl implements RegionRepository {
  RegionRepositoryImpl(this.dataSource);

  final PokemonDataSource dataSource;

  @override
  Future<DataState<RegionListDto>> getRegions() => dataSource.getRegions();

  @override
  Future<DataState<RegionDto>> getRegion(int id) => dataSource.getRegion(id);

  @override
  Future<DataState<PokedexDto>> getPokedex(int id) => dataSource.getPokedex(id);
}
