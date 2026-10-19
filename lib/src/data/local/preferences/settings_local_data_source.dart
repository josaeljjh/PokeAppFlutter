import 'package:shared_preferences/shared_preferences.dart';

import '../../../core/tools/const.dart';

abstract class SettingsLocalDataSource {
  Future<String?> getThemeMode();

  Future<void> saveThemeMode(String mode);
}

class SettingsLocalDataSourceImpl implements SettingsLocalDataSource {
  SettingsLocalDataSourceImpl(this.preferences);

  final SharedPreferences preferences;

  @override
  Future<String?> getThemeMode() async => preferences.getString(prefThemeMode);

  @override
  Future<void> saveThemeMode(String mode) =>
      preferences.setString(prefThemeMode, mode);
}
