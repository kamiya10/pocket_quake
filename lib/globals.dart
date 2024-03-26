import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:pocket_quake/core/api.dart';
import 'package:pocket_quake/model/location.dart';
import 'package:pocket_quake/model/partial_earthquake_report.dart';
import 'package:pocket_quake/model/town.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Global {
  static late SharedPreferences preference;
  static late ExpTechApi api;
  static late String taiwanGeojsonString;
  static Map<String, Map<String, Town>> region = {};
  static Map<String, Location> location = {};
  static List<PartialEarthquakeReport> reports = [];
  static Future init() async {
    preference = await SharedPreferences.getInstance();

    api = ExpTechApi(apikey: preference.getString("apikey"));

    // src: assets/json/region.json
    Map<String, dynamic> regionRaw =
        jsonDecode(await rootBundle.loadString("assets/json/region.json"));

    regionRaw.forEach((cityName, city) {
      region[cityName] = <String, Town>{};
      if (city is Map) {
        city.forEach((townName, json) {
          region[cityName]![townName] = Town.fromJson(json);
        });
      }
    });

    // src: assets/json/location.json
    Map<String, dynamic> locationRaw =
        jsonDecode(await rootBundle.loadString("assets/json/location.json"));

    locationRaw.forEach((postal, data) {
      location[postal] = Location.fromJson(data);
    });

    taiwanGeojsonString =
        await rootBundle.loadString("assets/json/tw_city.geojson");
  }
}
