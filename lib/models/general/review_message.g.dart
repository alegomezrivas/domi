// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'review_message.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ReviewMessage _$ReviewMessageFromJson(Map<String, dynamic> json) {
  return ReviewMessage(
    json['id'] as int,
    json['description'] as String,
    json['review_type'] as int,
    json['from_star'] as int,
    json['to_star'] as int,
  );
}

Map<String, dynamic> _$ReviewMessageToJson(ReviewMessage instance) =>
    <String, dynamic>{
      'id': instance.id,
      'description': instance.description,
      'review_type': instance.reviewType,
      'from_star': instance.fromStar,
      'to_star': instance.toStar,
    };
