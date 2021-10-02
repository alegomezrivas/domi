
import 'package:domi/core/network/network.dart';

class RegisterRepository {
  Future<bool> sendCode(String countryCode, String phone) async {
    try {
      final response = await NetworkService.post("users/sing_up/send_code/",
          {"phone": phone, "country_code": countryCode},
          auth: false);
      return response["success"];
    } catch (e) {
      return Future.error(e);
    }
  }

  Future<dynamic> checkCode(String countryCode, String phone, String code) async {
    try {
      final response = await NetworkService.post("users/sing_up/validate_code/",
          {"phone": phone, "country_code": countryCode, "code": code},
          auth: false);
      print(response.toString());
      return response;
    } catch (e) {
      return Future.error(e);
    }
  }

  Future<dynamic> getPresignedData(
      String countryCode, String phone, String code, String filename) async {
    try {
      final response = await NetworkService.post(
          "users/sing_up/upload_domi_doc/",
          {
            "phone": phone,
            "country_code": countryCode,
            "code": code,
            "filename": filename
          },
          auth: NetworkService.token != null && NetworkService.token != "");
      return response;
    } catch (e) {
      return Future.error(e);
    }
  }

  Future<dynamic> registerUser(userData) async {
    try {
      final response = await NetworkService.post("users/sing_up/", userData, auth: false);
      return response;
    } catch (e) {
      return Future.error(e);
    }
  }

  Future<dynamic> convertToDomi(userData) async {
    try {
      final response = await NetworkService.post("users/covert_to_domi/", userData, auth: true);
      return response;
    } catch (e) {
      return Future.error(e);
    }
  }
}
