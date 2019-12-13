import 'package:find_rooms_app/ui/uiHelper.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthHelper {
  static signOut() async {
    FirebaseAuth _auth = FirebaseAuth.instance;

    await _auth.signOut().catchError((error) {
      print(error.toString());
    });
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString("email", "");
    prefs.setString("uid", null);
    prefs.setString("user_token", "");
  }

  static updatePassword(BuildContext context, String newPassword) async {
    FirebaseAuth _auth = FirebaseAuth.instance;
    UIHelper.showLoadingDialog(context);
    FirebaseUser _user = await _auth.currentUser();
    await _user.updatePassword(newPassword);
    Navigator.pop(context);
    UIHelper.showAlertDone(
        context, "Updated", Icons.check_circle, Colors.green);
  }

  static saveUser(FirebaseUser _user, String password) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    _user.getIdToken(refresh: false).then((res) {
      String userToken = res.token;
      prefs.setString("user_token", userToken);
    });
    prefs.setString("email", _user.email);
    prefs.setString("password", password);
    prefs.setString("uid", _user.uid);
  }
}
