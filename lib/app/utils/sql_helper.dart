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
      ${constants.date} TEXT NOT NULL,
      ${constants.pin} INTEGER,
      ${constants.favorite} INTEGER
    )""");
  }

  Future<Database> db() async {
    return openDatabase(constants.dbName, version: constants.dbVersion,
        onCreate: (db, version) async {
      await createTables(db);
    });
  }

  Future<int> createItem(String title, String text, String timestamp, int pin,
      int favorite) async {
    final db = await SQLHelper().db();
    final data = {
      constants.title: title,
      constants.text: text,
      constants.date: timestamp,
      constants.pin: pin,
      constants.favorite: favorite,
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

  Future<int> pinItem(bool pin, List id) async {
    final db = await SQLHelper().db();
    int convertPin = pin ? 1 : 0;
    final data = {
      constants.pin: convertPin,
    };
    final update = db.update(constants.tableName, data,
        where: "id IN (${id.join(', ')})",
        conflictAlgorithm: ConflictAlgorithm.replace);
    return update;
  }

  Future<int> favoriteItem(bool favorite, List id) async {
    final db = await SQLHelper().db();
    int convertFavorite = favorite ? 1 : 0;
    final data = {
      constants.favorite: convertFavorite,
    };
    final update = db.update(constants.tableName, data,
        where: "id IN (${id.join(', ')})",
        conflictAlgorithm: ConflictAlgorithm.replace);
    return update;
  }

  Future<List<Map<String, dynamic>>> getAllItem() async {
    final db = await SQLHelper().db();
    return db.query(constants.tableName, orderBy: '${constants.date} DESC');
  }

  Future<List<Map<String, dynamic>>> getFavoritedItem() async {
    final db = await SQLHelper().db();
    return db.query(constants.tableName,
        orderBy: '${constants.date} DESC', where: '${constants.favorite} = 1');
  }

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
