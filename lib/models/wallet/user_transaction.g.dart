// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_transaction.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UserTransaction _$UserTransactionFromJson(Map<String, dynamic> json) {
  return UserTransaction(
    id: json['id'] as int?,
    transactionType: json['transaction_type'] as int?,
    detail: json['detail'] as int?,
    status: json['status'] as int?,
    total: json['total'] as String?,
    timestamp: json['timestamp'] as String?,
    user: json['user'] as int?,
  );
}

Map<String, dynamic> _$UserTransactionToJson(UserTransaction instance) =>
    <String, dynamic>{
      'id': instance.id,
      'transaction_type': instance.transactionType,
      'detail': instance.detail,
      'status': instance.status,
      'total': instance.total,
      'timestamp': instance.timestamp,
      'user': instance.user,
    };
