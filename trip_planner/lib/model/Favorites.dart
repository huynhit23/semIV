class Favorites {
  int tour_id;
  int user_id;

  Favorites(this.tour_id, this.user_id);

  Map<String, Object?> toMap() {
    return {
      'tour_id': tour_id,
      'user_id': user_id,
    };
  }
}
