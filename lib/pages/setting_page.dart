import 'package:flutter/material.dart';

class SettingPage extends StatefulWidget {
  @override
  _SettingPageState createState() => _SettingPageState();
}

class _SettingPageState extends State<SettingPage> {
  List<bool> _isSelected = [false, false, true];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(
            'Setting',
            semanticsLabel: 'Setting',
          ),
        ),
        body: ListView(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: ListTile(
                leading: Text(
                  'Theme',
                  style: Theme.of(context).textTheme.body2,
                  semanticsLabel: 'Theme',
                ),
                trailing: ToggleButtons(
                  children: <Widget>[
                    Icon(Icons.brightness_5),
                    Icon(Icons.brightness_2),
                    Icon(Icons.settings),
                  ],
                  onPressed: (int index) {
                    setState(() {
                      for (int buttonIndex = 0;
                          buttonIndex < _isSelected.length;
                          buttonIndex++) {
                        if (buttonIndex == index) {
                          _isSelected[buttonIndex] = true;
                        } else {
                          _isSelected[buttonIndex] = false;
                        }
                      }
                    });
                    print(_isSelected);
                  },
                  isSelected: _isSelected,
                ),
              ),
            ),
          ],
        ));
  }
}
