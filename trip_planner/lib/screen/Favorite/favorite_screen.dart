import 'package:flutter/material.dart';
import 'package:trip_planner/model/Tours.dart';
import 'package:trip_planner/screen/Detail/detail_screen.dart';
import 'package:trip_planner/service/favorite_service.dart';
import '../../../model/Users.dart';

class FavoriteScreen extends StatefulWidget {
  final Users user;

  const FavoriteScreen({Key? key, required this.user}) : super(key: key);

  @override
  _FavoriteScreenState createState() => _FavoriteScreenState();
}

class _FavoriteScreenState extends State<FavoriteScreen> {
  late Future<List<Tours>> _favoriteTours;
  final FavoriteService _favoriteService = FavoriteService();

  @override
  void initState() {
    super.initState();
    _loadFavoriteTours();
  }

  void _loadFavoriteTours() {
    setState(() {
      _favoriteTours =
          _favoriteService.getFavoriteToursByUserId(widget.user.user_id!);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Your Favorite Tours'),
      ),
      body: FutureBuilder<List<Tours>>(
        future: _favoriteTours,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No favorite tours found.'));
          } else {
            final favoriteTours = snapshot.data!;
            return ListView.builder(
              itemCount: favoriteTours.length,
              itemBuilder: (context, index) {
                final tour = favoriteTours[index];
                return ListTile(
                  leading: Image.asset(
                    "assets/images/tours/${tour.image}",
                    width: 50,
                    height: 50,
                    fit: BoxFit.cover,
                  ),
                  title: Text(tour.tour_name),
                  subtitle: Text("${tour.tour_price} USD"),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: Icon(Icons.delete),
                        onPressed: () {
                          showConfirm(context, tour.tour_id, widget.user.user_id!);
                        },
                      ),
                    ],
                  ),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            DetailScreen(tour: tour, user: widget.user),
                      ),
                    );
                  },
                );
              },
            );
          }
        },
      ),
    );
  }

  void showConfirm(BuildContext context, int tourId, int userId) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Delete favorite tours?'),
          content: Text('Are you sure you want to delete this favorite tours???'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text('No'),
            ),
            TextButton(
              onPressed: () async {
                await _favoriteService.removeFavorite(tourId, userId);
                _loadFavoriteTours(); // Refresh the list after deletion
                Navigator.pop(context);
              },
              child: Text('Yes'),
            ),
          ],
        );
      },
    );
  }
}
