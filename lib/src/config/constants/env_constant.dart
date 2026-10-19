class EnvConstants {
  EnvConstants._internal();

  // Nombres de entorno
  static const String development = 'dev';
  static const String production = 'prod';

  // Claves internas de los Maps
  static const String _pokeApiUrl = 'POKE_API_URL';
  static const String _artworkUrl = 'ARTWORK_URL';

  static final Map<String, String> _production = {
    _pokeApiUrl: 'https://pokeapi.co/api/v2/',
    _artworkUrl:
        'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/other/official-artwork/',
  };

  static final Map<String, String> _dev = {
    _pokeApiUrl: 'https://pokeapi.co/api/v2/',
    _artworkUrl:
        'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/other/official-artwork/',
  };

  // Variables estáticas consumidas por el resto de la app
  static String pokeApiUrl = '';
  static String artworkUrl = '';
  static bool isDev = false;
  static bool showHttpLogs = false;

  /// Inicializa todas las variables estáticas según el entorno.
  /// Llamar antes de cualquier otra inicialización en main.dart.
  static void setup({required String flavorName}) {
    isDev = flavorName == development;
    final env = isDev ? _dev : _production;
    env.forEach((key, value) {
      switch (key) {
        case _pokeApiUrl:
          pokeApiUrl = value;
        case _artworkUrl:
          artworkUrl = value;
      }
    });
  }

  /// Activa o desactiva los logs HTTP (útil para dev).
  static void showingHttpsLog(bool show) {
    showHttpLogs = show;
  }

  /// Resetea todas las variables estáticas. Útil en tests de integración.
  static void dispose() {
    pokeApiUrl = '';
    artworkUrl = '';
    isDev = false;
    showHttpLogs = false;
  }
}
