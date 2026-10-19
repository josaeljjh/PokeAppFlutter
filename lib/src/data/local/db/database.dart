import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class AppDatabase {
  AppDatabase._();
  static final AppDatabase instance = AppDatabase._();

  static const teamTable = 'TeamEntity';

  Database? _db;

  Future<Database> get database async {
    _db ??= await _open();
    return _db!;
  }

  Future<Database> _open() async {
    final path = join(await getDatabasesPath(), 'poke_app.db');
    return openDatabase(
      path,
      version: 1,
      onCreate: (db, version) async {
        await db.execute(
          'CREATE TABLE IF NOT EXISTS $teamTable ( '
          'id INTEGER PRIMARY KEY AUTOINCREMENT, '
          'name TEXT NOT NULL, '
          'region TEXT NOT NULL, '
          'pokemon TEXT NOT NULL, '
          'created_at TEXT NOT NULL '
          ')',
        );
      },
    );
  }
}
