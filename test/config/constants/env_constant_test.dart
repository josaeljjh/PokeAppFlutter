import 'package:flutter_test/flutter_test.dart';
import 'package:poke_app/src/config/constants/env_constant.dart';

void main() {
  tearDown(EnvConstants.dispose);

  test('setup dev configura urls e isDev', () {
    EnvConstants.setup(flavorName: EnvConstants.development);

    expect(EnvConstants.isDev, isTrue);
    expect(EnvConstants.pokeApiUrl, 'https://pokeapi.co/api/v2/');
    expect(EnvConstants.artworkUrl, endsWith('official-artwork/'));
  });

  test('setup prod desactiva isDev', () {
    EnvConstants.setup(flavorName: EnvConstants.production);

    expect(EnvConstants.isDev, isFalse);
    expect(EnvConstants.pokeApiUrl, isNotEmpty);
  });

  test('dispose limpia los valores', () {
    EnvConstants.setup(flavorName: EnvConstants.production);
    EnvConstants.showingHttpsLog(true);

    EnvConstants.dispose();

    expect(EnvConstants.pokeApiUrl, isEmpty);
    expect(EnvConstants.showHttpLogs, isFalse);
  });
}
