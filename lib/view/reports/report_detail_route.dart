import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:intl/intl.dart';
import 'package:maplibre_gl/mapbox_gl.dart';
import 'package:pocket_quake/components/detail_field.dart';
import 'package:pocket_quake/model/partial_earthquake_report.dart';
import 'package:pocket_quake/utils/dms.dart';
import 'package:pocket_quake/utils/intensity_color.dart';

class ReportDetailRoute extends StatefulWidget {
  final PartialEarthquakeReport partialReport;

  const ReportDetailRoute({super.key, required this.partialReport});

  @override
  State<ReportDetailRoute> createState() => _ReportDetailRouteState();
}

class _ReportDetailRouteState extends State<ReportDetailRoute> {
  final _sheet = GlobalKey();
  final _controller = DraggableScrollableController();

  DraggableScrollableSheet get sheet =>
      (_sheet.currentWidget as DraggableScrollableSheet);

  @override
  void initState() {
    super.initState();
    _controller.addListener(_onChanged);
  }

  void _onChanged() {
    final currentSize = _controller.size;
    if (currentSize <= 0.05) _collapse();
  }

  void _animateSheet(double size) {
    _controller.animateTo(
      size,
      duration: const Duration(milliseconds: 50),
      curve: Curves.easeInOut,
    );
  }

  void _collapse() => _animateSheet(sheet.snapSizes!.first);

  void _anchor() => _animateSheet(sheet.snapSizes!.last);

  void _expand() => _animateSheet(sheet.maxChildSize);

  void _hide() => _animateSheet(sheet.minChildSize);

  void onMapCreated(MaplibreMapController controller) async {
    controller.addImage('marker',
        (await rootBundle.load("assets/image/cross.png")).buffer.asUint8List());

    await controller.addSymbol(
      SymbolOptions(
        iconSize: 0.1,
        iconImage: "marker",
        geometry: LatLng(widget.partialReport.lat, widget.partialReport.lon),
        iconAnchor: "bottom",
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
        appBar:
            AppBar(leading: const BackButton(), title: Text(l10n.viewReports)),
        body: Stack(
          children: [
            MaplibreMap(
              initialCameraPosition: CameraPosition(
                  zoom: 6.5,
                  target: LatLng(widget.partialReport.lat - 0.5,
                      widget.partialReport.lon)),
              dragEnabled: true,
              rotateGesturesEnabled: false,
              onMapCreated: onMapCreated,
            ),
            LayoutBuilder(
                builder: (lu, constraints) => DraggableScrollableSheet(
                      key: _sheet,
                      initialChildSize: 0.27,
                      maxChildSize: 1,
                      minChildSize: 0,
                      snap: true,
                      snapSizes: [100 / constraints.maxHeight, 0.27],
                      controller: _controller,
                      builder: (context, scrollController) => Card(
                          shape: const RoundedRectangleBorder(
                            borderRadius:
                                BorderRadius.vertical(top: Radius.circular(16)),
                          ),
                          margin: EdgeInsets.zero,
                          elevation: 4.0,
                          child:
                              ListView(controller: scrollController, children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Container(
                                  margin:
                                      const EdgeInsets.symmetric(vertical: 10),
                                  height: 4,
                                  width: 32,
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(10),
                                      color: theme.colorScheme.onSurfaceVariant
                                          .withOpacity(0.4)),
                                ),
                              ],
                            ),
                            Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 24),
                                child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.stretch,
                                    children: [
                                      Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  widget.partialReport
                                                      .getLocation(),
                                                  style: const TextStyle(
                                                      fontSize: 24,
                                                      fontWeight:
                                                          FontWeight.bold),
                                                ),
                                                Text(
                                                  widget.partialReport
                                                              .getNumber() !=
                                                          null
                                                      ? l10n.reportNumbered(
                                                          widget.partialReport
                                                              .getNumber()!)
                                                      : l10n.reportUnnumbered,
                                                  style: const TextStyle(
                                                      fontSize: 16),
                                                )
                                              ],
                                            ),
                                            Container(
                                                width: 64,
                                                height: 64,
                                                decoration: BoxDecoration(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            12.0),
                                                    color: theme.colorScheme
                                                        .intensity(widget
                                                            .partialReport
                                                            .intensity)),
                                                child: Center(
                                                    child: Text(
                                                        widget.partialReport
                                                            .intensity
                                                            .toString(),
                                                        style: TextStyle(
                                                            fontSize: 28,
                                                            fontWeight:
                                                                FontWeight.bold,
                                                            color: theme.colorScheme
                                                                .onIntensity(widget.partialReport.intensity)))))
                                          ]),
                                      const SizedBox(height: 16),
                                      DetailField(
                                          label: "發生時間",
                                          value: DateFormat(
                                                  "yyyy/MM/dd hh:mm:ss")
                                              .format(DateTime
                                                  .fromMillisecondsSinceEpoch(
                                                      widget.partialReport
                                                          .time))),
                                      const SizedBox(height: 8),
                                      Row(children: [
                                        Expanded(
                                            flex: 1,
                                            child: DetailField(
                                                label: "芮氏規模",
                                                value:
                                                    "M ${widget.partialReport.mag.toStringAsFixed(1)}")),
                                        Expanded(
                                            flex: 1,
                                            child: DetailField(
                                                label: "深度",
                                                value:
                                                    "${widget.partialReport.depth} km"))
                                      ]),
                                      const SizedBox(height: 8),
                                      DetailField(
                                          label: "震央座標",
                                          value:
                                              "${toCoordinateNotation(widget.partialReport.lat)} ${toCoordinateNotation(widget.partialReport.lon)}"),
                                      const SizedBox(height: 8),
                                      DetailField(
                                          label: "震央位置",
                                          value: widget.partialReport.loc),
                                    ]))
                          ])),
                    ))
          ],
        ));
  }
}
