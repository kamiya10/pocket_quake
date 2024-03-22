import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_map_geojson/flutter_map_geojson.dart';
import 'package:latlong2/latlong.dart';
import 'package:intl/intl.dart';
import 'package:pocket_quake/components/detail_field.dart';
import 'package:pocket_quake/components/intensity_item.dart';
import 'package:pocket_quake/globals.dart';
import 'package:pocket_quake/model/earthquake_report.dart';
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
  final _stations = <Marker>[];
  final _controller = DraggableScrollableController();
  final _borderRadius = BorderRadiusTween(
      begin: BorderRadius.circular(12), end: BorderRadius.zero);
  final _mapController = MapController();
  final _report = Completer<EarthquakeReport>();

  DraggableScrollableSheet get sheet =>
      (_sheet.currentWidget as DraggableScrollableSheet);

  @override
  void initState() {
    super.initState();
    _controller.addListener(_onChanged);
    Global.api
        .getReport(widget.partialReport.id)
        .then((value) => _report.complete(value));
    _report.future.then((r) {
      setState(() {
        final all =
            r.list.values.expand((e) => e.town.values.toList()).toList();

        all.sort((a, b) => a.intensity - b.intensity);

        final theme = Theme.of(context);
        final points = <LatLng>[LatLng(r.lat, r.lon)];

        for (var town in all) {
          points.add(LatLng(town.lat, town.lon));
          _stations.add(Marker(
              width: 20,
              height: 20,
              point: LatLng(town.lat, town.lon),
              child: Container(
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8.0),
                      color: theme.colorScheme.intensity(town.intensity),
                      border: Border.all(color: Colors.white)),
                  child: Center(
                      child: Text(town.intensity.toString(),
                          style: TextStyle(
                              fontSize: 12.0,
                              fontWeight: FontWeight.bold,
                              color: theme.colorScheme
                                  .onIntensity(town.intensity)))))));
        }

        _mapController.fitCamera(CameraFit.bounds(
            bounds: LatLngBounds.fromPoints(points),
            padding: const EdgeInsets.fromLTRB(24, 24, 24, 240)));
      });
    });
  }

  void _onChanged() {
    final currentSize = _controller.size;
    if (currentSize <= 0.05) _collapseBottomSheet();
  }

  void _animateSheet(double size) {
    _controller.animateTo(
      size,
      duration: const Duration(milliseconds: 200),
      curve: Easing.standard,
    );
  }

  void _collapseBottomSheet() => _animateSheet(sheet.snapSizes!.first);

  void onUserPanMap(DragStartDetails details) {
    _collapseBottomSheet();
  }

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
    _mapController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context)!;
    final geojson = GeoJsonParser(
        defaultPolygonFillColor: theme.colorScheme.surfaceVariant,
        defaultPolygonBorderColor: theme.colorScheme.outline);
    geojson.parseGeoJsonAsString(Global.taiwanGeojsonString);

    return Scaffold(
        appBar:
            AppBar(leading: const BackButton(), title: Text(l10n.viewReports)),
        body: Stack(
          children: [
            FlutterMap(
                mapController: _mapController,
                options: MapOptions(
                  backgroundColor: Colors.transparent,
                  interactionOptions: const InteractionOptions(
                      flags: InteractiveFlag.drag |
                          InteractiveFlag.pinchZoom |
                          InteractiveFlag.pinchMove),
                  initialCenter: LatLng(
                      widget.partialReport.lat -
                          (widget.partialReport.mag / 10),
                      widget.partialReport.lon),
                  initialZoom: (12.5 - widget.partialReport.mag),
                  onPointerHover: (event, point) {
                    _collapseBottomSheet();
                  },
                ),
                children: [
                  PolygonLayer(
                    polygons: geojson.polygons,
                    polygonCulling: true,
                    polygonLabels: false,
                  ),
                  MarkerLayer(markers: _stations),
                  MarkerLayer(markers: [
                    Marker(
                        height: 42,
                        width: 42,
                        point: LatLng(
                            widget.partialReport.lat, widget.partialReport.lon),
                        child: const Image(
                            image: AssetImage("assets/image/cross.png")))
                  ]),
                ]),
            LayoutBuilder(
                builder: (lu, constraints) => DraggableScrollableSheet(
                      key: _sheet,
                      initialChildSize: 230 / constraints.maxHeight,
                      maxChildSize: 1,
                      minChildSize: 100 / constraints.maxHeight,
                      snap: true,
                      snapSizes: [
                        100 / constraints.maxHeight,
                        230 / constraints.maxHeight
                      ],
                      controller: _controller,
                      builder: (context, scrollController) => Card(
                          shape: RoundedRectangleBorder(
                            borderRadius: _borderRadius.begin!,
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
                                                  style: TextStyle(
                                                      fontSize: 24,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      color: theme.colorScheme
                                                          .onSurface),
                                                ),
                                                Text(
                                                  widget.partialReport
                                                              .getNumber() !=
                                                          null
                                                      ? l10n.reportNumbered(
                                                          widget.partialReport
                                                              .getNumber()!)
                                                      : l10n.reportUnnumbered,
                                                  style: TextStyle(
                                                      fontSize: 16,
                                                      color: theme.colorScheme
                                                          .onSurfaceVariant),
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
                                          label: l10n.reportEventTime,
                                          value: Text(
                                              DateFormat("yyyy/MM/dd HH:mm:ss")
                                                  .format(DateTime
                                                      .fromMillisecondsSinceEpoch(
                                                          widget.partialReport
                                                              .time)),
                                              style: TextStyle(
                                                  fontSize: 16,
                                                  color: theme.colorScheme
                                                      .onSurfaceVariant))),
                                      const SizedBox(height: 12),
                                      Row(children: [
                                        Expanded(
                                            flex: 1,
                                            child: DetailField(
                                                label: l10n.reportMagnitude,
                                                value: Text(
                                                    "M ${widget.partialReport.mag.toStringAsFixed(1)}",
                                                    style: TextStyle(
                                                        fontSize: 16,
                                                        color: theme.colorScheme
                                                            .onSurfaceVariant)))),
                                        Expanded(
                                            flex: 1,
                                            child: DetailField(
                                                label: l10n.reportDepth,
                                                value: Text(
                                                    "${widget.partialReport.depth} km",
                                                    style: TextStyle(
                                                        fontSize: 16,
                                                        color: theme.colorScheme
                                                            .onSurfaceVariant))))
                                      ]),
                                      const SizedBox(height: 12),
                                      DetailField(
                                          label: l10n.reportEpicenterCoordinate,
                                          value: Wrap(
                                            spacing: 16,
                                            children: [
                                              Text(
                                                  toCoordinateNotation(
                                                      widget.partialReport.lat),
                                                  style: TextStyle(
                                                      fontSize: 16,
                                                      color: theme.colorScheme
                                                          .onSurfaceVariant)),
                                              Text(
                                                  toCoordinateNotation(
                                                      widget.partialReport.lon),
                                                  style: TextStyle(
                                                      fontSize: 16,
                                                      color: theme.colorScheme
                                                          .onSurfaceVariant))
                                            ],
                                          )),
                                      const SizedBox(height: 12),
                                      DetailField(
                                          label: l10n.reportEpicenterLocation,
                                          value: Text(
                                            widget.partialReport.loc,
                                            style: TextStyle(
                                                fontSize: 16,
                                                color: theme.colorScheme
                                                    .onSurfaceVariant),
                                          )),
                                      const SizedBox(height: 12),
                                      FutureBuilder(
                                        future: _report.future,
                                        builder: (context, snapshot) {
                                          if (snapshot.hasData) {
                                            List<Widget> list = [];

                                            snapshot.data!.list
                                                .forEach((cityName, city) {
                                              List<Widget> c = [];

                                              city.town
                                                  .forEach((townName, town) {
                                                c.add(IntensityBadge(
                                                    name: townName,
                                                    station: town));

                                                c.add(
                                                    const SizedBox(height: 4));
                                              });

                                              list.add(Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.stretch,
                                                children: [
                                                  Text(
                                                    cityName,
                                                    style: TextStyle(
                                                        color: theme.colorScheme
                                                            .outline),
                                                  ),
                                                  const SizedBox(height: 8),
                                                  Wrap(
                                                      spacing: 4,
                                                      runSpacing: 4,
                                                      children: c)
                                                ],
                                              ));

                                              list.add(
                                                  const SizedBox(height: 12));
                                            });

                                            return DetailField(
                                                label: l10n.reportIntensity,
                                                value: Column(children: list));
                                          } else {
                                            return const Center(
                                              child:
                                                  CircularProgressIndicator(),
                                            );
                                          }
                                        },
                                      )
                                    ]))
                          ])),
                    ))
          ],
        ));
  }
}
