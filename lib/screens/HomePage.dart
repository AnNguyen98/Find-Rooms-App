import 'package:find_rooms_app/screens/Home.dart';
import 'package:find_rooms_app/screens/Notifications.dart';
import 'package:find_rooms_app/screens/Profile.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  static String title = "/homePage";
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with TickerProviderStateMixin {
  TabController controller;
  List<String> titles = [
    "Home",
    "Notifications",
    "Profile",
  ];
  String title = "Home";
  @override
  void initState() {
    super.initState();
    controller = TabController(length: 3, vsync: this);
    controller.addListener(() {
      setState(() {
        title = titles[controller.index];
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          leading: Text(""),
          title: Text(this.title),
        ),
        body: SafeArea(
          child: TabBarView(
            controller: controller,
            children: <Widget>[
              Home(),
              Notifications(),
              Profile(),
            ],
          ),
        ),
        bottomNavigationBar: TabBar(
          controller: controller,
          unselectedLabelColor: Colors.grey,
          unselectedLabelStyle: TextStyle(fontSize: 11),
          labelStyle: TextStyle(fontSize: 13),
          indicatorColor: Colors.white.withAlpha(0),
          labelColor: Colors.blue,
          tabs: <Widget>[
            Tab(
              icon: Icon(
                Icons.home,
              ),
              text: "Home",
            ),
            Tab(
              icon: Icon(CupertinoIcons.bell_solid),
              text: "Notifications",
            ),
            Tab(
              icon: Icon(CupertinoIcons.person_solid),
              text: "Profile",
            ),
          ],
        ));
  }
}
