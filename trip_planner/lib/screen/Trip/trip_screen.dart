import 'dart:io';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:trip_planner/screen/Trip/trip_detail_screen.dart';
import '../../../model/Tours.dart';
import '../../../model/Trips.dart';
import '../../../service/data.dart';
import '../../../service/tour_service.dart';
import '../../../service/trip_service.dart';
import '../../model/Users.dart';

class TripScreen extends StatefulWidget {
  final Users user;

  const TripScreen({super.key, required this.user});

  @override
  _TripScreenState createState() => _TripScreenState();
}

class _TripScreenState extends State<TripScreen> {
  List<Trips> trips = [];
  late TripService tripService;
  List<Tours> tours = [];
  late TourService tourService;

  @override
  void initState() {
    super.initState();
    initServices();
  }

  Future<void> initServices() async {
    final db = await getDatabase();
    tripService = TripService(db);
    tourService = TourService(db);
    await refreshData();
  }

  Future<void> refreshData() async {
    try {
      var tripData = await tripService.getByUserId(widget.user.user_id!);
      var tourData = await tourService.getAll();
      setState(() {
        trips = tripData;
        tours = tourData;
      });
    } catch (e) {
      print("Error refreshing data: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('List of your trips'),
      ),
      body: RefreshIndicator(
        onRefresh: refreshData,
        child: trips.isEmpty
            ? Center(child: Text('No trips found for this user.'))
            : ListView.builder(
          itemCount: trips.length,
          itemBuilder: (context, index) {
            final trip = trips[index];
            final tour = tours.firstWhere(
                  (t) => t.tour_id == trip.tour_id,
            );
            return Card(
              margin: EdgeInsets.all(8),
              child: ListTile(
                leading: Container(
                  width: 80,
                  height: 80,
                  child: _buildTripImage(tour.image),
                ),
                title: Text(
                  trip.trip_name,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Trip Id: ${trip.trip_id}'),
                    Text('Trip Price: ${trip.budget.toStringAsFixed(2)} USD'),
                    Text('Start time: ${DateFormat.yMMMd().format(trip.start_date.toLocal())}'),
                    Text('End time: ${DateFormat.yMMMd().format(trip.end_date.toLocal())}'),
                    Text('Destination: ${trip.destination}'),
                    Text('Trip Status: ${trip.status}'),
                  ],
                ),
                onTap: () async {
                  final result = await Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => TripDetailScreen(trip: trip, tour: tour),
                    ),
                  );
                  if (result == true) {
                    await refreshData();
                  }
                },
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildTripImage(String imagePath) {
    if (imagePath.startsWith('/data/')) {
      return Image.file(
        File(imagePath),
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) {
          return Icon(Icons.error);
        },
      );
    } else {
      return Image.asset(
        "assets/images/tours/$imagePath",
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) {
          return Icon(Icons.image_not_supported);
        },
      );
    }
  }
}