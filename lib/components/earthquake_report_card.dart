import 'package:dynamic_color/dynamic_color.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:pocket_quake/model/partial_earthquake_report.dart';
import 'package:pocket_quake/utils/extensions.dart';
import 'package:pocket_quake/utils/intensity_color.dart';
import 'package:pocket_quake/view/earthquake/report_detail_route.dart';

class EarthquakeReportCard extends StatelessWidget {
  final PartialEarthquakeReport report;

  const EarthquakeReportCard({super.key, required this.report});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 8),
            child: Text(
              report.getNumber() != null
                  ? context.l10n.reportNumbered(report.getNumber()!)
                  : context.l10n.reportUnnumbered,
              style: TextStyle(
                fontSize: 14,
                color: context.colors.outline,
              ),
            ),
          ),
          const SizedBox(height: 4),
          ClipPath(
            clipper: ShapeBorderClipper(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: Material(
              borderRadius: BorderRadius.circular(12),
              surfaceTintColor: context.colors.surfaceTint,
              elevation: 4,
              child: InkWell(
                onTap: () async {
                  await Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>
                          ReportDetailRoute(partialReport: report),
                    ),
                  );
                },
                child: Container(
                  decoration: BoxDecoration(
                    border: Border(
                      left: BorderSide(
                        color: report
                            .getReportColor()
                            .harmonizeWith(context.colors.primary),
                        width: 4,
                      ),
                    ),
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
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            DateFormat("yyyy/MM/dd HH:mm:ss").format(
                              DateTime.fromMillisecondsSinceEpoch(report.time),
                            ),
                            style: TextStyle(
                              fontSize: 14,
                              color: context.colors.onSurfaceVariant,
                            ),
                          ),
                          Row(
                            children: [
                              Text(
                                context.l10n.reportCardMagnitude(
                                    report.mag.toStringAsFixed(1)),
                                style: TextStyle(
                                    fontSize: 14,
                                    color: context.colors.onSurfaceVariant),
                              ),
                              const SizedBox(width: 8),
                              Text(
                                context.l10n
                                    .reportCardDepth(report.depth.toString()),
                                style: TextStyle(
                                    fontSize: 14,
                                    color: context.colors.onSurfaceVariant),
                              ),
                            ],
                          )
                        ],
                      ),
                      Container(
                        width: 64,
                        height: 64,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12.0),
                          color: context.colors.intensity(report.intensity),
                        ),
                        child: Center(
                          child: Text(
                            report.intensity.toString(),
                            style: TextStyle(
                              fontSize: 28,
                              fontWeight: FontWeight.bold,
                              color:
                                  context.colors.onIntensity(report.intensity),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
