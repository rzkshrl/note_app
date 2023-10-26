import 'package:flutter/material.dart';
import 'package:note_app/app/utils/constants.dart';
import 'package:note_app/app/utils/snackbar.dart';
import 'package:sqflite/sqflite.dart';

class SQLHelper {
  var constants = Constants();

  Future<void> createTables(Database database) async {
    await database.execute("""CREATE TABLE ${constants.tableName}(
      ${constants.id} INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,
      ${constants.title} TEXT,
      ${constants.text} TEXT,
      ${constants.date} TEXT NOT NULL
    )""");
  }

  Future<Database> db() async {
    return openDatabase(constants.dbName, version: constants.dbVersion,
        onCreate: (db, version) async {
      await createTables(db);
    });
  }

  Future<int> createItem(String title, String text, String timestamp) async {
    final db = await SQLHelper().db();
    final data = {
      constants.title: title,
      constants.text: text,
      constants.date: timestamp
    };
    final id = await db.insert(constants.tableName, data,
        conflictAlgorithm: ConflictAlgorithm.replace);
    return id;
  }

  Future<int> updateItem(
      String title, String text, int id, String timestamp) async {
    final db = await SQLHelper().db();
    final data = {
      constants.title: title,
      constants.text: text,
      constants.date: timestamp
    };
    final update = db.update(constants.tableName, data,
        where: 'id = ?',
        whereArgs: [id],
        conflictAlgorithm: ConflictAlgorithm.replace);
    return update;
  }

  Future<int> updateItemWithoutDate(String title, String text, int id) async {
    final db = await SQLHelper().db();
    final data = {
      constants.title: title,
      constants.text: text,
    };
    final update = db.update(constants.tableName, data,
        where: 'id = ?',
        whereArgs: [id],
        conflictAlgorithm: ConflictAlgorithm.replace);
    return update;
  }

  Future<List<Map<String, dynamic>>> getAllItem() async {
    final db = await SQLHelper().db();
    return db.query(constants.tableName, orderBy: 'id');
  }

  // Future<List<Map<String, dynamic>>> getItemByID(int id) async {
  //   final db = await SQLHelper().db();
  //   return db.query(constants.tableName,
  //       where: "id = ?", whereArgs: [id], limit: 1);
  // }

  Future<void> deleteItem(List id) async {
    final db = await SQLHelper().db();
    try {
      debugPrint('delete item jalan, $id');
      await db.delete(constants.tableName, where: "id IN (${id.join(', ')})");
    } catch (e) {
      SnackBarService.showSnackBar(
        content: const Text("Can't delete item."),
      );
      debugPrint('$e');
    }
  }

  Future<void> deleteAllItem() async {
    final db = await SQLHelper().db();
    await db.delete(constants.tableName);
    await db.close();
  }
}
