import 'package:sqflite/sqflite.dart';
import '../model/Expenses.dart';

class ExpenseService {
  final Database db;

  ExpenseService(this.db);

  // Insert a new expense
  Future<int> insertExpense(Expenses expense) async {
    final expenseMap = expense.toMap();
    expenseMap.remove('expense_id'); // Remove expense_id from the map for insertion

    int id = await db.insert('expenses', expenseMap,
        conflictAlgorithm: ConflictAlgorithm.replace);
    return id;
  }

  // Fetch expenses for a specific trip
  Future<List<Expenses>> getExpensesForTrip(int tripId) async {
    final List<Map<String, dynamic>> maps = await db.query(
      'expenses',
      where: 'trip_id = ?',
      whereArgs: [tripId],
    );

    print('Fetched expenses: $maps'); // Debug print

    return List.generate(maps.length, (i) => Expenses.fromMap(maps[i]));
  }
}