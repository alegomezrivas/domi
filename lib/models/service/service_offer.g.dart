// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'service_offer.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ServiceOffer _$ServiceOfferFromJson(Map<String, dynamic> json) {
  return ServiceOffer(
    json['id'] as int,
    SimpleUser.fromJson(json['domi'] as Map<String, dynamic>),
    json['is_favorite'] as bool,
    json['status'] as bool,
    json['created_at'] as String,
    json['service'] as int,
    (json['distance'] as num).toDouble(),
    json['counteroffer'] as String,
  );
}

Map<String, dynamic> _$ServiceOfferToJson(ServiceOffer instance) =>
    <String, dynamic>{
      'id': instance.id,
      'domi': instance.domi,
      'is_favorite': instance.isFavorite,
      'status': instance.status,
      'created_at': instance.createdAt,
      'service': instance.service,
      'distance': instance.distance,
      'counteroffer': instance.counteroffer,
    };
