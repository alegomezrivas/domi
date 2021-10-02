import 'package:domi/core/classes/paginated.dart';
import 'package:domi/core/enum/service_enums.dart';
import 'package:domi/models/service/service.dart';
import 'package:domi/repositories/service_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final activeServicesProvider =
    StateNotifierProvider<ActiveServicesProvider, ActiveServiceState>(
        (ref) => ActiveServicesProvider(ActiveServiceState()));

class ActiveServicesProvider extends APIProvider<ActiveServiceState> {
  ActiveServicesProvider(ActiveServiceState state) : super(state);

  Future<Service?> getActiveServices() async {
    try {
      super.toggleLoading();
      final result = await ServiceRepository.getActiveServices();
      final pendingServices = result
          .where((element) => element.getServiceStatus == ServiceStatus.pending)
          .toList();
      state.results = result
          .where((element) => element.getServiceStatus == ServiceStatus.active)
          .toList();
      return pendingServices.isNotEmpty ? pendingServices.first : null;
    } catch (e) {
      return Future.error(e);
    } finally {
      super.toggleLoading();
    }
  }

  void removeService(int serviceId) {
    state.results.removeWhere((element) => element.id == serviceId);
    state = state;
  }

  void setService(Service service) {
    state.results.removeWhere((element) => element.id == service.id);
    state.results.add(service);
    state = state;
  }

  void setDomiActiveService(int serviceId) {
    state.domiActiveService = serviceId;
    state = state;
  }
}

class ActiveServiceState {
  List<Service> results = [];
  int domiActiveService = 0;
}
