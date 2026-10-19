import 'package:design_system/design_system.dart';

import '../../../data/remote/dto/region/named_resource_dto.dart';
import '../../../data/remote/dto/region/region_dto.dart';
import '../../model/data/region/region.dart';
import '../mapper.dart';
import '../resource_id.dart';

class RegionResourceMapper extends Mapper<NamedResourceDto, Region> {
  @override
  Region call(NamedResourceDto object) {
    final name = object.name.orEmptyString;
    return Region(
      id: resourceIdFromUrl(object.url),
      name: name,
      displayName: name.capitalize,
    );
  }
}

class RegionListMapper extends Mapper<RegionListDto, List<Region>> {
  @override
  List<Region> call(RegionListDto object) {
    final mapper = RegionResourceMapper();
    return object.results.orEmptyList.map(mapper.call).toList();
  }
}

class RegionMapper extends Mapper<RegionDto, Region> {
  @override
  Region call(RegionDto object) {
    final name = object.name.orEmptyString;
    return Region(
      id: object.id.orIntZero,
      name: name,
      displayName: name.capitalize,
    );
  }
}
