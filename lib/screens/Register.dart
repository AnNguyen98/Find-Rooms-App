import 'package:find_rooms_app/screens/HomePage.dart';
import 'package:find_rooms_app/widgets/ButtonCustom.dart';
import 'package:find_rooms_app/widgets/TextFieldCustom.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class Register extends StatefulWidget {
  static String title = "/register";
  @override
  _RegisterState createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  TextEditingController emailController;
  TextEditingController passwordController;
  TextEditingController fullNameController;
  TextEditingController phoneNumberController;
  bool obscureText1 = true;
  bool obscureText2 = true;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  @override
  void initState() {
    super.initState();
    emailController = TextEditingController();
    passwordController = TextEditingController();
    phoneNumberController = TextEditingController();
    fullNameController = TextEditingController();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(CupertinoIcons.back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: Text("Register"),
        centerTitle: true,
      ),
      body: Container(
        color: Colors.black12,
        child: ListView(
          children: <Widget>[
            Center(
              child: Container(
                width: 130,
                height: 130,
                margin: EdgeInsets.only(bottom: 30, top: 50),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(25),
                  border: Border.all(color: Colors.white, width: 4),
                  image: DecorationImage(
                    image: AssetImage("images/logo.png"),
                  ),
                ),
              ),
            ),
            TextFieldCustom(
              controller: fullNameController,
              placeholder: "Fullname",
            ),
            TextFieldCustom(
              controller: phoneNumberController,
              keyboardType: TextInputType.phone,
              placeholder: "Phone number",
            ),
            TextFieldCustom(
              controller: emailController,
              placeholder: "Email",
            ),
            TextFieldCustom(
              obscureText: obscureText1,
              onTap: () {
                setState(() {
                  obscureText1 = !obscureText1;
                  print("OK");
                });
              },
              icon: obscureText1
                  ? FontAwesomeIcons.eyeSlash
                  : FontAwesomeIcons.eye,
              controller: passwordController,
              placeholder: "Password",
            ),
            TextFieldCustom(
              obscureText: obscureText2,
              onTap: () {
                setState(() {
                  obscureText2 = !obscureText2;
                  print("OK");
                });
              },
              icon: obscureText2
                  ? FontAwesomeIcons.eyeSlash
                  : FontAwesomeIcons.eye,
              controller: passwordController,
              placeholder: "Confirm password",
            ),
            Container(
              margin: EdgeInsets.only(top: 30),
              child: ButtonCustom(
                title: "Register",
                color: Colors.green,
                onPressed: _handleRegister,
              ),
            ),
          ],
        ),
      ),
    );
  }

  _handleRegister() async {
    AuthResult _authResult = await _auth
        .createUserWithEmailAndPassword(
            email: emailController.text, password: passwordController.text)
        .catchError((error) {
      print(error);
    });
    if (_authResult.user == null) {
      return;
    }
    Navigator.push(
      context,
      CupertinoPageRoute(
        builder: (context) => HomePage(),
      ),
    );
  }
}
