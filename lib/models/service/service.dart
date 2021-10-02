import 'package:domi/core/enum/service_enums.dart';
import 'package:domi/core/extensions/string.dart';
import 'package:domi/models/general/domi_params.dart';
import 'package:domi/models/user/address_book.dart';
import 'package:domi/models/user/simple_user.dart';
import 'package:domi/re_use/utils/domi_format.dart';

import 'package:json_annotation/json_annotation.dart';

part 'service.g.dart';

@JsonSerializable(fieldRename: FieldRename.snake)
class Service {
  int id;
  SimpleUser? user;
  List<WayPoint> wayPoints;
  int serviceType;
  String offer;
  String serviceTax;
  String domiTax;
  String insuranceTax;
  String cancelInPlace;
  String observation;
  int payMethod;
  int paymentStatus;
  int? weight;
  String insurance;
  String createdAt;
  int serviceStatus;
  Package? package;
  SimpleUser? domi;
  double distance;
  @JsonKey(defaultValue: false)
  bool isFavorite;

  Service(
      this.id,
      this.user,
      this.wayPoints,
      this.serviceType,
      this.offer,
      this.serviceTax,
      this.domiTax,
      this.insuranceTax,
      this.cancelInPlace,
      this.observation,
      this.payMethod,
      this.paymentStatus,
      this.weight,
      this.insurance,
      this.createdAt,
      this.serviceStatus,
      this.package,
      this.domi,
      this.distance,
      this.isFavorite);

  factory Service.fromJson(Map<String, dynamic> json) =>
      _$ServiceFromJson(json);

  Map<String, dynamic> toJson() => _$ServiceToJson(this);

  ServiceStatus get getServiceStatus => ServiceStatus.values[serviceStatus - 1];

  ServiceType get getServiceType => ServiceType.values[serviceType - 1];

  String get getTotal => DomiFormat.formatCurrencyCustom(offer.toDouble());

  String get getTotalWithTax => DomiFormat.formatCurrencyCustom(
      offer.toDouble() + serviceTax.toDouble() + insuranceTax.toDouble());

  String get getTotalTax => DomiFormat.formatCurrencyCustom(
      serviceTax.toDouble() + insuranceTax.toDouble());

  String get getTotalDomiTax => DomiFormat.formatCurrencyCustom(domiTax.toDouble());

  String get getTotalDescription =>
      "${DomiFormat.formatCurrencyCustom(offer.toDouble())} de base${serviceTax.toDouble() != 0 ? "+ ${DomiFormat.formatCurrencyCustom(serviceTax.toDouble())} del servicio" : ""} ${package != null ? "+ ${DomiFormat.formatCurrencyCustom(insuranceTax.toDouble())} del seguro" : ""}";

  PayMethod get getPayMethod => PayMethod.values[payMethod - 1];
}

@JsonSerializable(fieldRename: FieldRename.snake)
class WayPoint {
  Location? location;
  String address;
  bool check;
  bool inWay;
  int order;
  @JsonKey(ignore: true, defaultValue: false)
  bool mark = false;

  WayPoint(this.location, this.address, this.check, this.inWay, this.order);

  factory WayPoint.fromJson(Map<String, dynamic> json) =>
      _$WayPointFromJson(json);

  Map<String, dynamic> toJson() => _$WayPointToJson(this);
}
