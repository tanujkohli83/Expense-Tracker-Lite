import 'dart:io';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

class DBHelper {
  // singltone
  DBHelper._();

  static DBHelper getInstance() {
    return DBHelper._();
  }

  Database? myDB;

  // DB open
  Future<Database> getDB() async {
    if (myDB != null) {
      return myDB!;
    } else {
      myDB = await openDB();
      return myDB!;
    }
  }

  Future<Database> openDB() async {
    Directory appDir = await getApplicationDocumentsDirectory();

    String dbPath = join(appDir.path, "ExpenseDB.db");

    return await openDatabase(
      dbPath,
      onCreate: (db, version) {
        // create tables here

        db.execute('''CREATE TABLE budgetAmt
          (
          budgetAmount REAL
          )
          ''');

        db.execute('''CREATE TABLE expenseTable
          (
          id INTEGER PRIMARY KEY AUTOINCREMENT,
          reason TEXT,
          amount REAL
          )
          ''');
      },
    );
  }
}
