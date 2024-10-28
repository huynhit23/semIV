import 'dart:io';
import 'package:flutter/material.dart';
import 'package:trip_planner/service/favorite_service.dart';
import '../../../model/Tours.dart';
import '../../../model/Users.dart';
import '../../Detail/detail_screen.dart';

class ProductCard extends StatefulWidget {
  final Users user;
  final Tours tour;
  const ProductCard({super.key, required this.tour, required this.user});

  @override
  _ProductCardState createState() => _ProductCardState();
}

class _ProductCardState extends State<ProductCard> {
  bool isFavorite = false;
  final FavoriteService favoriteService = FavoriteService();

  @override
  void initState() {
    super.initState();
    _checkIfFavorite();
  }

  Future<void> _checkIfFavorite() async {
    final favoriteStatus = await favoriteService.isFavorite(widget.tour.tour_id, widget.user.user_id!);
    setState(() {
      isFavorite = favoriteStatus;
    });
  }

  void _toggleFavorite() async {
    setState(() {
      isFavorite = !isFavorite;
    });

    if (isFavorite) {
      await favoriteService.addFavorite(widget.tour, widget.user);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Added to favorites successfully!')),
      );
    } else {
      await favoriteService.removeFavorite(widget.tour.tour_id, widget.user.user_id!);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Removed from favorites!')),
      );
    }
  }


  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => DetailScreen(tour: widget.tour, user: widget.user),
          ),
        );
      },
      child: Stack(
        children: [
          Container(
            width: double.infinity,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              color: Colors.white,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 5),
                Center(
                  child: Hero(
                    tag: widget.tour.image,
                    child: _buildTourImage(widget.tour.image),
                  ),
                ),
                const SizedBox(height: 10),
                Padding(
                  padding: const EdgeInsets.only(left: 10),
                  child: Text(
                    widget.tour.tour_name,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                Padding(
                  padding: const EdgeInsets.only(left: 10, right: 10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "${widget.tour.tour_price} USD",
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.red,
                          fontSize: 20,
                        ),
                      ),
                      IconButton(
                        icon: Icon(
                          isFavorite ? Icons.favorite : Icons.favorite_border,
                          color: isFavorite ? Colors.red : Colors.grey,
                        ),
                        onPressed: _toggleFavorite,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTourImage(String imagePath) {
    if (imagePath.startsWith('/data/')) {
      // If it's an asset image
      return Image.file(
        File(imagePath),
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) {
          return const Icon(Icons.error);
        },
      );
    } else {
      return Image.asset(
        "assets/images/tours/$imagePath",
        fit: BoxFit.cover,
      );
    }
  }

}
