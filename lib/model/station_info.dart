import 'package:json_annotation/json_annotation.dart';

part 'station_info.g.dart';

@JsonSerializable()
class StationInfo {
  final String code;
  final double lon;
  final double lat;
  final String time;

  StationInfo(
      {required this.code,
      required this.lon,
      required this.lat,
      required this.time});

  factory StationInfo.fromJson(Map<String, dynamic> json) =>
      _$StationInfoFromJson(json);

  Map<String, dynamic> toJson() => _$StationInfoToJson(this);
}
