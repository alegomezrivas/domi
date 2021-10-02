import 'package:domi/core/classes/paginated.dart';
import 'package:domi/models/user/address_book.dart';
import 'package:domi/repositories/user_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final addressProvider = StateNotifierProvider<AddressProvider, AddressState>(
    (ref) => AddressProvider(AddressState()));

class AddressProvider extends StateNotifier<AddressState> {
  final repository = UserRepository();

  AddressProvider(AddressState state) : super(state);

  void toggleLoading() {
    state.isLoading = !state.isLoading;
    state = state;
  }

  getAddressBook() async {
    try {
      toggleLoading();
      final addresses = await repository.getAddressBook();
      state.results = addresses;
    } catch (e) {
      return Future.error(e);
    }
    toggleLoading();
  }

  createAddress(
      double latitude, double longitude, String name, String address) async {
    try {
      final newAddress = await repository.createAddressBook(
          latitude, longitude, name, address);
      state.results.insert(0, newAddress);
      state = state;
    } catch (e) {
      return Future.error(e);
    }
  }

  deleteAddress(int bookId) async {
    try {
      await repository.deleteAddressBook(bookId);
      state.results.removeWhere((element) => element.id == bookId);
      state = state;
    } catch (e) {
      return Future.error(e);
    }
  }
}

class AddressState extends Paginated {
  List<AddressBook> results = [];
}
