import 'package:domi/re_use/utils/domi_format.dart';
import 'package:json_annotation/json_annotation.dart';

part 'simple_user.g.dart';


@JsonSerializable(fieldRename: FieldRename.snake)
class SimpleUser {
  int id;
  String username;
  String firstName;
  String lastName;
  Person person;
  int? vehicleType;
  String? plate;

  SimpleUser(this.id, this.username, this.firstName, this.lastName, this.person, this.vehicleType, this.plate);

  factory SimpleUser.fromJson(Map<String, dynamic> json) => _$SimpleUserFromJson(json);

  Map<String, dynamic> toJson() => _$SimpleUserToJson(this);

  String get fullName => firstName + " " + lastName;

  String get getStars => DomiFormat.formatCompat(person.stars / person.reviews);

  String vehicleTypeString(){
    if(vehicleType==1){
      return "Bicicleta";
    }
    if(vehicleType==2){
      return "Moto";
    }
    if(vehicleType==3){
      return "Carro";
    }
    return "";
  }
}

@JsonSerializable(fieldRename: FieldRename.snake)
class Person {
  String? photo;
  int reviews;
  double stars;
  int domiCount;

  Person(this.photo, this.reviews, this.stars, this.domiCount);

  factory Person.fromJson(Map<String, dynamic> json) => _$PersonFromJson(json);

  Map<String, dynamic> toJson() => _$PersonToJson(this);
}
