import 'dart:io';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../../model/Trips.dart';
import '../../../model/Tours.dart';
import '../../../model/Expenses.dart';
import '../../constants.dart';
import '../../../service/trip_service.dart';
import '../../../service/data.dart';
import '../../service/expenses_service.dart';

class TripDetailScreen extends StatefulWidget {
  final Trips trip;
  final Tours tour;

  const TripDetailScreen({Key? key, required this.trip, required this.tour})
      : super(key: key);

  @override
  _TripDetailScreenState createState() => _TripDetailScreenState();
}

class _TripDetailScreenState extends State<TripDetailScreen> {
  late TripService tripService;
  late ExpenseService expenseService;
  bool _hasChanges = false;
  List<Expenses> _expenses = [];

  @override
  void initState() {
    super.initState();
    initServices();
  }

  Future<void> initServices() async {
    final db = await getDatabase();
    tripService = TripService(db);
    expenseService = ExpenseService(db);
    await fetchExpenses();
  }

  Future<void> fetchExpenses() async {
    try {
      final expenses =
          await expenseService.getExpensesForTrip(widget.trip.trip_id!);
      setState(() {
        _expenses = expenses;
      });
      print('Expenses fetched: $_expenses'); // Debug print
    } catch (e) {
      print('Error fetching expenses: $e'); // Debug print
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error fetching expenses: $e')),
      );
    }
  }

  Future<void> cancelTrip() async {
    if (widget.trip.status.toLowerCase() == 'waiting for confirmation') {
      try {
        await tripService.flight_canceled(
            widget.trip.trip_id!, 'Flight canceled');
        setState(() {
          widget.trip.status = 'Flight canceled';
          _hasChanges = true;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Trip has been canceled successfully')),
        );
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to cancel trip: $e')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        Navigator.of(context).pop(_hasChanges);
        return false;
      },
      child: Scaffold(
        backgroundColor: kcontentColor,
        body: SafeArea(
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildAppBar(context),
                _buildImageSection(widget.tour.image),
                const SizedBox(height: 20),
                Container(
                  width: double.infinity,
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                      topRight: Radius.circular(40),
                      topLeft: Radius.circular(40),
                    ),
                  ),
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildTripDetails(),
                      const SizedBox(height: 25),
                      Text(
                        widget.trip.trip_name,
                        style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.blue,
                            fontSize: 20),
                      ),
                      const SizedBox(height: 25),
                      _buildTourSchedule(),
                      const SizedBox(height: 25),
                      _buildTripInfo(),
                      const SizedBox(height: 25),
                      _buildExpensesInfo(),
                      const SizedBox(height: 25),
                      _buildCancelButton(),
                      const SizedBox(height: 100),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildExpensesInfo() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "Expenses details",
          style: TextStyle(
              fontWeight: FontWeight.bold, color: Colors.blue, fontSize: 20),
        ),
        const SizedBox(height: 10),
        _expenses.isEmpty
            ? const Text("No expenses recorded for this trip.")
            : Column(
                children: _expenses
                    .map((expense) => _buildExpenseItem(expense))
                    .toList(),
              ),
      ],
    );
  }

  Widget _buildExpenseItem(Expenses expense) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text("Trip Budget: \$${widget.trip.budget.toStringAsFixed(2)}",
            style: const TextStyle(
                fontWeight: FontWeight.bold, fontSize: 17, height: 1.8)),
        Text("Tour Price: \$${widget.tour.tour_price.toStringAsFixed(2)}",
            style: const TextStyle(
                fontWeight: FontWeight.bold, fontSize: 17, height: 1.8)),
        Text("Cost 1 day: \$${expense.expense_date}",
            style: const TextStyle(
                fontWeight: FontWeight.bold, fontSize: 17, height: 1.8)),
        Text("Expenses note: ${expense.notes}",
            style: const TextStyle(
                fontWeight: FontWeight.bold, fontSize: 17, height: 1.8)),
      ],
    );
  }

  Widget _buildCancelButton() {
    return widget.trip.status.toLowerCase() == 'waiting for confirmation'
        ? ElevatedButton(
            onPressed: cancelTrip,
            child: Text('Cancel Trip'),
          )
        : SizedBox.shrink();
  }

  Widget _buildAppBar(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          GestureDetector(
            onTap: () => Navigator.pop(context, _hasChanges),
            child: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10),
              ),
              child: const Icon(Icons.arrow_back, color: Colors.black),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildImageSection(String imagePath) {
    return Container(
      height: 200,
      width: double.infinity,
      child: imagePath.startsWith('/data/')
          ? Image.file(
              File(imagePath),
              fit: BoxFit.cover,
            )
          : Image.asset(
              "assets/images/tours/$imagePath",
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) {
                return Icon(Icons.error);
              },
            ),
    );
  }

  Widget _buildTripDetails() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              widget.trip.destination,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
            ),
            const SizedBox(height: 5),
            Row(
              children: [
                const Icon(Icons.location_on, color: Colors.blue, size: 14),
                const SizedBox(width: 5),
                Text(widget.tour.nation,
                    style: const TextStyle(color: Colors.grey)),
              ],
            ),
          ],
        ),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
          decoration: BoxDecoration(
            color: Colors.blue.withOpacity(0.1),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Text(
            '\$${widget.trip.budget.toStringAsFixed(2)}',
            style: const TextStyle(
                color: Colors.blue, fontWeight: FontWeight.bold),
          ),
        ),
      ],
    );
  }

  Widget _buildTourSchedule() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text("Tour Schedule",
            style: TextStyle(
                fontWeight: FontWeight.bold, color: Colors.blue, fontSize: 20)),
        const SizedBox(height: 10),
        _buildFormattedSchedule(widget.tour.schedule),
      ],
    );
  }

  Widget _buildFormattedSchedule(String schedule) {
    final RegExp dayRegex = RegExp(r'DAY \d+:', caseSensitive: false);
    final List<TextSpan> textSpans = [];

    schedule.split('\n').forEach((line) {
      if (dayRegex.hasMatch(line)) {
        //
        if (textSpans.isNotEmpty) {
          textSpans.add(const TextSpan(text: '\n'));
        }
        textSpans.add(TextSpan(
          text: '$line\n',
          style: const TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.grey,
              fontSize: 17,
              height: 1.8),
        ));
      } else {
        textSpans.add(
            TextSpan(text: '$line\n', style: const TextStyle(height: 1.4)));
      }
    });

    return RichText(
      text: TextSpan(
        style: const TextStyle(fontSize: 16, color: Colors.black),
        children: textSpans,
      ),
    );
  }

  Widget _buildTripInfo() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text("Trip Information",
            style: TextStyle(
                fontWeight: FontWeight.bold, color: Colors.blue, fontSize: 20)),
        const SizedBox(height: 10),
        Text(
            "Start Date: ${DateFormat.yMMMd().format(widget.trip.start_date.toLocal())}",
            style: const TextStyle(
                fontWeight: FontWeight.bold, fontSize: 17, height: 1.8)),
        Text(
            "End Date: ${DateFormat.yMMMd().format(widget.trip.end_date.toLocal())}",
            style: const TextStyle(
                fontWeight: FontWeight.bold, fontSize: 17, height: 1.8)),
        Text("Status: ${widget.trip.status}",
            style: const TextStyle(
                fontWeight: FontWeight.bold, fontSize: 17, height: 1.8)),
      ],
    );
  }
}
