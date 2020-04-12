import 'package:flutter/material.dart';

class PunchHole extends StatelessWidget {
  final String shape;

  PunchHole({@required this.shape});

  @override
  Widget build(BuildContext context) {
    ShapeBorder _shapeBorder;
    switch (shape) {
      case "circle":
        _shapeBorder = CircleBorder();
        break;
      case "box":
        _shapeBorder = ContinuousRectangleBorder();
        break;
      default:
        _shapeBorder = CircleBorder();
    }
    return Center(
      child: Container(
        width: 5.5,
        height: 5.5,
        decoration: ShapeDecoration(
          shape: _shapeBorder,
          color: Colors.white,
        ),
      ),
    );
  }
}
