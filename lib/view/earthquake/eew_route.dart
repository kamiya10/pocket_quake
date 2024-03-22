import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_map_geojson/flutter_map_geojson.dart';
import 'package:latlong2/latlong.dart';
import 'package:pocket_quake/globals.dart';

class EewRoute extends StatefulWidget {
  const EewRoute({super.key});

  @override
  State<EewRoute> createState() => _EewRoute();
}

class _EewRoute extends State<EewRoute> {
  final _mapController = MapController();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final geojson = GeoJsonParser(
        defaultPolygonFillColor: theme.colorScheme.surfaceVariant,
        defaultPolygonBorderColor: theme.colorScheme.outline);
    geojson.parseGeoJsonAsString(Global.taiwanGeojsonString);

    return Scaffold(
        body: FlutterMap(
            mapController: _mapController,
            options: MapOptions(
              backgroundColor: Colors.transparent,
              interactionOptions: const InteractionOptions(
                  flags: InteractiveFlag.drag |
                      InteractiveFlag.pinchZoom |
                      InteractiveFlag.pinchMove),
              initialCameraFit: CameraFit.bounds(
                  bounds: LatLngBounds(const LatLng(25.33, 118.14),
                      const LatLng(21.88, 122.18))),
              initialZoom: 7,
            ),
            children: [
              PolygonLayer(
                polygons: geojson.polygons,
                polygonCulling: true,
                polygonLabels: false,
              ),
            ]),
        bottomSheet: Card(
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
          ),
          elevation: 4,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text("強震即時警報",
                      style: TextStyle(
                          fontSize: 24, color: theme.colorScheme.error)),
                ],
              )
            ],
          ),
        ));
  }
}
