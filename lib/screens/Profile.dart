import 'package:find_rooms_app/screens/EditInformation.dart';
import 'package:find_rooms_app/widgets/CircleButton.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Profile extends StatefulWidget {
  static String title = "/profile";
  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
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
                  iconSize: 20,
                  icon: FontAwesomeIcons.userEdit,
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
          Spacer(),
          Container(
            height: 40,
            margin: EdgeInsets.only(bottom: 10, left: 20, right: 20),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: Colors.red, width: 1),
            ),
            child: MaterialButton(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              child: Row(
                children: <Widget>[
                  Icon(
                    FontAwesomeIcons.signOutAlt,
                    color: Colors.red,
                    size: 20,
                  ),
                  SizedBox(
                    width: 40,
                  ),
                  Text(
                    "Log Out",
                    style: TextStyle(
                      color: Colors.red,
                    ),
                  )
                ],
              ),
              onPressed: _handleSignOut,
            ),
          )
        ],
      ),
    );
  }

  _handleSignOut() async {
    _auth.signOut();
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString("email", "");
    prefs.setString("uid", null);
    prefs.setString("user_token", "");
    Navigator.pop(context);
  }
}
