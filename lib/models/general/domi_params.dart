import 'package:json_annotation/json_annotation.dart';

part 'domi_params.g.dart';

@JsonSerializable(fieldRename: FieldRename.snake)
class DomiParams {
  Params params;
  List<Package> packages;

  DomiParams(
    this.params,
    this.packages,
  );

  factory DomiParams.fromJson(Map<String, dynamic> json) =>
      _$DomiParamsFromJson(json);

  Map<String, dynamic> toJson() => _$DomiParamsToJson(this);
}

@JsonSerializable(fieldRename: FieldRename.snake)
class Package {
  int id;
  String name;
  String description;
  int order;

  Package(
    this.id,
    this.name,
    this.description,
    this.order,
  );

  factory Package.fromJson(Map<String, dynamic> json) =>
      _$PackageFromJson(json);

  Map<String, dynamic> toJson() => _$PackageToJson(this);
}

@JsonSerializable(fieldRename: FieldRename.snake)
class Params {
  int id;
  double userTaxPercent;
  double domiTaxPercent;
  String kmValue;
  String minServiceValue;
  double serviceIncDec;
  String minDrawbackValue;
  int offerLifeTime;
  int serviceLifeTime;
  String referCodeReward;
  double insuranceValue;
  String? insuranceMaxValue;
  int country;

  // help

  String shareUrl;
  String pqrUrl;
  String termsUrl;
  String privacyUrl;
  String frequentlyUrl;
  String paymentUrl;
  String helpUrl;
  String rewardUrl;
  String aboutUrl;
  String drawbackUrl;

  Params(
      this.id,
      this.userTaxPercent,
      this.domiTaxPercent,
      this.kmValue,
      this.minServiceValue,
      this.serviceIncDec,
      this.minDrawbackValue,
      this.offerLifeTime,
      this.serviceLifeTime,
      this.referCodeReward,
      this.insuranceValue,
      this.insuranceMaxValue,
      this.country,
      this.shareUrl,
      this.pqrUrl,
      this.termsUrl,
      this.privacyUrl,
      this.frequentlyUrl,
      this.paymentUrl,
      this.helpUrl,
      this.rewardUrl,
      this.aboutUrl,
      this.drawbackUrl
      );

  factory Params.fromJson(Map<String, dynamic> json) => _$ParamsFromJson(json);

  Map<String, dynamic> toJson() => _$ParamsToJson(this);
}
