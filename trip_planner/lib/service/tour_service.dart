import 'package:sqflite/sqflite.dart';

import '../model/Tours.dart';

class TourService {
  Database db;
  TourService(this.db);

  Future<int> insert(Tours tour) async {
    // Remove tour_id from the map for insertion
    final tourMap = tour.toMap();
    tourMap.remove('tour_id');

    int id = await db.insert('tours', tourMap,
        conflictAlgorithm: ConflictAlgorithm.replace);
    return id;
  }

  // Update an existing tour
  Future<void> update(Tours tour) async {
    await db.update(
      "tours",
      tour.toMap(),
      where: "tour_id = ?",
      whereArgs: [tour.tour_id],
    );
  }

  // Retrieve all tours
  Future<List<Tours>> getAll() async {
    final List<Map<String, Object?>> tours = await db.query("tours");
    return [
      for (final {
            'tour_id': id as int,
            'tour_name': name as String,
            'image': image as String,
            'time': time as int,
            'destination': dest as String,
            'schedule': sched as String,
            'nation': nation as String,
            'tour_price': tour_price as double
          } in tours)
        Tours(id, name, image, time, dest, sched, nation, tour_price),
    ];
  }

  Future<List<Tours>> search_by_nation(String nation) async {
    if (nation == "All") {
      nation = "";
    }
    final List<Map<String, dynamic>> tours = await db.query(
      "tours",
      where: "nation LIKE ?",
      whereArgs: ["%$nation%"],
    );
    return tours
        .map((tour) => Tours(
              tour['tour_id'] as int? ?? 0,
              tour['tour_name'] as String? ?? '',
              tour['image'] as String? ?? '',
              tour['time'] as int? ?? 0,
              tour['destination'] as String? ?? '',
              tour['schedule'] as String? ?? '',
              tour['nation'] as String? ?? '',
              (tour['tour_price'] as num?)?.toDouble() ?? 0.0,
            ))
        .toList();
  }

  // Search for tours by name
  Future<List<Tours>> search(String query) async {
    final List<Map<String, Object?>> tours = await db.query(
      "tours",
      where: "tour_name LIKE ? OR nation LIKE ?",
      whereArgs: ["%$query%", "%$query%"],
    );
    return [
      for (final {
            'tour_id': id as int,
            'tour_name': name as String,
            'image': image as String,
            'time': time as int,
            'destination': dest as String,
            'schedule': sched as String,
            'nation': nation as String,
            'tour_price': tour_price as double
          } in tours)
        Tours(id, name, image, time, dest, sched, nation, tour_price),
    ];
  }

  // Retrieve a tour by ID
  Future<Tours> getById(int id) async {
    List<Map<String, dynamic>> maps =
        await db.query('tours', where: 'tour_id = ?', whereArgs: [id]);
    if (maps.isNotEmpty) {
      return Tours(
        maps.first['tour_id'],
        maps.first['tour_name'],
        maps.first['image'],
        maps.first['time'],
        maps.first['destination'],
        maps.first['schedule'],
        maps.first['nation'],
        maps.first['tour_price'],
      );
    } else {
      throw Exception('ID $id not found');
    }
  }

  // Delete a tour by ID
  Future<bool> isTourReferenced(int tourId) async {
    final List<Map<String, dynamic>> trips = await db.query(
      'trips',
      where: 'tour_id = ?',
      whereArgs: [tourId],
      limit: 1,
    );
    return trips.isNotEmpty;
  }

  // Delete a tour by ID with reference check
  Future<void> delete(int id) async {
    bool isReferenced = await isTourReferenced(id);
    if (isReferenced) {
      throw Exception('Cannot delete tour because it is associated with existing trips.');
    }
    await db.delete("tours", where: "tour_id = ?", whereArgs: [id]);
  }
}
