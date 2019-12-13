import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class InformationUser extends StatelessWidget {
  final String title;
  final String value;
  InformationUser({this.value, this.title});
  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.only(top: 20, left: 20, right: 20),
      child: Container(
        alignment: Alignment.center,
        height: 50,
        child: Row(
          children: <Widget>[
            Container(
              margin: EdgeInsets.only(left: 50, right: 20),
              child: Text(title),
            ),
            Text(
              value,
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }
}
