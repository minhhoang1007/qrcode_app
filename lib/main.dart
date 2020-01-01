import 'package:flutter/material.dart';
import 'package:qrcode_app/screens/HomeScreen.dart';
import 'package:shared_preferences/shared_preferences.dart';

SharedPreferences prefs;

void main() async {
  prefs = await SharedPreferences.getInstance();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: HomeScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}
