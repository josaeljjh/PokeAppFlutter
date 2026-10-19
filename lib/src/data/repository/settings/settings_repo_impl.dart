import '../../../domain/repository/settings/settings_repository.dart';
import '../../local/preferences/settings_local_data_source.dart';

class SettingsRepositoryImpl implements SettingsRepository {
  SettingsRepositoryImpl(this.dataSource);

  final SettingsLocalDataSource dataSource;

  @override
  Future<String?> getThemeMode() => dataSource.getThemeMode();

  @override
  Future<void> saveThemeMode(String mode) => dataSource.saveThemeMode(mode);
}
