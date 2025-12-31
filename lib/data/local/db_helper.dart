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
      version: 1,
    );
  }

  // query
  Future<bool> addBudget({required double amt}) async {
    var db = await getDB();

    int rowEffected = await db.insert("budgetAmt", {"budgetAmount": amt});

    return rowEffected > 0;
  }

  Future<bool> addExpense({required String res, required double amt}) async {
    var db = await getDB();

    int rowEffected = await db.insert("expenseTable", {
      "reason": res,
      "amount": amt,
    });

    return rowEffected > 0;
  }

  void editBudget() {}

  void editExpense() {}

  Future<List<Map<String, dynamic>>> getBudgetData() async {
    var db = await getDB();
    List<Map<String, dynamic>> data = await db.query("budgetAmt");
    return data;
  }

  Future<List<Map<String, dynamic>>> getExpenseData() async {
    var db = await getDB();
    List<Map<String, dynamic>> data = await db.query("expenseTable");
    return data;
  }

  void deleteData() {}
}
