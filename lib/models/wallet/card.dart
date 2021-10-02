import 'package:json_annotation/json_annotation.dart';

part 'card.g.dart';

@JsonSerializable(fieldRename: FieldRename.snake)
class Card {
  int id;
  String firstName;
  String lastName;
  String mask;
  String? franchise;
  String expMonth;
  String expYear;

  Card(this.id, this.mask, this.franchise, this.expMonth, this.expYear,
      this.firstName, this.lastName);

  factory Card.fromJson(Map<String, dynamic> json) => _$CardFromJson(json);

  Map<String, dynamic> toJson() => _$CardToJson(this);
}
