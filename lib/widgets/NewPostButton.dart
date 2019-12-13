import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class NewPostButton extends StatelessWidget {
  final Function onPressedNewPost;
  final Function onPressedAvatar;
  final ImageProvider avatar;

  NewPostButton({
    this.onPressedNewPost,
    this.onPressedAvatar,
    this.avatar,
  });
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 80,
      child: Row(
        children: <Widget>[
          GestureDetector(
            onTap: onPressedAvatar,
            child: Container(
              margin: EdgeInsets.only(left: 5),
              child: CircleAvatar(
                radius: 25,
                backgroundImage: avatar,
              ),
            ),
          ),
          Expanded(
            child: Container(
              height: 45,
              margin: EdgeInsets.symmetric(horizontal: 5),
              decoration: BoxDecoration(
                border: Border.all(width: 1, color: Colors.grey),
                borderRadius: BorderRadius.circular(30),
              ),
              child: MaterialButton(
                height: 45,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
                onPressed: onPressedNewPost,
                child: Row(
                  children: <Widget>[
                    Text(
                      "Đăng bài mới...",
                      textAlign: TextAlign.left,
                    )
                  ],
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
