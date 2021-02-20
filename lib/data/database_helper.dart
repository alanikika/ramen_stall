import 'dart:io';

import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import 'package:stall_noodle/data/schema/staller_schema.dart';

const dbName = "ramen_stall_db";

class DatabaseHelper {
  DatabaseHelper._privateConstructor();

  static final DatabaseHelper instance = DatabaseHelper._privateConstructor();

  static Database _database;
  Future<Database> get database async {
    if (_database != null) return _database;
    _database = await _initDatabase();
    return _database;
  }

  _initDatabase() async {
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, dbName);
    return await openDatabase(
      path,
      version: 1,
      onCreate: _onCreate,
      onUpgrade: _onUpgrade,
    );
  }

  Future _onCreate(Database db, int version) async {
    await db.execute(createTableStallSql);
  }

  Future _onUpgrade(Database database, int oldVersion, int newVersion) async {
    print('oldVersion: $oldVersion, newVersion: $newVersion');
  }

  Future<int> insertRamenStall(Map<String, dynamic> data) async {
    Database db = await instance.database;
    return await db.insert(tableStall, data);
  }
}
