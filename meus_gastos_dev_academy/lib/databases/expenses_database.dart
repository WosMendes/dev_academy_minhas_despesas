import 'package:flutter/material.dart';
import 'package:meus_gastos_dev_academy/models/expense_model.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class ExpensesDatabase extends ChangeNotifier {
  ExpensesDatabase();
  ExpensesDatabase._();

  static final ExpensesDatabase db = ExpensesDatabase._();

  Future<Database> getDatabase() async {
    final String dbPath = await getDatabasesPath();
    final String path = join(dbPath, 'expenses_app_1.db');
    return openDatabase(path, onCreate: (db, version) {
      db.execute('''
        CREATE TABLE expenses(
          id INTEGER PRIMARY KEY AUTOINCREMENT,
          name TEXT,
          value TEXT,
          category TEXT,
          date TEXT
        )
        ''');
    }, version: 1, onDowngrade: onDatabaseDowngradeDelete);
  }

  Future<List<dynamic>> getExpenses() async {
    final Database db = await getDatabase();
    final List<Map<String, dynamic>> result = await db.query('expenses');
    final List<Expense> expenses = [];

    for (Map<String, dynamic> row in result) {
      final Expense expense = Expense(
        id: row['id'],
        name: row['name'],
        category: row['category'],
        value: row['value'],
        date: row['date'],
      );
      expenses.add(expense);
    }
    return expenses;
  }

  addNewExpense(Expense expense) async {
    final Database db = await ExpensesDatabase.db.getDatabase();
    db.insert('expenses', expense.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace);
    notifyListeners();
  }

  removeExpense(int? id) async {
    final Database db = await ExpensesDatabase.db.getDatabase();
    await db.delete(
      'expenses',
      where: 'id = ?',
      whereArgs: [id],
    );
    notifyListeners();
  }

  updateExpense(Expense expense) async {
    final Database db = await ExpensesDatabase.db.getDatabase();
    await db.update(
      'expenses',
      expense.toMap(),
      where: 'id = ?',
      whereArgs: [expense.id],
    );
    notifyListeners();
  }

  notify() {
    notifyListeners();
  }
}
