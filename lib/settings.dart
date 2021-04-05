import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:user_data/util/theme_notifier.dart';
import 'package:user_data/values/theme.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingsPage extends StatefulWidget {
  static const routeName = '/settings';
  @override
  _SettingsPageState createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {

  var _darkTheme = true;

  @override
  Widget build(BuildContext context) {
    final themeNotifier = Provider.of<ThemeNotifier>(context);
    _darkTheme = (themeNotifier.getTheme() == darkTheme);
    return Scaffold(
      appBar: AppBar(
        title: Text('Settings'),
      ),
      body: ListView(
        children: <Widget>[
          ListTile(
            title: Text('Dark Theme'),
            contentPadding: const EdgeInsets.only(left: 16.0),
            trailing: Transform.scale(
              scale: 0.75,
              child:Switch(
                value: _darkTheme,
                onChanged: (val) {
                  setState(() {
                    _darkTheme = val;
                  });
                  onThemeChanged(val, themeNotifier);
                },
              ),
            ),
          )
        ],
      ),
    );
  }

  void onThemeChanged(bool value, ThemeNotifier themeNotifier) async {
    (value)
        ? themeNotifier.setTheme(darkTheme)
        : themeNotifier.setTheme(lightTheme);
    var prefsTheme = await SharedPreferences.getInstance();
    prefsTheme.setBool('darkMode', value);
  }
}