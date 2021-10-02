import 'dart:io';

import 'package:domi/models/general/city.dart';
import 'package:domi/models/general/country.dart';
import 'package:domi/models/user/user.dart' as userData;
import 'package:domi/re_use/message_strings.dart';
import 'package:domi/repositories/general_repository.dart';
import 'package:domi/repositories/register_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class RegisterNotifier extends StateNotifier<Register> {
  final repository = RegisterRepository();

  RegisterNotifier(Register state) : super(state);

  void reload() {
    state = state;
  }

  void restart(){
    state = Register();
  }

  void setPhoneData(Country selectedCountry, String phone) {
    state.selectedCountry = selectedCountry;
    state.phone = phone;
  }

  Future<bool> sendCode() async {
    try {
      return await repository.sendCode(
          state.selectedCountry!.phoneCode!, state.phone!);
    } catch (e) {
      return Future.error(e);
    }
  }

  Future<dynamic> checkCode(String optCode) async {
    try {
      state.code = optCode;
      return await repository.checkCode(
          state.selectedCountry!.phoneCode!, state.phone!, optCode);
    } catch (e) {
      return Future.error(e);
    }
  }

  Future<Map<String, dynamic>> getSignedData(String filename) async {
    try {
      return await repository.getPresignedData(
          state.selectedCountry!.phoneCode!,
          state.phone!,
          state.code!,
          filename);
    } catch (e) {
      return Future.error(e);
    }
  }

  Future<dynamic> registerUser() async {
    try {
      Map<String, dynamic> data = {};
      data["country_code"] = state.selectedCountry!.phoneCode;
      data["phone"] = state.phone;
      data["code"] = state.code;
      data["first_name"] = state.firstName;
      data["last_name"] = state.lastName;
      data["city"] = state.selectedCity!.id;

      if (state.docNumber != null) {
        data["domi_data"] = getDomiData();
      }
      return await repository.registerUser(data);
    } catch (e) {
      return Future.error(e);
    }
  }

  Future<userData.User> convertUserToDomi() async {
    try {
      return userData.User.fromJson(
          await repository.convertToDomi(getDomiData()));
    } catch (e) {
      return Future.error(e);
    }
  }

  Map<String, dynamic> getDomiData() {
    final Map<String, dynamic> data = {};
    data["photo"] = state.photo;
    data["refer_code"] = state.referCode;
    data["birthday"] =
        "${state.birthday!.year}-${state.birthday!.month}-${state.birthday!.day}";
    data["email"] = state.email == "" ? null : state.email;

    data["doc_number"] = state.docNumber;
    data["exp_date"] =
        "${state.expeditionDate!.year}-${state.expeditionDate!.month}-${state.expeditionDate!.day}";
    data["doc_front"] = state.docFront;
    data["doc_back"] = state.docBack;

    data["pic_with_license"] = state.frontPhotoId;

    data["license_number"] = state.numberLicense;
    data["license_exp_date"] =
        "${state.expireDateLicense!.year}-${state.expireDateLicense!.month}-${state.expireDateLicense!.day}";
    data["license_front"] = state.licFront;
    data["license_back"] = state.licBack;

    data["vehicle_type"] = state.selectType;
    data["vehicle_plate"] = state.plateNumber;
    data["vehicle_photo"] = state.vehicleFront;

    data["soat_expedition_date"] =
        "${state.expeditionSoat!.year}-${state.expeditionSoat!.month}-${state.expeditionSoat!.day}";
    data["soat_exp_date"] =
        "${state.expireSoat!.year}-${state.expireSoat!.month}-${state.expireSoat!.day}";
    data["soat_doc"] = state.soatFront;

    data["property_doc_front"] = state.propCardFront;
    data["property_doc_back"] = state.propCardBack;
    return data;
  }

  void setAboutMeData(String firstName, String lastName, String photo,
      String photoPath, String email, DateTime birthday) {
    state.firstName = firstName;
    state.lastName = lastName;
    state.photo = photo;
    state.photoPath = photoPath;
    state.email = email;
    state.birthday = birthday;
    state = state;
  }

  void setIdentificationData(
      String docNumber, DateTime expeditionDate, String front, String back) {
    state.docNumber = docNumber;
    state.expeditionDate = expeditionDate;
    state.docFront = front;
    state.docBack = back;
    state = state;
  }

  void setPhotoID(String photo, String path) {
    state.frontPhotoPath = path;
    state.frontPhotoId = photo;
    state = state;
  }

  void setLicenseDriver(
      String nLicense, DateTime expire, String front, String back) {
    state.numberLicense = nLicense;
    state.expireDateLicense = expire;
    state.licFront = front;
    state.licBack = back;
    state = state;
  }

  void setAboutVehicle(int type, plateVehicle, String front) {
    state.selectType = type;
    state.plateNumber = plateVehicle;
    state.vehicleFront = front;
    state = state;
  }

  void setSoat(DateTime expeditionSoatVehicle, DateTime expireSoatVehicle,
      String front) {
    state.expeditionSoat = expeditionSoatVehicle;
    state.expireSoat = expireSoatVehicle;
    state.soatFront = front;
    state = state;
  }

  void setPropertyCard(String front, String back) {
    state.propCardFront = front;
    state.propCardBack = back;
    state = state;
  }

  void setReferCode(String code) {
    state.referCode = code;
    state = state;
  }

  Future<String> uploadImageFromPathRegister(String path) async {
    try {
      final file = File(path);
      if (await file.length() > MAX_IMAGE_SIZE) {
        return Future.error({"detail": IMAGE_SIZE_MESSAGE});
      }
      final response = await getSignedData(file.uri.pathSegments.last);
      await GeneralRepository.uploadFile(response, file);
      return response["fields"]["key"];
    } catch (e) {
      return Future.error(e);
    }
  }

  void convertToDomi(userData.User user) {
    state.covertToDomi = true;
    state.code = "1234";
    state.phone = user.person.phone;
    state.selectedCountry =
        Country(countryCode: "", phoneCode: user.person.countryCode);
    state.firstName = user.firstName;
    state.lastName = user.lastName;
    state.email = user.email;
  }
}

