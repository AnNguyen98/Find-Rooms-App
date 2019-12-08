import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class CardInformation extends StatelessWidget {
  final String title;
  final TextEditingController controller;
  CardInformation({this.title, this.controller});
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Card(
        margin: EdgeInsets.only(top: 10, left: 10, right: 10),
        child: Row(
          children: <Widget>[
            Container(
              margin: EdgeInsets.symmetric(horizontal: 10),
              child: Container(
                width: 70,
                child: Text("$title: "),
              ),
            ),
            Expanded(
              child: TextField(
                controller: controller,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
