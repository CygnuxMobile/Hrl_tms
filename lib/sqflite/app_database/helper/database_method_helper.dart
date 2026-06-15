///This [DBHelperMethod] is use to add som default
///crud operation method needed by the main application.
abstract class DBHelperMethod<T> {
  Future<int> insert(T data);
  Future<int> update(T data);
  Future<int> delete({int? data});
  Future<List<T>> query();
  dynamic rawQuery(String raw);
  dynamic rawQueryWithCustomMap(String raw);
}
