import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:pocket_quake/globals.dart';
import 'package:pocket_quake/main.dart';
import 'package:pocket_quake/view/earthquake/eew_route.dart';
import 'package:pocket_quake/view/settings/location_setting_route.dart';

class Settings extends StatefulWidget {
  const Settings({super.key});

  @override
  State<StatefulWidget> createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {
  String _theme = Global.preference.getString("theme") ?? "system";
  String _location = Global.preference.getString("location") ?? "";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(AppLocalizations.of(context)!.viewSettings),
        ),
        body: ListView(
          children: [
            ListTile(
              title: Text(AppLocalizations.of(context)!.settingsThemeTitle),
              subtitle: Text({
                "light": AppLocalizations.of(context)!.themeOptionLight,
                "dark": AppLocalizations.of(context)!.themeOptionDark,
                "system": AppLocalizations.of(context)!.themeOptionSystem
              }[_theme]!),
              onTap: () => showDialog<String>(
                context: context,
                builder: (BuildContext context) => SimpleDialog(
                    title:
                        Text(AppLocalizations.of(context)!.settingsThemeTitle),
                    children: [
                      RadioListTile(
                          value: "light",
                          groupValue: _theme,
                          title: Text(
                              AppLocalizations.of(context)!.themeOptionLight),
                          onChanged: (value) {
                            setState(() {
                              _theme = value!;
                              Global.preference.setString("theme", value);
                              MainApp.of(context)!.changeTheme(_theme);
                              Navigator.pop(context);
                            });
                          }),
                      RadioListTile(
                          value: "dark",
                          groupValue: _theme,
                          title: Text(
                              AppLocalizations.of(context)!.themeOptionDark),
                          onChanged: (value) {
                            setState(() {
                              _theme = value!;
                              Global.preference.setString("theme", value);
                              MainApp.of(context)!.changeTheme(_theme);
                              Navigator.pop(context);
                            });
                          }),
                      RadioListTile(
                          value: "system",
                          groupValue: _theme,
                          title: Text(
                              AppLocalizations.of(context)!.themeOptionSystem),
                          onChanged: (value) {
                            setState(() {
                              _theme = value!;
                              Global.preference.setString("theme", value);
                              MainApp.of(context)!.changeTheme(_theme);
                              Navigator.pop(context);
                            });
                          }),
                      Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              TextButton(
                                  onPressed: () => Navigator.pop(context),
                                  child: Text(AppLocalizations.of(context)!
                                      .buttonCancel))
                            ],
                          ))
                    ]),
              ),
            ),
            ListTile(
              title: Text(AppLocalizations.of(context)!.settingsLocationTitle),
              subtitle: Text(_location.isNotEmpty
                  ? "${Global.location[_location]?.city} ${Global.location[_location]?.town}"
                  : "未設定"),
              onTap: () async {
                await Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const LocationSettingRoute()),
                );

                setState(() {
                  _location = Global.preference.getString("location") ?? "";
                });
              },
            ),
            ListTile(
              title: const Text("開啟速報畫面"),
              onTap: () async {
                await Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const EewRoute()),
                );
              },
            ),
          ],
        ));
  }
}
