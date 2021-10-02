import 'package:domi/models/user/simple_user.dart';
import 'package:domi/re_use/utils/domi_format.dart';
import 'package:json_annotation/json_annotation.dart';

part 'service_offer.g.dart';

@JsonSerializable(fieldRename: FieldRename.snake)
class ServiceOffer {
  int id;
  SimpleUser domi;
  bool isFavorite;
  bool status;
  String createdAt;
  int service;
  double distance;
  String counteroffer;

  ServiceOffer(this.id, this.domi, this.isFavorite, this.status, this.createdAt,
      this.service, this.distance, this.counteroffer);

  factory ServiceOffer.fromJson(Map<String, dynamic> json) =>
      _$ServiceOfferFromJson(json);

  Map<String, dynamic> toJson() => _$ServiceOfferToJson(this);

  int get getTime {
    if (distance < 1) {
      return 3;
    }
    if (distance >= 1 && distance <= 5) {
      return 5;
    }
    return 10;
  }

  String get getDistance{
    if(distance < 1){
      return "${DomiFormat.formatCompat(distance * 100)} m";
    }
    return "${DomiFormat.formatCompat(distance)} km";
  }
}
