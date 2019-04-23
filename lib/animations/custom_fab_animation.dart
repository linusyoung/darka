import 'package:flutter/material.dart';

class CustomFabAnimation extends FloatingActionButtonAnimator {
  double _x;
  double _y;
  @override
  Offset getOffset({Offset begin, Offset end, double progress}) {
    // _x = begin.dx + (end.dx - begin.dx) * progress;
    // _y = begin.dy + (end.dy - begin.dy) * progress;
    _x = end.dx;
    _y = end.dy;
    return Offset(_x, _y);
  }

  @override
  Animation<double> getRotationAnimation({Animation<double> parent}) {
    return Tween<double>(begin: 1.0, end: 1.0).animate(parent);
  }

  @override
  Animation<double> getScaleAnimation({Animation<double> parent}) {
    return Tween<double>(begin: 1.0, end: 1.0).animate(parent);
  }
}
