import 'package:flutter/material.dart';
import 'package:trip_planner/model/Expenses.dart';
import 'package:trip_planner/model/Tours.dart';
import 'package:trip_planner/model/Trips.dart';
import 'package:trip_planner/service/data.dart';
import 'package:trip_planner/service/expenses_service.dart';

import '../../model/Users.dart';
import '../nav_home_screen.dart';

class AddExpensesScreen extends StatefulWidget {
  final Tours tour;
  final Users user;
  final Trips trip;
  final int amount; // Quantity
  final DateTime startDate;
  final DateTime endDate;
  final double tourPrice;

  const AddExpensesScreen({
    Key? key,
    required this.amount,
    required this.startDate,
    required this.endDate,
    required this.tourPrice,
    required this.tour,
    required this.trip,
    required this.user
  }) : super(key: key);

  @override
  _AddExpensesScreenState createState() => _AddExpensesScreenState();
}

class _AddExpensesScreenState extends State<AddExpensesScreen> {
  final TextEditingController _notesController = TextEditingController();

  @override
  void dispose() {
    _notesController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final int duration = widget.endDate.difference(widget.startDate).inDays;
    double totalExpense = widget.tourPrice * widget.amount; // Total expense
    double dailyExpense =
        duration > 0 ? totalExpense / duration : 0; // Daily expense

    return Scaffold(
      appBar: AppBar(
        title: const Text('Expenses'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
                'Expense per Day: \$${dailyExpense.toStringAsFixed(2)}'), // Changed label
            Text('Amount: ${widget.amount}'), // Display actual amount
            Text('Total Price Trip: ${widget.tourPrice}'),
            const SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: TextField(
                controller: _notesController,
                decoration: const InputDecoration(
                  labelText: 'Enter your feedback/notes',
                  border: OutlineInputBorder(),
                ),
                maxLines: 3, // Allow multiline feedback
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                placeOrder(context, dailyExpense);
              },
              child: const Text('Confirm Booking'),
            ),
          ],
        ),
      ),
    );
  }

  void placeOrder(BuildContext context, double dailyExpense) async {
    String notes = _notesController.text;

    // Create an Expense object with the user's notes
    Expenses expense = Expenses(
      null, // Set expense_id to null, it will be auto-generated
      widget.amount , // Use dailyExpense as the amount (it's already a double)
      dailyExpense.toStringAsFixed(2), // Use dailyExpense as expense_date
      notes, // User's notes
      widget.trip.trip_id!, // Trip ID
      widget.user.user_id!, // User ID
    );

    // Insert the expense into the database
    ExpenseService service = ExpenseService(await getDatabase());
    int newExpenseId = await service.insertExpense(expense);
    // Update the expense object with the new ID
    expense.expense_id = newExpenseId;
    print("Expense booked: ${expense.toMap()}");

    // Navigate to the NavHomeScreen after booking
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(
        builder: (context) => NavHomeScreen(user: widget.user),
      ),
          (route) => false, // Remove all previous routes
    );
  }
}
