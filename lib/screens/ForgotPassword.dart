import 'package:find_rooms_app/ui/uiHelper.dart';
import 'package:find_rooms_app/widgets/ButtonCustom.dart';
import 'package:find_rooms_app/widgets/TextFieldCustom.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ForgotPassword extends StatefulWidget {
  static String title = "forgotPassword";
  @override
  _ForgotPasswordState createState() => _ForgotPasswordState();
}

class _ForgotPasswordState extends State<ForgotPassword> {
  FirebaseAuth _auth;
  TextEditingController emailController;
  GlobalKey<ScaffoldState> _globalKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    _auth = FirebaseAuth.instance;
    emailController = TextEditingController();
    _auth.sendPasswordResetEmail(email: "");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _globalKey,
      appBar: AppBar(
        title: Text("Reset password"),
        centerTitle: true,
      ),
      body: Container(
        color: Color.fromRGBO(32, 35, 48, 1),
        padding: EdgeInsets.only(top: 50, bottom: 30),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Container(
              alignment: Alignment.centerLeft,
              margin: EdgeInsets.only(bottom: 10, left: 20),
              child: Text(
                "Enter your email account:",
                style: TextStyle(fontSize: 14, color: Colors.white),
              ),
            ),
            TextFieldCustom(
              placeholder: "Email",
              controller: emailController,
            ),
            Container(
              margin: EdgeInsets.symmetric(vertical: 30),
              child: ButtonCustom(
                onPressed: _handleResetPassword,
                title: "Reset password",
                color: Colors.white,
              ),
            )
          ],
        ),
      ),
    );
  }

  _handleResetPassword() async {
    String email = emailController.text;
    if (email == "") {
      UIHelper.showSnackBarWithTitle(_globalKey, "Input your email!");
      return;
    }
    UIHelper.showLoadingDialog(context);
    await _auth.sendPasswordResetEmail(email: email).catchError((error) {
      Navigator.pop(context);
      UIHelper.showAlertDone(context, "Error", Icons.error_outline, Colors.red);
    });
    Navigator.pop(context);
    UIHelper.showAlertDone(
        context, "Please check your email!", Icons.check_circle, Colors.yellow);
    emailController.text = "";
  }
}
