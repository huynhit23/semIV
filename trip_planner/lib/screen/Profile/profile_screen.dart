import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../../../model/Users.dart';
import '../../../service/user_service.dart';
import '../../../service/data.dart';
import '../Login/sign_in_screen.dart';
import '../Trip/trip_screen.dart';
import 'detail_profile_screen.dart';
import '../Favorite/favorite_screen.dart';

class ProfileScreen extends StatefulWidget {
  final int userId;

  const ProfileScreen({super.key, required this.userId});

  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  late UserService service;
  Users user = Users(
    user_id: 0,
    full_name: "",
    user_name: "",
    email: "",
    password_hash: "",
    avatar: "",
    role: "",
    status: "",
  );

  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    setState(() {
      isLoading = true;
    });
    try {
      service = UserService(await getDatabase());
      var data = await service.getById(widget.userId);
      if (data != null) {
        setState(() {
          user = data;
          isLoading = false;
        });
      }
    } catch (e) {
      print('Error fetching user data: $e');
      setState(() {
        isLoading = false;
      });
    }
  }

  void _logout(BuildContext context) {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => SignInScreen(),
      ),
    );
  }

  void _trip(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => TripScreen(user: user),
      ),
    );
  }
  void _Favorite(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => FavoriteScreen(user: user),
      ),
    );
  }

  void _detailProfile(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => DetailProfileScreen(user.user_id!),
      ),
    ).then((_) => _loadUserData());
  }

  ImageProvider _buildImage(String imagePath) {
    if (imagePath.startsWith('/data/')) {
      return FileImage(File(imagePath));
    } else {
      return AssetImage("assets/images/users/$imagePath");
    }
  }

  @override
  Widget build(BuildContext context) {
    final TextStyle titleStyle =
        const TextStyle(fontSize: 24, fontWeight: FontWeight.bold);
    final TextStyle infoStyle = const TextStyle(fontSize: 16);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Account Information'),
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      CircleAvatar(
                        radius: 50,
                        backgroundImage: _buildImage(user.avatar),
                      ),
                      const SizedBox(width: 16),
                      Text(
                        user.full_name,
                        style: titleStyle,
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  const Divider(),
                  const SizedBox(height: 16),
                  Text('Personal Information', style: titleStyle),
                  const SizedBox(height: 16),
                  GestureDetector(
                    onTap: () => _detailProfile(context),
                    child: _buildRow('User Information', context),
                  ),

                  const SizedBox(height: 16),
                  GestureDetector(
                    onTap: () => _Favorite(context),
                    child: _buildRow('Favorite History', context),
                  ),
                  const SizedBox(height: 16),
                  GestureDetector(
                    onTap: () => _trip(context),
                    child: _buildRow('Trip history', context),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Text('Version', style: infoStyle),
                      const Spacer(),
                      Text('0.1', style: infoStyle),
                    ],
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () => _logout(context),
                    child: const Text('Log Out'),
                  ),
                ],
              ),
            ),
    );
  }

  Widget _buildRow(String title, BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(title, style: const TextStyle(fontSize: 16)),
        Text('>', style: const TextStyle(fontSize: 16)),
      ],
    );
  }
}
