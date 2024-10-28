import 'dart:io';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart'; // Import for date formatting
import 'package:trip_planner/screen/admin/Trip/admin_trip_detail_screen.dart';
import '../../../model/Tours.dart';
import '../../../model/Trips.dart';
import '../../../service/data.dart';
import '../../../service/tour_service.dart';
import '../../../service/trip_service.dart';

class AdTripScreen extends StatefulWidget {
  const AdTripScreen({super.key});

  @override
  _AdTripScreenState createState() => _AdTripScreenState();
}

class _AdTripScreenState extends State<AdTripScreen> {
  List<Trips> trips = [];
  late TripService tripService;
  List<Tours> tours = [];
  late TourService tourService;
  bool isLoading = true;

  Future<void> getTrips() async {
    try {
      tripService = TripService(await getDatabase());
      var data = await tripService.getAll();
      setState(() {
        trips = data;
        isLoading = false; // Update loading state
      });
    } catch (e) {
      print("Error getting trips: $e");
      setState(() {
        isLoading = false; // Update loading state on error
      });
    }
  }

  Future<void> getTours() async {
    try {
      tourService = TourService(await getDatabase());
      var data = await tourService.getAll();
      setState(() {
        tours = data;
      });
    } catch (e) {
      print("Error getting tours: $e");
    }
  }

  @override
  void initState() {
    super.initState();
    getTours(); // Call getTours before getTrips
    getTrips();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Trip List'),
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : trips.isEmpty
          ? Center(child: Text('No trips found.'))
          : ListView.builder(
        itemCount: trips.length,
        itemBuilder: (context, index) {
          final trip = trips[index];
          final tour = tours.firstWhere(
                (t) => t.tour_id == trip.tour_id,
            orElse: () => Tours(0, 'Unknown Tour', '', 0, '', '', '', 0),
          );

          return Card(
            margin: const EdgeInsets.all(8),
            child: ListTile(
              leading: Container(
                width: 80,
                height: 80,
                child: _buildTripImage(tour.image),
              ),
              title: Text(
                trip.trip_name,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Trip code: ${trip.trip_id}'),
                  Text('Trip Price: ${trip.budget.toStringAsFixed(2)} USD'),
                  Text('Start time: ${DateFormat.yMMMd().format(trip.start_date.toLocal())}'),
                  Text('End time: ${DateFormat.yMMMd().format(trip.end_date.toLocal())}'),
                  Text('Destination: ${trip.destination}'),
                  Text('Status: ${trip.status}'),
                ],
              ),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => AdminTripDetailScreen(tripId: trip.trip_id!),
                  ),
                ).then((_) {
                  // Refresh the trip list when returning from the detail screen
                  getTrips();
                });
              },
            ),
          );
        },
      ),
    );
  }

  Widget _buildTripImage(String imagePath) {
    if (imagePath.startsWith('/data/')) {
      // If it's a file image
      return Image.file(
        File(imagePath),
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) {
          return const Icon(Icons.error);
        },
      );
    } else {
      // If it's an asset image
      return Image.asset(
        "assets/images/tours/$imagePath",
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) {
          return const Icon(Icons.image_not_supported);
        },
      );
    }
  }
}
