import 'package:domi/core/classes/paginated.dart';
import 'package:domi/main.dart';
import 'package:domi/models/service/service_review.dart';
import 'package:domi/repositories/domi_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final serviceReviewsProvider = StateNotifierProvider.autoDispose<
        ServiceReviewsProvider, ServiceReviewState>(
    (ref) => ServiceReviewsProvider(ref.read, ServiceReviewState()));

class ServiceReviewsProvider extends APIProvider<ServiceReviewState> {
  final repository = DomiRepository();
  final Reader read;

  ServiceReviewsProvider(this.read, state) : super(state);

  Future<void> getReviews() async {
    if (isLoading) {
      return;
    }
    if (!hasMoreResults) {
      return;
    }
    try {
      super.toggleLoading();
      final newResults = await repository.getServiceReview(page: page);
      hasMoreResults = newResults.length >= pageSize;
      state.results.addAll(newResults);
      page++;
    } catch (e) {
      return Future.error(e);
    } finally {
      super.toggleLoading();
    }
  }

  getReviewStatus() async {
    try {
      if (!mounted) {
        final person = await repository.getReviewStatus();
        read(authProvider).userData!.user.person.domiCount = person.domiCount;
        read(authProvider).userData!.user.person.reviews = person.reviews;
        read(authProvider).userData!.user.person.stars = person.stars;
        state = state;
      }
    } catch (e) {
      return Future.error(e);
    }
  }

  @override
  void dispose() {
    mounted = true;
    super.dispose();
  }
}

class ServiceReviewState {
  List<ServiceReview> results = [];
}
