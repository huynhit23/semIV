import 'package:sqflite/sqflite.dart';
import 'package:trip_planner/service/data.dart';
import '../model/Comments.dart';
import '../model/Users.dart';

class CommentService {
  final Database db;

  CommentService(this.db);

  Future<int> insertComment(Comments comment) async {
    final db = await getDatabase();

    // Insert the comment into the database
    final id = await db.insert(
      'comments', // Your table name
      {
        'content': comment.content,
        'tour_id': comment.tour_id,
        'user_id': comment.user_id,
      },
    );

    return id; // Return the generated ID
  }

  // Fetch comments by tour_id
  Future<List<Comments>> getCommentsByTourId(int tourId) async {
    final List<Map<String, dynamic>> maps = await db.query(
      'comments',
      where: 'tour_id = ?',
      whereArgs: [tourId],
      orderBy: 'comment_id DESC',  // This will show the newest comments first
    );

    return List.generate(maps.length, (i) {
      return Comments(
        maps[i]['comment_id'],
        maps[i]['content'],
        maps[i]['tour_id'],
        maps[i]['user_id'],
      );
    });
  }

  Future<Users> getUserById(int userId) async {
    final List<Map<String, dynamic>> results = await db.query(
      'users', // The name of your user table
      where: 'user_id = ?',
      whereArgs: [userId],
    );

    if (results.isNotEmpty) {
      return Users.fromMap(results.first); // Assuming you have a fromMap method in your Users model
    } else {
      throw Exception('User not found');
    }
  }

  // Remove a comment
  Future<bool> removeComment(int commentId) async {
    final db = await getDatabase();
    try {
      await db.delete(
        'comments',
        where: 'comment_id = ?',
        whereArgs: [commentId],
      );
      return true;
    } catch (e) {
      print("Error removing comment: $e");
      return false;
    }
  }

  // Update an existing comment
  Future<void> updateComment(Comments comment) async {
    await db.update(
      "comments",
      {
        'content': comment.content,
        'tour_id': comment.tour_id,
        'user_id': comment.user_id,
      },
      where: "comment_id = ?",
      whereArgs: [comment.comment_id],
    );
  }
}