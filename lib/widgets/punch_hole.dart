import 'package:flutter/material.dart';

class PunchHole extends StatelessWidget {
  final int shapeIndex;

  PunchHole({@required this.shapeIndex});

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
