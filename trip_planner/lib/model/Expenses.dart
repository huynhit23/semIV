class Expenses {
  int? expense_id;
  int amount; // Changed from int to double
  String expense_date;
  String notes;
  int trip_id;
  int user_id;

  Expenses(this.expense_id, this.amount, this.expense_date, this.notes,
      this.trip_id, this.user_id);

  Map<String, dynamic> toMap() {
    return {
      'expense_id': expense_id,
      'amount': amount,
      'expense_date': expense_date,
      'notes': notes,
      'trip_id': trip_id,
      'user_id': user_id,
    };
  }

  // Add a factory constructor to create an Expense from a map
  factory Expenses.fromMap(Map<String, dynamic> map) {
    return Expenses(
      map['expense_id'],
      map['amount'], // Convert to double
      map['expense_date'],
      map['notes'],
      map['trip_id'],
      map['user_id'],
    );
  }
}
