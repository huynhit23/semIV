class Tours {
  int tour_id;
  String tour_name;
  String image;
  int time;
  String destination;
  String schedule;
  String nation;
  double tour_price;

  Tours(this.tour_id, this.tour_name, this.image, this.time, this.destination,
      this.schedule, this.nation, this.tour_price);

  Map<String, Object?> toMap() {
    return {
      'tour_id': tour_id,
      'tour_name': tour_name,
      'image': image,
      'time': time,
      'destination': destination,
      'schedule': schedule,
      'nation': nation,
      'tour_price': tour_price,
    };
  }
}
