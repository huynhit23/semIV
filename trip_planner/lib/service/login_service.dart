import 'package:sqflite/sqflite.dart';

import '../model/Users.dart';

class LoginService {
  Database db;
  LoginService(this.db);

  Future<int> insert(Users user) async {
    final userMap = user.toMap();
    userMap.remove('user_id'); // Ensure user_id is not included
    int id = await db.insert('users', userMap,
        conflictAlgorithm: ConflictAlgorithm.replace);
    return id; // Return the generated ID
  }

  Future<Users?> loginUser(String username, String password) async {
    final List<Map<String, dynamic>> result = await db.query(
      'users',
      where: 'user_name = ? AND password_hash = ?',
      whereArgs: [username, password],
    );

    if (result.isNotEmpty) {
      return Users.fromMap(result.first);
    }
    return null; // Return null if no user found
  }
}
