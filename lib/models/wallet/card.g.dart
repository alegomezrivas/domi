// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'card.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Card _$CardFromJson(Map<String, dynamic> json) {
  return Card(
    json['id'] as int,
    json['mask'] as String,
    json['franchise'] as String?,
    json['exp_month'] as String,
    json['exp_year'] as String,
    json['first_name'] as String,
    json['last_name'] as String,
  );
}

Map<String, dynamic> _$CardToJson(Card instance) => <String, dynamic>{
      'id': instance.id,
      'first_name': instance.firstName,
      'last_name': instance.lastName,
      'mask': instance.mask,
      'franchise': instance.franchise,
      'exp_month': instance.expMonth,
      'exp_year': instance.expYear,
    };
