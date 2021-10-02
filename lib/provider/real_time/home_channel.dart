import 'dart:async';
import 'dart:convert';

import 'package:domi/core/classes/geo.dart';
import 'package:domi/core/network/network.dart';
import 'package:domi/provider/service/active_services_provider.dart';
import 'package:domi/repositories/service_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

final homeDomisProvider =
    StateNotifierProvider<HomeDomisNearWSProvider, List<Marker>>(
        (ref) => HomeDomisNearWSProvider(ref.read, []));

class HomeDomisNearWSProvider extends StateNotifier<List<Marker>> {
  WebSocketChannel? channel;
  BitmapDescriptor? _markerIcon;
  StreamSubscription? _subscription;
  final Reader read;
  bool _mounted = false;

  HomeDomisNearWSProvider(this.read, List<Marker> state) : super(state);

  listenWS(int userId, VoidCallback onReconnect) {
    _subscription?.cancel();
    channel?.sink.close();
    channel = null;
    channel = WebSocketChannel.connect(
      Uri.parse(NetworkService.WS_URL + "ws/chat/user_$userId/"),
    );

    _subscription = channel!.stream.listen((message) {
      if (!_mounted) {
        try {
          final data = jsonDecode(message);
          print(data);
          if (data["action"] == null) {
            state.add(_createMarker(
                "${data["message"]["user"] ?? "me"}",
                LatLng(data["message"]["lat"], data["message"]["lng"]),
                data["message"]["giros"]));
          } else {
            if (data["action"] == "complete") {
              read(activeServicesProvider.notifier).removeService(data["data"]);
            }
            if (data["action"] == "canceled") {
              read(activeServicesProvider.notifier).getActiveServices();
            }
          }

          super.state = super.state;
        } catch (e) {
          print("error $e");
        }
      }
    }, onDone: () {
      reconnect(userId, onReconnect);
    }, onError: (e) {
      reconnect(userId, onReconnect);
    });
  }

  void reconnect(int userId, VoidCallback onReconnect) async {
    if (!_mounted) {
      print('Disconnected');
      if (channel != null) {
        channel?.sink.close();
        await Future.delayed(Duration(seconds: 4));
      }
      _subscription?.cancel();
      onReconnect();
      listenWS(userId, onReconnect);
    }
  }

  createMarkerImageFromAsset(BuildContext context) async {
    _markerIcon = BitmapDescriptor.fromBytes(await getBytesFromAsset(
        context, 'assets/icons/geo/icono-moto-indomi.png'));
  }

  Marker _createMarker(String id, LatLng latLng, giros) {
    if (_markerIcon != null) {
      return Marker(
          markerId: MarkerId(id),
          position: latLng,
          icon: _markerIcon!,
          rotation: giros + 70);
    } else {
      return Marker(markerId: MarkerId(id), position: latLng, rotation: giros);
    }
  }

  getNearDomis(double latitude, double longitude) async {
    try {
      final domis = await ServiceRepository.getNearDomis(latitude, longitude);
      state.addAll(domis
          .map((e) => _createMarker(e.user.toString(),
              LatLng(e.location.latitude!, e.location.longitude!), 0.0))
          .toList());
      state = state;
    } catch (e) {
      return Future.error(e);
    }
  }

  @override
  void dispose() {
    _mounted = true;
    _subscription?.cancel();
    channel?.sink.close();
    super.dispose();
  }
}
