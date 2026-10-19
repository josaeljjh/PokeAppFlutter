import 'package:flutter_test/flutter_test.dart';
import 'package:poke_app/src/domain/mappers/region/region_mapper.dart';
import 'package:poke_app/src/domain/mappers/resource_id.dart';
import 'package:poke_app/src/domain/model/data/region/region.dart';

import '../../../helpers/fixtures.dart';

void main() {
  group('resourceIdFromUrl', () {
    test('extrae el id con o sin slash final', () {
      expect(resourceIdFromUrl('https://pokeapi.co/api/v2/region/7/'), 7);
      expect(resourceIdFromUrl('https://pokeapi.co/api/v2/pokedex/26'), 26);
    });

    test('devuelve 0 para url nula, vacía o sin id', () {
      expect(resourceIdFromUrl(null), 0);
      expect(resourceIdFromUrl(''), 0);
      expect(resourceIdFromUrl('https://pokeapi.co/api/v2/region/'), 0);
    });
  });

  test('RegionListMapper mapea id y displayName capitalizado', () {
    final result = RegionListMapper().call(tRegionListDto);

    expect(result, const [
      Region(id: 1, name: 'kanto', displayName: 'Kanto'),
      Region(id: 2, name: 'johto', displayName: 'Johto'),
    ]);
  });

  test('RegionMapper mapea RegionDto', () {
    expect(RegionMapper().call(tRegionDto), tRegion);
  });
}