class Register {
  bool covertToDomi = false;

  Country? selectedCountry;
  String? phone;
  String? code;
  City? selectedCity;
  String? firstName;
  String? lastName;

  /// domi data about me
  String? photo;
  String? photoPath;
  String? email;
  DateTime? birthday;

  /// identification Data
  String? docNumber;
  DateTime? expeditionDate;
  String? docFront;
  String? docBack;

  /// confirmation ID
  String? frontPhotoPath;
  String? frontPhotoId;

  /// Driver License
  String? numberLicense;
  DateTime? expireDateLicense;
  String? licFront;
  String? licBack;

  /// About vehicle
  int? selectType;
  String? plateNumber;
  String? vehicleFront;

  /// SOAT
  DateTime? expeditionSoat;
  DateTime? expireSoat;
  String? soatFront;

  /// Property card
  String? propCardFront;
  String? propCardBack;

  /// Refer code
  String? referCode;

  bool validateAboutMe() {
    return firstName != null &&
        lastName != null &&
        photo != null &&
        birthday != null;
  }

  bool validateIdentification() {
    return docNumber != null &&
        expeditionDate != null &&
        docFront != null &&
        docBack != null;
  }

  bool validatePhotoID() {
    return frontPhotoId != null;
  }

  bool validateDriverLicense() {
    return numberLicense != null &&
        expireDateLicense != null &&
        licFront != null &&
        licBack != null;
  }

  bool validateAboutVehicle() {
    return selectType != null &&
        plateNumber != null &&
        vehicleFront != null &&
        validateSoat() &&
        validatePropertyCard();
  }

  bool validateSoat() {
    return expeditionSoat != null && expireSoat != null && soatFront != null;
  }

  bool validatePropertyCard() {
    return propCardFront != null && propCardBack != null;
  }

  bool validateReferCode() {
    return referCode != null;
  }

  bool validateAll() {
    return validateAboutMe() &&
        validateIdentification() &&
        validatePhotoID() &&
        validateDriverLicense() &&
        validateAboutVehicle() &&
        validateSoat() &&
        validatePropertyCard();
  }
}
