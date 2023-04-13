// ignore_for_file: prefer_typing_uninitialized_variables

import 'dart:developer';

import 'package:sqflite_test/models/post.dart';
import 'package:sqflite_test/repositories(COR)/repository.dart';
import 'package:sqflite_test/repositories(COR)/request.dart';

import '../models/user.dart';

class PostController {
  Future<void> createPost(Post post) async {
    const query = '''
        INSERT INTO 
        POSTS(TITLE, USERID) 
        VALUES(?, ?)
      ''';
    try {
      await Repository.getHandler().handleRequest(Request(
        Action.insertAndSync,
        query,
        dto: post,
        args: [
          post.title,
          post.userId,
        ],
      ));
    } catch (e) {
      log(e.toString());
    }
  }

  Future<int> getPostIdMax() async {
    String query = 'SELECT MAX(id) FROM POSTS';
    late var result;

    try {
      result = await Repository.getHandler().handleRequest(Request(
        Action.rawQuery,
        query,
      ));
    } catch (e) {
      log(e.toString());
    }

    return result[0]['MAX(id)'] == null ? 1 : result[0]['MAX(id)'] as int;
  }

  Future<List<Post>> getListOfPost({
    List? args,
  }) async {
    String query = 'SELECT * FROM POSTS';
    var res = [];
    try {
      res = await Repository.getHandler().handleRequest(
        Request(
          Action.select,
          query,
          args: args,
        ),
      );
    } catch (e) {
      log(e.toString());
    }
    return res.map((e) => Post.fromMap(e)).toList();
  }

  Future<List<Post>> filterPost(String text) async {
    List<String> params = text.split(',');

    String query =
        'SELECT * FROM POSTS WHERE USERID IN (${params.map((_) => '?').join(',')})';
    var res = [];
    try {
      res = await Repository.getHandler().handleRequest(
        Request(
          Action.select,
          query,
        ),
      );
    } catch (e) {
      log(e.toString());
    }
    return res.map((e) => Post.fromMap(e)).toList();
  }

  Future<List<Post>> getListOfPostOfUser(
    User user,
  ) async {
    String query = 'SELECT * FROM POSTS WHERE USERID = ?';
    var res = [];
    try {
      res = await Repository.getHandler().handleRequest(
        Request(
          Action.select,
          query,
          args: [user.id],
        ),
      );
    } catch (e) {
      log(e.toString());
    }
    return res.map((e) => Post.fromMap(e)).toList();
  }

  Future<void> updatePost(
    Post post,
  ) async {
    const query = '''
        UPDATE POSTS
        SET title = ?, userid = ?
        WHERE id = ?
      ''';
    try {
      await Repository.getHandler().handleRequest(
        Request(
          Action.updateAndSync,
          query,
          dto: post,
          args: [
            post.title,
            post.userId,
            post.id,
          ],
        ),
      );
    } catch (e) {
      log(e.toString());
    }
  }

  Future<void> deletePost(
    Post post,
  ) async {
    const query = '''
        DELETE FROM POSTS
        WHERE id = ?
      ''';
    try {
      await Repository.getHandler().handleRequest(
        Request(
          Action.updateAndSync,
          query,
          dto: post,
          args: [
            post.id,
          ],
        ),
      );
    } catch (e) {
      log(e.toString());
    }
  }
}
