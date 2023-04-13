import 'package:sqflite_test/db_helper/base_db_helper.dart';

class LogDatabaseHelper with BaseDatabaseHelper {
  final _tableName = 'logs';

  Future<int> createLog(String logQuery, String jsonString) async {
    return await insert(
      _tableName,
      {
        'sqlQuery': logQuery,
        'objectJson': jsonString,
      },
    );
  }

  Future<List<String>> getListOfLog({
    String? where,
    List? whereArgs,
  }) async {
    final res = await select(
      _tableName,
      where,
      whereArgs,
    );
    return res.map((e) => e.toString()).toList();
  }
}
