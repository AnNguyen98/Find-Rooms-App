import 'package:flutter/material.dart';

class Notifications extends StatefulWidget {
  static String title = "/notification";
  @override
  _NotificationsState createState() => _NotificationsState();
}

class _NotificationsState extends State<Notifications> {
  Color tapDownColor = Colors.grey;
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        padding: EdgeInsets.symmetric(vertical: 10),
        child: ListView.builder(
          itemCount: 10,
          itemBuilder: (context, index) {
            return GestureDetector(
              onTapDown: (detail) {
                setState(() {});
              },
              onTapUp: (detail) {},
              child: Container(
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
                                    "Learn a skill that could help you launch a new career or fulfill your lifelong dream and save up to 90% for Black Friday. Now that’s smart shopping",
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
              ),
            );
          },
        ),
      ),
    );
  }
}
