import 'package:json_annotation/json_annotation.dart';

part 'location.g.dart';

@JsonSerializable(includeIfNull: false)
class Location {
  final double lng;
  final double lat;
  final String city;
  final String town;

  Location(
      {required this.lng,
      required this.lat,
      required this.city,
      required this.town});

  factory Location.fromJson(Map<String, dynamic> json) =>
      _$LocationFromJson(json);

  Map<String, dynamic> toJson() => _$LocationToJson(this);
}
