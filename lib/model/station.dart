import 'package:json_annotation/json_annotation.dart';
import 'package:pocket_quake/model/station_info.dart';

part 'station.g.dart';

@JsonSerializable()
class Station {
  final String net;
  final List<StationInfo> info;
  final bool work;

  Station({required this.net, required this.info, required this.work});

  factory Station.fromJson(Map<String, dynamic> json) =>
      _$StationFromJson(json);

  Map<String, dynamic> toJson() => _$StationToJson(this);
}
