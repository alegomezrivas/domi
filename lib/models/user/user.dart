import 'package:domi/models/general/domi_params.dart';
import 'package:domi/re_use/utils/domi_format.dart';
import 'package:json_annotation/json_annotation.dart';

part 'user.g.dart';

@JsonSerializable(fieldRename: FieldRename.snake)
class UserData {
  User user;
  Params params;
  String token;
  String refresh;

  UserData(this.user, this.params, this.token, this.refresh);

  factory UserData.fromJson(Map<String, dynamic> json) =>
      _$UserDataFromJson(json);

  Map<String, dynamic> toJson() => _$UserDataToJson(this);
}

@JsonSerializable(fieldRename: FieldRename.snake)
class User {
  int id;
  bool isDomi;
  bool isDomiActive;
  Person person;
  String? lastLogin;
  String username;
  String firstName;
  String lastName;
  String? email;
  bool isActive;
  String dateJoined;

  User(
      this.id,
      this.isDomi,
      this.person,
      this.lastLogin,
      this.username,
      this.firstName,
      this.lastName,
      this.email,
      this.isActive,
      this.isDomiActive,
      this.dateJoined);

  factory User.fromJson(Map<String, dynamic> json) => _$UserFromJson(json);

  String get fullName => "$firstName $lastName";

  Map<String, dynamic> toJson() => _$UserToJson(this);

  String get getStars => DomiFormat.formatCompat(person.stars / person.reviews);
}

@JsonSerializable(fieldRename: FieldRename.snake)
class Person {
  int id;
  String? photo;
  String countryCode;
  String phone;
  String? birthday;
  String? referCode;
  double stars;
  int reviews;
  int domiCount;
  int user;
  City city;
  bool available;

  Person(
      this.id,
      this.photo,
      this.countryCode,
      this.phone,
      this.birthday,
      this.referCode,
      this.stars,
      this.reviews,
      this.domiCount,
      this.user,
      this.city,
      this.available
      );

  factory Person.fromJson(Map<String, dynamic> json) => _$PersonFromJson(json);

  Map<String, dynamic> toJson() => _$PersonToJson(this);
}

@JsonSerializable(fieldRename: FieldRename.snake)
class City {
  String name;
  double latitude;
  double longitude;
  String stateCode;
  String countryName;
  String currency;

  City(this.name, this.latitude, this.longitude, this.stateCode,
      this.countryName, this.currency);

  factory City.fromJson(Map<String, dynamic> json) => _$CityFromJson(json);

  Map<String, dynamic> toJson() => _$CityToJson(this);
}
