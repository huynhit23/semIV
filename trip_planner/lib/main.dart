import 'package:flutter/material.dart';
import 'package:trip_planner/screen/Login/sign_in_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Trip Planner',
      debugShowCheckedModeBanner: false,
      home: SignInScreen(),
    );
  }
}
