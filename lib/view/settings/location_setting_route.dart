import 'package:flutter/material.dart';
import 'package:pocket_quake/globals.dart';
import 'package:pocket_quake/utils/extensions.dart';

class LocationSettingRoute extends StatefulWidget {
  const LocationSettingRoute({super.key});

  @override
  State<LocationSettingRoute> createState() => _LocationSettingRoute();
}

class _LocationSettingRoute extends State<LocationSettingRoute> {
  String _location = Global.preference.getString("location") ?? "";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          leading: const BackButton(),
          title: Text(context.l10n.settingsLocationTitle),
          elevation: 3.0),
      body: ListView(
        children: [
          ListTile(
            title: Text(context.l10n.settingsLocationCityTitle),
            subtitle: Text(_location.isNotEmpty
                ? "${Global.location[_location]?.city}"
                : context.l10n.locationNone),
            onTap: () {
              List<String> cityList = Global.region.keys.toList();

              showDialog(
                context: context,
                builder: (context) => AlertDialog(
                  title: Text(context.l10n.settingsLocationCityTitle),
                  contentPadding:
                      const EdgeInsets.symmetric(horizontal: 0, vertical: 16.0),
                  content: SizedBox(
                    width: double.minPositive,
                    child: ListView.builder(
                      shrinkWrap: true,
                      itemCount: cityList.length,
                      itemBuilder: (context, index) => RadioListTile(
                        value: cityList[index],
                        groupValue: Global.location[_location]?.city ?? "",
                        title: Text(cityList[index]),
                        onChanged: (value) {
                          setState(() {
                            String code = Global.region[value]!.values
                                .toList()
                                .first
                                .code
                                .toString();
                            _location = code;
                            Global.preference.setString("location", code);
                            Navigator.pop(context);
                          });
                        },
                      ),
                    ),
                  ),
                  actions: [
                    TextButton(
                        onPressed: () => Navigator.pop(context),
                        child: Text(context.l10n.buttonCancel))
                  ],
                ),
              );
            },
          ),
          ListTile(
            title: Text(context.l10n.settingsLocationTownTitle),
            subtitle: Text(_location.isNotEmpty
                ? "${Global.location[_location]?.town}"
                : context.l10n.locationNone),
            enabled: _location.isNotEmpty,
            onTap: () {
              List<String> townList = Global
                  .region[Global.location[_location]!.city]!.values
                  .map((e) => e.code.toString())
                  .toList();

              showDialog(
                context: context,
                builder: (context) => AlertDialog(
                  title: Text(context.l10n.settingsLocationTownTitle),
                  contentPadding:
                      const EdgeInsets.symmetric(horizontal: 0, vertical: 16.0),
                  content: SizedBox(
                    width: double.minPositive,
                    child: ListView.builder(
                      shrinkWrap: true,
                      itemCount: townList.length,
                      itemBuilder: (context, index) => RadioListTile(
                        value: townList[index],
                        groupValue: _location,
                        title: Text(Global.location[townList[index]]!.town),
                        onChanged: (value) {
                          setState(() {
                            _location = value.toString();
                            Global.preference
                                .setString("location", value.toString());
                            Navigator.pop(context);
                          });
                        },
                      ),
                    ),
                  ),
                  actions: [
                    TextButton(
                        onPressed: () => Navigator.pop(context),
                        child: Text(context.l10n.buttonCancel))
                  ],
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
