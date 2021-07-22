import 'dart:async';
import 'dart:io';

import 'package:gii_test/Movie.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseHelper {
  static final _dbName = 'Movie.db';
  static final _dbVersion = 2;
  static final _tableName = 'mytable';

  DatabaseHelper._();
  static final DatabaseHelper instance = DatabaseHelper._();

  static Database? _database;
  Future<Database> get database async => _database ??= await _initiateDatabase();

  Future<Database> _initiateDatabase() async {
    Directory directory = await getApplicationDocumentsDirectory();
    String path = join(directory.path, _dbName);
    return await openDatabase(path, version: _dbVersion, onOpen: (db) {}, onCreate: _onCreate);
  }
  String? title;
  String? description;
  String? director;
  String? photo;
  Future _onCreate(Database db, int version) async {
    await db.execute("CREATE TABLE $_tableName ("
        "id INTEGER PRIMARY KEY,"
        "title TEXT,"
        "description TEXT,"
        "director TEXT,"
        "photo TEXT"
        ")");
  }

  Future<int> insert(Map<String, dynamic> row) async {
    Database db = await instance.database;
    return await db.insert(_tableName, row, conflictAlgorithm: ConflictAlgorithm.replace);
  }

  Future<List<Movie>> getData() async {
    final db = await database;
    var res = await db.query(_tableName);
    List<Movie> list = res.isNotEmpty ? res.map((c) => Movie.fromJson(c)).toList() : [];
    return list;
  }

  Future<int> delete() async {
    Database db = await instance.database;
    return await db.delete(_tableName);
  }
}