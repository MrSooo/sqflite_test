import 'package:sqflite_test/repositories(COR)/abstract_repository.dart';
import 'package:sqflite_test/repositories(COR)/offline_repository.dart';
import 'package:sqflite_test/repositories(COR)/online_repository.dart';

class Repository {
  static AbstractRepository getHandler() {
    AbstractRepository cudHandler = OfflineRepository();
    AbstractRepository logHandler = OnlineRepository();
    cudHandler.setNextHandler(logHandler);
    return cudHandler;
  }
}
