import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class EditInformation extends StatefulWidget {
  static String title = "/editInformation";
  @override
  _EditInformationState createState() => _EditInformationState();
}

class _EditInformationState extends State<EditInformation> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Edit"),
        actions: <Widget>[
          Container(
            width: 70,
            height: 40,
            child: MaterialButton(
              onPressed: () {},
              child: Text("Save"),
            ),
          )
        ],
      ),
    );
  }
}
