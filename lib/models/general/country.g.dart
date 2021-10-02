// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'country.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Country _$CountryFromJson(Map<String, dynamic> json) {
  return Country(
    id: json['id'] as int?,
    name: json['name'] as String?,
    phoneCode: json['phone_code'] as String?,
    countryCode: json['country_code'] as String?,
    icon: json['icon'] as String?,
    currency: json['currency'] as String?,
    status: json['status'] as bool?,
  );
}

Map<String, dynamic> _$CountryToJson(Country instance) => <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'phone_code': instance.phoneCode,
      'country_code': instance.countryCode,
      'icon': instance.icon,
      'currency': instance.currency,
      'status': instance.status,
    };
