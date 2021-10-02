import 'dart:io';

import 'package:domi/core/network/network.dart';
import 'package:domi/models/general/city.dart';
import 'package:domi/models/general/country.dart';
import 'package:domi/models/general/domi_params.dart';
import 'package:domi/models/general/review_message.dart';

class GeneralRepository {
  static DomiParams? domiParams;

  static Future<List<Country>> getCountries() async {
    try {
      final response =
          await NetworkService.get("general/countries/", auth: false);
      return (response["results"] as List)
          .map((e) => Country.fromJson(e))
          .toList();
    } catch (e) {
      return Future.error(e);
    }
  }

  static Future<List<City>> getCities(int countryId) async {
    try {
      final response = await NetworkService.get(
          "general/cities/?country=$countryId",
          auth: false);
      return (response["results"] as List)
          .map((e) => City.fromJson(e))
          .toList();
    } catch (e) {
      return Future.error(e);
    }
  }

  static Future<dynamic> uploadFile(
      Map<String, dynamic> signedData, File file) async {
    try {
      final Map<String, String> newMap = {};
      signedData["fields"].forEach((key, value) {
        newMap[key] = value.toString();
      });
      final response = await NetworkService.postMultipart(
          signedData["url"], newMap, file,
          auth: false);
      return response;
    } catch (e) {
      print("error uploading");
      return Future.error(e);
    }
  }

  static Future<DomiParams> getDomiVars() async {
    try {
      final response = await NetworkService.get("general/params/", auth: false);
      return DomiParams.fromJson(response);
    } catch (e) {
      return Future.error(e);
    }
  }

  static Future<List<ReviewMessage>> getReviewMessages() async {
    try {
      final response = await NetworkService.get(
          "general/review_messages/?from_star=1&to_star=5",
          auth: true);
      print(response);
      return (response["results"] as List)
          .map((e) => ReviewMessage.fromJson(e))
          .toList();
    } catch (e) {
      return Future.error(e);
    }
  }
}
