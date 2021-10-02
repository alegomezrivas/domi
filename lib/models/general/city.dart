
import 'package:json_annotation/json_annotation.dart';

part 'city.g.dart';

@JsonSerializable(fieldRename: FieldRename.snake)
class City {
  int? id;
  String? name;
  String? stateCode;
  String? countryCode;

  City({this.id, this.name, this.stateCode, this.countryCode});

  factory City.fromJson(Map<String, dynamic> json) => _$CityFromJson(json);

  Map<String, dynamic> toJson() => _$CityToJson(this);
}