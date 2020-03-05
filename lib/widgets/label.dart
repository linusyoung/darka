import 'package:flutter/material.dart';

class Label extends StatelessWidget {
  final int color;

  Label({@required this.color});

  @override
  Widget build(BuildContext context) {
    Color _labelColor;
    if (color == 0) {
      _labelColor = Theme.of(context).canvasColor;
    } else {
      _labelColor = Color(color);
    }
    return Container(
      height: 20.0,
      width: 55.0,
      decoration: BoxDecoration(
        color: _labelColor,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(7.0),
          bottomLeft: Radius.circular(7.0),
        ),
      ),
    );
  }
}
