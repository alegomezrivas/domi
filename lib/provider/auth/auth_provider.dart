import 'dart:async';
import 'dart:convert';

import 'package:domi/core/network/network.dart';
import 'package:domi/models/user/user.dart';
import 'package:domi/repositories/user_repository.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class AuthProvider {
  UserData? userData;
  final repository = UserRepository();
  static final storage = FlutterSecureStorage();
  StreamController<Map<String, dynamic>> push =
      StreamController<Map<String, dynamic>>();

  Map<String, dynamic> lastPush = {};

  // Service
  static bool availableScreen = false;

  setUserData(UserData userData) async {
    this.userData = userData;
    await storage.write(key: "userData", value: jsonEncode(userData.toJson()));
    await storage.write(key: "token", value: userData.token);
    await storage.write(key: "refresh", value: userData.refresh);
  }

  Future<bool> getUserData() async {
    final dataJson = await FlutterSecureStorage().read(key: "userData");
    if (dataJson != null) {
      this.userData = UserData.fromJson(jsonDecode(dataJson));
      return true;
    }
    return false;
  }

  logout() async {
    final storage = FlutterSecureStorage();
    await storage.delete(key: "userData");
    await storage.delete(key: "token");
    await storage.delete(key: "refresh");
    this.userData = null;
    NetworkService.token = null;
  }

  editProfile(
      String? photo, String firstname, String lastname, String? email) async {
    try {
      final response =
          await repository.editUser(photo, firstname, lastname, email);
      await setUser(response);
    } catch (e) {
      return Future.error(e);
    }
  }

  setUser(User user) async {
    this.userData!.user = user;
    final storage = FlutterSecureStorage();
    await storage.write(key: "userData", value: jsonEncode(userData!.toJson()));
  }

  getUserInfo() async {
    try {
      final response = await repository.getUserData();
      userData = response;
      await setUser(response.user);
    } catch (e) {
      return Future.error(e);
    }
  }

  static Future<void> clearExternalIdOpenSignal(String userId) async {
    await storage.delete(key: "$userId-external");
  }

  static Future<bool> checkUserExternalIdOpenSignal(String userId) async {
    final hasPin = await storage.read(key: "$userId-external");
    return hasPin != null;
  }

  static Future<void> setUserExternalIdOpenSignal(String userId) async {
    await storage.write(key: "$userId-external", value: "true");
  }

  setNewData(Map<String, dynamic> newPush) {
    // if (newPush["data"] != lastPush["data"]) {
    push.sink.add(newPush);
    lastPush = newPush;
    // }
  }

  dispose() {
    push.close();
  }
}
