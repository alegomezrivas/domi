
import 'package:json_annotation/json_annotation.dart';

part 'domi_status.g.dart';

@JsonSerializable(fieldRename: FieldRename.snake)
class DomiStatus{
  int? service;

  DomiStatus(this.service);

  factory DomiStatus.fromJson(Map<String, dynamic> json) =>
      _$DomiStatusFromJson(json);

  Map<String, dynamic> toJson() => _$DomiStatusToJson(this);
}