import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:material_symbols_icons/symbols.dart';
import 'package:optimize_battery/optimize_battery.dart';
import 'package:pocket_quake/globals.dart';
import 'package:pocket_quake/main.dart';
import 'package:pocket_quake/utils/extensions.dart';
import 'package:pocket_quake/view/earthquake/eew_route.dart';
import 'package:pocket_quake/view/settings/location_setting_route.dart';

class Settings extends StatefulWidget {
  const Settings({super.key});

  @override
  State<StatefulWidget> createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {
  String _theme = Global.preference.getString("theme") ?? "system";
  String _mapBase = Global.preference.getString("base_map") ?? "geojson";
  String _location = Global.preference.getString("location") ?? "";
  bool showBatteryOptimizationAlert = false;

  void checkBatteryOptimization() {
    OptimizeBattery.isIgnoringBatteryOptimizations().then((isOptimized) {
      if (!isOptimized) {
        setState(() {
          showBatteryOptimizationAlert = true;
        });
      }
    });
  }

  @override
  void initState() {
    super.initState();
    checkBatteryOptimization();
  }

  @override
  Widget build(BuildContext context) {
    final themeOptions = {
      "light": context.l10n.themeOptionLight,
      "dark": context.l10n.themeOptionDark,
      "system": context.l10n.themeOptionSystem,
    };

    final baseMapOptions = {
      "geojson": context.l10n.mapBaseOptionGeojson,
      "googlemap": context.l10n.mapBaseOptionGoogleMap,
      "googletrain": context.l10n.mapBaseOptionGoogleTrain,
      "googlesatellite": context.l10n.mapBaseOptionGoogleSatellite,
      "openstreetmap": context.l10n.mapBaseOptionOpenStreetMap
    };

    return Scaffold(
      appBar: AppBar(
        title: Text(context.l10n.viewSettings),
      ),
      body: ListView(
        children: [
          if (showBatteryOptimizationAlert)
            ListTile(
              leading: const Icon(Symbols.dark_mode_rounded),
              title: Text(context.l10n.settingsThemeTitle),
              subtitle: Text(themeOptions[_theme]!),
              onTap: () => showDialog<String>(
                context: context,
                builder: (BuildContext context) => SimpleDialog(
                  title: Text(context.l10n.settingsThemeTitle),
                  children: [
                    ...themeOptions.entries.map(
                      (e) => RadioListTile(
                        value: e.key,
                        groupValue: _theme,
                        title: Text(e.value),
                        onChanged: (value) {
                          if (value != null) {
                            setState(() {
                              _theme = value;
                              Global.preference.setString("theme", value);
                              MainApp.of(context)!.changeTheme(_theme);
                              Navigator.pop(context);
                            });
                          }
                        },
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          TextButton(
                            onPressed: () => Navigator.pop(context),
                            child: Text(context.l10n.buttonCancel),
                          )
                        ],
                      ),
                    )
                  ],
                ),
              ),
            ),
          ListTile(
            leading: const Icon(Symbols.location_pin_rounded),
            title: Text(context.l10n.settingsLocationTitle),
            subtitle: Text(
              _location.isNotEmpty
                  ? "${Global.location[_location]?.city} ${Global.location[_location]?.town}"
                  : "未設定",
            ),
            onTap: () async {
              await Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const LocationSettingRoute(),
                ),
              );

              setState(() {
                _location = Global.preference.getString("location") ?? "";
              });
            },
          ),
          ListTile(
            leading: const Icon(Symbols.map_rounded),
            title: Text(context.l10n.settingsBaseMapTitle),
            subtitle: Text(baseMapOptions[_mapBase]!),
            onTap: () => showDialog<String>(
              context: context,
              builder: (BuildContext context) => SimpleDialog(
                title: Text(context.l10n.settingsBaseMapTitle),
                children: [
                  ...baseMapOptions.entries.map(
                    (e) => RadioListTile(
                      value: e.key,
                      groupValue: _mapBase,
                      title: Text(e.value),
                      onChanged: (value) {
                        if (value != null) {
                          setState(() {
                            _mapBase = value;
                            Global.preference.setString("base_map", value);
                            Navigator.pop(context);
                          });
                        }
                      },
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        TextButton(
                          onPressed: () => Navigator.pop(context),
                          child: Text(context.l10n.buttonCancel),
                        )
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          ListTile(
            leading: const Icon(Symbols.bug_report_rounded),
            title: const Text("開啟速報畫面"),
            onTap: () async {
              await Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const EewRoute()),
              );
            },
          ),
          ListTile(
            leading: const Icon(Symbols.bug_report_rounded),
            title: const Text("複製 FCM Token"),
            onTap: () async {
              Clipboard.setData(ClipboardData(
                  text: await FirebaseMessaging.instance.getToken() ?? ""));
              const snackBar = SnackBar(content: Text('已複製 FCM Token'));
              ScaffoldMessenger.of(context).showSnackBar(snackBar);
            },
          ),
          AboutListTile(
            icon: const Icon(Symbols.info_rounded),
            applicationName: "Pocket Quake",
            applicationVersion: "0.0.1",
            aboutBoxChildren: [Text(context.l10n.about)],
          ),
        ],
      ),
    );
  }
}
