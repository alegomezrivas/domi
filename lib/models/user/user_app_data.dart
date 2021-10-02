import 'package:domi/models/general/domi_params.dart';
import 'package:domi/models/user/user.dart';
import 'package:json_annotation/json_annotation.dart';

part 'user_app_data.g.dart';

@JsonSerializable(fieldRename: FieldRename.snake)
class UserAppData{
User user;
DomiParams params;
String token;
String refresh;

UserAppData(this.user, this.params, this.token, this.refresh);
factory UserAppData.fromJson(Map<String, dynamic> json) =>
    _$UserAppDataFromJson(json);

Map<String, dynamic> toJson() => _$UserAppDataToJson(this);
}