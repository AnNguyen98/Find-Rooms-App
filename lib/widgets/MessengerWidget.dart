import 'package:find_rooms_app/model/MessengerModel.dart';
import 'package:find_rooms_app/model/User.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class MessengerWidget extends StatelessWidget {
  final MessengerModel mes;
  final User user;
  final BorderRadiusGeometry border;
  final TextAlign textAlign;
  final Color color;
  final Alignment alignmentImages;
  final EdgeInsetsGeometry margin;
  final MainAxisAlignment mainAxisAlignment;
  MessengerWidget({
    this.mes,
    this.user,
    this.border,
    this.textAlign = TextAlign.right,
    this.color = Colors.white,
    this.alignmentImages = Alignment.bottomRight,
    this.margin,
    this.mainAxisAlignment,
  });
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: margin,
      child: Column(
        mainAxisAlignment: mainAxisAlignment,
        children: <Widget>[
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: <Widget>[
              Spacer(),
              Expanded(
                child: Container(
                  decoration: BoxDecoration(
                    color: color,
                    borderRadius: border,
                  ),
                  padding: EdgeInsets.all(10),
                  margin: EdgeInsets.all(5),
                  child: Text(
                    mes.content,
                    textAlign: textAlign,
                  ),
                ),
              ),
              CircleAvatar(
                backgroundImage: user != null && user.avatarUrl != null
                    ? NetworkImage(user.avatarUrl)
                    : AssetImage("images/avatar-default.png"),
              ),
            ],
          ),
          mes.imageUrl != null
              ? Container(
                  alignment: alignmentImages,
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
                              child: Image.network(url.toString()),
                            ))
                        .toList(),
                  ),
                )
              : Container(),
        ],
      ),
    );
  }
}
