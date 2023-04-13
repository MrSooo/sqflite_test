import 'package:sqflite_test/repositories(COR)/request.dart';

abstract class AbstractRepository {
  AbstractRepository? nextHandler;

  void setNextHandler(AbstractRepository nextHandler) {
    this.nextHandler = nextHandler;
  }

  Future<dynamic> handleRequest(Request result) async {
    if (canHandle(result)) {
      return handle(result);
    } else if (nextHandler != null) {
      return nextHandler!.handle(result);
    } else {
      throw Exception('Unhandle request');
    }
  }

  bool canHandle(Request result);
  Future<dynamic> handle(Request request);
}
