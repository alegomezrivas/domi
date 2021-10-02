import 'package:domi/re_use/theme.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:json_annotation/json_annotation.dart';

part 'user_transaction.g.dart';

@JsonSerializable(fieldRename: FieldRename.snake)
class UserTransaction {
  int? id;
  int? transactionType;
  int? detail;
  int? status;
  String? total;
  String? timestamp;
  int? user;

  UserTransaction(
      {this.id,
      this.transactionType,
      this.detail,
      this.status,
      this.total,
      this.timestamp,
      this.user});

  factory UserTransaction.fromJson(Map<String, dynamic> json) =>
      _$UserTransactionFromJson(json);

  Map<String, dynamic> toJson() => _$UserTransactionToJson(this);

  String getDetail() {
    switch (TransactionDetail.values[detail! - 1]) {
      case TransactionDetail.charge:
        return "Recarga";
      case TransactionDetail.service:
        return "Servicio";
      case TransactionDetail.fee:
        return "Tarifa";
      case TransactionDetail.refund:
        return "Rembolso";
      case TransactionDetail.refer:
        return "Referido";
      case TransactionDetail.drawBack:
        return "Desembolso";
      default:
        return "";
    }
  }

  Color getDetailColor() {
    if(TransactionStatus.values[status! - 1] != TransactionStatus.complete){
      return getStatusColor();
    }
    switch (transactionType) {
      case 1:
        return Colors.green;
      case 2:
        return Colors.redAccent;
      default:
        return inDomiGreyBlack;
    }
  }

  String getStatus() {
    switch (TransactionStatus.values[status! - 1]) {
      case TransactionStatus.pending:
        return "Pendiente";
      case TransactionStatus.complete:
        return "Exitoso";
      case TransactionStatus.rejected:
        return "Cancelada";
      default:
        return "";
    }
  }

  Color getStatusColor() {
    switch (TransactionStatus.values[status! - 1]) {
      case TransactionStatus.pending:
        return Colors.amber;
      case TransactionStatus.complete:
        return Colors.green;
      case TransactionStatus.rejected:
        return Colors.redAccent;
      default:
        return Colors.black;
    }
  }
}

enum TransactionDetail { charge, service, fee, refund, refer, drawBack }

enum TransactionStatus { pending, complete, rejected }
