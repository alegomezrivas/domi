// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'near_domi.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

NearDomi _$NearDomiFromJson(Map<String, dynamic> json) {
  return NearDomi(
    json['user'] as int,
    Location.fromJson(json['location'] as Map<String, dynamic>),
  );
}

Map<String, dynamic> _$NearDomiToJson(NearDomi instance) => <String, dynamic>{
      'user': instance.user,
      'location': instance.location,
    };
