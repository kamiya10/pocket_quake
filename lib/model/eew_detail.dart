import 'package:json_annotation/json_annotation.dart';

part 'eew_detail.g.dart';

@JsonSerializable()
class EewDetail {
  final int time;
  final double lon;
  final double lat;
  final double depth;
  final double mag;
  final String loc;
  final int max;
  final Map<String, int> area;

  EewDetail(
      {required this.time,
      required this.lon,
      required this.lat,
      required this.depth,
      required this.mag,
      required this.loc,
      required this.max,
      required this.area});

  factory EewDetail.fromJson(Map<String, dynamic> json) =>
      _$EewDetailFromJson(json);

  Map<String, dynamic> toJson() => _$EewDetailToJson(this);
}
