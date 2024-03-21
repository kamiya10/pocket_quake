import 'dart:math';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:simplify/simplify.dart';

List<Polygon> simplifyPolyons(List<Polygon> polygons, {double? tolerance}) {
  List<Polygon> list = [];

  for (var element in polygons) {
    List<Point<double>> points =
        element.points.map((e) => Point(e.latitude, e.longitude)).toList();
    list.add(Polygon(
        borderColor: element.borderColor,
        borderStrokeWidth: element.borderStrokeWidth,
        color: element.color,
        disableHolesBorder: element.disableHolesBorder,
        isDotted: element.isDotted,
        isFilled: element.isFilled,
        label: element.label,
        labelPlacement: element.labelPlacement,
        labelStyle: element.labelStyle,
        rotateLabel: element.rotateLabel,
        strokeCap: element.strokeCap,
        strokeJoin: element.strokeJoin,
        points: simplify<Point<double>>(points, tolerance: tolerance)
            .map((e) => LatLng(e.x, e.y))
            .toList()));
  }

  return list;
}
