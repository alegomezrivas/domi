import 'package:domi/core/classes/paginated.dart';
import 'package:domi/models/user/favorite_domi.dart';
import 'package:domi/repositories/user_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final favoritesProvider =
    StateNotifierProvider<FavoritesProvider, FavoriteSate>(
        (ref) => FavoritesProvider(FavoriteSate()));

class FavoritesProvider extends StateNotifier<FavoriteSate> {
  final repository = UserRepository();

  FavoritesProvider(FavoriteSate state) : super(state);

  void toggleLoading() {
    state.isLoading = !state.isLoading;
    state = state;
  }

  getFavorites() async {
    try {
      toggleLoading();
      final favorites = await repository.getFavoriteDomis();
      state.results = favorites;
    } catch (e) {
      return Future.error(e);
    }
    toggleLoading();
  }

  createFavorite(int domiId) async {
    try {
      final newFavorite = await repository.createFavorite(domiId);
      state.results.insert(0, newFavorite);
      state = state;
    } catch (e) {
      return Future.error(e);
    }
  }

  deleteFavorite(int favoriteId) async {
    try {
      await repository.deleteFavorite(favoriteId);
      state.results.removeWhere((element) => element.id == favoriteId);
      state = state;
    } catch (e) {
      return Future.error(e);
    }
  }
}

class FavoriteSate extends Paginated {
  List<FavoriteDomi> results = [];
}
