import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class TextFieldCustom extends StatelessWidget {
  final TextEditingController controller;
  final String placeholder;
  final bool obscureText;
  final Function onTap;
  final IconData icon;
  final TextInputType keyboardType;
  final bool enabled;
  TextFieldCustom({
    this.enabled = true,
    this.controller,
    this.placeholder,
    this.obscureText,
    this.onTap,
    this.icon = FontAwesomeIcons.eyeSlash,
    this.keyboardType = TextInputType.emailAddress,
  });
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 46,
      padding: EdgeInsets.symmetric(horizontal: 10),
      margin: EdgeInsets.symmetric(horizontal: 20, vertical: 5),
      decoration: BoxDecoration(
        color: Colors.grey.withOpacity(0.4),
        border: Border.all(
          style: BorderStyle.solid,
          width: 1,
          color: Colors.black,
        ),
        borderRadius: BorderRadius.circular(20),
      ),
      child: obscureText != null
          ? Row(
              children: <Widget>[
                Expanded(
                  child: CupertinoTextField(
                    enabled: enabled,
                    style: TextStyle(color: Colors.black, fontSize: 13),
                    controller: controller,
                    placeholder: placeholder,
                    obscureText: obscureText,
                    maxLength: 8,
                    placeholderStyle:
                        TextStyle(color: Colors.black38, fontSize: 13),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
                GestureDetector(
                  child: Icon(
                    icon,
                    size: 20,
                    color: Colors.black,
                  ),
                  onTap: onTap,
                ),
                SizedBox(
                  width: 5,
                )
              ],
            )
          : CupertinoTextField(
              keyboardType: keyboardType,
              controller: controller,
              placeholder: placeholder,
              enabled: enabled,
              style: TextStyle(color: Colors.black, fontSize: 13),
              placeholderStyle: TextStyle(color: Colors.black38, fontSize: 13),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
    );
  }
}
