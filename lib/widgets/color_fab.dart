import 'package:flutter/material.dart';

class ColorFab extends StatefulWidget {
  final Function() onPressed;
  final String tooltip;
  final ValueNotifier<int> colorNotifier;

  ColorFab(this.colorNotifier, {this.onPressed, this.tooltip});

  @override
  _ColorFabState createState() => _ColorFabState();
}

class _ColorFabState extends State<ColorFab>
    with SingleTickerProviderStateMixin {
  bool isOpened = false;
  AnimationController _animationController;
  Animation<double> _animateIcon;
  Animation<double> _translateButton;
  Curve _curve = Curves.easeOut;
  double _fabWidth = 56.0;

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
      begin: _fabWidth,
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

  animate(Color color) {
    if (!isOpened) {
      _animationController.forward();
    } else {
      _animationController.reverse();
    }
    isOpened = !isOpened;

    if (widget.colorNotifier.value == color.value) {
      widget.colorNotifier.value = 0;
    } else if (color != Colors.black) {
      widget.colorNotifier.value = color.value;
    }
  }

  Widget redLabel() {
    return colorPicker(Colors.red, 'red');
  }

  Widget amberLabel() {
    return colorPicker(Colors.amber, 'amber');
  }

  Widget greeLabel() {
    return colorPicker(Colors.green, 'green');
  }

  Widget colorPicker(Color color, Object heroTag) {
    return FloatingActionButton(
      heroTag: heroTag,
      onPressed: () => animate(color),
      backgroundColor: color,
    );
  }

  Widget toggle() {
    return FloatingActionButton(
      heroTag: 'edit_color',
      backgroundColor: Theme.of(context).primaryColor,
      onPressed: () => animate(Colors.black),
      tooltip: 'Toggle',
      child: AnimatedIcon(
        icon: AnimatedIcons.menu_close,
        progress: _animateIcon,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    print(_translateButton.value);
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: <Widget>[
        Transform(
          transform: Matrix4.translationValues(
            _translateButton.value * 3.0,
            0.0,
            0.0,
          ),
          child: redLabel(),
        ),
        Transform(
          transform: Matrix4.translationValues(
            _translateButton.value * 2.0,
            0.0,
            0.0,
          ),
          child: amberLabel(),
        ),
        Transform(
          transform: Matrix4.translationValues(
            _translateButton.value,
            0.0,
            0.0,
          ),
          child: greeLabel(),
        ),
        toggle(),
      ],
    );
  }
}
