// ignore_for_file: prefer_typing_uninitialized_variables

import 'dart:developer';

import 'package:sqflite_test/models/user.dart';
import 'package:sqflite_test/repositories(COR)/repository.dart';
import 'package:sqflite_test/repositories(COR)/request.dart';

class UserController {
  Future<void> createUser(User user) async {
    const query = '''
        INSERT INTO 
        USERS(NAME, ADDRESS) 
        VALUES(?, ?)
      ''';
    try {
      await Repository.getHandler().handleRequest(
        Request(
          Action.insertAndSync,
          rawQuery: query,
          dto: user,
          args: [
            user.name,
            user.address,
          ],
        ),
      );
    } catch (e) {
      log(e.toString());
    }
    // if (success) {
    //   next?.createUser(user);
    // } else {
    //   next?.cancel();
    // }
  }

  Future<int> getUserIdMax() async {
    String query = 'SELECT MAX(id) FROM USERS';
    late var result;

    try {
      result = await Repository.getHandler().handleRequest(Request(
        Action.rawQuery,
        rawQuery: query,
      ));
    } catch (e) {
      log(e.toString());
    }

    return result[0]['MAX(id)'] == null ? 1 : result[0]['MAX(id)'] as int;
  }

  Future<List<User>> getListOfUser({
    List? args,
  }) async {
    String query = 'SELECT * FROM USERS';
    var res = [];
    try {
      res = await Repository.getHandler().handleRequest(
        Request(
          Action.select,
          rawQuery: query,
          args: args,
        ),
      );
    } catch (e) {
      log(e.toString());
    }
    return res.map((e) => User.fromMap(e)).toList();
  }

  Future<void> updateUser(
    User user,
  ) async {
    const query = '''
        UPDATE USERS
        SET name = ?, address = ?
        WHERE id = ?
      ''';
    try {
      await Repository.getHandler().handleRequest(
        Request(
          Action.updateAndSync,
          rawQuery: query,
          dto: user,
          args: [
            user.name,
            user.address,
            user.id,
          ],
        ),
      );
    } catch (e) {
      log(e.toString());
    }
  }

  Future<void> deleteUser(
    User user,
  ) async {
    const query = '''
        DELETE FROM USERS
        WHERE id = ?
      ''';
    try {
      await Repository.getHandler().handleRequest(
        Request(
          Action.updateAndSync,
          rawQuery: query,
          dto: user,
          args: [
            user.id,
          ],
        ),
      );
    } catch (e) {
      log(e.toString());
    }
  }
}
