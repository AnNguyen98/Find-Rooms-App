import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class GridImages extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.green,
      child: _rowImages(100),
    );
  }

  _rowImages(int number) {
    switch (number) {
      case 0:
        return Container();
        break;
      case 1:
        return Container(
          height: 170,
          color: Colors.red,
        );
        break;
      case 2:
        return Container(
          height: 170,
          child: Flex(
            direction: Axis.horizontal,
            children: <Widget>[
              Flexible(
                flex: 1,
                child: Container(
                  color: Colors.red,
                ),
              ),
              Flexible(
                flex: 1,
                child: Container(
                  color: Colors.orange,
                ),
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
                color: Colors.blue,
                height: 150,
              ),
              Container(
                height: 100,
                child: Flex(
                  direction: Axis.horizontal,
                  children: <Widget>[
                    Flexible(
                      flex: 1,
                      child: Container(
                        color: Colors.red,
                      ),
                    ),
                    Flexible(
                      flex: 1,
                      child: Container(
                        color: Colors.orange,
                      ),
                    ),
                  ],
                ),
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
                color: Colors.blue,
                height: 170,
                child: Flex(
                  direction: Axis.horizontal,
                  children: <Widget>[
                    Flexible(
                      flex: 1,
                      child: Container(
                        color: Colors.red,
                      ),
                    ),
                    Flexible(
                      flex: 1,
                      child: Container(
                        color: Colors.orange,
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                height: 100,
                child: Flex(
                  direction: Axis.horizontal,
                  children: <Widget>[
                    Flexible(
                      flex: 1,
                      child: Container(
                        color: Colors.blueAccent,
                      ),
                    ),
                    Flexible(
                      flex: 1,
                      child: Container(
                        color: Colors.orange,
                      ),
                    ),
                    Flexible(
                      flex: 1,
                      child: Container(
                        color: Colors.yellow,
                        child: (number - 5) == 0
                            ? Container()
                            : Center(
                                child: Text(
                                  "+${number - 5}",
                                  style: TextStyle(
                                    fontSize: 18,
                                    color: Colors.white,
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
