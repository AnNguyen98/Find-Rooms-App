import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:multi_image_picker/multi_image_picker.dart';
import 'package:url_launcher/url_launcher.dart';

class Message extends StatefulWidget {
  static String title = "/message";
  @override
  _MessageState createState() => _MessageState();
}

class _MessageState extends State<Message> {
  List<Asset> images;
  File _imageCameraFile;

  @override
  void initState() {
    super.initState();
    images = [];
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
          IconButton(
            onPressed: () {
              _handleCallTo("198");
            },
            icon: Icon(FontAwesomeIcons.phoneAlt),
          ),
          IconButton(
            onPressed: () {},
            icon: Icon(Icons.more_vert),
          )
        ],
      ),
      body: Container(
        child: Column(
          children: <Widget>[
            Expanded(
              child: ListView.builder(
                reverse: true,
                itemCount: 10,
                itemBuilder: (context, index) {
                  if (index.isOdd) {
                    return Container(
                      margin: EdgeInsets.only(top: 5, right: 20),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: <Widget>[
                          CircleAvatar(),
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
                              child: Text(
                                  "RxDart is a reactive functional programming library for Google Dart, based on ReactiveX. Google Dart comes with a very decent Streams API out-of-the-box; rather than attempting to provide an alternative to this API, RxDart adds functionality on top of it."),
                            ),
                          )
                        ],
                      ),
                    );
                  } else {
                    return Container(
                      margin: EdgeInsets.only(top: 5, left: 20),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: <Widget>[
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
                                  "RxDart is a reactive functional programming library for Google Dart, based on ReactiveX. Google Dart comes with a very decent Streams API out-of-the-box; rather than attempting to provide an alternative to this API, RxDart adds functionality on top of it."),
                            ),
                          ),
                          CircleAvatar(),
                        ],
                      ),
                    );
                  }
                },
              ),
            ),
            Container(
              color: Colors.red,
              width: 200,
              height: 200,
              child: images.length <= 0
                  ? Text("None")
                  : AssetThumb(
                      width: 200,
                      height: 200,
                      asset: images[0],
                    ),
            ),
            Container(
              color: Colors.red,
              width: 200,
              height: 200,
              child: _imageCameraFile == null
                  ? Text("None")
                  : Image.file(_imageCameraFile),
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
                  Container(
                    width: 40,
                    child: IconButton(
                      icon: Icon(Icons.videocam),
                      onPressed: () {},
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
                    onPressed: () {},
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  Future _handleGetPhotoCamera() async {
    var image = await ImagePicker.pickImage(source: ImageSource.camera);
    setState(() {
      _imageCameraFile = image;
    });
  }

  Future _handleGetImages() async {
    var images = await MultiImagePicker.pickImages(
      maxImages: 10,
      enableCamera: true,
    );
    setState(() {
      this.images = images;
    });
  }

  _handleCallTo(String phoneNumber) async {
    print("Processing...");
    var url = "tel:+1 555 010 999";
    if (await canLaunch(url)) {
      print("OK");
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }
}
