import 'package:flutter/material.dart';

class PunchHole extends StatelessWidget {
  final int shapeIndex;
  final double holeSize;

  PunchHole({this.shapeIndex = 1, this.holeSize = 5.0});

  @override
  Widget build(BuildContext context) {
    ShapeBorder _shapeBorder;
    switch (shapeIndex) {
      case 1:
        _shapeBorder = CircleBorder();
        break;
      case 0:
        _shapeBorder = ContinuousRectangleBorder();
        break;
      default:
        _shapeBorder = CircleBorder();
    }
    return Center(
      child: Container(
        width: holeSize,
        height: holeSize,
        decoration: ShapeDecoration(
          shape: _shapeBorder,
          color: Colors.white,
        ),
      ),
    );
  }
}
