import 'package:sqflite/sqflite.dart';
import 'package:trip_planner/service/data.dart';
import '../model/Tours.dart';
import '../model/Users.dart';

class FavoriteService {
  // Add a tour to the favorites list
  Future<bool> addFavorite(Tours tour, Users user) async {
    final db = await getDatabase();
    try {
      await db.insert(
        'favorites',
        {
          'tour_id': tour.tour_id,
          'user_id': user.user_id,
        },
        conflictAlgorithm: ConflictAlgorithm.ignore, // Prevent duplicates
      );
      return true;
    } catch (e) {
      print("Error adding favorite: $e");
      return false;
    }
  }

  // Remove a tour from the favorites list
  Future<bool> removeFavorite(int tourId, int userId) async {
    final db = await getDatabase();
    try {
      await db.delete(
        'favorites',
        where: 'tour_id = ? AND user_id = ?',
        whereArgs: [tourId, userId],
      );
      return true;
    } catch (e) {
      print("Error removing favorite: $e");
      return false;
    }
  }

  // Check if a tour is in the user's favorite list
  Future<bool> isFavorite(int tourId, int userId) async {
    final db = await getDatabase();
    try {
      final List<Map<String, dynamic>> result = await db.query(
        'favorites',
        where: 'tour_id = ? AND user_id = ?',
        whereArgs: [tourId, userId],
      );
      return result.isNotEmpty;
    } catch (e) {
      print("Error checking favorite: $e");
      return false;
    }
  }

  // Get all favorite tours for a user
  Future<List<Tours>> getFavoriteToursByUserId(int userId) async {
    final db = await getDatabase();
    try {
      final List<Map<String, dynamic>> maps = await db.rawQuery('''
        SELECT t.tour_id, t.tour_name, t.tour_price, t.image, t.time, t.destination, t.schedule, t.nation 
        FROM tours t
        INNER JOIN favorites f ON t.tour_id = f.tour_id
        WHERE f.user_id = ?
      ''', [userId]);

      return List.generate(maps.length, (i) {
        return Tours(
          maps[i]['tour_id'],
          maps[i]['tour_name'],
          maps[i]['image'],
          maps[i]['time'],
          maps[i]['destination'],
          maps[i]['schedule'],
          maps[i]['nation'],
          maps[i]['tour_price'],
        );
      });
    } catch (e) {
      print("Error retrieving favorite tours: $e");
      return [];
    }
  }
}
