import 'dart:async';
import 'dart:convert';

import 'package:domi/core/classes/paginated.dart';
import 'package:domi/core/network/network.dart';
import 'package:domi/models/service/service.dart';
import 'package:domi/provider/service/active_services_provider.dart';
import 'package:domi/repositories/domi_repository.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

final availableProvider = StateNotifierProvider.autoDispose<
        AvailableServiceProvider, AvailableServiceState>(
    (ref) => AvailableServiceProvider(ref.read, AvailableServiceState()));

class AvailableServiceProvider extends StateNotifier<AvailableServiceState> {
  final Reader read;
  final repository = DomiRepository();
  List<Service> remove = [];
  WebSocketChannel? channel;
  StreamSubscription? _subscription;
  bool mount = false;

  AvailableServiceProvider(this.read, AvailableServiceState state)
      : super(state);

  void connectToWS(int userId, VoidCallback onReconnect) {
    if (channel != null) {
      _subscription?.cancel();
      channel?.sink.close();
      channel = null;
    }
    channel = WebSocketChannel.connect(
      Uri.parse(NetworkService.WS_URL + "ws/chat/user_$userId/"),
    );
    _subscription = channel!.stream.listen((message) {
      try {
        if (!mount) {
          print(message);
          final messageJson = jsonDecode(message);
          if (messageJson["action"] == "add") {
            final data = Service.fromJson(messageJson["data"]);
            super.state.results.add(data);
          }

          if (messageJson["action"] == "remove") {
            super.state.results.removeWhere(
                (element) => element.id == messageJson["data"]["id"]);
          }

          if (messageJson["accept_offer"] == userId) {
            read(activeServicesProvider.notifier)
                .setDomiActiveService(messageJson["accept_offer_service"]);
          }

          if (messageJson["action"] == "canceled") {
            read(activeServicesProvider.notifier).setDomiActiveService(0);
          }

          super.state = super.state;
        }
      } catch (e) {
        print("error $e");
      }
    }, onDone: () {
      reconnect(userId, onReconnect);
    }, onError: (e) {
      reconnect(userId, onReconnect);
    });
  }

  void reconnect(int userId, VoidCallback onReconnect) async {
    if (!mount) {
      print('Disconnected');
      if (channel != null) {
        _subscription?.cancel();
        channel?.sink.close();
        await Future.delayed(Duration(seconds: 4));
      }
      _subscription?.cancel();
      channel = null;
      onReconnect();
      connectToWS(userId, onReconnect);
    }
  }

  Future<void> refresh(LatLng latLng) async {
    state.results = [];
    state.refresh();
    await getAvailableServices(latLng);
  }

  Future<void> getAvailableServices(LatLng latLng) async {
    // if (state.isLoading) {
    //   return;
    // }
    // if (!state.hasMoreResults) {
    //   return;
    // }
    try {
      state.toggleLoading();
      final newResults = await repository.getAvailableServices(page: state.page, latLng: latLng);
      // state.hasMoreResults = newResults.length >= state.pageSize;
      state.results = newResults;
      // state.page++;
      state.toggleLoading();
    } catch (e) {
      state.toggleLoading();
      return Future.error(e);
    }
    state = state;
  }

  void removeItem(Service service) {
    state.results.remove(service);
    state = state;
  }

  @override
  void dispose() {
    mount = true;
    _subscription?.cancel();
    channel?.sink.close();
    super.dispose();
  }
}

class AvailableServiceState extends Paginated {
  List<Service> results = [];
}
