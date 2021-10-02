import 'package:domi/core/network/network.dart';
import 'package:domi/models/service/near_domi.dart';
import 'package:domi/models/service/service.dart';
import 'package:domi/models/service/service_offer.dart';

class ServiceRepository {
  Future<dynamic> createService(Map<String, dynamic> data) async {
    try {
      final response =
          await NetworkService.post("services/services/", data, auth: true);
      return response;
    } catch (e) {
      return Future.error(e);
    }
  }

  static Future<dynamic> cancelService(int serviceId) async {
    try {
      final response = await NetworkService.delete(
          "services/services/$serviceId/cancel_service/",
          auth: true);
      return response;
    } catch (e) {
      return Future.error(e);
    }
  }

  Future<List<ServiceOffer>> getOffers(int serviceId) async {
    try {
      final response = await NetworkService.get(
          "services/services/$serviceId/get_offers/",
          auth: true);
      return (response as List).map((e) => ServiceOffer.fromJson(e)).toList();
    } catch (e) {
      return Future.error(e);
    }
  }

  static Future<dynamic> rejectOffer(int offerId) async {
    try {
      final response = await NetworkService.delete(
          "services/services/$offerId/reject_offer/",
          auth: true);
      return response;
    } catch (e) {
      return Future.error(e);
    }
  }

  static Future<dynamic> acceptOffer(int offerId) async {
    try {
      final response = await NetworkService.post(
          "services/services/accept_offer/", {"service_offer": offerId},
          auth: true);
      return response;
    } catch (e) {
      return Future.error(e);
    }
  }

  Future<Service> getServiceDetail(int serviceId) async {
    try {
      final response = await NetworkService.get(
          "services/in_service_detail/$serviceId/",
          auth: true);
      return Service.fromJson(response);
    } catch (e) {
      return Future.error(e);
    }
  }

  static Future<List<Service>> getActiveServices() async {
    try {
      final response = await NetworkService.get(
          "services/services/get_active_services/",
          auth: true);
      return (response as List).map((e) => Service.fromJson(e)).toList();
    } catch (e) {
      return Future.error(e);
    }
  }

  static Future<dynamic> sendServiceQualification(
      int serviceId, double stars, List<int> messages) async {
    try {
      final response = await NetworkService.post("services/qualification/",
          {"service": serviceId, "stars": stars, "messages_id": messages},
          auth: true);
      return response;
    } catch (e) {
      return Future.error(e);
    }
  }

  Future<List<Service>> getServiceHistory({int page = 1}) async {
    try {
      final response =
          await NetworkService.get("services/history/?page=$page", auth: true);
      return (response["results"] as List)
          .map((e) => Service.fromJson(e))
          .toList();
    } catch (e) {
      return Future.error(e);
    }
  }

  static Future<List<NearDomi>> getNearDomis(
      double latitude, double longitude) async {
    try {
      final response = await NetworkService.get(
          "services/services/get_near_domis/?lat=$latitude&lng=$longitude",
          auth: true);
      return (response as List).map((e) => NearDomi.fromJson(e)).toList();
    } catch (e) {
      return Future.error(e);
    }
  }
  static Future<String> createShareCode(int id) async {
    try {
      final response = await NetworkService.put(
          "services/services/$id/generate_share_code/", {},
          auth: true);
      return response["data"];
    } catch (e) {
      return Future.error(e);
    }
  }
  static Future<dynamic> cancelInService(int serviceId) async {
    try {
      final response = await NetworkService.delete(
          "services/cancellation/$serviceId/",
          auth: true);
      return response;
    } catch (e) {
      return Future.error(e);
    }
  }
}
