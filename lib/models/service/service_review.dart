import 'package:domi/models/user/simple_user.dart';
import 'package:json_annotation/json_annotation.dart';

part 'service_review.g.dart';

@JsonSerializable(fieldRename: FieldRename.snake)
class ServiceReview {
  int id;
  SimpleUser user;
  List<Messages> messages;
  double stars;
  int service;

  String createdAt;

  ServiceReview(this.id, this.user, this.messages, this.stars, this.service,
      this.createdAt);

  factory ServiceReview.fromJson(Map<String, dynamic> json) =>
      _$ServiceReviewFromJson(json);

  Map<String, dynamic> toJson() => _$ServiceReviewToJson(this);
}

@JsonSerializable(fieldRename: FieldRename.snake)
class Messages {
  int id;
  String description;
  int reviewType;
  int fromStar;
  int toStar;

  Messages(
      this.id, this.description, this.reviewType, this.fromStar, this.toStar);

  factory Messages.fromJson(Map<String, dynamic> json) =>
      _$MessagesFromJson(json);

  Map<String, dynamic> toJson() => _$MessagesToJson(this);
}
