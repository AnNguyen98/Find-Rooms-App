import 'dart:async';
import 'dart:io';

import 'package:find_rooms_app/model/User.dart';
import 'package:find_rooms_app/ui/uiHelper.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DatabaseHelper {
  static updateCoverPhoto(File file, BuildContext context) async {
    DatabaseReference _usersRef =
        FirebaseDatabase.instance.reference().child("users");
    var uid = await getUidString();
    if (uid == null) {
      return;
    }
    File imageFile = await UIHelper.handleGetPhoto();
    if (imageFile == null) {
      print("imageFile Null");
      return;
    }
    UIHelper.showLoadingDialog(context);
    String coverUrl =
        await DatabaseHelper.getUrlUploadFile(imageFile, "covers");
    if (coverUrl == null) {
      print("coverUrl Null");
      return;
    }
    _usersRef.child(uid).update({
      "coverUrl": coverUrl,
    }).then((res) {
      Navigator.pop(context);
    });
  }

  static Future<String> getUrlUploadFile(File file, String to) async {
    String fileName = file.path.split("/").last;
    var unit8ListImage = file.readAsBytesSync();
    final StorageReference storageReference =
        FirebaseStorage().ref().child(to).child(fileName);
    final StorageUploadTask uploadTask =
        storageReference.putData(unit8ListImage);
    final StreamSubscription<StorageTaskEvent> streamSubscription =
        uploadTask.events.listen((event) {
      print('upload avatar ${event.type}');
    });
    await uploadTask.onComplete;
    streamSubscription.cancel();
    var url = await storageReference.getDownloadURL().then((value) {
      return value;
    });
    return url.toString();
  }

  static getUidString() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString("uid");
  }

  static updateAvatar(BuildContext context, File fileImage) async {
    DatabaseReference _usersRef =
        FirebaseDatabase.instance.reference().child("users");
    var uid = await DatabaseHelper.getUidString();
    if (uid == null) {
      return;
    }
    File imageFile = await UIHelper.handleGetPhoto();
    if (imageFile == null) {
      return;
    }
    UIHelper.showLoadingDialog(context);
    String coverUrl = await getUrlUploadFile(imageFile, "avatars");
    if (coverUrl == null) {
      print("coverUrl Null");
      return;
    }
    _usersRef.child(uid).update({
      "avatarUrl": coverUrl,
    }).then((res) {
      Navigator.pop(context);
    });
  }

  static getUserByUid(String uid, onValue(User user)) async {
    DatabaseReference _usersRef =
        FirebaseDatabase.instance.reference().child("users");
    _usersRef.child(uid).onValue.listen((event) {
      if (event.snapshot.value == null) {
        return null;
      }
      var userDict = event.snapshot.value;
      var user = User.fromObject(userDict);
      onValue(user);
    });
  }

  static getCurrentUser(onValue(User user)) async {
    DatabaseReference _usersRef =
        FirebaseDatabase.instance.reference().child("users");
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String uid = prefs.getString("uid") ?? null;
    if (uid == null) {
      print("current user uid is null");
      return null;
    }
    _usersRef.child(uid).onValue.listen((event) {
      if (event.snapshot.value == null) {
        return null;
      }
      var userDict = event.snapshot.value;
      var user = User.fromObject(userDict);
      onValue(user);
    });
  }

  static updateInformation(
    User user,
    BuildContext context,
  ) async {
    DatabaseReference _usersRef =
        FirebaseDatabase.instance.reference().child("users");
    var userJson = user.toJson();
    UIHelper.showLoadingDialog(context);
    _usersRef.child(user.uid).update(userJson).then((res) {
      print("Updated");
      Navigator.pop(context);
      UIHelper.showAlertDone(
          context, "Updated", Icons.check_circle, Colors.green);
    });
  }
}
