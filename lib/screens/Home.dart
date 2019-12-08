import 'dart:async';

import 'package:connectivity/connectivity.dart';
import 'package:find_rooms_app/screens/Comments.dart';
import 'package:find_rooms_app/screens/Message.dart';
import 'package:find_rooms_app/screens/NewPost.dart';
import 'package:find_rooms_app/widgets/GridImages.dart';
import 'package:find_rooms_app/widgets/NewPostButton.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class Home extends StatefulWidget {
  static String title = "/home";
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey =
      GlobalKey<RefreshIndicatorState>();
  Future<void> _onRefreshData() {
    _refreshIndicatorKey.currentState.show();
    return null;
  }

  StreamSubscription subscription;

  @override
  void initState() {
    super.initState();
    _handleCheckNetwork();
//    _getCurrentUser();
    subscription = Connectivity()
        .onConnectivityChanged
        .listen((ConnectivityResult result) {
      if (result == ConnectivityResult.none) {
        Scaffold.of(context).showSnackBar(
          SnackBar(
            content: Text("No network!"),
            action: SnackBarAction(
              label: "OK",
              textColor: Colors.blue,
              onPressed: () {
                Scaffold.of(context).hideCurrentSnackBar();
              },
            ),
          ),
        );
      } else if (result == ConnectivityResult.wifi ||
          result == ConnectivityResult.mobile) {
        Scaffold.of(context).showSnackBar(
          SnackBar(
            content: Text("You are online!"),
            action: SnackBarAction(
              label: "OK",
              textColor: Colors.blue,
              onPressed: () {
                Scaffold.of(context).hideCurrentSnackBar();
              },
            ),
          ),
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: RefreshIndicator(
          key: _refreshIndicatorKey,
          onRefresh: _onRefreshData,
          child: ListView.builder(
            physics: AlwaysScrollableScrollPhysics(),
            itemCount: 10,
            itemBuilder: (context, index) {
              if (index == 0) {
                return NewPostButton(
                  onPressedNewPost: () {
                    Navigator.push(
                      context,
                      CupertinoPageRoute(
                        fullscreenDialog: true,
                        builder: (context) => NewPost(),
                      ),
                    );
                  },
                  onPressedAvatar: () {},
                );
              } else if (index == 1) {
                return Container(
                  height: 80,
                  color: Colors.cyan,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: 10,
                    itemBuilder: (context, index) {
                      return GestureDetector(
                        onTap: () {
                          print("OK");
                        },
                        child: Container(
                          margin: EdgeInsets.symmetric(horizontal: 3),
                          child: CircleAvatar(
                            radius: 25,
                            backgroundColor: Colors.red,
                          ),
                        ),
                      );
                    },
                  ),
                );
              } else {
                return Container(
                  child: Column(
                    children: <Widget>[
                      Row(
                        children: <Widget>[
                          Container(
                            margin: EdgeInsets.only(right: 5, left: 10),
                            child: CircleAvatar(
                              backgroundColor: Colors.yellow,
                            ),
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Text(
                                "An Nguyễn",
                                style: TextStyle(
                                  color: Colors.blueAccent,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Row(
                                children: <Widget>[
                                  Text(
                                    "1hr",
                                    style: TextStyle(color: Colors.grey),
                                  ),
                                  GestureDetector(
                                    onTap: () {
                                      print("ICON");
                                    },
                                    child: Container(
                                      margin: EdgeInsets.only(left: 10),
                                      child: Icon(
                                        Icons.people,
                                        size: 18,
                                        color: Colors.grey,
                                      ),
                                    ),
                                  )
                                ],
                              )
                            ],
                          ),
                          Spacer(),
                          IconButton(
                            icon: Icon(Icons.more_horiz),
                            onPressed: () {},
                          )
                        ],
                      ),
                      Container(
                        margin: EdgeInsets.symmetric(horizontal: 10),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Container(
                              margin: EdgeInsets.only(bottom: 10, top: 5),
                              child: Text(
                                "Chụp ảnh chung với Cán bộ coi thi ICPC ASIA 2019",
                                style: TextStyle(
                                  fontSize: 12,
                                ),
                              ),
                            ),
                            GridImages(),
                          ],
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.only(top: 5, left: 10, right: 10),
                        child: Row(
                          children: <Widget>[
                            Icon(Icons.favorite),
                            Text("24"),
                            Spacer(),
                            Text("20"),
                            Text(" comments")
                          ],
                        ),
                      ),
                      Container(
                        height: 40,
                        child: Row(
                          children: <Widget>[
                            IconButton(
                              onPressed: () {},
                              icon: Icon(FontAwesomeIcons.thumbsUp),
                            ),
                            IconButton(
                              padding: EdgeInsets.all(0),
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  CupertinoPageRoute(
                                    fullscreenDialog: true,
                                    builder: (context) => Comments(),
                                  ),
                                );
                              },
                              icon: Icon(FontAwesomeIcons.comments),
                            ),
                            IconButton(
                              padding: EdgeInsets.all(0),
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  CupertinoPageRoute(
                                    builder: (context) => Message(),
                                  ),
                                );
                              },
                              icon: Icon(FontAwesomeIcons.facebookMessenger),
                            )
                          ],
                        ),
                      ),
                      Divider(
                        color: Colors.black38,
                      )
                    ],
                  ),
                );
              }
            },
          ),
        ),
      ),
    );
  }

  _handleCheckNetwork() async {
    var connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult != ConnectivityResult.mobile &&
        connectivityResult != ConnectivityResult.wifi) {
      Scaffold.of(context).showSnackBar(
        SnackBar(
          content: Text("No network!"),
        ),
      );
    }
  }

  @override
  dispose() {
    super.dispose();
    subscription.cancel();
  }
}
