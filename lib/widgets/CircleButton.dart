import 'package:flutter/material.dart';

class CircleButton extends StatelessWidget {
  final Function onPressed;
  final Color color;
  final Color backgroundColor;
  final IconData icon;
  final double iconSize;

  CircleButton({
    this.color = Colors.white,
    this.backgroundColor = Colors.green,
    this.onPressed,
    @required this.icon,
    this.iconSize = 25,
  });

  @override
  Widget build(BuildContext context) {
    return CircleAvatar(
      radius: 25,
      backgroundColor: backgroundColor,
      child: IconButton(
        iconSize: iconSize,
        color: color,
        icon: Icon(icon),
        onPressed: onPressed,
      ),
    );
  }
}
