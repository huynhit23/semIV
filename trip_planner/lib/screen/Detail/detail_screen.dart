import 'dart:io';
import 'package:flutter/material.dart';
import '../../constants.dart';
import '../../model/Tours.dart';
import '../../model/Users.dart';
import '../../model/Comments.dart';
import '../../service/comment_service.dart';
import '../../service/data.dart';
import 'Widget/detail_app_bar.dart';
import 'Widget/items_details.dart';
import 'Widget/book_trip.dart';

class DetailScreen extends StatefulWidget {
  final Users user;
  final Tours tour;

  const DetailScreen({super.key, required this.tour, required this.user});

  @override
  _DetailScreenState createState() => _DetailScreenState();
}

class _DetailScreenState extends State<DetailScreen> {
  late CommentService _commentService;
  List<Comments> _comments = [];
  final TextEditingController _commentController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _initCommentService();
  }

  void _initCommentService() async {
    final db = await getDatabase();
    _commentService = CommentService(db);
    _loadComments();
  }

  void _loadComments() async {
    final data = await _commentService.getCommentsByTourId(widget.tour.tour_id);
    final List<Comments> commentsWithUserDetails = [];

    for (var comment in data) {
      // Assuming you have a method to get user details by ID
      final user = await _commentService.getUserById(comment.user_id); // Modify this as needed
      commentsWithUserDetails.add(Comments(
        comment.comment_id,
        comment.content,
        comment.tour_id,
        comment.user_id,
        fullName: user.full_name, // Assuming `full_name` is a property of your User model
      ));
    }

    setState(() {
      _comments = commentsWithUserDetails;
    });
  }


  Future<void> _addComment() async {
    if (_commentController.text.isNotEmpty) {
      final newComment = Comments(
        null,
        _commentController.text,
        widget.tour.tour_id,
        widget.user.user_id!,
      );

      int commentId = await _commentService.insertComment(newComment);

      setState(() {
        _comments.add(Comments(commentId, newComment.content, newComment.tour_id, newComment.user_id));
      });

      _commentController.clear();
    }
  }

  void _showDeleteConfirmation(int commentId) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Delete Comment?'),
          content: Text('Are you sure you want to delete this comment?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text('No'),
            ),
            TextButton(
              onPressed: () async {
                await _commentService.removeComment(commentId);
                _loadComments();
                Navigator.pop(context);
              },
              child: Text('Yes'),
            ),
          ],
        );
      },
    );
  }

  void _showEditDialog(Comments comment) {
    final TextEditingController editController = TextEditingController(text: comment.content);

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Edit Comment'),
          content: TextField(
            controller: editController,
            decoration: InputDecoration(hintText: 'Enter your updated comment'),
            maxLines: 3,
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text('Cancel'),
            ),
            TextButton(
              onPressed: () async {
                if (editController.text.isNotEmpty) {
                  final updatedComment = Comments(
                    comment.comment_id,
                    editController.text,
                    comment.tour_id,
                    comment.user_id,
                  );
                  await _commentService.updateComment(updatedComment);
                  _loadComments();
                  Navigator.pop(context);
                }
              },
              child: Text('Save'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kcontentColor,
      floatingActionButton: BookTrip(tour: widget.tour, user: widget.user),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              DetailAppBar(tour: widget.tour),
              _buildImageSection(widget.tour.image),
              const SizedBox(height: 20),
              _buildTourDetails(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTourDetails() {
    return Container(
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
          ItemsDetails(tour: widget.tour),
          const SizedBox(height: 25),
          Text(
            widget.tour.tour_name,
            style: const TextStyle(
                fontWeight: FontWeight.bold, color: Colors.blue, fontSize: 20),
          ),
          const SizedBox(height: 25),
          _buildTourSchedule(),
          const SizedBox(height: 25),
          _buildVisaInfo(),
          const SizedBox(height: 25),
          _buildGuideInfo(),
          const SizedBox(height: 25),
          _buildCommentsSection(),
          const SizedBox(height: 150),
        ],
      ),
    );
  }

  Widget _buildCommentsSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text("Comments",
            style: TextStyle(
                fontWeight: FontWeight.bold, color: Colors.blue, fontSize: 20)),
        const SizedBox(height: 10),
        _comments.isNotEmpty
            ? ListView.builder(
          shrinkWrap: true,
          physics: NeverScrollableScrollPhysics(),
          itemCount: _comments.length,
          itemBuilder: (context, index) {
            final comment = _comments[index];
            return Card(
              child: ListTile(
                title: Text(comment.fullName ?? widget.user.full_name), // Display full name
                subtitle: Text(comment.content),
                trailing: comment.user_id == widget.user.user_id
                    ? Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      icon: Icon(Icons.edit),
                      onPressed: () {
                        _showEditDialog(comment);
                      },
                    ),
                    IconButton(
                      icon: Icon(Icons.delete),
                      onPressed: () {
                        _showDeleteConfirmation(comment.comment_id!);
                      },
                    ),
                  ],
                )
                    : null,
              ),
            );
          },
        )
            : const Text("No comments yet.",
            style: TextStyle(fontStyle: FontStyle.italic)),
        const SizedBox(height: 10),
        TextField(
          controller: _commentController,
          decoration: InputDecoration(
            hintText: 'Add a comment...',
            suffixIcon: IconButton(
              icon: const Icon(Icons.send),
              onPressed: _addComment,
            ),
          ),
        ),
      ],
    );
  }



  Widget _buildTourSchedule() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text("Tour program",
            style: TextStyle(
                fontWeight: FontWeight.bold, color: Colors.blue, fontSize: 20)),
        const SizedBox(height: 10),
        _buildFormattedSchedule(widget.tour.schedule),
      ],
    );
  }

  Widget _buildVisaInfo() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text("Visa Information",
            style: TextStyle(
                fontWeight: FontWeight.bold, color: Colors.blue, fontSize: 20)),
        const SizedBox(height: 10),
        const Text(
            "- A valid Vietnamese passport is required with at least 6 months validity.",
            style: TextStyle(fontSize: 16)),
        const SizedBox(height: 10),
        const Text("- Visa exemption for Vietnamese nationals.",
            style: TextStyle(fontSize: 16)),
      ],
    );
  }

  Widget _buildGuideInfo() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text("Guide Information",
            style: TextStyle(
                fontWeight: FontWeight.bold, color: Colors.blue, fontSize: 20)),
        const SizedBox(height: 10),
        const Text("- The guide will contact you 2-3 days before departure.",
            style: TextStyle(fontSize: 16)),
      ],
    );
  }

  Widget _buildFormattedSchedule(String schedule) {
    final RegExp dayRegex = RegExp(r'DAY \d+:', caseSensitive: false);
    final List<TextSpan> textSpans = [];

    schedule.split('\n').forEach((line) {
      if (dayRegex.hasMatch(line)) {
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

  Widget _buildImageSection(String imagePath) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
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
                      return const Icon(Icons.error);
                    },
                  ),
          ),
        ],
      ),
    );
  }
}
