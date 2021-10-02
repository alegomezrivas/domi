// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'service_review.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ServiceReview _$ServiceReviewFromJson(Map<String, dynamic> json) {
  return ServiceReview(
    json['id'] as int,
    SimpleUser.fromJson(json['user'] as Map<String, dynamic>),
    (json['messages'] as List<dynamic>)
        .map((e) => Messages.fromJson(e as Map<String, dynamic>))
        .toList(),
    (json['stars'] as num).toDouble(),
    json['service'] as int,
    json['created_at'] as String,
  );
}

Map<String, dynamic> _$ServiceReviewToJson(ServiceReview instance) =>
    <String, dynamic>{
      'id': instance.id,
      'user': instance.user,
      'messages': instance.messages,
      'stars': instance.stars,
      'service': instance.service,
      'created_at': instance.createdAt,
    };

Messages _$MessagesFromJson(Map<String, dynamic> json) {
  return Messages(
    json['id'] as int,
    json['description'] as String,
    json['review_type'] as int,
    json['from_star'] as int,
    json['to_star'] as int,
  );
}

Map<String, dynamic> _$MessagesToJson(Messages instance) => <String, dynamic>{
      'id': instance.id,
      'description': instance.description,
      'review_type': instance.reviewType,
      'from_star': instance.fromStar,
      'to_star': instance.toStar,
    };
