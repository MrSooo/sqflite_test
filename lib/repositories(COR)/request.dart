enum Action {
  insertAndSync,
  updateAndSync,
  deleteAndSync,
  select,
  rawQuery,
  onlySync,
}

class Request {
  final Action action;
  final String rawQuery;
  final List? args;
  final dynamic dto;

  get getAction => action;

  get getRawQuery => rawQuery;

  get getArgs => args;

  get getDto => dto;

  Request(
    this.action,
    this.rawQuery, {
    this.dto,
    this.args,
  });
}
