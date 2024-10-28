import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../../model/Trips.dart';
import '../../../model/Tours.dart';
import '../../../model/Users.dart';
import '../../../service/trip_service.dart';
import '../../../service/tour_service.dart';
import '../../../service/user_service.dart';
import '../../../service/data.dart';

class AdminTripDetailScreen extends StatefulWidget {
  final int tripId;

  const AdminTripDetailScreen({Key? key, required this.tripId}) : super(key: key);

  @override
  _AdminTripDetailScreenState createState() => _AdminTripDetailScreenState();
}

class _AdminTripDetailScreenState extends State<AdminTripDetailScreen> {
  late TripService tripService;
  late TourService tourService;
  late UserService userService;
  Trips? trip;
  Tours? relatedTour;
  Users? user;

  @override
  void initState() {
    super.initState();
    _initServices();
  }

  Future<void> _initServices() async {
    final db = await getDatabase();
    tripService = TripService(db);
    tourService = TourService(db);
    userService = UserService(db);
    _loadTripDetails();
  }

  Future<void> _loadTripDetails() async {
    try {
      final loadedTrip = await tripService.get(widget.tripId);
      final loadedTour = await tourService.getById(loadedTrip.tour_id);
      final loadedUser = await userService.getById(loadedTrip.user_id);
      setState(() {
        trip = loadedTrip;
        relatedTour = loadedTour;
        user = loadedUser;
      });
    } catch (e) {
      print("Error loading trip details: $e");
    }
  }

  Future<void> _updateTripStatus(String newStatus) async {
    if (trip != null) {
      final updatedTrip = Trips(
        trip!.trip_id,
        trip!.trip_name,
        trip!.start_date,
        trip!.end_date,
        trip!.destination,
        trip!.budget,
        newStatus,
        trip!.tour_id,
        trip!.user_id,
      );

      try {
        await tripService.update(updatedTrip);
        setState(() {
          trip = updatedTrip;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Trip status updated successfully')),
        );
      } catch (e) {
        print("Error updating trip status: $e");
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to update trip status')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    if (trip == null || relatedTour == null || user == null) {
      return Scaffold(
        appBar: AppBar(title: Text('Trip Details')),
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      appBar: AppBar(title: Text('Trip Details')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildSection('Trip Information', [
              _buildInfoRow('Trip ID', trip!.trip_id.toString()),
              _buildInfoRow('Trip Name', trip!.trip_name),
              _buildInfoRow('Start Date', DateFormat('yyyy-MM-dd').format(trip!.start_date)),
              _buildInfoRow('End Date', DateFormat('yyyy-MM-dd').format(trip!.end_date)),
              _buildInfoRow('Destination', trip!.destination),
              _buildInfoRow('Budget', '\$${trip!.budget.toStringAsFixed(2)}'),
              _buildInfoRow('Status', trip!.status),
            ]),
            SizedBox(height: 20),
            _buildSection('Tour Information', [
              _buildInfoRow('Tour ID', relatedTour!.tour_id.toString()),
              _buildInfoRow('Tour Name', relatedTour!.tour_name),
              _buildInfoRow('Duration', '${relatedTour!.time} days'),
              _buildInfoRow('Nation', relatedTour!.nation),
              _buildInfoRow('Tour Price', '\$${relatedTour!.tour_price.toStringAsFixed(2)}'),
            ]),
            SizedBox(height: 20),
            _buildSection('User Information', [
              _buildInfoRow('User ID', user!.user_id.toString()),
              _buildInfoRow('Username', user!.user_name),
              _buildInfoRow('Full Name', user!.full_name),
              _buildInfoRow('Email', user!.email),
            ]),
            SizedBox(height: 20),
            Text('Update Status:', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  onPressed: trip!.status == 'Waiting for confirmation'
                      ? () => _updateTripStatus('Trip confirmed')
                      : null,
                  child: Text('Confirm Trip'),

                ),
                ElevatedButton(
                  onPressed: trip!.status == 'Trip confirmed'
                      ? () => _updateTripStatus('Complete the trip')
                      : null,
                  child: Text('Complete Trip'),

                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSection(String title, List<Widget> children) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
        SizedBox(height: 10),
        Card(
          elevation: 2,
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: children,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 120,
            child: Text(
              label,
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
          Expanded(
            child: Text(value),
          ),
        ],
      ),
    );
  }
}