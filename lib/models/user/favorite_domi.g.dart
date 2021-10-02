// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'favorite_domi.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

FavoriteDomi _$FavoriteDomiFromJson(Map<String, dynamic> json) {
  return FavoriteDomi(
    json['id'] as int,
    SimpleUser.fromJson(json['domi'] as Map<String, dynamic>),
  );
}

Map<String, dynamic> _$FavoriteDomiToJson(FavoriteDomi instance) =>
    <String, dynamic>{
      'id': instance.id,
      'domi': instance.domi,
    };
