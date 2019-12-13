import 'package:find_rooms_app/ui/uiHelper.dart';
import 'package:find_rooms_app/until/AuthHelper.dart';
import 'package:find_rooms_app/widgets/ButtonCustom.dart';
import 'package:find_rooms_app/widgets/TextFieldCustom.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ChangePassword extends StatefulWidget {
  @override
  _ChangePasswordState createState() => _ChangePasswordState();
}

class _ChangePasswordState extends State<ChangePassword> {
  TextEditingController oldPasswordController;
  TextEditingController newPasswordController;
  TextEditingController confirmPasswordController;
  bool oldPasswordObscureText = true;
  bool newPasswordObscureText = true;
  bool confirmPasswordObscureText = true;

  @override
  void initState() {
    super.initState();
    oldPasswordController = TextEditingController();
    newPasswordController = TextEditingController();
    confirmPasswordController = TextEditingController();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Change password"),
        centerTitle: true,
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.check),
            onPressed: _updatePassword,
          )
        ],
      ),
      body: Container(
        color: Color.fromRGBO(32, 35, 48, 1),
        padding: EdgeInsets.only(top: 50, bottom: 30),
        child: ListView(
          children: <Widget>[
            TextFieldCustom(
              controller: oldPasswordController,
              placeholder: "Old password",
              obscureText: oldPasswordObscureText,
              onTap: () {
                setState(() {
                  oldPasswordObscureText = !oldPasswordObscureText;
                });
              },
            ),
            TextFieldCustom(
              controller: newPasswordController,
              placeholder: "New password",
              obscureText: newPasswordObscureText,
              onTap: () {
                setState(() {
                  newPasswordObscureText = !newPasswordObscureText;
                });
              },
            ),
            TextFieldCustom(
              controller: confirmPasswordController,
              placeholder: "Confirm new password",
              obscureText: confirmPasswordObscureText,
              onTap: () {
                setState(() {
                  confirmPasswordObscureText = !confirmPasswordObscureText;
                });
              },
            ),
            Container(
              margin: EdgeInsets.only(top: 30),
              child: ButtonCustom(
                title: "Update",
                onPressed: _updatePassword,
                color: Colors.white,
              ),
            )
          ],
        ),
      ),
    );
  }

  _updatePassword() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String oldPassword = prefs.getString("password");
    print(oldPassword);
    if (oldPasswordController.text == "" ||
        newPasswordController.text == "" ||
        confirmPasswordController.text == "") {
      return;
    }
    if (oldPassword != oldPasswordController.text) {
      UIHelper.showAlertDone(
          context, "Old password wrong!", Icons.error_outline, Colors.red);
      return;
    }
    if (newPasswordController.text != confirmPasswordController.text) {
      UIHelper.showAlertDone(context, "Old password and new password not same!",
          Icons.error_outline, Colors.red);
      return;
    }
    await AuthHelper.updatePassword(context, confirmPasswordController.text);
  }
}
