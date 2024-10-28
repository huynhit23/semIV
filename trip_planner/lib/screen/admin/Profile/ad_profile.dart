import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../../../model/Users.dart';
import '../../Login/sign_in_screen.dart';

class AdProfile extends StatelessWidget {
  final Users user;

  const AdProfile({super.key, required this.user});

  void _logout(BuildContext context) {
    // Clear session data if necessary
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => SignInScreen(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final TextStyle titleStyle =
        TextStyle(fontSize: 24, fontWeight: FontWeight.bold);

    return Scaffold(
      appBar: AppBar(
        title: Text('Account Information Page'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                CircleAvatar(
                  radius: 50,
                  backgroundImage: AssetImage('assets/images/${user.avatar}'),
                ),
                SizedBox(width: 16),
                Text(
                  user.full_name,
                  style: titleStyle,
                ),
              ],
            ),
            SizedBox(height: 16),
            Divider(),
            SizedBox(height: 16),
            Text('Personal information', style: titleStyle),
            SizedBox(height: 16),
            _buildInfoRow('User ID', '${user.user_id}'),
            _buildInfoRow('Full Name', user.full_name),
            _buildInfoRow('Username', user.user_name),
            _buildInfoRow('Email', user.email),
            _buildInfoRow('Role', user.role),
            _buildInfoRow('Status', user.status),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: () => _logout(context),
              child: Text('Log out'),
            ),
          ],
        ),
      ),
    );
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
}
