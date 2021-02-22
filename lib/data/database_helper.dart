import 'dart:io';

import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import 'package:stall_noodle/data/schema/staller_schema.dart';
import 'package:stall_noodle/model/ramen_model.dart';
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

  Future<List<RamenModel>> getRamenStall() async {
    Database db = await instance.database;
    List<Map<String, dynamic>> data = await db.query(tableStall);
    if(data.length > 0) {
      return data.map((data) => RamenModel.fromJsonMap(data)).toList();
    } else {
      return null;
    }
  }

  Future<bool> isRamenExist(String ramenName) async {
    Database db = await instance.database;
    List<Map<String, dynamic>> data = await db.rawQuery(
      "SELECT * FROM $tableStall WHERE $name=?",[ramenName]
    );
    if(data.length > 0) {
      return true;
    } else {
      return false;
    }
  }

  Future<int> deleteRamenById(int ramenId) async {
    Database db = await instance.database;
    return await db.delete(tableStall, where: "$id=?", whereArgs: [ramenId]);
  }
}
