import 'package:flutter/cupertino.dart';

class ImageAspectRatio extends StatelessWidget {
  final String imageUrl;
  ImageAspectRatio({this.imageUrl});
  @override
  Widget build(BuildContext context) {
    return Flexible(
      flex: 1,
      child: AspectRatio(
        aspectRatio: 1,
        child: Image.network(
          imageUrl,
          fit: BoxFit.fill,
        ),
      ),
    );
  }
}
