import 'package:flutter/material.dart';

class PunchHole extends StatelessWidget {
  final int shapeIndex;
  final double holeWidth;
  final double holeHeight;

  PunchHole(
      {@required this.shapeIndex, this.holeWidth = 5.5, this.holeHeight = 5.5});

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
        width: holeWidth,
        height: holeHeight,
        decoration: ShapeDecoration(
          shape: _shapeBorder,
          color: Colors.white,
        ),
      ),
    );
  }
}
