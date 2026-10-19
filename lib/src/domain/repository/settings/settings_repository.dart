abstract class SettingsRepository {
  Future<String?> getThemeMode();

  Future<void> saveThemeMode(String mode);
}
