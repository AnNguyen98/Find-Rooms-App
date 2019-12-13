import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:image_picker/image_picker.dart';

class UIHelper {
  static Future<File> handleGetPhoto() async {
    var image = await ImagePicker.pickImage(source: ImageSource.gallery);
    return image;
  }

  static showLoadingDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return Container(
          child: SpinKitCircle(
            color: Colors.white,
            size: 50.0,
          ),
        );
      },
    );
  }

  static showSnackBarWithTitle(
      GlobalKey<ScaffoldState> _scaffoldkey, String title) {
    _scaffoldkey.currentState.hideCurrentSnackBar();
    _scaffoldkey.currentState.showSnackBar(SnackBar(
      content: Text(title),
      action: SnackBarAction(
        label: "OK",
        onPressed: () {
          _scaffoldkey.currentState.hideCurrentSnackBar();
        },
      ),
    ));
  }

  static showAlertDone(
      BuildContext context, String title, IconData iconData, Color color) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          content: Container(
            height: 130,
            child: Column(
              children: <Widget>[
                Icon(
                  Icons.check_circle,
                  size: 100,
                  color: Colors.green,
                ),
                Text("Updated!"),
              ],
            ),
          ),
          title: Text("Message"),
          actions: <Widget>[
            MaterialButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text(
                "OK",
                style: TextStyle(color: Colors.blue),
              ),
            )
          ],
        );
      },
    );
  }
}
