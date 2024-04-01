import 'package:json_annotation/json_annotation.dart';
import 'package:pocket_quake/model/eew_detail.dart';

part 'eew.g.dart';

@JsonSerializable()
class Eew {
  final String type = "eew";
  final String author;
  final String id;
  final int serial;
  final int status;
  @JsonKey(name: "final")
  final int isFinal;
  final EewDetail eq;
  final int timestamp;

  Eew(
      {required this.author,
      required this.id,
      required this.serial,
      required this.status,
      required this.isFinal,
      required this.eq,
      required this.timestamp});

  factory Eew.fromJson(Map<String, dynamic> json) => _$EewFromJson(json);

  Map<String, dynamic> toJson() => _$EewToJson(this);
}
