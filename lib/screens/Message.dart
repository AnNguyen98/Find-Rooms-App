import 'dart:async';
import 'dart:io';

import 'package:find_rooms_app/model/MessengerModel.dart';
import 'package:find_rooms_app/model/User.dart';
import 'package:find_rooms_app/screens/UserProfile.dart';
import 'package:find_rooms_app/ui/uiHelper.dart';
import 'package:find_rooms_app/until/database.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:multi_image_picker/multi_image_picker.dart';
import 'package:url_launcher/url_launcher.dart';

class Message extends StatefulWidget {
  static String title = "/message";
  final String uid;
  Message({this.uid});
  @override
  _MessageState createState() => _MessageState();
}

class _MessageState extends State<Message> {
  List<File> fileImages = [];
  User currentUser, otherUser;
  TextEditingController messengerController;
  List<Widget> imageWidgets = [];
  List<MessengerModel> messengers = [];

  @override
  void initState() {
    super.initState();
    messengerController = TextEditingController();
    _getMessage();
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
        actions: <Widget>[
          Container(
            alignment: Alignment.center,
            margin: EdgeInsets.only(left: 50),
            child: Row(
              children: <Widget>[
                CircleAvatar(
                  radius: 17,
                  foregroundColor: Colors.grey,
                  backgroundImage:
                      otherUser != null && otherUser.avatarUrl != null
                          ? NetworkImage(otherUser.avatarUrl)
                          : AssetImage("images/avatar-default.png"),
                ),
                Container(
                  margin: EdgeInsets.symmetric(horizontal: 5),
                  child: Text(
                    otherUser != null && otherUser.fullName != null
                        ? otherUser.fullName
                        : "",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),
          ),
          Spacer(),
          IconButton(
            onPressed: () {
              _handleCallTo();
            },
            icon: Icon(FontAwesomeIcons.phoneAlt),
          ),
          PopupMenuButton(
            onSelected: (value) {
              //_handleToUserProfile();
              print("OK");
              Navigator.push(
                context,
                CupertinoPageRoute(
                  builder: (context) => UserProfile(),
                ),
              );
            },
            itemBuilder: (BuildContext context) {
              return [
                PopupMenuItem<String>(
                  value: "Profile",
                  child: Row(
                    children: <Widget>[
                      Icon(
                        Icons.people,
                        color: Colors.grey,
                      ),
                      SizedBox(
                        width: 5,
                      ),
                      Text("Profile"),
                    ],
                  ),
                )
              ];
            },
          ),
        ],
      ),
      body: Container(
        child: Column(
          children: <Widget>[
            Expanded(
              child: ListView.builder(
                reverse: true,
                itemCount: messengers.length,
                itemBuilder: (context, index) {
                  MessengerModel mes = messengers[index];
                  if (mes.uid == otherUser.uid) {
                    return Container(
                        margin: EdgeInsets.only(top: 5, right: 20),
                        child: Column(
                          children: <Widget>[
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: <Widget>[
                                CircleAvatar(
                                  backgroundImage: otherUser != null &&
                                          otherUser.avatarUrl != null
                                      ? NetworkImage(otherUser.avatarUrl)
                                      : AssetImage("images/avatar-default.png"),
                                ),
                                Expanded(
                                  child: Container(
                                    decoration: BoxDecoration(
                                      color: Colors.blueAccent,
                                      borderRadius: BorderRadius.only(
                                        topRight: Radius.circular(10),
                                        bottomRight: Radius.circular(10),
                                        topLeft: Radius.circular(10),
                                      ),
                                    ),
                                    padding: EdgeInsets.all(10),
                                    margin: EdgeInsets.all(5),
                                    child: Text(mes.content),
                                  ),
                                )
                              ],
                            ),
                            mes.imageUrl != null
                                ? Container(
                                    alignment: Alignment.bottomRight,
                                    margin: EdgeInsets.symmetric(
                                      vertical: 10,
                                      horizontal: 20,
                                    ),
                                    child: Wrap(
                                      direction: Axis.horizontal,
                                      children: mes.imageUrl
                                          .map((url) => Container(
                                                width: 60,
                                                height: 60,
                                                child: Image.network(
                                                    url.toString()),
                                              ))
                                          .toList(),
                                    ),
                                  )
                                : Container(),
                          ],
                        ));
                  } else {
                    return Container(
                      margin: EdgeInsets.only(top: 5, left: 20),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: <Widget>[
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: <Widget>[
                              Spacer(),
                              Expanded(
                                child: Container(
                                  decoration: BoxDecoration(
                                    color: Colors.greenAccent,
                                    borderRadius: BorderRadius.only(
                                      topRight: Radius.circular(10),
                                      bottomLeft: Radius.circular(10),
                                      topLeft: Radius.circular(10),
                                    ),
                                  ),
                                  padding: EdgeInsets.all(10),
                                  margin: EdgeInsets.all(5),
                                  child: Text(
                                    mes.content,
                                    textAlign: TextAlign.right,
                                    style: TextStyle(
                                      backgroundColor: Colors.greenAccent,
                                    ),
                                  ),
                                ),
                              ),
                              CircleAvatar(
                                backgroundImage: currentUser != null &&
                                        currentUser.avatarUrl != null
                                    ? NetworkImage(currentUser.avatarUrl)
                                    : AssetImage("images/avatar-default.png"),
                              ),
                            ],
                          ),
                          mes.imageUrl != null
                              ? Container(
                                  alignment: Alignment.bottomRight,
                                  margin: EdgeInsets.symmetric(
                                    vertical: 10,
                                    horizontal: 20,
                                  ),
                                  child: Wrap(
                                    direction: Axis.horizontal,
                                    children: mes.imageUrl
                                        .map((url) => Container(
                                              width: 60,
                                              height: 60,
                                              child:
                                                  Image.network(url.toString()),
                                            ))
                                        .toList(),
                                  ),
                                )
                              : Container(),
                        ],
                      ),
                    );
                  }
                },
              ),
            ),
            Container(
              alignment: Alignment.topLeft,
              margin: EdgeInsets.all(10),
              child: Wrap(
                direction: Axis.horizontal,
                children: imageWidgets,
              ),
            ),
            Container(
              height: 60,
              margin: EdgeInsets.only(bottom: 20),
              child: Row(
                children: <Widget>[
                  Container(
                    width: 40,
                    child: IconButton(
                      icon: Icon(Icons.image),
                      onPressed: _handleGetImages,
                    ),
                  ),
                  Container(
                    width: 40,
                    child: IconButton(
                      icon: Icon(Icons.camera_alt),
                      onPressed: _handleGetPhotoCamera,
                    ),
                  ),
                  Expanded(
                    child: Container(
                      height: 45,
                      padding: EdgeInsets.symmetric(horizontal: 10),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                          width: 1,
                          color: Colors.grey,
                        ),
                      ),
                      child: TextField(
                        controller: messengerController,
                        decoration: InputDecoration(
                          hintText: "Enter somethings...",
                          hintStyle: TextStyle(fontSize: 13),
                          border: InputBorder.none,
                        ),
                      ),
                    ),
                  ),
                  IconButton(
                    icon: Icon(FontAwesomeIcons.solidPaperPlane),
                    onPressed: _handleSendMessenger,
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  _handleToUserProfile() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => UserProfile(),
      ),
    );
  }

  Future _handleGetPhotoCamera() async {
    var file = await ImagePicker.pickImage(source: ImageSource.camera);
    UIHelper.showLoadingDialog(context);
    setState(() {
      imageWidgets.add(
        Container(
          width: 60,
          height: 60,
          child: Image.file(
            file,
            fit: BoxFit.fill,
          ),
        ),
      );
      fileImages.add(file);
    });
    //TODO: Remove image selected
    Navigator.pop(context);
  }

  Future _handleGetImages() async {
    var assets = await MultiImagePicker.pickImages(
      maxImages: 10,
      enableCamera: true,
    );
    UIHelper.showLoadingDialog(context);
    assets.forEach((asset) async {
      String pathF = await asset.filePath.then((path) {
        return path.toString();
      });
      File file = File(pathF);
      setState(() {
        imageWidgets.add(
          AssetThumb(
            asset: asset,
            width: 60,
            height: 60,
          ),
        );
        fileImages.add(file);
      });
    });
    Navigator.pop(context);
  }

  Future<String> _uploadImage(File file) async {
    var unit8ListImage = file.readAsBytesSync();
    String fileName = file.path.split("/").last;
    final StorageReference storageReference =
        FirebaseStorage().ref().child("images").child(fileName);
    final StorageUploadTask uploadTask =
        storageReference.putData(unit8ListImage);
    final StreamSubscription<StorageTaskEvent> streamSubscription =
        uploadTask.events.listen((event) {
      print('upload image ${event.type}');
    });
    await uploadTask.onComplete;
    streamSubscription.cancel();
    var url = await storageReference.getDownloadURL().then((value) {
      return value.toString();
    });
    return url;
  }

  _getImageUrlsUpload(onComplete(List<String> urls)) async {
    List<Future<String>> futures = [];
    fileImages.forEach((file) {
      futures.add(_uploadImage(file));
    });
    Future.wait(futures).then((urls) {
      onComplete(urls);
      return urls;
    });
  }

  _getUserInformation(Function onComplete) async {
    await DatabaseHelper.getCurrentUser((user) {
      setState(() {
        currentUser = user;
      });
    });
    await DatabaseHelper.getUserByUid(widget.uid, (user) {
      setState(() {
        otherUser = user;
        onComplete();
      });
    });
  }

  _getMessage() async {
    _getUserInformation(() {
      DatabaseReference _messagesRef =
          FirebaseDatabase.instance.reference().child("messages");
      _messagesRef
          .child(currentUser.uid)
          .child(otherUser.uid)
          .onValue
          .listen((event) {
        var value = event.snapshot.value;
        if (value == null) {
          return;
        }
        List listMes = value as List;
        List<MessengerModel> listMessage =
            listMes.map((o) => MessengerModel.fromObject(o)).toList();
        setState(() {
          this.messengers = listMessage.reversed.toList();
        });
      });
    });
  }

  _handleSendMessenger() async {
    UIHelper.showLoadingDialog(context);
    await _getImageUrlsUpload((urls) {
      DatabaseReference _messagesRef =
          FirebaseDatabase.instance.reference().child("messages");
      MessengerModel messenger = MessengerModel(
          avatarUrl: currentUser.avatarUrl,
          uid: currentUser.uid,
          content: messengerController.text,
          imageUrl: urls);
      messengers.add(messenger);
      var messengersJson =
          messengers.map((messenger) => messenger.toJson()).toList();
      _messagesRef
          .child(currentUser.uid)
          .child(otherUser.uid)
          .set(messengersJson);
      Navigator.pop(context);
      setState(() {
        fileImages = [];
        imageWidgets = [];
        messengerController.text = "";
      });
    });
  }

  _handleCallTo() async {
    print("Processing...");
    String phoneNumber = otherUser.phoneNumber.substring(1);
    var url = "tel:+84 $phoneNumber";
    if (await canLaunch(url)) {
      print("OK");
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }
}
