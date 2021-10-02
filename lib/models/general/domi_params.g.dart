// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'domi_params.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

DomiParams _$DomiParamsFromJson(Map<String, dynamic> json) {
  return DomiParams(
    Params.fromJson(json['params'] as Map<String, dynamic>),
    (json['packages'] as List<dynamic>)
        .map((e) => Package.fromJson(e as Map<String, dynamic>))
        .toList(),
  );
}

Map<String, dynamic> _$DomiParamsToJson(DomiParams instance) =>
    <String, dynamic>{
      'params': instance.params,
      'packages': instance.packages,
    };

Package _$PackageFromJson(Map<String, dynamic> json) {
  return Package(
    json['id'] as int,
    json['name'] as String,
    json['description'] as String,
    json['order'] as int,
  );
}

Map<String, dynamic> _$PackageToJson(Package instance) => <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'description': instance.description,
      'order': instance.order,
    };

Params _$ParamsFromJson(Map<String, dynamic> json) {
  return Params(
    json['id'] as int,
    (json['user_tax_percent'] as num).toDouble(),
    (json['domi_tax_percent'] as num).toDouble(),
    json['km_value'] as String,
    json['min_service_value'] as String,
    (json['service_inc_dec'] as num).toDouble(),
    json['min_drawback_value'] as String,
    json['offer_life_time'] as int,
    json['service_life_time'] as int,
    json['refer_code_reward'] as String,
    (json['insurance_value'] as num).toDouble(),
    json['insurance_max_value'] as String?,
    json['country'] as int,
    json['share_url'] as String,
    json['pqr_url'] as String,
    json['terms_url'] as String,
    json['privacy_url'] as String,
    json['frequently_url'] as String,
    json['payment_url'] as String,
    json['help_url'] as String,
    json['reward_url'] as String,
    json['about_url'] as String,
    json['drawback_url'] as String,
  );
}

Map<String, dynamic> _$ParamsToJson(Params instance) => <String, dynamic>{
      'id': instance.id,
      'user_tax_percent': instance.userTaxPercent,
      'domi_tax_percent': instance.domiTaxPercent,
      'km_value': instance.kmValue,
      'min_service_value': instance.minServiceValue,
      'service_inc_dec': instance.serviceIncDec,
      'min_drawback_value': instance.minDrawbackValue,
      'offer_life_time': instance.offerLifeTime,
      'service_life_time': instance.serviceLifeTime,
      'refer_code_reward': instance.referCodeReward,
      'insurance_value': instance.insuranceValue,
      'insurance_max_value': instance.insuranceMaxValue,
      'country': instance.country,
      'share_url': instance.shareUrl,
      'pqr_url': instance.pqrUrl,
      'terms_url': instance.termsUrl,
      'privacy_url': instance.privacyUrl,
      'frequently_url': instance.frequentlyUrl,
      'payment_url': instance.paymentUrl,
      'help_url': instance.helpUrl,
      'reward_url': instance.rewardUrl,
      'about_url': instance.aboutUrl,
      'drawback_url': instance.drawbackUrl,
    };
