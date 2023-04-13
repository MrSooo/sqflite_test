import 'dart:convert';

import 'package:sqflite_test/db_helper/log_db_helper.dart';
import 'package:sqflite_test/models/post.dart';
import 'package:sqflite_test/models/user.dart';
import 'package:sqflite_test/repositories(COR)/abstract_repository.dart';
import 'package:sqflite_test/repositories(COR)/request.dart';

class OnlineRepository extends AbstractRepository {
  final _logDBHandler = LogDatabaseHelper();
  @override
  bool canHandle(Request result) {
    return result.action == Action.insertAndSync ||
        result.action == Action.updateAndSync ||
        result.action == Action.deleteAndSync ||
        result.action == Action.onlySync;
  }

  @override
  Future<dynamic> handle(Request request) async {
    try {
      String jsonString = '';
      switch (request.dto.runtimeType) {
        case User:
          jsonString = jsonEncode(request.dto);
          break;

        case Post:
          jsonString = jsonEncode(request.dto);
          break;
      }
      _logDBHandler.createLog(
        request.rawQuery,
        jsonString,
      );
    } catch (e) {
      throw (e.toString());
    }
  }
}
