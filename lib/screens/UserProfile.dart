import 'package:find_rooms_app/screens/EditInformation.dart';
import 'package:find_rooms_app/widgets/CircleButton.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class UserProfile extends StatefulWidget {
  static String title = "/userProfile";
  @override
  _UserProfileState createState() => _UserProfileState();
}

class _UserProfileState extends State<UserProfile> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: ListView(
        children: <Widget>[
          Stack(
            children: <Widget>[
              Container(
                height: 150,
                color: Colors.green,
              ),
              Container(
                margin: EdgeInsets.only(top: 90),
                alignment: Alignment.bottomCenter,
                child: Container(
                  width: 120,
                  height: 120,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(60),
                    border: Border.all(
                      width: 4,
                      color: Colors.white,
                    ),
                  ),
                  child: CircleAvatar(
                    radius: 60,
                    child: Align(
                      alignment: Alignment.bottomCenter,
                      child: Container(
                        margin: EdgeInsets.only(left: 90),
                        child: IconButton(
                          onPressed: () {},
                          icon: Icon(Icons.camera_alt),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
          Divider(),
          Container(
            margin: EdgeInsets.only(top: 10),
            child: Center(
              child: Text(
                "An Nguyễn",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                ),
              ),
            ),
          ),
          Container(
            margin: EdgeInsets.only(top: 40),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                CircleButton(
                  color: Colors.white,
                  backgroundColor: Colors.green,
                  onPressed: () {},
                  icon: Icons.call,
                ),
                CircleButton(
                  color: Colors.white,
                  backgroundColor: Colors.green,
                  onPressed: () {},
                  iconSize: 20,
                  icon: false
                      ? FontAwesomeIcons.userPlus
                      : FontAwesomeIcons.userCheck,
                ),
                CircleButton(
                  color: Colors.white,
                  backgroundColor: Colors.grey,
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => EditInformation(),
                      ),
                    );
                  },
                  icon: Icons.more_horiz,
                )
              ],
            ),
          ),
          Card(
            margin: EdgeInsets.only(top: 20, left: 20, right: 20),
            child: Container(
              alignment: Alignment.center,
              height: 50,
              child: Row(
                children: <Widget>[
                  Container(
                    margin: EdgeInsets.only(left: 50, right: 20),
                    child: Text("Address:"),
                  ),
                  Text(
                    "Đà Nẵng",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),
          ),
          Card(
            margin: EdgeInsets.only(top: 20, left: 20, right: 20),
            child: Container(
              alignment: Alignment.center,
              height: 50,
              child: Row(
                children: <Widget>[
                  Container(
                    margin: EdgeInsets.only(left: 50, right: 20),
                    child: Text("Follower:"),
                  ),
                  Text(
                    "60 peoples",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
