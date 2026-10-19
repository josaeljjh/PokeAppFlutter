class FlavorConfig {
  factory FlavorConfig({
    required String flavorName,
    bool bannerEnabled = true,
    bool debuggable = false,
    required Map<String, dynamic> values,
  }) {
    _instance = FlavorConfig._internal(
      flavorName,
      bannerEnabled,
      values,
      debuggable,
    );

    return _instance;
  }

  FlavorConfig._internal(
    this.flavorName,
    this.bannerEnabled,
    this.values,
    this.debuggable,
  );

  final String flavorName;
  final bool bannerEnabled;
  final bool debuggable;
  final Map<String, dynamic> values;

  static late FlavorConfig _instance;

  static FlavorConfig get instance {
    return _instance;
  }

  static String getFlavorName() => _instance.flavorName;

  static bool isBannerEnabled() => _instance.bannerEnabled;

  static bool isDebuggable() => _instance.debuggable;

  static Map<String, dynamic> getValues() => _instance.values;

  static dynamic getValue(String key) => _instance.values[key];
}
