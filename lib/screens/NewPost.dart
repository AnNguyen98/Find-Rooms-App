import 'dart:async';
import 'dart:io';

import 'package:find_rooms_app/model/Post.dart';
import 'package:find_rooms_app/model/User.dart';
import 'package:find_rooms_app/ui/uiHelper.dart';
import 'package:find_rooms_app/widgets/CardInformation.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:multi_image_picker/multi_image_picker.dart';
import 'package:uuid/uuid.dart';

class NewPost extends StatefulWidget {
  static String title = "/newPost";
  final User user;
  NewPost({this.user});
  @override
  _NewPostState createState() => _NewPostState();
}

class _NewPostState extends State<NewPost> {
  TextEditingController postTextController;
  TextEditingController addressController;
  TextEditingController landlordsController;
  TextEditingController priceController;
  List<Widget> imageWidgets = [];
  List<File> fileImages = [];

  @override
  void initState() {
    super.initState();
    postTextController = TextEditingController();
    landlordsController = TextEditingController();
    addressController = TextEditingController();
    priceController = TextEditingController();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Create Post"),
        actions: <Widget>[
          MaterialButton(
            onPressed: _handlePost,
            child: Text(
              "POST",
              style: TextStyle(color: Colors.white, fontSize: 16),
            ),
          )
        ],
      ),
      body: Container(
        child: ListView(
          children: <Widget>[
            CardInformation(
              controller: addressController,
              title: "Address",
            ),
            CardInformation(
              controller: landlordsController,
              title: "Landlords",
            ),
            CardInformation(
              controller: priceController,
              keyboardType: TextInputType.number,
              title: "Price",
            ),
            Container(
              margin: EdgeInsets.all(10),
              padding: EdgeInsets.all(5),
              height: 300,
              child: TextField(
                controller: postTextController,
                maxLines: 100,
                decoration: InputDecoration(
                  border: InputBorder.none,
                  hintText: "Title for your post...",
                ),
              ),
            ),
            Container(
              margin: EdgeInsets.all(10),
              child: Wrap(
                direction: Axis.horizontal,
                children: imageWidgets,
              ),
            ),
            Container(
              height: 45,
              margin: EdgeInsets.all(10),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.black54, width: 1),
                borderRadius: BorderRadius.circular(22.5),
              ),
              child: MaterialButton(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(22.5),
                ),
                onPressed: () {
                  _settingModalBottomSheet(context);
                },
                child: Row(
                  children: <Widget>[
                    Icon(Icons.add_a_photo),
                    SizedBox(
                      width: 20,
                    ),
                    Text("Photo/ Video")
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _settingModalBottomSheet(context) {
    showModalBottomSheet(
        context: context,
        builder: (BuildContext bc) {
          return Container(
            height: 130,
            child: Column(
              children: <Widget>[
                ListTile(
                  leading: Icon(Icons.camera),
                  title: Text('Camera'),
                  onTap: _handleGetPhotoCamera,
                ),
                ListTile(
                  leading: Icon(FontAwesomeIcons.images),
                  title: Text('Photos'),
                  onTap: _handleGetImages,
                ),
              ],
            ),
          );
        });
  }

  _handleRemoveImage() {}

  _moneyFormater(String money) {
    return NumberFormat.currency(locale: 'vi', customPattern: 'VNĐ #,###.#')
        .format(int.parse(money));
  }

  Future _handleGetPhotoCamera() async {
    var file = await ImagePicker.pickImage(source: ImageSource.camera);
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

  _showAlertDone(String title, IconData iconData, Color iconColor) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          content: Container(
            height: 130,
            child: Column(
              children: <Widget>[
                Icon(
                  iconData,
                  size: 100,
                  color: iconColor,
                ),
                Text(title),
              ],
            ),
          ),
          title: Text("Message"),
          actions: <Widget>[
            MaterialButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text(
                "OK",
                style: TextStyle(color: Colors.blue),
              ),
            )
          ],
        );
      },
    );
  }

  _addNewPostId(String postID) async {
    DatabaseReference _postsRef =
        FirebaseDatabase.instance.reference().child("postIds");
    _postsRef.onValue.first.then((event) {
      _postsRef = FirebaseDatabase.instance.reference();
      if (event.snapshot.value == null) {
        _postsRef.child("postIds").set([postID]);
        return;
      }
      List listPostIds = event.snapshot.value as List;
      List<String> listPostIdsString =
          listPostIds.map((value) => value.toString()).toList();
      print(listPostIdsString);
      listPostIdsString.add(postID);
      _postsRef.child("postIds").set(listPostIdsString);
    });
  }

  _handlePost() async {
    var uuid = Uuid();
    if (widget.user == null) {
      print("User null");
      return;
    }
    UIHelper.showLoadingDialog(context);
    _getImageUrlsUpload((imageUrls) async {
      String uuidV4 = uuid.v4();
      Post newPost = Post(
        uid: widget.user.uid,
        avatarUserPostUrl: widget.user.avatarUrl,
        content: postTextController.text,
        postId: uuidV4,
        datePost: DateFormat("HH:mm:ss - dd/MM/yyyy").format(DateTime.now()),
        imagesUrls: imageUrls,
        likeCount: 0,
        address: addressController.text,
        landlords: landlordsController.text,
        price: _moneyFormater(priceController.text),
        userName: widget.user.fullName,
      );
      _addNewPostId(newPost.postId);
      var postJson = newPost.toJson();
      DatabaseReference _postsRef =
          FirebaseDatabase.instance.reference().child("posts");
      await _postsRef.child(newPost.postId).set(postJson).catchError((error) {
        Navigator.pop(context);
        _showAlertDone("Error", Icons.error_outline, Colors.red);
        return;
      });
      Navigator.pop(context);
      _showAlertDone("Done", Icons.check_circle, Colors.green);
    });
  }
}
