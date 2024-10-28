import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../../model/Users.dart';
import '../../service/data.dart';
import '../../service/login_service.dart';

class RegisterScreen extends StatefulWidget {
  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  late LoginService loginService;
  final _formKey = GlobalKey<FormState>();

  TextEditingController _fullNameController = TextEditingController();
  TextEditingController _userNameController = TextEditingController();
  TextEditingController _emailController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();

  File? _avatarImage;
  final picker = ImagePicker();

  @override
  void initState() {
    super.initState();
    connectDatabase();
  }

  connectDatabase() async {
    loginService = LoginService(await getDatabase());
  }

  Future<void> _pickImage() async {
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    setState(() {
      if (pickedFile != null) {
        _avatarImage = File(pickedFile.path);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Register User')),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                TextFormField(
                  controller: _fullNameController,
                  decoration: InputDecoration(labelText: 'Full Name'),
                  validator: (value) => value!.isEmpty ? 'Please enter your full name' : null,
                ),
                TextFormField(
                  controller: _userNameController,
                  decoration: InputDecoration(labelText: 'Username'),
                  validator: (value) => value!.isEmpty ? 'Please enter a username' : null,
                ),
                TextFormField(
                  controller: _emailController,
                  decoration: InputDecoration(labelText: 'Email'),
                  validator: (value) => (value!.isEmpty || !value.contains('@')) ? 'Please enter a valid email' : null,
                ),
                TextFormField(
                  controller: _passwordController,
                  decoration: InputDecoration(labelText: 'Password'),
                  obscureText: true,
                  validator: (value) => value!.isEmpty ? 'Please enter a password' : null,
                ),
                ElevatedButton(onPressed: _pickImage, child: Text('Select Avatar')),
                if (_avatarImage != null) Image.file(_avatarImage!, height: 100),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 16.0),
                  child: ElevatedButton(
                    onPressed: () async {
                      if (_formKey.currentState!.validate()) {
                        Users newUser = Users(
                          full_name: _fullNameController.text,
                          user_name: _userNameController.text,
                          email: _emailController.text,
                          password_hash: _passwordController.text,
                          avatar: _avatarImage?.path ?? '',
                          role: 'user',
                          status: 'validity',
                        );

                        await loginService.insert(newUser);
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('User registered successfully!')));
                        // Clear form fields
                        _fullNameController.clear();
                        _userNameController.clear();
                        _emailController.clear();
                        _passwordController.clear();
                        setState(() { _avatarImage = null; });
                      }
                    },
                    child: Text('Register'),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

