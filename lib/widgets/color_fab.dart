import 'package:flutter/material.dart';

class ColorFab extends StatefulWidget {
  final Function() onPressed;
  final String tooltip;

  ColorFab({this.onPressed, this.tooltip});

  @override
  _ColorFabState createState() => _ColorFabState();
}

class _ColorFabState extends State<ColorFab>
    with SingleTickerProviderStateMixin {
  bool isOpened = false;
  AnimationController _animationController;
  // Animation<Color> _buttonColor;
  Animation<double> _animateIcon;
  Animation<double> _translateButton;
  Curve _curve = Curves.easeOut;
  double _fabHeight = 56.0;
  // final Color _beginColor;

  // _ColorFabState(this._beginColor);

  @override
  initState() {
    _animationController =
        AnimationController(vsync: this, duration: Duration(milliseconds: 500))
          ..addListener(() {
            setState(() {});
          });
    _animateIcon =
        Tween<double>(begin: 0.0, end: 1.0).animate(_animationController);

    _translateButton = Tween<double>(
      begin: _fabHeight,
      end: -14.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Interval(
        0.0,
        0.75,
        curve: _curve,
      ),
    ));
    super.initState();
  }

  @override
  dispose() {
    _animationController.dispose();
    super.dispose();
  }

  animate() {
    if (!isOpened) {
      _animationController.forward();
    } else {
      _animationController.reverse();
    }
    isOpened = !isOpened;
  }

  Widget add() {
    return colorPicker(Colors.red, 'red');
  }

  Widget image() {
    return colorPicker(Colors.amber, 'amber');
  }

  Widget inbox() {
    return colorPicker(Colors.green, 'green');
  }

  Widget colorPicker(Color color, Object heroTag) {
    return Container(
      child: FloatingActionButton(
        heroTag: heroTag,
        onPressed: animate,
        backgroundColor: color,
      ),
    );
  }

  Widget toggle() {
    return Container(
      child: FloatingActionButton(
        heroTag: 'edit_color',
        backgroundColor: Theme.of(context).primaryColor,
        onPressed: animate,
        tooltip: 'Toggle',
        child: AnimatedIcon(
          icon: AnimatedIcons.menu_close,
          progress: _animateIcon,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: <Widget>[
        Transform(
          transform: Matrix4.translationValues(
            _translateButton.value * 3.0,
            0.0,
            0.0,
          ),
          child: add(),
        ),
        Transform(
          transform: Matrix4.translationValues(
            _translateButton.value * 2.0,
            0.0,
            0.0,
          ),
          child: image(),
        ),
        Transform(
          transform: Matrix4.translationValues(
            _translateButton.value,
            0.0,
            0.0,
          ),
          child: inbox(),
        ),
        toggle(),
      ],
    );
  }
}
