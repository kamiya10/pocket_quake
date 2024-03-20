import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:pocket_quake/components/earthquake_report_card.dart';
import 'package:pocket_quake/globals.dart';

class Reports extends StatefulWidget {
  const Reports({super.key});

  @override
  State<StatefulWidget> createState() => _ReportsState();
}

class _ReportsState extends State<Reports>
    with AutomaticKeepAliveClientMixin<Reports> {
  @override
  get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.viewReports),
      ),
      body: FutureBuilder(
        future: Global.api.getReportList(),
        builder: (context, snapshot) => snapshot.hasData
            ? SingleChildScrollView(
                child: Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: snapshot.data!
                            .map((e) => EarthquakeReportCard(report: e))
                            .toList())))
            : Center(
                child: snapshot.hasError
                    ? Text('${snapshot.error}')
                    : const CircularProgressIndicator()),
      ),
    );
  }
}
