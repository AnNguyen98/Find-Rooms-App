import 'package:find_rooms_app/screens/HomePage.dart';
import 'package:find_rooms_app/screens/Register.dart';
import 'package:find_rooms_app/widgets/ButtonCustom.dart';
import 'package:find_rooms_app/widgets/TextFieldCustom.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Login extends StatefulWidget {
  static String title = "/login";
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  TextEditingController emailController;
  TextEditingController passwordController;
  bool obscureText = true;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  FirebaseUser _user;

  @override
  void initState() {
    super.initState();
    emailController = TextEditingController();
    passwordController = TextEditingController();
    _initData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          color: Colors.cyan,
          image: DecorationImage(
            fit: BoxFit.fill,
            image: AssetImage("images/background.png"),
          ),
        ),
        child: ListView(
          children: <Widget>[
            Center(
              child: Container(
                width: 130,
                height: 130,
                margin: EdgeInsets.only(bottom: 50, top: 100),
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
              controller: emailController,
              placeholder: "Email",
            ),
            TextFieldCustom(
              obscureText: obscureText,
              onTap: () {
                setState(() {
                  obscureText = !obscureText;
                });
              },
              icon: obscureText
                  ? FontAwesomeIcons.eyeSlash
                  : FontAwesomeIcons.eye,
              controller: passwordController,
              placeholder: "Password",
            ),
            Container(
              margin: EdgeInsets.only(top: 30),
              child: ButtonCustom(
                title: "Login",
                color: Colors.orange,
                onPressed: _handleLogin,
              ),
            ),
            Container(
              margin: EdgeInsets.only(top: 10, bottom: 20),
              child: ButtonCustom(
                title: "Register",
                color: Colors.green,
                onPressed: _handleRegister,
              ),
            )
          ],
        ),
      ),
    );
  }

  _initData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String email = (prefs.getString("email") ?? "");
    setState(() {
      emailController.text = email;
    });
  }

  _handleLogin() async {
    AuthResult authResult = await _auth
        .signInWithEmailAndPassword(
            email: emailController.text, password: passwordController.text)
        .catchError((error) {
      print("login error $error");
    });
    if (authResult.user != null) {
      _user = authResult.user;
      SharedPreferences prefs = await SharedPreferences.getInstance();
      _user.getIdToken(refresh: false).then((res) {
        String userToken = res.token;
        prefs.setString("user_token", userToken);
      });
      prefs.setString("email", _user.email);
      prefs.setString("uid", _user.uid);
      Navigator.push(
        context,
        CupertinoPageRoute(
          builder: (context) => HomePage(),
        ),
      );
    }
  }

  _handleRegister() {
    Navigator.push(
      context,
      CupertinoPageRoute(
        builder: (context) => Register(),
      ),
    );
  }
}
