import 'package:domi/core/classes/paginated.dart';
import 'package:domi/models/service/service.dart';
import 'package:domi/repositories/service_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final serviceHistoryProvider = StateNotifierProvider.autoDispose<
        ServiceHistoryProvider, ServiceHistoryState>(
    (ref) => ServiceHistoryProvider(ServiceHistoryState()));

class ServiceHistoryProvider extends APIProvider<ServiceHistoryState> {
  final repository = ServiceRepository();

  ServiceHistoryProvider(ServiceHistoryState state) : super(state);

  Future<void> getHistory() async {
    if (isLoading) {
      return;
    }
    if (!hasMoreResults) {
      return;
    }
    try {
      super.toggleLoading();
      final newResults = await repository.getServiceHistory(page: page);
      if(!mounted) {
        hasMoreResults = newResults.length >= pageSize;
        state.results.addAll(newResults);
        page++;
      }
    } catch (e) {
      return Future.error(e);
    } finally {
      super.toggleLoading();
    }
  }

  @override
  void dispose() {
   mounted = true;
    super.dispose();
  }
}

class ServiceHistoryState {
  List<Service> results = [];
}
