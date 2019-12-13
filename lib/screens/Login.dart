import 'package:find_rooms_app/screens/ForgotPassword.dart';
import 'package:find_rooms_app/screens/HomePage.dart';
import 'package:find_rooms_app/screens/Register.dart';
import 'package:find_rooms_app/ui/uiHelper.dart';
import 'package:find_rooms_app/until/AuthHelper.dart';
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
  final GlobalKey<ScaffoldState> _scaffoldkey = new GlobalKey<ScaffoldState>();
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
      key: _scaffoldkey,
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            fit: BoxFit.fill,
            colorFilter: ColorFilter.linearToSrgbGamma(),
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
              margin: EdgeInsets.only(right: 20),
              alignment: Alignment.topRight,
              child: GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ForgotPassword(),
                    ),
                  );
                },
                child: Text(
                  "Forgot password?",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 12,
                  ),
                ),
              ),
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

  _isEmptyValue() {
    return emailController.text == "" || passwordController.text == "";
  }

  _showPasswordInvalidUser() {
    Navigator.pop(context);
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text("Error"),
          content: Text(
              "The password is invalid or the user does not have a password."),
          actions: <Widget>[
            MaterialButton(
              child: Text("OK"),
              onPressed: () {
                Navigator.pop(context);
              },
            )
          ],
        );
      },
    );
  }

  _handleLogin() async {
    if (_isEmptyValue()) {
      UIHelper.showSnackBarWithTitle(_scaffoldkey, "Empty email or password!");
      return;
    }
    if (passwordController.text.length < 8) {
      UIHelper.showSnackBarWithTitle(_scaffoldkey, "Password == 8 characters!");
      return;
    }
    UIHelper.showLoadingDialog(context);
    AuthResult authResult = await _auth
        .signInWithEmailAndPassword(
            email: emailController.text, password: passwordController.text)
        .catchError((error) {
      _showPasswordInvalidUser();
    });
    if (authResult.user != null) {
      Navigator.pop(context);
      _user = authResult.user;
      await AuthHelper.saveUser(_user, passwordController.text);
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
