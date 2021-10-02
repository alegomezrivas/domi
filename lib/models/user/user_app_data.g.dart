// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_app_data.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UserAppData _$UserAppDataFromJson(Map<String, dynamic> json) {
  return UserAppData(
    User.fromJson(json['user'] as Map<String, dynamic>),
    DomiParams.fromJson(json['params'] as Map<String, dynamic>),
    json['token'] as String,
    json['refresh'] as String,
  );
}

Map<String, dynamic> _$UserAppDataToJson(UserAppData instance) =>
    <String, dynamic>{
      'user': instance.user,
      'params': instance.params,
      'token': instance.token,
      'refresh': instance.refresh,
    };
