import 'dart:io';

import 'package:find_rooms_app/model/User.dart';
import 'package:find_rooms_app/screens/ChangePassword.dart';
import 'package:find_rooms_app/screens/EditInformation.dart';
import 'package:find_rooms_app/ui/uiHelper.dart';
import 'package:find_rooms_app/until/AuthHelper.dart';
import 'package:find_rooms_app/until/database.dart';
import 'package:find_rooms_app/widgets/CircleButton.dart';
import 'package:find_rooms_app/widgets/InformationUser.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class Profile extends StatefulWidget {
  static String title = "/profile";
  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  User user;

  @override
  void initState() {
    super.initState();
    _currentUser();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: ListView(
        children: <Widget>[
          Stack(
            children: <Widget>[
              Container(
                height: 150,
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: user != null && user.coverUrl != null
                        ? NetworkImage(user.coverUrl)
                        : AssetImage("images/cover-image.jpeg"),
                    fit: BoxFit.cover,
                  ),
                ),
                child: Align(
                  alignment: Alignment.bottomRight,
                  child: IconButton(
                    onPressed: _updateCoverPhoto,
                    color: Colors.white,
                    icon: Icon(FontAwesomeIcons.cameraRetro),
                  ),
                ),
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
                    backgroundColor: Colors.white,
                    backgroundImage: user == null
                        ? AssetImage("images/avatar-default.png")
                        : NetworkImage(user.avatarUrl),
                    child: Align(
                      alignment: Alignment.bottomCenter,
                      child: Container(
                        margin: EdgeInsets.only(left: 80),
                        child: IconButton(
                          onPressed: _updateAvatar,
                          color: Colors.grey,
                          iconSize: 20,
                          icon: Icon(Icons.add_a_photo),
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
                user != null ? user.fullName : "",
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
                  backgroundColor: Colors.blueGrey,
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ChangePassword(),
                      ),
                    );
                  },
                  iconSize: 26,
                  icon: Icons.more_horiz,
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
          InformationUser(
            title: "Address:",
            value: user != null ? user.address : "",
          ),
          InformationUser(
            title: "Phone:",
            value: user != null ? user.phoneNumber : "",
          ),
          InformationUser(
            title: "Gender:",
            value: user != null && user.gender != null && user.gender
                ? "Male"
                : "Female",
          ),
          Container(
            height: 40,
            margin: EdgeInsets.only(bottom: 10, left: 20, right: 20, top: 30),
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

  _updateCoverPhoto() async {
    File fileImage = await UIHelper.handleGetPhoto();
    await DatabaseHelper.updateCoverPhoto(fileImage, context);
  }

  _updateAvatar() async {
    File fileImage = await UIHelper.handleGetPhoto();
    await DatabaseHelper.updateAvatar(context, fileImage);
  }

  _currentUser() async {
    await DatabaseHelper.getCurrentUser((userRes) {
      setState(() {
        user = userRes;
      });
    });
  }

  _handleSignOut() async {
    await AuthHelper.signOut();
    Navigator.pop(context);
  }
}
