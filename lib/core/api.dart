import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:pocket_quake/model/earthquake_report.dart';
import 'package:pocket_quake/model/partial_earthquake_report.dart';

class ExpTechApi {
  String? apikey;

  ExpTechApi({this.apikey});

  Future<List<PartialEarthquakeReport>> getReportList({int limit = 20}) async {
    final response = await http.get(
        Uri.parse('https://lb-3.exptech.com.tw/api/v2/eq/report?limit=$limit'));

    if (response.statusCode == 200) {
      return (jsonDecode(response.body) as List<dynamic>)
          .map((e) => PartialEarthquakeReport.fromJson(e))
          .toList();
    } else {
      throw Exception(
          'The server returned a status code of ${response.statusCode}');
    }
  }

  Future<EarthquakeReport> getReport(String id) async {
    final response = await http
        .get(Uri.parse('https://lb-3.exptech.com.tw/api/v2/eq/report/$id'));

    if (response.statusCode == 200) {
      return EarthquakeReport.fromJson(jsonDecode(response.body));
    } else {
      throw Exception(
          'The server returned a status code of ${response.statusCode}');
    }
  }
}
