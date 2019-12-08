import 'package:find_rooms_app/screens/Comments.dart';
import 'package:find_rooms_app/screens/GetStart.dart';
import 'package:find_rooms_app/screens/Home.dart';
import 'package:find_rooms_app/screens/HomePage.dart';
import 'package:find_rooms_app/screens/Login.dart';
import 'package:find_rooms_app/screens/Message.dart';
import 'package:find_rooms_app/screens/NewPost.dart';
import 'package:find_rooms_app/screens/Notifications.dart';
import 'package:find_rooms_app/screens/Profile.dart';
import 'package:find_rooms_app/screens/Register.dart';
import 'package:flutter/material.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      debugShowCheckedModeBanner: false,
      home: GetStart(),
      routes: {
        GetStart.title: (context) => GetStart(),
        Comments.title: (context) => Comments(),
        Home.title: (context) => Home(),
        HomePage.title: (context) => HomePage(),
        Login.title: (context) => Login(),
        Message.title: (context) => Message(),
        NewPost.title: (context) => NewPost(),
        Notifications.title: (context) => Notifications(),
        Profile.title: (context) => Profile(),
        Register.title: (context) => Register(),
      },
    );
  }
}
