import 'dart:convert';
import 'package:hrl_2026/sqflite/sqlite_strings.dart';
import 'package:sqflite/sqflite.dart';
import 'app_database/database_helper/database_helper.dart';
import 'app_database/helper/database_method_helper.dart';
import 'database_model/pod_tabel_model.dart';

class TmsPodTable implements DBHelperMethod<PodTableModel> {

  /// this insert method will add the data entry of the Complete TestResult data to the TestResultTable into database.
  @override
  Future<int> insert(PodTableModel data) async {
    final DataBaseHelper dataBaseHelper = DataBaseHelper();
    Database dataBase = await dataBaseHelper.dataBase;
    return dataBase.transaction(
      (txn) => txn.insert(
        SqliteStrings.tmsPodTable,
        data.toJsonWithOutId(),
      ),
    );
  }

  /// this query method will retrieve the data contained in the TestResultTable from the database.
  @override
  Future<List<PodTableModel>> query() async {
    final DataBaseHelper dataBaseHelper = DataBaseHelper();
    Database dataBase = await dataBaseHelper.dataBase;
    List<Map<String, dynamic>> userData = await dataBase.transaction(
      (txn) => txn.query(SqliteStrings.tmsPodTable),
    );
    return podTableListModelFromJson(jsonEncode(userData));
  }

  /// this delete method is used to remove any of the data from a database's Table.
  @override
  Future<int> delete({int? data}) async {
    final DataBaseHelper dataBaseHelper = DataBaseHelper();
    Database dataBase = await dataBaseHelper.dataBase;
    return data != null
        ? dataBase.transaction(
            (txn) => txn.delete(
              SqliteStrings.tmsPodTable,
              where: '${SqliteStrings.podId} = ?',
              whereArgs: [data],
            ),
          )
        : dataBase.transaction(
            (txn) => txn.delete(SqliteStrings.tmsPodTable),
          );
  }

  /// this method is used to update the data inside of database TestResultTable.
  @override
  Future<int> update(PodTableModel data) async {
    final DataBaseHelper dataBaseHelper = DataBaseHelper();
    Database dataBase = await dataBaseHelper.dataBase;
    return dataBase.transaction(
      (txn) => txn.update(
        SqliteStrings.tmsPodTable,
        data.toJson(),
        where: '${SqliteStrings.tmsPodTable} = ?',
        whereArgs: [data.id],
      ),
    );
  }

  ///[rawQuery] is used to execute queries in the database.
  @override
  Future<List<PodTableModel>> rawQuery(String raw) async {
    final DataBaseHelper dataBaseHelper = DataBaseHelper();
    Database dataBase = await dataBaseHelper.dataBase;
    List<Map<String, dynamic>> userData = await dataBase.transaction(
      (txn) => txn.rawQuery(raw),
    );
    return podTableListModelFromJson(jsonEncode(userData));
  }

  @override
  Future<List<Map<String, dynamic>>> rawQueryWithCustomMap(String raw) async {
    final DataBaseHelper dataBaseHelper = DataBaseHelper();
    Database dataBase = await dataBaseHelper.dataBase;
    List<Map<String, dynamic>> userData =
        await dataBase.transaction((txn) => txn.rawQuery(raw));
    return userData;
  }
}
