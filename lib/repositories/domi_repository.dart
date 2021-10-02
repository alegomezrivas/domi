import 'package:domi/core/network/network.dart';
import 'package:domi/models/service/domi_status.dart';
import 'package:domi/models/service/service.dart';
import 'package:domi/models/service/service_offer.dart';
import 'package:domi/models/service/service_review.dart';
import 'package:domi/models/user/simple_user.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class DomiRepository {
  Future<List<Service>> getAvailableServices(
      {int page = 1, required LatLng latLng}) async {
    try {
      final response = await NetworkService.get(
          "services/domi/?page=$page&lat=${latLng.latitude}&lng=${latLng.longitude}",
          auth: true);
      return (response["results"] as List)
          .map((e) => Service.fromJson(e))
          .toList();
    } catch (e) {
      return Future.error(e);
    }
  }

  static Future<ServiceOffer> takeService(
      int serviceId, double counteroffer) async {
    try {
      final response = await NetworkService.post(
          "services/domi/$serviceId/take_service/",
          {"counteroffer": counteroffer},
          auth: true);
      return ServiceOffer.fromJson(response);
    } catch (e) {
      return Future.error(e);
    }
  }

  static Future<DomiStatus> getDomiStatus() async {
    try {
      final response =
          await NetworkService.get("services/domi/domi_status/", auth: true);
      return DomiStatus.fromJson(response);
    } catch (e) {
      return Future.error(e);
    }
  }

  static Future<dynamic> nextStatus() async {
    try {
      final response = await NetworkService.put(
          "services/domi/next_status/", {},
          auth: true);
      return response;
    } catch (e) {
      return Future.error(e);
    }
  }

  Future<List<ServiceReview>> getServiceReview({int page = 1}) async {
    try {
      final response = await NetworkService.get(
          "services/qualification/?page=$page",
          auth: true);
      return (response["results"] as List)
          .map((e) => ServiceReview.fromJson(e))
          .toList();
    } catch (e) {
      return Future.error(e);
    }
  }

  Future<Person> getReviewStatus() async {
    try {
      final response = await NetworkService.get(
          "services/qualification/get_qualification_status/",
          auth: true);
      return Person.fromJson(response);
    } catch (e) {
      return Future.error(e);
    }
  }

  static Future<dynamic> available(
      bool available, Map<String, dynamic> location) async {
    try {
      final response = await NetworkService.put("services/domi/available/",
          {"available": available, "location": location},
          auth: true);
      return response;
    } catch (e) {
      return Future.error(e);
    }
  }
}
