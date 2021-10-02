// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'simple_user.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SimpleUser _$SimpleUserFromJson(Map<String, dynamic> json) {
  return SimpleUser(
    json['id'] as int,
    json['username'] as String,
    json['first_name'] as String,
    json['last_name'] as String,
    Person.fromJson(json['person'] as Map<String, dynamic>),
    json['vehicle_type'] as int?,
    json['plate'] as String?,
  );
}

Map<String, dynamic> _$SimpleUserToJson(SimpleUser instance) =>
    <String, dynamic>{
      'id': instance.id,
      'username': instance.username,
      'first_name': instance.firstName,
      'last_name': instance.lastName,
      'person': instance.person,
      'vehicle_type': instance.vehicleType,
      'plate': instance.plate,
    };

Person _$PersonFromJson(Map<String, dynamic> json) {
  return Person(
    json['photo'] as String?,
    json['reviews'] as int,
    (json['stars'] as num).toDouble(),
    json['domi_count'] as int,
  );
}

Map<String, dynamic> _$PersonToJson(Person instance) => <String, dynamic>{
      'photo': instance.photo,
      'reviews': instance.reviews,
      'stars': instance.stars,
      'domi_count': instance.domiCount,
    };
