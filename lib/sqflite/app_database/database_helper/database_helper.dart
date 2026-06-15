import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import '../../sqlite_strings.dart';

class DataBaseHelper {
  DataBaseHelper._();

  static final DataBaseHelper _instance = DataBaseHelper._();

  factory DataBaseHelper() => _instance;

  Database? _database;

  ///This getter is use to get the database from this clas instance.
  Future<Database> get dataBase async => _database ??= await _initDataBase();

  ///This methods [_initDataBase] the data base and gives the instance of [Database]
  Future<Database> _initDataBase() async {
    Directory directory = await getApplicationDocumentsDirectory();
    String dataBasePath = join(directory.path, SqliteStrings.dataBaseName);
    if (kDebugMode) {
      Sqflite.devSetDebugModeOn(true);
    }
    return openDatabase(
      dataBasePath,
      version: SqliteStrings.dataBaseVersion,
      onCreate: _onCreate,
      singleInstance: true,
      /// onUpgrade: _onUpgrade,
    );
  }

  ///This method [_onCreate] is use to create the tables in the database.
  Future<void> _onCreate(Database db, int version) async {
    Batch batch = db.batch();

    // batch.execute('''
    //   CREATE TABLE IF NOT EXISTS ${SqliteStrings.tmsPodTable} (
    //     ${SqliteStrings.podId} INTEGER PRIMARY KEY AUTOINCREMENT,
    //     ${SqliteStrings.podDocNo} INTEGER,
    //     ${SqliteStrings.podImage} TEXT,
    //     ${SqliteStrings.podStatus} INTEGER,
    //     UNIQUE (${SqliteStrings.podId})
    //   )
    //   ''');

    batch.execute('''
      CREATE TABLE IF NOT EXISTS ${SqliteStrings.tmsPodTable} (
        ${SqliteStrings.podId} INTEGER NOT NULL,
        ${SqliteStrings.podDocNo} TEXT,
        ${SqliteStrings.podImage} TEXT,
        ${SqliteStrings.podStatus} INTEGER,
        PRIMARY KEY(${SqliteStrings.podId} AUTOINCREMENT)
      )
      ''');

    // CREATE TABLE "tmspod" (
    //     "id"	INTEGER UNIQUE,
    //     "docNo"	INTEGER,
    //     "image"	TEXT,
    //     "status"	INTEGER,
    //     PRIMARY KEY("id")
    // );

    await batch.commit();
  }

  ///For Future Respective and adding new Column to database.
  /// Future<void> _onUpgrade(Database db, int oldVersion, int newVersion) async {
  ///   if (oldVersion < newVersion) {
  ///     Batch batch = db.batch();
  ///     batch.execute("ALTER TABLE <TABLE> ADD COLUMN <NAME> TEXT");
  ///     batch.execute("ALTER TABLE <TABLE> ADD COLUMN <NAME> TEXT");
  ///     await batch.commit();
  ///   }
  /// }

  /// This method [close] is use to close the database instance to free the resources
  /// use ny the main application.
  Future<void>? close() => _database?.close();
}
