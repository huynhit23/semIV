class Comments {
  final int? comment_id;
  final String content;
  final int tour_id;
  final int user_id;
  final String? fullName; // New field for full name

  Comments(this.comment_id, this.content, this.tour_id, this.user_id, {this.fullName});
}
