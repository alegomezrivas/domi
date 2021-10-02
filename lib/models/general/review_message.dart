import 'package:json_annotation/json_annotation.dart';

part 'review_message.g.dart';

@JsonSerializable(fieldRename: FieldRename.snake)
class ReviewMessage {
  int id;
  String description;
  int reviewType;
  int fromStar;
  int toStar;
  @JsonKey(ignore: true, defaultValue: false)
  bool selected = false;

  ReviewMessage(
      this.id, this.description, this.reviewType, this.fromStar, this.toStar);

  factory ReviewMessage.fromJson(Map<String, dynamic> json) =>
      _$ReviewMessageFromJson(json);

  Map<String, dynamic> toJson() => _$ReviewMessageToJson(this);
}
