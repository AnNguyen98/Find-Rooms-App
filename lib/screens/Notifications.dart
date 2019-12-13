import 'package:find_rooms_app/model/NotificationModel.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Notifications extends StatefulWidget {
  static String title = "/notification";
  @override
  _NotificationsState createState() => _NotificationsState();
}

class _NotificationsState extends State<Notifications> {
  Color tapDownColor = Colors.grey;
  List<NotificationModel> notifications;

  @override
  void initState() {
    super.initState();
    _getNotificationsCurrentUser();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        padding: EdgeInsets.symmetric(vertical: 10),
        child: ListView.builder(
          itemCount: notifications != null ? notifications.length : 0,
          itemBuilder: (context, index) {
            return Container(
              child: Column(
                children: <Widget>[
                  Container(
                    margin: EdgeInsets.symmetric(horizontal: 5),
                    child: MaterialButton(
                      onPressed: () {},
                      child: Row(
                        children: <Widget>[
                          CircleAvatar(
                            backgroundColor: Colors.red,
                            backgroundImage: NetworkImage(
                              notifications[index].avatarUserPostUrl,
                            ),
                            radius: 20,
                          ),
                          SizedBox(
                            width: 10,
                          ),
                          Flexible(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Text(
                                  notifications[index].content,
                                  style: TextStyle(fontSize: 12),
                                ),
                                Icon(Icons.people, size: 20),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Divider(
                    color: Colors.black54,
                  )
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  _getNotificationsCurrentUser() async {
    DatabaseReference _notificationsRef =
        FirebaseDatabase.instance.reference().child("notifications");
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String uid = prefs.getString("uid");
    if (uid == null) {
      print("uid null");
      return;
    }
    _notificationsRef.child(uid).onValue.listen((onData) {
      var rList = onData.snapshot.value as List;
      if (rList == null) {
        return;
      }
      setState(() {
        notifications = rList
            .map((object) => NotificationModel.fromObject(object))
            .toList();
      });
    });
  }
}
