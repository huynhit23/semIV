import 'package:flutter/material.dart';
import 'package:trip_planner/screen/admin/Trip/ad_trip_screen.dart';
import '../../constants.dart';
import '../../model/Users.dart';
import 'Profile/ad_profile.dart';
import 'Tour/ad_tour_screen.dart';
import 'account/account_screen.dart';
import 'ad_home_screen.dart';

class AdNavHomeScreen extends StatefulWidget {
  final Users user;

  const AdNavHomeScreen({super.key, required this.user});

  @override
  State<AdNavHomeScreen> createState() => _AdNavHomeScreenState();
}

class _AdNavHomeScreenState extends State<AdNavHomeScreen> {
  int currentIndex = 2;
  late final List<Widget> screens;

  @override
  void initState() {
    super.initState();
    screens = [
      const AdTourScreen(),
      const AdTripScreen(),
      const AdHomeScreen(),
      const AccountScreen(),
      AdProfile(user: widget.user),
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
                Icons.tour,
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
                Icons.trip_origin,
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
      body: screens[currentIndex],
    );
  }
}
