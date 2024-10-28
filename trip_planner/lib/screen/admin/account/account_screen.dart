import 'package:flutter/material.dart';
import 'dart:io';
import '../../../model/Users.dart';
import '../../../service/User_Service.dart';
import '../../../service/data.dart';
import 'detail_account_screen.dart';
import 'edit_account_form_screen.dart';

class AccountScreen extends StatefulWidget {
  const AccountScreen({super.key});
  @override
  _AccountScreenState createState() => _AccountScreenState();
}

class _AccountScreenState extends State<AccountScreen> {
  List<Users> users = [];
  late UserService service;

  Future<void> getUsers() async {
    try {
      service = UserService(await getDatabase());
      var data = await service.getAll();

      // Print data for debugging
      print("Fetched users: $data");

      setState(() {
        // Filter users to include only those with the role "user"
        users = data.where((user) => user.role == 'user').toList();
      });
    } catch (e) {
      print("Error getting users: $e");
    }
  }

  @override
  void initState() {
    super.initState();
    getUsers();
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
    return Scaffold(
      appBar: AppBar(
        title: const Text('User account list page'),
      ),
      body: ListView.builder(
        itemCount: users.length,
        itemBuilder: (context, index) {
          final user = users[index];
          return ListTile(
            leading: CircleAvatar(
              radius: 40,
              backgroundImage: _buildImage(user.avatar),
            ),
            title: Text(
              user.full_name,
              overflow: TextOverflow.ellipsis,
            ),
            subtitle: Text(
              'Email: ${user.email}',
              overflow: TextOverflow.ellipsis,
            ),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  icon: Icon(Icons.edit),
                  onPressed: user.user_id != null
                      ? () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  EditAccountFormScreen(user.user_id!),
                            ),
                          ).then((_) {
                            getUsers();
                          });
                        }
                      : null,
                ),
              ],
            ),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => DetailAccountScreen(user.user_id!),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
