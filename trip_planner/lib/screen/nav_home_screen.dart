import 'package:flutter/material.dart';
import '../constants.dart';
import '../model/Users.dart';
import 'About/about_us.dart';
import 'Contact/contact_us.dart';
import 'Trip/trip_screen.dart';
import 'Home/home_screen.dart';
import 'Profile/profile_screen.dart';

class NavHomeScreen extends StatefulWidget {
  final Users user;

  const NavHomeScreen({super.key, required this.user});

  @override
  State<NavHomeScreen> createState() => _NavHomeScreenState();
}

class _NavHomeScreenState extends State<NavHomeScreen> {
  int currentIndex = 2;
  late final List<Widget> screens;

  @override
  void initState() {
    super.initState();
    screens = [
      const ContactUs(),
      TripScreen(user: widget.user),  // Pass the user here
      HomeScreen(user: widget.user),
      const AboutUs(),
      ProfileScreen(userId: widget.user.user_id!),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          setState(() {
            currentIndex = 2;
          });
        },
        shape: const CircleBorder(),
        backgroundColor: kprimaryColor,
        child: const Icon(
          Icons.home,
          color: Colors.white,
          size: 35,
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: BottomAppBar(
        elevation: 1,
        height: 60,
        color: Colors.white,
        shape: const CircularNotchedRectangle(),
        notchMargin: 10,
        clipBehavior: Clip.antiAliasWithSaveLayer,
        child: Row(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            IconButton(
              onPressed: () {
                setState(() {
                  currentIndex = 0;
                });
              },
              icon: Icon(
                Icons.contact_phone,
                size: 30,
                color: currentIndex == 0 ? kprimaryColor : Colors.grey.shade400,
              ),
            ),
            IconButton(
              onPressed: () {
                setState(() {
                  currentIndex = 1;
                });
              },
              icon: Icon(
                Icons.near_me,
                size: 30,
                color: currentIndex == 1 ? kprimaryColor : Colors.grey.shade400,
              ),
            ),
            const SizedBox(width: 15),
            IconButton(
              onPressed: () {
                setState(() {
                  currentIndex = 3;
                });
              },
              icon: Icon(
                Icons.contact_page,
                size: 30,
                color: currentIndex == 3 ? kprimaryColor : Colors.grey.shade400,
              ),
            ),
            IconButton(
              onPressed: () {
                setState(() {
                  currentIndex = 4;
                });
              },
              icon: Icon(
                Icons.person,
                size: 30,
                color: currentIndex == 4 ? kprimaryColor : Colors.grey.shade400,
              ),
            ),
          ],
        ),
      ),
      body: screens[currentIndex], // Use currentIndex to select screen
    );
  }
}
