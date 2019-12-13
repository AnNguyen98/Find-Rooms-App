import 'package:find_rooms_app/widgets/TextFieldCustom.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class UpdateUser extends StatelessWidget {
  final TextEditingController controller;
  final String placeholder;
  final String title;
  UpdateUser({this.controller, this.placeholder, this.title = ""});
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Row(
        children: <Widget>[
          Container(
            margin: EdgeInsets.only(left: 20),
            width: 70,
            child: Text(
              title,
              style: TextStyle(
                color: Colors.white,
              ),
            ),
          ),
          Expanded(
            child: TextFieldCustom(
              controller: controller,
              placeholder: placeholder,
            ),
          )
        ],
      ),
    );
  }
}
