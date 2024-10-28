import 'dart:io';

import 'package:flutter/material.dart';

import '../../../model/Users.dart';
import '../../../service/data.dart';
import '../../../service/user_service.dart';
import 'edit_profile_screen.dart';

class DetailProfileScreen extends StatefulWidget {
  final int userId;

  DetailProfileScreen(this.userId);

  @override
  _DetailProfileScreenState createState() => _DetailProfileScreenState();
}

class _DetailProfileScreenState extends State<DetailProfileScreen> {
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

  // Loading state
  bool isLoading = true;

  Future<void> getUser() async {
    try {
      service = UserService(await getDatabase());
      var data = await service.getById(widget.userId);
      if (data != null) {
        setState(() {
          user = data;
          isLoading = false; // Set loading to false after data is loaded
        });
      }
    } catch (e) {
      // Handle error
      print('Error fetching user data: $e');
      setState(() {
        isLoading = false; // Also set loading to false in case of error
      });
    }
  }

  @override
  void initState() {
    super.initState();
    getUser();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("User Profile"),
        actions: [
          IconButton(
            icon: Icon(Icons.edit),
            onPressed: () => _editProfile(context),
          ),
        ],
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator()) // Show loading spinner
          : SingleChildScrollView(
        child: Container(
          margin: EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildAvatarSection(user.avatar),
              _buildInfoRow('User ID', '${user.user_id}'),
              _buildInfoRow('Full Name', user.full_name),
              _buildInfoRow('Username', user.user_name),
              _buildInfoRow('Email', user.email),
              _buildInfoRow('Role', user.role),
              _buildInfoRow('Status', user.status),
            ],
          ),
        ),
      ),
    );
  }

  void _editProfile(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => EditProfileScreen(widget.userId),
      ),
    ).then((_) {
      getUser();
    });;
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 100,
            child: Text(
              label,
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
          Expanded(
            child: Text(value),
          ),
        ],
      ),
    );
  }

  Widget _buildAvatarSection(String imagePath) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16.0),
      child: Center(
        child: Column(
          children: [
            CircleAvatar(
              radius: 60,
              backgroundImage: imagePath.startsWith('/data/')
                  ? FileImage(File(imagePath))
                  : AssetImage("assets/images/users/$imagePath") as ImageProvider,
              onBackgroundImageError: (exception, stackTrace) {
                print('Error loading avatar: $exception');
              },
            ),
            SizedBox(height: 16),
            Text(
              user.full_name,
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }
}
