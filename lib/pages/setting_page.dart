import 'package:flutter/material.dart';

class SettingPage extends StatelessWidget {
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
                  'Enable Dark Mode',
                  style: Theme.of(context).textTheme.body2,
                  semanticsLabel: 'Enable dark mode',
                ),
                trailing: Switch(
                  value: true,
                  onChanged: (bool newValue) => _update(),
                  activeColor: Theme.of(context).primaryColor,
                  activeTrackColor: Theme.of(context).primaryColorLight,
                ),
              ),
            ),
          ],
        ));
  }

  bool _update() {
    return false;
  }
}
