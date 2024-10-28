import 'package:flutter/material.dart';
import 'package:trip_planner/model/Tours.dart';
import 'package:trip_planner/screen/Trip/add_trip_screen.dart';


import '../../../constants.dart';
import '../../../model/Users.dart';

class BookTrip extends StatefulWidget {
  final Users user;
  final Tours tour;
  const BookTrip({super.key, required this.tour, required this.user});

  @override
  State<BookTrip> createState() => _BookTripState();
}

class _BookTripState extends State<BookTrip> {
  int currentIndex = 1;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15),
      child: Container(
        height: 85,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(50),
          color: Colors.black,
        ),
        padding: const EdgeInsets.symmetric(horizontal: 15),
        alignment: Alignment.center,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Container(
              height: 40,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: Colors.white, width: 2),
              ),
              child: Row(
                children: [
                  IconButton(
                    onPressed: () {
                      if (currentIndex != 1) {
                        setState(() {
                          currentIndex--;
                        });
                      }
                    },
                    iconSize: 18,
                    icon: const Icon(
                      Icons.remove,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(width: 5),
                  Text(
                    currentIndex.toString(),
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(width: 5),
                  IconButton(
                    onPressed: () {
                      setState(() {
                        currentIndex++;
                      });
                    },
                    iconSize: 18,
                    icon: const Icon(
                      Icons.add,
                      color: Colors.white,
                    ),
                  )
                ],
              ),
            ),
            GestureDetector(
              onTap: () {
                // Navigate to the order screen after adding to cart and remove the previous pages from the stack
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => AddTripScreen(
                      user: widget.user,
                      tour: widget.tour,
                      quantity: currentIndex, // Pass the selected quantity
                    ),
                  ),
                       // Remove all previous routes
                );
              },
              child: Container(
                height: 55,
                decoration: BoxDecoration(
                  color: kprimaryColor,
                  borderRadius: BorderRadius.circular(50),
                ),
                alignment: Alignment.center,
                padding: const EdgeInsets.symmetric(horizontal: 50),
                child: const Text(
                  "Book now",
                  style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 20),
                ),
              ),
            )

          ],
        ),
      ),
    );
  }
}
