import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:intl/intl.dart';
import 'package:pocket_quake/model/partial_earthquake_report.dart';
import 'package:pocket_quake/utils/intensity_color.dart';
import 'package:pocket_quake/view/reports/report_detail_route.dart';

class EarthquakeReportCard extends StatelessWidget {
  final PartialEarthquakeReport report;

  const EarthquakeReportCard({super.key, required this.report});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context)!;

    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Text(
          report.getNumber() != null
              ? l10n.reportNumbered(report.getNumber()!)
              : l10n.reportUnnumbered,
          style: TextStyle(fontSize: 14, color: theme.colorScheme.outline)),
      GestureDetector(
          onTap: () async {
            await Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) =>
                      ReportDetailRoute(partialReport: report)),
            );
          },
          child: Card(
            child: ClipPath(
              clipper: ShapeBorderClipper(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12))),
              child: Container(
                decoration: const BoxDecoration(
                  border: Border(
                      left: BorderSide(color: Colors.lightGreen, width: 4)),
                ),
                padding: const EdgeInsets.all(16.0),
                alignment: Alignment.centerLeft,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          report.getLocation(),
                          style: const TextStyle(
                              fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                        Text(
                          DateFormat("yyyy/MM/dd hh:mm:ss").format(
                              DateTime.fromMillisecondsSinceEpoch(report.time)),
                          style: TextStyle(
                              fontSize: 14,
                              color: theme.colorScheme.onSurfaceVariant),
                        ),
                        Row(children: [
                          Text(
                            l10n.reportCardMagnitude(
                                report.mag.toStringAsFixed(1)),
                            style: TextStyle(
                                fontSize: 14,
                                color: theme.colorScheme.onSurfaceVariant),
                          ),
                          const SizedBox(width: 8),
                          Text(
                            l10n.reportCardDepth(report.depth.toString()),
                            style: TextStyle(
                                fontSize: 14,
                                color: theme.colorScheme.onSurfaceVariant),
                          )
                        ])
                      ],
                    ),
                    Container(
                      width: 64,
                      height: 64,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12.0),
                          color: theme.colorScheme.intensity(report.intensity)),
                      child: Center(
                          child: Text(report.intensity.toString(),
                              style: TextStyle(
                                  fontSize: 28,
                                  fontWeight: FontWeight.bold,
                                  color: theme.colorScheme
                                      .onIntensity(report.intensity)))),
                    ),
                  ],
                ),
              ),
            ),
          ))
    ]);
  }
}
