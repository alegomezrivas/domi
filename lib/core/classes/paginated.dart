import 'package:flutter_riverpod/flutter_riverpod.dart';

class APIProvider<T> extends PaginatedNotifier<T> {
  bool mounted = false;

  APIProvider(T state) : super(state);

  toggleLoading() {
    if (!mounted) {
      isLoading = !isLoading;
      super.state = super.state;
    }
  }

  newPage() {
    super.page++;
  }
}

class PaginatedNotifier<T> extends StateNotifier<T> {
  int page = 1;
  int pageSize = 15;
  bool isLoading = false;
  bool hasMoreResults = true;

  PaginatedNotifier(T state) : super(state);

  toggleLoading() {
    isLoading = !isLoading;
  }

  refresh() {
    page = 1;
    isLoading = false;
    hasMoreResults = true;
  }
}

class Paginated {
  int page = 1;
  int pageSize = 15;
  bool isLoading = false;
  bool hasMoreResults = true;

  toggleLoading() {
    isLoading = !isLoading;
  }

  refresh() {
    page = 1;
    isLoading = false;
    hasMoreResults = true;
  }
}
