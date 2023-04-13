import 'dart:async';
import 'package:path/path.dart' as p;
import 'package:vts_sqflite/sqflite.dart';

mixin BaseDatabaseHelper {
  static late Database _database;
  static Future<Database> get database async {
    _database = await _initDatabase();
    return _database;
  }

  static Future<Database> _initDatabase() async {
    String path = await getDatabasesPath();
    path = p.join(path, 'tule1.db');
    return await openDatabase(
      path,
      version: 1,
      onCreate: _onCreate,
    );
  }

  static Future<void> dropDb() async {
    final Database db = await database;
    db.delete('USERS');
    db.delete('POSTS');
    db.delete('LOGS');

    db.execute("DELETE FROM SQLITE_SEQUENCE WHERE name= 'USERS'");
    db.execute("DELETE FROM SQLITE_SEQUENCE WHERE name= 'POSTS'");
    db.execute("DELETE FROM SQLITE_SEQUENCE WHERE name= 'LOGS'");
  }

  static void _onCreate(
    Database db,
    int version,
  ) async {
    // create your tables here
    await db.execute('''
      CREATE TABLE USERS (id INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL, name TEXT, address TEXT, createAt TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP);
    ''');
    await db.execute('''
      CREATE TABLE POSTS (id INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL, title TEXT, userId INTEGER, createAt TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP);
    ''');
    await db.execute('''
      CREATE TABLE LOGS (id INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL, sqlQuery TEXT, objectJson TEXT, createAt TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP);
    ''');
    // add more tables if needed
  }

  Future<dynamic> executeRaw(String query, {List<dynamic>? args}) async {
    Database db = await database;
    final result = await db.rawQuery(
      query,
      args,
    );

    return result;
  }

  Future<int> insert(
    String tableName,
    Map<String, dynamic> row,
  ) async {
    Database db = await database;

    return await db.insert(
      tableName,
      row,
    );
  }

  Future<int> insertRaw(
    String query,
    List<dynamic> args,
  ) async {
    Database db = await database;

    return await db.rawInsert(
      query,
      args,
    );
  }

  Future<List<Map<String, dynamic>>> selectAll(
    String tableName,
  ) async {
    Database db = await database;
    return await db.query(tableName);
  }

  Future<List<Map<String, dynamic>>> selectAllRaw(
    String query,
    List<dynamic> args,
  ) async {
    Database db = await database;
    return await db.rawQuery(
      query,
      args,
    );
  }

  Future<List<dynamic>> select(
    String tableName,
    String? where,
    List? whereArgs,
  ) async {
    Database db = await database;
    return await db.query(
      tableName,
      where: where,
      whereArgs: whereArgs,
    );
  }

  Future<List<dynamic>> selectRaw(
    String query,
    List<dynamic>? args,
  ) async {
    Database db = await database;
    return await db.rawQuery(
      query,
      args,
    );
  }

  Future<int> update(
    String tableName,
    Map<String, Object?> values,
    String? where,
    List<dynamic>? whereArgs,
  ) async {
    Database db = await database;
    return await db.update(
      tableName,
      values,
      where: where,
      whereArgs: whereArgs,
    );
  }

  Future<int> updateRaw(
    String query,
    List<dynamic> args,
  ) async {
    Database db = await database;
    return await db.rawUpdate(
      query,
      args,
    );
  }

  Future<int> delete(
    String tableName,
    String? where,
    List<dynamic>? whereArgs,
  ) async {
    Database db = await database;
    return await db.delete(
      tableName,
      where: where,
      whereArgs: whereArgs,
    );
  }

  Future<int> deleteRaw(
    String query,
    List<dynamic> args,
  ) async {
    Database db = await database;
    return await db.rawDelete(
      query,
      args,
    );
  }

  Future close() async {
    final db = await database;
    db.close();
  }
}
