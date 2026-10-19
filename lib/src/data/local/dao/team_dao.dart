import 'package:sqflite/sqflite.dart';

import '../db/database.dart';
import '../entity/team_entity.dart';

abstract class TeamDao {
  Future<List<TeamEntity>> findAll();

  Future<int> insert(TeamEntity entity);

  Future<void> rename(int id, String name);

  Future<void> deleteById(int id);
}

class SqfliteTeamDao implements TeamDao {
  Future<Database> get _db async => AppDatabase.instance.database;

  @override
  Future<List<TeamEntity>> findAll() async {
    final db = await _db;
    final rows = await db.query(
      AppDatabase.teamTable,
      orderBy: 'created_at DESC',
    );
    return rows.map(TeamEntity.fromMap).toList();
  }

  @override
  Future<int> insert(TeamEntity entity) async {
    final db = await _db;
    return db.insert(
      AppDatabase.teamTable,
      entity.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  @override
  Future<void> rename(int id, String name) async {
    final db = await _db;
    await db.update(
      AppDatabase.teamTable,
      {'name': name},
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  @override
  Future<void> deleteById(int id) async {
    final db = await _db;
    await db.delete(AppDatabase.teamTable, where: 'id = ?', whereArgs: [id]);
  }
}
