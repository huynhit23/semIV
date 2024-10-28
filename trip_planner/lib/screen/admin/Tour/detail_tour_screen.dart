import 'dart:io';

import 'package:flutter/material.dart';

import '../../../model/Tours.dart';
import '../../../service/data.dart';
import '../../../service/tour_service.dart';

class DetailTourScreen extends StatefulWidget {
  final int id;
  DetailTourScreen(this.id);

  @override
  _DetailTourScreenState createState() => _DetailTourScreenState();
}

class _DetailTourScreenState extends State<DetailTourScreen> {
  late TourService service;
  Tours tour =
      Tours(0, "", "", 0, "", "", "", 0); // Initialize with default values

  getTour() async {
    service = TourService(await getDatabase());
    var data = await service.getById(widget.id);
    setState(() {
      tour = data;
    });
  }

  @override
  void initState() {
    getTour();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Tour details"),
      ),
      body: SingleChildScrollView(
        child: Container(
          margin: EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildInfoRow('Tour code', '${tour.tour_id}'),
              _buildInfoRow('Tour name', tour.tour_name),
              _buildImageSection(tour.image),
              _buildInfoRow('Tour Time', '${tour.time}'),
              _buildMultilineInfoRow('Destination', tour.destination),
              _buildMultilineInfoRow('Schedule', tour.schedule),
              _buildInfoRow('Nation', tour.nation),
              _buildInfoRow(
                  'Tour price', '${tour.tour_price.toStringAsFixed(2)} USD'),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 100,
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

  Widget _buildMultilineInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 4),
          Text(
            value,
            style: TextStyle(height: 1.5),
          ),
        ],
      ),
    );
  }

  Widget _buildImageSection(String imagePath) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Tour images',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 8),
          Container(
            height: 200,
            width: double.infinity,
            child: imagePath.startsWith('/data/')
                ? Image.file(
                    File(imagePath),
                    fit: BoxFit.cover,
                  )
                : Image.asset(
                    "assets/images/tours/${imagePath}",
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return Icon(Icons.error);
                    },
                  ),
          ),
        ],
      ),
    );
  }
}
