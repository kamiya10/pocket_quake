import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:pocket_quake/components/earthquake_report_card.dart';
import 'package:pocket_quake/globals.dart';
import 'package:pocket_quake/model/partial_earthquake_report.dart';

class Reports extends StatefulWidget {
  const Reports({super.key});

  @override
  State<StatefulWidget> createState() => _ReportsState();
}

class _ReportsState extends State<Reports>
    with AutomaticKeepAliveClientMixin<Reports> {
  @override
  get wantKeepAlive => true;

  late List<PartialEarthquakeReport> _reports;

  Future<void> _refreshReports() {
    return Global.api.getReportList().then((data) {
      setState(() {
        _reports = data;
      });
    }).catchError((e) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(e.toString())));
    });
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.viewReports),
      ),
      body: FutureBuilder(
          future: Global.api.getReportList(limit: 25),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              _reports = snapshot.data!;

              return RefreshIndicator(
                  onRefresh: _refreshReports,
                  child: ListView(
                      padding: const EdgeInsets.all(12.0),
                      children: _reports
                          .map((e) => EarthquakeReportCard(report: e))
                          .toList()));
            } else {
              return Center(
                  child: snapshot.hasError
                      ? Text('${snapshot.error}')
                      : const CircularProgressIndicator());
            }
          }),
    );
  }
}
