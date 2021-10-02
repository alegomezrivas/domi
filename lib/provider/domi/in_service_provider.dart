import 'dart:async';
import 'dart:convert';

import 'package:domi/core/classes/geo.dart';
import 'package:domi/core/classes/paginated.dart';
import 'package:domi/core/enum/service_enums.dart';
import 'package:domi/core/network/network.dart';
import 'package:domi/models/service/service.dart';
import 'package:domi/repositories/domi_repository.dart';
import 'package:domi/repositories/service_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

final inServiceProvider =
    StateNotifierProvider<InServiceProvider, InServiceState>(
        (ref) => InServiceProvider(InServiceState()));

class InServiceProvider extends APIProvider<InServiceState> {
  final ServiceRepository repository = ServiceRepository();
  WebSocketChannel? channel;
  StreamSubscription? _subscription;
  BitmapDescriptor? _bitmapDescriptorDomi;
  BitmapDescriptor? _bitmapDescriptorMarker;

  InServiceProvider(InServiceState state) : super(state);

  void listenDomi(int serviceId) {
    _subscription?.cancel();
    channel?.sink.close();
    channel = null;
    channel = WebSocketChannel.connect(
      Uri.parse(NetworkService.WS_URL + "ws/chat/service_$serviceId/"),
    );

    _subscription = channel!.stream.listen((message) {
      try {
        final jsonMessage = jsonDecode(message);
        if (jsonMessage["message"] != null) {
          updateDomiPosition(
              LatLng(
                  jsonMessage["message"]["lat"], jsonMessage["message"]["lng"]),
              giros: jsonMessage["message"]["giros"]);
        }

        if (jsonMessage["action"] == "way_points") {
          if (super.state.service != null) {
            if (state.service!.wayPoints
                    .indexWhere((element) => element.check && element.inWay) >
                -1) {
              state.service!.wayPoints
                  .where((element) => element.check && element.inWay)
                  .forEach((element) {
                element.mark = true;
              });
            }
            updateStatus();
          }
        }

        print(jsonMessage);
        if (jsonMessage["action"] == "canceled") {
          if (super.state.service != null) {
            print(jsonMessage["data"]);
            if (jsonMessage["data"] == super.state.service!.id) {
              super.state.service!.serviceStatus =
                  ServiceStatus.canceled.index + 1;
            }
          }
        }

        if (jsonMessage["action"] == "complete" &&
            jsonMessage["data"] == serviceId) {
          super.state.serviceCompleted = true;
        }

        super.state = super.state;
      } catch (e) {
        print("error $e");
      }
    }, onDone: () {
      reconnectDomi(serviceId);
    }, onError: (e) {
      print("print a errrorr $e");
      reconnectDomi(serviceId);
    });
  }

  createMarkerImageFromAsset(BuildContext context) async {
    _bitmapDescriptorDomi = BitmapDescriptor.fromBytes(await getBytesFromAsset(
        context, 'assets/icons/geo/icono-moto-indomi.png'));
    _bitmapDescriptorMarker = BitmapDescriptor.fromBytes(
        await getBytesFromAsset(
            context, 'assets/icons/geo/icono-ubicador.png'));
  }

  void listenUser(int userId) {
    _subscription?.cancel();
    channel?.sink.close();
    channel = null;
    channel = WebSocketChannel.connect(
      Uri.parse(NetworkService.WS_URL + "ws/domi/user_$userId/"),
    );
    _subscription = channel!.stream.listen((message) {
      try {
        final jsonMessage = jsonDecode(message);
        if (jsonMessage["action"] == "canceled") {
          if (super.state.service != null) {
            if (jsonMessage["data"] == super.state.service!.id) {
              super.state.service!.serviceStatus =
                  ServiceStatus.canceled.index + 1;
              super.state = super.state;
            }
          }
        }
      } catch (e) {
        print(e);
      }
    }, onDone: () {
      reconnectUser(userId);
    }, onError: (e) {
      print("print a errrorr $e");
      reconnectUser(userId);
    });
  }

