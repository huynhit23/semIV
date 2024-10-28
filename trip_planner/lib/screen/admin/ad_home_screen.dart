import 'package:flutter/material.dart';

class AdHomeScreen extends StatelessWidget {
  const AdHomeScreen({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Administrator page'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: <Widget>[
            Text(
              'Welcome to the Administrator page',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }
}

class SalesData {
  final String month;
  final int sales;

  SalesData(this.month, this.sales);
}
