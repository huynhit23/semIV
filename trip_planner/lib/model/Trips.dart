class Trips {
  int? trip_id;
  String trip_name;
  DateTime start_date;
  DateTime end_date;
  String destination;
  double budget;
  String status;
  int tour_id;
  int user_id;

  Trips(this.trip_id, this.trip_name, this.start_date, this.end_date,
      this.destination, this.budget, this.status, this.tour_id, this.user_id);

  Map<String, dynamic> toMap() {
    return {
      'trip_id': trip_id,
      'trip_name': trip_name,
      'start_date': start_date.toIso8601String(),
      'end_date': end_date.toIso8601String(),
      'destination': destination,
      'total_price': budget,
      'status': status,
      'tour_id': tour_id,
      'user_id': user_id,
    };
  }
}
