// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UserData _$UserDataFromJson(Map<String, dynamic> json) {
  return UserData(
    User.fromJson(json['user'] as Map<String, dynamic>),
    Params.fromJson(json['params'] as Map<String, dynamic>),
    json['token'] as String,
    json['refresh'] as String,
  );
}

Map<String, dynamic> _$UserDataToJson(UserData instance) => <String, dynamic>{
      'user': instance.user,
      'params': instance.params,
      'token': instance.token,
      'refresh': instance.refresh,
    };

User _$UserFromJson(Map<String, dynamic> json) {
  return User(
    json['id'] as int,
    json['is_domi'] as bool,
    Person.fromJson(json['person'] as Map<String, dynamic>),
    json['last_login'] as String?,
    json['username'] as String,
    json['first_name'] as String,
    json['last_name'] as String,
    json['email'] as String?,
    json['is_active'] as bool,
    json['is_domi_active'] as bool,
    json['date_joined'] as String,
  );
}

Map<String, dynamic> _$UserToJson(User instance) => <String, dynamic>{
      'id': instance.id,
      'is_domi': instance.isDomi,
      'is_domi_active': instance.isDomiActive,
      'person': instance.person,
      'last_login': instance.lastLogin,
      'username': instance.username,
      'first_name': instance.firstName,
      'last_name': instance.lastName,
      'email': instance.email,
      'is_active': instance.isActive,
      'date_joined': instance.dateJoined,
    };

Person _$PersonFromJson(Map<String, dynamic> json) {
  return Person(
    json['id'] as int,
    json['photo'] as String?,
    json['country_code'] as String,
    json['phone'] as String,
    json['birthday'] as String?,
    json['refer_code'] as String?,
    (json['stars'] as num).toDouble(),
    json['reviews'] as int,
    json['domi_count'] as int,
    json['user'] as int,
    City.fromJson(json['city'] as Map<String, dynamic>),
    json['available'] as bool,
  );
}

Map<String, dynamic> _$PersonToJson(Person instance) => <String, dynamic>{
      'id': instance.id,
      'photo': instance.photo,
      'country_code': instance.countryCode,
      'phone': instance.phone,
      'birthday': instance.birthday,
      'refer_code': instance.referCode,
      'stars': instance.stars,
      'reviews': instance.reviews,
      'domi_count': instance.domiCount,
      'user': instance.user,
      'city': instance.city,
      'available': instance.available,
    };

City _$CityFromJson(Map<String, dynamic> json) {
  return City(
    json['name'] as String,
    (json['latitude'] as num).toDouble(),
    (json['longitude'] as num).toDouble(),
    json['state_code'] as String,
    json['country_name'] as String,
    json['currency'] as String,
  );
}

Map<String, dynamic> _$CityToJson(City instance) => <String, dynamic>{
      'name': instance.name,
      'latitude': instance.latitude,
      'longitude': instance.longitude,
      'state_code': instance.stateCode,
      'country_name': instance.countryName,
      'currency': instance.currency,
    };
