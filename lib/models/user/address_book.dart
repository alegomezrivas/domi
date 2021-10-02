

import 'package:json_annotation/json_annotation.dart';

part 'address_book.g.dart';

@JsonSerializable(fieldRename: FieldRename.snake)
class AddressBook {
  int? id;
  Location? location;
  String? name;
  String? address;

  AddressBook({this.id, this.location, this.name, this.address});
  factory AddressBook.fromJson(Map<String, dynamic> json) =>
      _$AddressBookFromJson(json);

  Map<String, dynamic> toJson() => _$AddressBookToJson(this);

}
@JsonSerializable(fieldRename: FieldRename.snake)
class Location {
  double? latitude;
  double? longitude;

  Location({this.latitude, this.longitude});

  factory Location.fromJson(Map<String, dynamic> json) =>
      _$LocationFromJson(json);

  Map<String, dynamic> toJson() => _$LocationToJson(this);
}