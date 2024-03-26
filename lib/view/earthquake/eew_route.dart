import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_map_geojson/flutter_map_geojson.dart';
import 'package:latlong2/latlong.dart';
import 'package:material_symbols_icons/symbols.dart';
import 'package:pocket_quake/components/detail_field.dart';
import 'package:pocket_quake/globals.dart';
import 'package:pocket_quake/utils/extensions.dart';

class EewRoute extends StatefulWidget {
  const EewRoute({super.key});

  @override
  State<EewRoute> createState() => _EewRoute();
}

class _EewRoute extends State<EewRoute> {
  final _mapController = MapController();

  @override
  Widget build(BuildContext context) {
    final geojson = GeoJsonParser(
        defaultPolygonFillColor: context.colors.surfaceVariant,
        defaultPolygonBorderColor: context.colors.outline);

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
            padding: const EdgeInsets.fromLTRB(24, 24, 24, 240),
            bounds: LatLngBounds(
              const LatLng(25.33, 119.14),
              const LatLng(21.88, 122.18),
            ),
          ),
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
        ],
      ),
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
                borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
              ),
              color: context.colors.error,
              margin: EdgeInsets.zero,
              child: Padding(
                padding: const EdgeInsets.all(32),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Symbols.crisis_alert_rounded,
                      size: 32,
                      color: context.colors.onError,
                      fill: 1,
                      weight: 700,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      "強震即時警報",
                      style: TextStyle(
                          color: context.colors.onError,
                          fontSize: 24,
                          fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      "花蓮縣秀林鄉發生地震\n慎防強烈搖晃",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: context.colors.onError,
                        fontSize: 14,
                      ),
                    )
                  ],
                ),
              ),
            ),
            const SizedBox(height: 8),
            Padding(
              padding: const EdgeInsets.all(8),
              child: Row(
                children: [
                  Expanded(
                    flex: 1,
                    child: DetailField(
                      label: context.l10n.reportMagnitude,
                      icon: Symbols.speed_rounded,
                      value: const Text("M 5"),
                    ),
                  ),
                  Expanded(
                    flex: 1,
                    child: DetailField(
                      label: context.l10n.reportDepth,
                      icon: Symbols.keyboard_double_arrow_down_rounded,
                      value: const Text("20 km"),
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