  void reconnectDomi(int serviceId) async {
    if (!mounted) {
      print('Disconnected');
      if (channel != null) {
        channel?.sink.close();
        await Future.delayed(Duration(seconds: 4));
      }
      _subscription?.cancel();
      listenDomi(serviceId);
    }
  }

  void reconnectUser(int userId) async {
    if (!mounted) {
      print('Disconnected');
      if (channel != null) {
        channel?.sink.close();
        await Future.delayed(Duration(seconds: 4));
      }
      _subscription?.cancel();
      listenUser(userId);
    }
  }

  Future<Service?> getServiceDetail(int serviceId) async {
    try {
      super.toggleLoading();
      state.service = await repository.getServiceDetail(serviceId);
      state.markers = state.service!.wayPoints
          .map((e) => Marker(
              markerId: MarkerId(e.address),
              icon: _bitmapDescriptorMarker != null
                  ? _bitmapDescriptorMarker!
                  : BitmapDescriptor.defaultMarker,
              position: LatLng(e.location!.latitude!, e.location!.longitude!)))
          .toList();
    } catch (e) {
      return Future.error(e);
    } finally {
      super.toggleLoading();
    }
    return state.service;
  }

  Future<dynamic> nextStatus() async {
    try {
      final response = await DomiRepository.nextStatus();
      updateStatus();
      state = state;
      return response;
    } catch (e) {
      return Future.error(e);
    }
  }

  void updateStatus() {
    try {
      final WayPoint? wayPoint = state.service!.wayPoints
          .firstWhere((element) => !element.check, orElse: null);
      if (wayPoint != null) {
        if (wayPoint.inWay) {
          wayPoint.check = true;
        } else {
          wayPoint.inWay = true;
        }
      } else {
        print("Termino");
      }
    } catch (e) {}
  }

  void updateDomiPosition(LatLng position, {double giros = 0.0}) {
    state.markers.removeWhere((element) => element.markerId == MarkerId("ME"));
    state.markers.add(Marker(
        markerId: MarkerId("ME"),
        position: position,
        rotation: giros,
        icon: _bitmapDescriptorDomi != null
            ? _bitmapDescriptorDomi!
            : BitmapDescriptor.defaultMarker));
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

class InServiceState {
  Service? service;
  List<Marker> markers = [];
  bool serviceCompleted = false;

  getServiceWayPointStatus() {
    try {
      final WayPoint wayPoint =
          service!.wayPoints.firstWhere((element) => !element.check);
      String order = "";
      switch (wayPoint.order) {
        case 1:
          order = "Primera";
          break;
        case 2:
          order = "Segunda";
          break;
        case 3:
          order = "Tercera";
          break;
        case 4:
          order = "Cuarta";
          break;
      }
      if (wayPoint.order == service!.wayPoints.length) {
        order = "Última";
      }

      if (wayPoint.inWay) {
        return "Llegue a la $order dirección";
      } else {
        return "En camino a la $order dirección";
      }
    } catch (e) {
      return "Finalizar";
    }
  }

  getUserDomiStatus() {
    try {
      final WayPoint wayPoint =
          service!.wayPoints.firstWhere((element) => !element.mark);
      String order = "";
      switch (wayPoint.order) {
        case 1:
          order = "Primera";
          break;
        case 2:
          order = "Segunda";
          break;
        case 3:
          order = "Tercera";
          break;
        case 4:
          order = "Cuarta";
          break;
      }
      if (wayPoint.order == service!.wayPoints.length) {
        order = "Última";
      }

      if (wayPoint.inWay && !wayPoint.check) {
        return "El domi va camino a la $order dirección";
      } else {
        if (!wayPoint.inWay && !wayPoint.check && wayPoint.order == 1) {
          return "El domi ha aceptado tu solicitud llegara en 5 min";
        } else {
          return "El domi llego a la $order dirección";
        }
      }
    } catch (e) {
      return "Tu pedido ha finalizado";
    }
  }
}
