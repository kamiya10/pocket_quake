import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:pocket_quake/globals.dart';

class LocationSettingRoute extends StatefulWidget {
  const LocationSettingRoute({super.key});

  @override
  State<LocationSettingRoute> createState() => _LocationSettingRoute();
}

class _LocationSettingRoute extends State<LocationSettingRoute> {
  String _location = Global.preference.getString("location") ?? "";

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(
            leading: const BackButton(),
            title: Text(AppLocalizations.of(context)!.settingsLocationTitle),
            elevation: 3.0),
        body: ListView(
          children: [
            ListTile(
              title:
                  Text(AppLocalizations.of(context)!.settingsLocationCityTitle),
              subtitle: Text(_location.isNotEmpty
                  ? "${Global.location[_location]?.city}"
                  : AppLocalizations.of(context)!.locationNone),
              onTap: () {
                List<String> cityList = Global.region.keys.toList();

                showDialog(
                    context: context,
                    builder: (context) => AlertDialog(
                          title: Text(AppLocalizations.of(context)!
                              .settingsLocationCityTitle),
                          contentPadding: const EdgeInsets.symmetric(
                              horizontal: 0, vertical: 16.0),
                          content: SizedBox(
                              width: double.minPositive,
                              child: ListView.builder(
                                  shrinkWrap: true,
                                  itemCount: cityList.length,
                                  itemBuilder: (context, index) =>
                                      RadioListTile(
                                          value: cityList[index],
                                          groupValue: Global
                                                  .location[_location]?.city ??
                                              "",
                                          title: Text(cityList[index]),
                                          onChanged: (value) {
                                            setState(() {
                                              String code = Global
                                                  .region[value]!.values
                                                  .toList()
                                                  .first
                                                  .code
                                                  .toString();
                                              _location = code;
                                              Global.preference
                                                  .setString("location", code);
                                              Navigator.pop(context);
                                            });
                                          }))),
                          actions: [
                            TextButton(
                                onPressed: () => Navigator.pop(context),
                                child: Text(
                                    AppLocalizations.of(context)!.buttonCancel))
                          ],
                        ));
              },
            ),
            ListTile(
              title:
                  Text(AppLocalizations.of(context)!.settingsLocationTownTitle),
              subtitle: Text(_location.isNotEmpty
                  ? "${Global.location[_location]?.town}"
                  : AppLocalizations.of(context)!.locationNone),
              enabled: _location.isNotEmpty,
              onTap: () {
                List<String> townList = Global
                    .region[Global.location[_location]!.city]!.values
                    .map((e) => e.code.toString())
                    .toList();

                showDialog(
                    context: context,
                    builder: (context) => AlertDialog(
                          title: Text(AppLocalizations.of(context)!
                              .settingsLocationTownTitle),
                          contentPadding: const EdgeInsets.symmetric(
                              horizontal: 0, vertical: 16.0),
                          content: SizedBox(
                              width: double.minPositive,
                              child: ListView.builder(
                                  shrinkWrap: true,
                                  itemCount: townList.length,
                                  itemBuilder: (context, index) =>
                                      RadioListTile(
                                          value: townList[index],
                                          groupValue: _location,
                                          title: Text(Global
                                              .location[townList[index]]!.town),
                                          onChanged: (value) {
                                            setState(() {
                                              _location = value.toString();
                                              Global.preference.setString(
                                                  "location", value.toString());
                                              Navigator.pop(context);
                                            });
                                          }))),
                          actions: [
                            TextButton(
                                onPressed: () => Navigator.pop(context),
                                child: Text(
                                    AppLocalizations.of(context)!.buttonCancel))
                          ],
                        ));
              },
            ),
          ],
        ),
      );
}
