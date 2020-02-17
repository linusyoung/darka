import 'package:darka/blocs/setting/settings.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SettingPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    bool _darkModeIsEnable;
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
                  value: _darkModeIsEnable,
                  onChanged: (bool newValue) => {
                    BlocProvider.of<SettingBloc>(context)
                        .add(ToggleDarkMode(newValue))
                  },
                  activeColor: Theme.of(context).primaryColor,
                  activeTrackColor: Theme.of(context).primaryColorLight,
                ),
              ),
            ),
          ],
        ));
  }
}
