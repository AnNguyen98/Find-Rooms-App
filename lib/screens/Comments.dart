import 'dart:io';

import 'package:find_rooms_app/model/Comment.dart';
import 'package:find_rooms_app/model/User.dart';
import 'package:find_rooms_app/ui/uiHelper.dart';
import 'package:find_rooms_app/until/database.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class Comments extends StatefulWidget {
  static String title = "/comments";
  final String postId;
  final User user;
  Comments({this.postId, this.user});
  @override
  _CommentsState createState() => _CommentsState();
}

class _CommentsState extends State<Comments> {
  TextEditingController commentController;
  List<Comment> comments = [];
  String imageUrl = "";
  @override
  void initState() {
    super.initState();
    commentController = TextEditingController();
    _getComments();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Comments"),
      ),
      body: Container(
        margin: EdgeInsets.only(top: 5),
        child: Column(
          children: <Widget>[
            Expanded(
              child: ListView.builder(
                itemCount: comments.length,
                itemBuilder: (context, index) {
                  return Container(
                    margin: EdgeInsets.only(top: 5),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        CircleAvatar(
                          backgroundImage:
                              NetworkImage(comments[index].userAvatarUrl),
                        ),
                        Expanded(
                          child: Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20),
                              color: Color.fromRGBO(240, 242, 245, 1),
                            ),
                            padding: EdgeInsets.only(
                                top: 5, bottom: 5, left: 10, right: 5),
                            margin:
                                EdgeInsets.only(left: 10, right: 10, top: 5),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Container(
                                  margin: EdgeInsets.only(
                                      top: 0, bottom: 5, left: 0, right: 5),
                                  child: Text(
                                    comments.length > 0 &&
                                            comments[index].userName != null
                                        ? comments[index].userName
                                        : "",
                                    style:
                                        TextStyle(fontWeight: FontWeight.bold),
                                  ),
                                ),
                                Text(comments.length > 0 &&
                                        comments[index].content != null
                                    ? comments[index].content
                                    : ""),
                                comments[index].imageUrl != ""
                                    ? Container(
                                        margin: EdgeInsets.only(top: 10),
                                        width: 200,
                                        height: 200,
                                        child: Image(
                                          fit: BoxFit.fill,
                                          image: NetworkImage(
                                              comments[index].imageUrl),
                                        ),
                                      )
                                    : Container()
                              ],
                            ),
                          ),
                        )
                      ],
                    ),
                  );
                },
              ),
            ),
            Divider(),
            Container(
              height: 50,
              margin: EdgeInsets.only(bottom: 10, right: 20, left: 5),
              child: Row(
                children: <Widget>[
                  IconButton(
                    onPressed: _handleAddImage,
                    icon: Icon(
                      FontAwesomeIcons.camera,
                      size: 20,
                    ),
                  ),
                  Expanded(
                    child: Container(
                      padding: EdgeInsets.symmetric(horizontal: 15),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        color: Color.fromRGBO(240, 242, 246, 1),
                      ),
                      child: TextField(
                        controller: commentController,
                        decoration: InputDecoration(
                          hintText: "Write a comment...",
                          border: InputBorder.none,
                          hintStyle: TextStyle(fontSize: 14),
                        ),
                      ),
                    ),
                  ),
                  IconButton(
                    icon: Icon(FontAwesomeIcons.solidPaperPlane),
                    onPressed: _handleComment,
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  _handleAddImage() async {
    File imageFile = await UIHelper.handleGetPhoto();
    String url = await DatabaseHelper.getUrlUploadFile(imageFile, "comments");
    setState(() {
      imageUrl = url;
    });
  }

  _handleComment() {
    if (commentController.text == "") {
      return;
    }
    DatabaseReference _commentRef =
        FirebaseDatabase.instance.reference().child("comments");

    Comment comment = Comment(
        userName: widget.user.fullName,
        content: commentController.text,
        imageUrl: imageUrl,
        userAvatarUrl: widget.user.avatarUrl);
    comments.add(comment);
    commentController.text = "";
    imageUrl = "";
    var commentJson = comments.map((comment) => comment.toJson()).toList();
    _commentRef.child(widget.postId).set(commentJson);
  }

  _getComments() async {
    DatabaseReference _commentRef =
        FirebaseDatabase.instance.reference().child("comments");
    _commentRef.child(widget.postId).onValue.listen((data) {
      var value = data.snapshot.value;
      if (value == null) {
        return;
      }
      print(widget.user.fullName);
      List list = value as List;
      List<Comment> listComments =
          list.map((v) => Comment.fromObject(v)).toList();
      setState(() {
        comments = listComments;
      });
    });
  }
}
