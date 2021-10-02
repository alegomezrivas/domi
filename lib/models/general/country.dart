
import 'package:json_annotation/json_annotation.dart';

part 'country.g.dart';

@JsonSerializable(fieldRename: FieldRename.snake)
class Country {
  int? id;
  String? name;
  String? phoneCode;
  String? countryCode;
  String? icon;
  String? currency;
  bool? status;

  Country({this.id,
    this.name,
    this.phoneCode,
    this.countryCode,
    this.icon,
    this.currency,
    this.status});

  factory Country.fromJson(Map<String, dynamic> json) => _$CountryFromJson(json);

  Map<String, dynamic> toJson() => _$CountryToJson(this);

}