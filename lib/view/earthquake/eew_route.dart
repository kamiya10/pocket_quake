import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_map_geojson/flutter_map_geojson.dart';
import 'package:latlong2/latlong.dart';
import 'package:material_symbols_icons/symbols.dart';
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

    final baseMap = Global.preference.getString("base_map") ?? "geojson";

    if (baseMap == "geojson") {
      geojson.parseGeoJsonAsString(Global.taiwanGeojsonString);
    }

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
              baseMap == "geojson"
                  ? PolygonLayer(
                      polygons: geojson.polygons,
                      polygonCulling: true,
                      polygonLabels: false,
                    )
                  : TileLayer(
                      urlTemplate: {
                        "googlemap":
                            "http://mt1.google.com/vt/lyrs=m&x={x}&y={y}&z={z}",
                        "googletrain":
                            "http://mt1.google.com/vt/lyrs=r@221097413,bike,transit&x={x}&y={y}&z={z}",
                        "googlesatellite":
                            "http://mt1.google.com/vt/lyrs=s&x={x}&y={y}&z={z}",
                        "openstreetmap":
                            "https://tile.openstreetmap.org/{z}/{x}/{y}.png"
                      }[baseMap],
                      userAgentPackageName: 'app.kamiya.pocket_quake',
                    ),
            ]),
        bottomSheet: Card(
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
          ),
          elevation: 4,
          margin: EdgeInsets.zero,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Card(
                  shape: const RoundedRectangleBorder(
                    borderRadius:
                        BorderRadius.vertical(top: Radius.circular(16)),
                  ),
                  color: theme.colorScheme.error,
                  margin: EdgeInsets.zero,
                  child: Padding(
                      padding: const EdgeInsets.all(32),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Symbols.warning_rounded,
                            size: 32,
                            color: theme.colorScheme.onError,
                            fill: 1,
                            weight: 700,
                          ),
                          const SizedBox(height: 4),
                          Text("強震即時警報",
                              style: TextStyle(
                                  fontSize: 24,
                                  color: theme.colorScheme.onError)),
                        ],
                      ))),
              const SizedBox(height: 8),
              Row(
                children: [Text("e")],
              )
            ],
          ),
        ));
  }
}
