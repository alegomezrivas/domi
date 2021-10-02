import 'package:domi/core/network/network.dart';
import 'package:domi/models/wallet/card.dart';
import 'package:domi/models/wallet/user_transaction.dart';

class WalletRepository {
  Future<Map<String, dynamic>> getBalance() async {
    try {
      final response = await NetworkService.get("wallet/balance/", auth: true);
      return response;
    } catch (e) {
      return Future.error(e);
    }
  }

  Future<List<UserTransaction>> getUserTransaction({int page = 1}) async {
    try {
      final response = await NetworkService.get(
          "wallet/transactions/?page=$page",
          auth: true);
      return (response["results"] as List)
          .map((e) => UserTransaction.fromJson(e))
          .toList();
    } catch (e) {
      return Future.error(e);
    }
  }
  static Future<Card> createCreditCard(Map<String, dynamic> data) async {
    try {
      final response =
      await NetworkService.post("wallet/cards/", data, auth: true);
      print(response);
      return Card.fromJson(response);
    } catch (e) {
      return Future.error(e);
    }
  }

  static Future<UserTransaction> createRecharge(double total) async {
    try {
      final response = await NetworkService.post(
          "wallet/recharge/", {"total": total},
          auth: true);
      return UserTransaction.fromJson(response);
    } catch (e) {
      return Future.error(e);
    }
  }

  Future<List<Card>> getCreditCard({int page = 1}) async {
    try {
      final response =
      await NetworkService.get("wallet/cards/?page=$page", auth: true);
      return (response["results"] as List)
          .map((e) => Card.fromJson(e))
          .toList();
    } catch (e) {
      return Future.error(e);
    }
  }
  static Future<dynamic> postDrawback(Map<String, dynamic> data) async {
    try {
      final response =
      await NetworkService.post("wallet/drawback/", data, auth: true);
      print(response);
      return response;
    } catch (e) {
      return Future.error(e);
    }
  }

  static Future<Map<String, dynamic>> getRewardBalance() async {
    try {
      final response = await NetworkService.get("wallet/rewards/", auth: true);
      return response;
    } catch (e) {
      return Future.error(e);
    }
  }

   Future<dynamic> deleteCreditCard(int cardId) async {
    try {
      final response = await NetworkService.delete(
          "wallet/cards/$cardId/",
          auth: true);
      return response;
    } catch (e) {
      return Future.error(e);
    }
  }
}
