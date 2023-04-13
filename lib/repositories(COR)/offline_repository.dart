import 'package:sqflite_test/db_helper/base_db_helper.dart';
import 'package:sqflite_test/repositories(COR)/abstract_repository.dart';
import 'package:sqflite_test/repositories(COR)/request.dart';

class OfflineRepository extends AbstractRepository with BaseDatabaseHelper {
  @override
  bool canHandle(Request result) {
    return result.action == Action.insertAndSync ||
        result.action == Action.deleteAndSync ||
        result.action == Action.updateAndSync ||
        result.action == Action.rawQuery ||
        result.action == Action.select;
  }

  @override
  Future<dynamic> handle(Request request) async {
    try {
      int res = 0;

      switch (request.action) {
        case Action.insertAndSync:
          res = await doInsert(request);
          break;
        case Action.updateAndSync:
          res = await doUpdate(request);
          break;
        case Action.deleteAndSync:
          res = await doDelete(request);
          break;
        case Action.select:
          return await doSelect(request);
        case Action.rawQuery:
          return await doRawQuery(request);
        default:
          return;
      }

      if (res != 0) {
        await nextHandler?.handle(request);
      } else {
        throw Exception('SQL fail');
      }
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  Future<int> doInsert(Request request) async {
    return await insertRaw(
      request.rawQuery!,
      request.args!,
    );
  }

  Future<int> doUpdate(Request request) async {
    return await updateRaw(
      request.rawQuery!,
      request.args!,
    );
  }

  Future<int> doDelete(Request request) async {
    return await deleteRaw(
      request.rawQuery!,
      request.args!,
    );
  }

  Future<dynamic> doSelect(Request request) async {
    var res = await selectRaw(
      request.rawQuery!,
      request.args,
    );
    return res;
  }

  Future<dynamic> doRawQuery(Request request) async {
    var res = await executeRaw(
      request.rawQuery!,
    );
    return res;
  }
}
