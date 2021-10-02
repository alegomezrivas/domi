import 'dart:async';
import 'dart:convert';

import 'package:domi/core/classes/paginated.dart';
import 'package:domi/core/network/network.dart';
import 'package:domi/models/service/service_offer.dart';
import 'package:domi/repositories/service_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

final offersProvider =
    StateNotifierProvider.autoDispose<OffersProvider, OfferState>(
        (ref) => OffersProvider(OfferState()));

class OffersProvider extends APIProvider<OfferState> {
  final repository = ServiceRepository();

  WebSocketChannel? channel;
  StreamSubscription? _subscription;

  OffersProvider(state) : super(state);

  void listenOffers(int serviceId) {
    if (channel != null) {
      _subscription?.cancel();
      channel?.sink.close();
      channel = null;
    }
    channel = WebSocketChannel.connect(
      Uri.parse(NetworkService.WS_URL + "ws/chat/offers_$serviceId/"),
    );

    _subscription = channel!.stream.listen((message) {
      try {
        print(message);
        final jsonMessage = jsonDecode(message);
        if (jsonMessage["action"] == "add") {
          final data = ServiceOffer.fromJson(jsonMessage["data"]);
          super.state.results.add(data);
        }

        if (jsonMessage["action"] == "remove") {
          super.state.results.removeWhere(
              (element) => element.id == jsonMessage["data"]["id"]);
        }

        super.state = super.state;
      } catch (e) {
        print("error $e");
      }
    }, onDone: () {
      reconnect(serviceId);
    }, onError: (e) {
      reconnect(serviceId);
      print("print a errrorr $e");
    });
  }

  void reconnect(int serviceId) async {
    if (!mounted) {
      print('Disconnected');
      if (channel != null) {
        channel?.sink.close();
        await Future.delayed(Duration(seconds: 4));
      }
      channel = null;
      listenOffers(serviceId);
    }
  }

  getOffers(int serviceId) async {
    super.toggleLoading();
    try {
      state.results = await repository.getOffers(serviceId);
    } catch (e) {
      return Future.error(e);
    } finally {
      super.toggleLoading();
    }
  }

  void removeItem(ServiceOffer offer) {
    state.results.remove(offer);
    state = state;
  }

  @override
  void dispose() {
    mounted = true;
    _subscription?.cancel();
    channel?.sink.close();
    super.dispose();
  }
}

class OfferState extends Paginated {
  List<ServiceOffer> results = [];
}
