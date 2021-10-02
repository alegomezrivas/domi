// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'address_book.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AddressBook _$AddressBookFromJson(Map<String, dynamic> json) {
  return AddressBook(
    id: json['id'] as int?,
    location: json['location'] == null
        ? null
        : Location.fromJson(json['location'] as Map<String, dynamic>),
    name: json['name'] as String?,
    address: json['address'] as String?,
  );
}

Map<String, dynamic> _$AddressBookToJson(AddressBook instance) =>
    <String, dynamic>{
      'id': instance.id,
      'location': instance.location,
      'name': instance.name,
      'address': instance.address,
    };

Location _$LocationFromJson(Map<String, dynamic> json) {
  return Location(
    latitude: (json['latitude'] as num?)?.toDouble(),
    longitude: (json['longitude'] as num?)?.toDouble(),
  );
}

Map<String, dynamic> _$LocationToJson(Location instance) => <String, dynamic>{
      'latitude': instance.latitude,
      'longitude': instance.longitude,
    };
