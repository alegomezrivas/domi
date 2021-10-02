import 'package:domi/models/user/address_book.dart';

import 'package:json_annotation/json_annotation.dart';

part 'near_domi.g.dart';

@JsonSerializable(fieldRename: FieldRename.snake)
class NearDomi {
  int user;
  Location location;

  NearDomi(this.user, this.location);

  factory NearDomi.fromJson(Map<String, dynamic> json) =>
      _$NearDomiFromJson(json);

  Map<String, dynamic> toJson() => _$NearDomiToJson(this);
}
