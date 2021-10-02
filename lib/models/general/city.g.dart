// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'city.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

City _$CityFromJson(Map<String, dynamic> json) {
  return City(
    id: json['id'] as int?,
    name: json['name'] as String?,
    stateCode: json['state_code'] as String?,
    countryCode: json['country_code'] as String?,
  );
}

Map<String, dynamic> _$CityToJson(City instance) => <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'state_code': instance.stateCode,
      'country_code': instance.countryCode,
    };
