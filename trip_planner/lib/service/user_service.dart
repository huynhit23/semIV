import 'package:sqflite/sqflite.dart';

import '../model/Users.dart';

class UserService {
  Database db;
  UserService(this.db);

  // Update an existing user
  Future<void> update(Users user) async {
    await db.update(
      "users",
      user.toMap(),
      where: "user_id = ?",
      whereArgs: [user.user_id],
    );
  }

  // Retrieve all users
  Future<List<Users>> getAll() async {
    final List<Map<String, Object?>> users = await db.query("users");
    print("Raw users from database: $users"); // Debugging line
    return [
      for (final user in users)
        Users(
          user_id: user['user_id'] as int?,
          full_name: user['full_name'] as String? ?? '',
          avatar: user['avatar'] as String? ?? '',
          user_name: user['user_name'] as String? ?? '',
          password_hash: user['password_hash'] as String? ?? '',
          email: user['email'] as String? ?? '',
          role: user['role'] as String? ?? 'user',
          status: user['status'] as String? ?? 'inactive',
        ),
    ];
  }

  // Search for users by name
  Future<List<Users>> search(String query) async {
    final List<Map<String, Object?>> users = await db.query(
      "users",
      where: "full_name LIKE ? OR user_name LIKE ?",
      whereArgs: ["%$query%", "%$query%"],
    );
    return [
      for (final {
            'user_id': id as int,
            'full_name': name as String,
            'avatar': avatar as String,
            'user_name': userName as String,
            'password_hash': passwordHash as String,
            'email': email as String,
            'role': role as String,
            'status': status as String,
          } in users)
        Users(
          user_id: id,
          full_name: name,
          avatar: avatar,
          user_name: userName,
          password_hash: passwordHash,
          email: email,
          role: role,
          status: status,
        ),
    ];
  }

  // Retrieve a user by ID
  Future<Users?> getById(int id) async {
    final List<Map<String, Object?>> users = await db.query(
      "users",
      where: 'user_id = ?',
      whereArgs: [id],
    );
    if (users.isNotEmpty) {
      return Users(
        user_id: users.first['user_id'] as int?,
        full_name: users.first['full_name'] as String? ?? '',
        avatar: users.first['avatar'] as String? ?? '',
        user_name: users.first['user_name'] as String? ?? '',
        password_hash: users.first['password_hash'] as String? ?? '',
        email: users.first['email'] as String? ?? '',
        role: users.first['role'] as String? ?? 'user',
        status: users.first['status'] as String? ?? 'inactive',
      );
    }
    return null; // Return null if user not found
  }
}
