import 'package:find_rooms_app/widgets/CardInformation.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:multi_image_picker/multi_image_picker.dart';

class NewPost extends StatefulWidget {
  static String title = "/newPost";
  @override
  _NewPostState createState() => _NewPostState();
}

class _NewPostState extends State<NewPost> {
  TextEditingController postTextController;
  TextEditingController addressController;
  TextEditingController phoneNumberController;
  TextEditingController landlordsController;
  List<Widget> imageWidgets = [];

  @override
  void initState() {
    super.initState();
    postTextController = TextEditingController();
    landlordsController = TextEditingController();
    addressController = TextEditingController();
    phoneNumberController = TextEditingController();
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
              controller: phoneNumberController,
              title: "Phone",
            ),
            CardInformation(
              controller: landlordsController,
              title: "Landlords",
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
              height: 60,
              color: Colors.orange,
              margin: EdgeInsets.all(10),
              child: ListView(
                scrollDirection: Axis.horizontal,
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
            child: Wrap(
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

  Future _handleGetPhotoCamera() async {
    var image = await ImagePicker.pickImage(source: ImageSource.camera);
    setState(() {
      imageWidgets.add(
        Container(
          width: 100,
          height: 100,
          child: Image.file(image),
        ),
      );
    });
  }

  Future _handleGetImages() async {
    var images = await MultiImagePicker.pickImages(
      maxImages: 10,
      enableCamera: true,
    );
    setState(() {
      //this.images = images;
    });
  }

  _handlePost() {
    Navigator.pop(context);
  }
}
