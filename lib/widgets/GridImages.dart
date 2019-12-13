import 'package:find_rooms_app/widgets/ImageAspectRatio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class GridImages extends StatelessWidget {
  final List<dynamic> imageUrls;
  GridImages({this.imageUrls});
  @override
  Widget build(BuildContext context) {
    return Container(
      child: _rowImages(imageUrls.length),
    );
  }

  _rowImages(int number) {
    switch (number) {
      case 0:
        return Container();
        break;
      case 1:
        return Container(
          alignment: Alignment.center,
          child: Image.network(
            imageUrls[0].toString(),
            fit: BoxFit.fill,
          ),
        );
        break;
      case 2:
        return Container(
          child: Flex(
            direction: Axis.horizontal,
            children: <Widget>[
              ImageAspectRatio(
                imageUrl: imageUrls[0].toString(),
              ),
              ImageAspectRatio(
                imageUrl: imageUrls[1].toString(),
              ),
            ],
          ),
        );
        break;
      case 3:
        return Container(
          child: Column(
            children: <Widget>[
              Container(
                child: Image.network(
                  imageUrls[0].toString(),
                  fit: BoxFit.fill,
                ),
              ),
              Flex(
                direction: Axis.horizontal,
                children: <Widget>[
                  ImageAspectRatio(
                    imageUrl: imageUrls[1].toString(),
                  ),
                  ImageAspectRatio(
                    imageUrl: imageUrls[2].toString(),
                  ),
                ],
              ),
            ],
          ),
        );
        break;
      case 4:
        return Container(
          child: Column(
            children: <Widget>[
              Flex(
                direction: Axis.horizontal,
                children: <Widget>[
                  ImageAspectRatio(
                    imageUrl: imageUrls[0].toString(),
                  ),
                  ImageAspectRatio(
                    imageUrl: imageUrls[1].toString(),
                  ),
                ],
              ),
              Flex(
                direction: Axis.horizontal,
                children: <Widget>[
                  ImageAspectRatio(
                    imageUrl: imageUrls[2].toString(),
                  ),
                  ImageAspectRatio(
                    imageUrl: imageUrls[3].toString(),
                  ),
                ],
              ),
            ],
          ),
        );
        break;
      default:
        return Container(
          child: Column(
            children: <Widget>[
              Container(
                child: Flex(
                  direction: Axis.horizontal,
                  children: <Widget>[
                    ImageAspectRatio(
                      imageUrl: imageUrls[0].toString(),
                    ),
                    ImageAspectRatio(
                      imageUrl: imageUrls[1].toString(),
                    ),
                  ],
                ),
              ),
              Container(
                child: Flex(
                  direction: Axis.horizontal,
                  children: <Widget>[
                    ImageAspectRatio(
                      imageUrl: imageUrls[2].toString(),
                    ),
                    ImageAspectRatio(
                      imageUrl: imageUrls[3].toString(),
                    ),
                    Flexible(
                      flex: 1,
                      child: AspectRatio(
                        aspectRatio: 1,
                        child: (number - 5) == 0
                            ? Container(
                                child: ImageAspectRatio(
                                  imageUrl: imageUrls[4].toString(),
                                ),
                              )
                            : Container(
                                decoration: BoxDecoration(
                                  image: DecorationImage(
                                    fit: BoxFit.fill,
                                    image: NetworkImage(
                                      imageUrls[4].toString(),
                                    ),
                                  ),
                                ),
                                child: Center(
                                  child: Text(
                                    "+${number - 5}",
                                    style: TextStyle(
                                      fontSize: 18,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                              ),
                      ),
                    )
                  ],
                ),
              ),
            ],
          ),
        );
    }
  }
}
