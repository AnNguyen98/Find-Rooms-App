import 'dart:io';

import 'package:find_rooms_app/model/User.dart';
import 'package:find_rooms_app/screens/HomePage.dart';
import 'package:find_rooms_app/ui/uiHelper.dart';
import 'package:find_rooms_app/until/AuthHelper.dart';
import 'package:find_rooms_app/until/Database.dart';
import 'package:find_rooms_app/widgets/ButtonCustom.dart';
import 'package:find_rooms_app/widgets/TextFieldCustom.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class Register extends StatefulWidget {
  static String title = "/register";
  @override
  _RegisterState createState() => _RegisterState();
}

class _RegisterState extends State<Register> with TickerProviderStateMixin {
  TextEditingController emailController;
  TextEditingController passwordController;
  TextEditingController confirmPasswordController;
  TextEditingController fullNameController;
  TextEditingController phoneNumberController;
  TextEditingController addressController;
  bool obscureText1 = true;
  bool obscureText2 = true;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  File _imageCameraFile;
  DatabaseReference _usersRef;

  @override
  void initState() {
    super.initState();
    emailController = TextEditingController();
    passwordController = TextEditingController();
    phoneNumberController = TextEditingController();
    fullNameController = TextEditingController();
    confirmPasswordController = TextEditingController();
    addressController = TextEditingController();
    _usersRef = FirebaseDatabase.instance.reference().child("users");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
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
        decoration: BoxDecoration(
          image: DecorationImage(
            fit: BoxFit.fill,
            colorFilter: ColorFilter.linearToSrgbGamma(),
            image: AssetImage("images/registerBG.png"),
          ),
        ),
        child: ListView(
          children: <Widget>[
            Center(
              child: Container(
                width: 130,
                height: 130,
                margin: EdgeInsets.only(bottom: 20, top: 30),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.white, width: 5),
                  borderRadius: BorderRadius.circular(65),
                ),
                child: CircleAvatar(
                  backgroundImage: _imageCameraFile == null
                      ? AssetImage("images/avatar-default.png")
                      : FileImage(_imageCameraFile),
                  child: IconButton(
                    icon: Icon(
                      FontAwesomeIcons.camera,
                      size: 24,
                      color: Colors.grey,
                    ),
                    onPressed: _handleGetPhotoCamera,
                  ),
                ),
              ),
            ),
            TextFieldCustom(
              controller: fullNameController,
              placeholder: "Fullname",
            ),
            TextFieldCustom(
              controller: addressController,
              placeholder: "Address",
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
              controller: confirmPasswordController,
              placeholder: "Confirm password",
            ),
            Container(
              margin: EdgeInsets.only(top: 30, bottom: 20),
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

  _isEmptyValue() {
    return emailController.text == "" ||
        passwordController.text == "" ||
        fullNameController.text == "" ||
        phoneNumberController.text == "" ||
        confirmPasswordController.text == "";
  }

  _showDialogError(String error) {
    Navigator.pop(context);
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text("Error"),
          content: Text("$error"),
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

  _comparePassword() {
    return passwordController.text != confirmPasswordController.text;
  }

  _handleGetPhotoCamera() async {
    await UIHelper.handleGetPhoto().then((file) {
      setState(() {
        _imageCameraFile = file;
      });
    });
  }

  _handleRegister() async {
    if (_isEmptyValue()) {
      UIHelper.showSnackBarWithTitle(_scaffoldKey, "Empty value!");
      return;
    }
    if (passwordController.text.length < 8 ||
        confirmPasswordController.text.length < 8) {
      UIHelper.showSnackBarWithTitle(_scaffoldKey, "Password == 8 characters!");
      return;
    }
    if (_comparePassword()) {
      UIHelper.showSnackBarWithTitle(
          _scaffoldKey, "Comfirm password not same password!");
      return;
    }
    UIHelper.showLoadingDialog(context);
    AuthResult _authResult = await _auth
        .createUserWithEmailAndPassword(
            email: emailController.text, password: passwordController.text)
        .catchError((error) {
      _showDialogError(error.toString());
      return;
    });
    await AuthHelper.saveUser(_authResult.user, confirmPasswordController.text);

    String avatarURL =
        await DatabaseHelper.getUrlUploadFile(_imageCameraFile, "avatars");
    print("avatarURL" + avatarURL);
    User user = User(
      avatarUrl: avatarURL,
      phoneNumber: phoneNumberController.text,
      email: emailController.text,
      address: addressController.text,
      coverUrl: null,
      fullName: fullNameController.text,
      birthday: null,
      uid: _authResult.user.uid,
      gender: true,
    );
    await _usersRef
        .child(_authResult.user.uid)
        .set(user.toJson())
        .whenComplete(() {
      print("whenComplete");
    }).then((res) {
      Navigator.pop(context);
      Navigator.push(
        context,
        CupertinoPageRoute(
          builder: (context) => HomePage(),
        ),
      );
    }).catchError((error) {
      _showDialogError(error.toString());
    });
  }
}
