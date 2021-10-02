// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'service.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Service _$ServiceFromJson(Map<String, dynamic> json) {
  return Service(
    json['id'] as int,
    json['user'] == null
        ? null
        : SimpleUser.fromJson(json['user'] as Map<String, dynamic>),
    (json['way_points'] as List<dynamic>)
        .map((e) => WayPoint.fromJson(e as Map<String, dynamic>))
        .toList(),
    json['service_type'] as int,
    json['offer'] as String,
    json['service_tax'] as String,
    json['domi_tax'] as String,
    json['insurance_tax'] as String,
    json['cancel_in_place'] as String,
    json['observation'] as String,
    json['pay_method'] as int,
    json['payment_status'] as int,
    json['weight'] as int?,
    json['insurance'] as String,
    json['created_at'] as String,
    json['service_status'] as int,
    json['package'] == null
        ? null
        : Package.fromJson(json['package'] as Map<String, dynamic>),
    json['domi'] == null
        ? null
        : SimpleUser.fromJson(json['domi'] as Map<String, dynamic>),
    (json['distance'] as num).toDouble(),
    json['is_favorite'] as bool? ?? false,
  );
}

Map<String, dynamic> _$ServiceToJson(Service instance) => <String, dynamic>{
      'id': instance.id,
      'user': instance.user,
      'way_points': instance.wayPoints,
      'service_type': instance.serviceType,
      'offer': instance.offer,
      'service_tax': instance.serviceTax,
      'domi_tax': instance.domiTax,
      'insurance_tax': instance.insuranceTax,
      'cancel_in_place': instance.cancelInPlace,
      'observation': instance.observation,
      'pay_method': instance.payMethod,
      'payment_status': instance.paymentStatus,
      'weight': instance.weight,
      'insurance': instance.insurance,
      'created_at': instance.createdAt,
      'service_status': instance.serviceStatus,
      'package': instance.package,
      'domi': instance.domi,
      'distance': instance.distance,
      'is_favorite': instance.isFavorite,
    };

WayPoint _$WayPointFromJson(Map<String, dynamic> json) {
  return WayPoint(
    json['location'] == null
        ? null
        : Location.fromJson(json['location'] as Map<String, dynamic>),
    json['address'] as String,
    json['check'] as bool,
    json['in_way'] as bool,
    json['order'] as int,
  );
}

Map<String, dynamic> _$WayPointToJson(WayPoint instance) => <String, dynamic>{
      'location': instance.location,
      'address': instance.address,
      'check': instance.check,
      'in_way': instance.inWay,
      'order': instance.order,
    };
