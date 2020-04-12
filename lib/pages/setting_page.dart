import 'package:darka/locale/locales.dart';
import 'package:darka/darka_utils.dart';
import 'package:darka/user_setting.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SettingPage extends StatefulWidget {
  @override
  _SettingPageState createState() => _SettingPageState();
}

class _SettingPageState extends State<SettingPage> {
  List<bool> _isSelected = [false, false, true];
  List<bool> _holeShapeSelected = [false, true];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(
            '${AppLocalizations.of(context).setting}',
            semanticsLabel: '${AppLocalizations.of(context).setting}',
          ),
        ),
        body: ListView(
          children: <Widget>[
            FutureBuilder<int>(
                future: UserSettingHelper.getThemeMode(),
                initialData: 0,
                builder: (BuildContext context, AsyncSnapshot<int> snapshot) {
                  return snapshot.hasData
                      ? _themeSetting(snapshot.data)
                      : _themeSetting(0); //0 is ThemeMode.system
                }),
            FutureBuilder<int>(
              future: UserSettingHelper.getHoleShape(),
              initialData: 1,
              builder: (BuildContext context, AsyncSnapshot<int> snapshot) {
                return snapshot.hasData
                    ? _holeShapeSetting(snapshot.data)
                    : _holeShapeSetting(1);
              },
            ),
          ],
        ));
  }

  Widget _themeSetting(int userThemeIndex) {
    _setTheme((userThemeIndex + 2) % 3);
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: ListTile(
        leading: Text(
          '${AppLocalizations.of(context).theme}',
          style: Theme.of(context).textTheme.body2,
          semanticsLabel: '${AppLocalizations.of(context).theme}',
        ),
        trailing: ToggleButtons(
          children: <Widget>[
            Icon(Icons.brightness_5),
            Icon(Icons.brightness_2),
            Icon(Icons.settings),
          ],
          onPressed: (int index) {
            setState(() {
              _setTheme(index);
              Provider.of<SettingStateNotifier>(context, listen: false)
                  .updateTheme(index);
            });
          },
          isSelected: _isSelected,
        ),
      ),
    );
  }

  void _setTheme(int index) {
    for (int buttonIndex = 0; buttonIndex < _isSelected.length; buttonIndex++) {
      if (buttonIndex == index) {
        _isSelected[buttonIndex] = true;
      } else {
        _isSelected[buttonIndex] = false;
      }
    }
  }

  Widget _holeShapeSetting(int userHoleShapeSetting) {
    _setShape(userHoleShapeSetting);
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: ListTile(
        leading: Text(
          'Hole Shape',
          style: Theme.of(context).textTheme.body2,
        ),
        trailing: ToggleButtons(
          children: <Widget>[
            Icon(Icons.stop),
            Icon(
              Icons.lens,
              size: 15.0,
            ),
          ],
          onPressed: (int index) {
            setState(() {
              _setShape(index);
            });
          },
          isSelected: _holeShapeSelected,
        ),
      ),
    );
  }

  void _setShape(int index) {
    _holeShapeSelected[index] = true;
    _holeShapeSelected[1 - index] = false;
    switch (index) {
      case 0:
        UserSettingHelper.setHoleShape('box');
        break;
      case 1:
        UserSettingHelper.setHoleShape('circle');
        break;
      default:
    }
  }
}
