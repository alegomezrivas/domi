import 'package:domi/core/network/network.dart';
import 'package:domi/models/user/address_book.dart';
import 'package:domi/models/user/favorite_domi.dart';
import 'package:domi/models/user/user.dart';

class UserRepository {
  static Future<dynamic> getPresignedData(String filename) async {
    try {
      final response = await NetworkService.post(
          "users/upload_file/", {"filename": filename},
          auth: true);
      return response;
    } catch (e) {
      return Future.error(e);
    }
  }

  Future<User> editUser(String? photo, String firstname, String lastname,
      String? email) async {
    try {
      final response = await NetworkService.put(
          "users/0/",
          {
            "photo": photo,
            "first_name": firstname,
            "last_name": lastname,
            "email": email
          },
          auth: true);
      return User.fromJson(response);
    } catch (e) {
      return Future.error(e);
    }
  }

  Future<List<AddressBook>> getAddressBook({int page = 1}) async {
    try {
      final response =
      await NetworkService.get("users/book/?page=$page", auth: true);
      return (response["results"] as List)
          .map((e) => AddressBook.fromJson(e))
          .toList();
    } catch (e) {
      return Future.error(e);
    }
  }

  Future<AddressBook> createAddressBook(double latitude, double longitude,
      String name, String address) async {
    try {
      final response = await NetworkService.post(
          "users/book/",
          {
            "location": {"latitude": latitude, "longitude": longitude},
            "name": name,
            "address": address,
          },
          auth: true);
      return AddressBook.fromJson(response);
    } catch (e) {
      return Future.error(e);
    }
  }

  Future<void> deleteAddressBook(int id) async {
    try {
      await NetworkService.delete("users/book/$id/", auth: true);
    } catch (e) {
      return Future.error(e);
    }
  }

  Future<List<FavoriteDomi>> getFavoriteDomis({int page = 1}) async {
    try {
      final response =
      await NetworkService.get("users/favorites/?page=$page", auth: true);
      return (response["results"] as List)
          .map((e) => FavoriteDomi.fromJson(e))
          .toList();
    } catch (e) {
      return Future.error(e);
    }
  }

  Future<FavoriteDomi> createFavorite(int domiId) async {
    try {
      final response = await NetworkService.post(
          "users/favorites/",
          {
            "domi_id": domiId,
          },
          auth: true);
      return FavoriteDomi.fromJson(response);
    } catch (e) {
      return Future.error(e);
    }
  }

  Future<void> deleteFavorite(int domiId) async {
    try {
      await NetworkService.delete("users/favorites/$domiId/", auth: true);
    } catch (e) {
      return Future.error(e);
    }
  }

  Future<UserData> getUserData() async {
    try {
      final response = await NetworkService.get("users/0/", auth: true);
      return UserData.fromJson(response);
    } catch (e) {
      return Future.error(e);
    }
  }

 static Future<void> refreshToken() async {
    try {
      final response = await NetworkService.post(
          "token/refresh/",
          {
            "refresh": await NetworkService.getRefreshToken(),
          },
          auth: true);
      await NetworkService.setToken(response["access"]);
    } catch (e) {
      return Future.error(e);
    }
  }
}
