import 'package:sqflite/sqflite.dart';
import '../model/Trips.dart';

class TripService {
  final Database db;

  TripService(this.db);

  // Insert a new trip
  Future<int> insertTrip(Trips trip) async {
    final tripMap = trip.toMap();
    tripMap.remove('trip_id'); // Remove trip_id from the map for insertion

    int id = await db.insert('trips', tripMap,
        conflictAlgorithm: ConflictAlgorithm.replace);
    return id;
  }

  // Fetch all trips
  Future<List<Trips>> getAll() async {
    final List<Map<String, dynamic>> maps = await db.query('trips');

    return List.generate(maps.length, (i) {
      return Trips(
        maps[i]['trip_id'],
        maps[i]['trip_name'],
        DateTime.parse(maps[i]['start_date']),
        DateTime.parse(maps[i]['end_date']),
        maps[i]['destination'],
        maps[i]['total_price'],
        maps[i]['status'],
        maps[i]['tour_id'],
        maps[i]['user_id'],
      );
    });
  }

  Future<Trips> get(int id) async {
    final List<Map<String, dynamic>> maps = await db.query(
      'trips',
      where: 'trip_id = ?',
      whereArgs: [id],
    );

    if (maps.isNotEmpty) {
      return Trips(
        maps.first['trip_id'],
        maps.first['trip_name'],
        DateTime.parse(maps.first['start_date']),
        DateTime.parse(maps.first['end_date']),
        maps.first['destination'],
        maps.first['total_price'],
        maps.first['status'],
        maps.first['tour_id'],
        maps.first['user_id'],
      );
    } else {
      throw Exception('Trip not found');
    }
  }

  Future<int> update(Trips trip) async {
    return await db.update(
      'trips',
      trip.toMap(),
      where: 'trip_id = ?',
      whereArgs: [trip.trip_id],
    );
  }

  Future<void> flight_canceled(int tripId, String newStatus) async {
    await db.update(
      'trips',
      {'status': newStatus},
      where: 'trip_id = ?',
      whereArgs: [tripId],
    );
  }

  // Fetch trips by user_id
  Future<List<Trips>> getByUserId(int userId) async {
    final List<Map<String, dynamic>> maps = await db.query(
      'trips',
      where: 'user_id = ?',
      whereArgs: [userId],
    );

    return List.generate(maps.length, (i) {
      return Trips(
        maps[i]['trip_id'],
        maps[i]['trip_name'],
        DateTime.parse(maps[i]['start_date']),
        DateTime.parse(maps[i]['end_date']),
        maps[i]['destination'],
        maps[i]['total_price'],
        maps[i]['status'],
        maps[i]['tour_id'],
        maps[i]['user_id'],
      );
    });
  }
}
