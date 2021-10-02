import 'package:domi/models/user/simple_user.dart';
import 'package:json_annotation/json_annotation.dart';

part 'favorite_domi.g.dart';

@JsonSerializable(fieldRename: FieldRename.snake)
class FavoriteDomi {
  int id;
  SimpleUser domi;

  FavoriteDomi(this.id, this.domi);


  factory FavoriteDomi.fromJson(Map<String, dynamic> json) =>
      _$FavoriteDomiFromJson(json);

  Map<String, dynamic> toJson() => _$FavoriteDomiToJson(this);
}