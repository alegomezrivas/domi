import 'dart:async';
import 'dart:convert';

import 'package:domi/core/enum/service_enums.dart';
import 'package:domi/core/extensions/string.dart';
import 'package:domi/core/network/network.dart';
import 'package:domi/main.dart';
import 'package:domi/models/service/service.dart';
import 'package:domi/re_use/theme.dart';
import 'package:domi/re_use/utils/dialogs.dart';
import 'package:domi/re_use/utils/domi_format.dart';
import 'package:domi/repositories/domi_repository.dart';
import 'package:domi/screens/domi_home/service/in_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

class ServiceDescriptionPage extends StatefulWidget {
  final Service service;

  ServiceDescriptionPage(this.service);

  @override
  _ServiceDescriptionPageState createState() => _ServiceDescriptionPageState();
}

class _ServiceDescriptionPageState extends State<ServiceDescriptionPage> {
  Completer<GoogleMapController> _controller = Completer();

  CameraPosition _center = CameraPosition(
    target: LatLng(37.42796133580664, -122.085749655962),
    zoom: 14.4746,
  );

  Timer? _timer;
  ValueNotifier<double> _timerNotifier = ValueNotifier<double>(0);
  ValueNotifier<double> _increment = ValueNotifier<double>(0);
  bool _sendOffer = false;
  int _counter = 0;
  bool mounted = false;
  List<Marker> _markers = [];
  WebSocketChannel? channel;
  int _seconds = 0;

  int userId = 0;

  @override
  void initState() {
    userId = context.read(authProvider).userData!.user.id;
    _markers = widget.service.wayPoints.map((e) {
      print(e.toJson());
      return Marker(
          markerId: MarkerId(e.address),
          position:
              LatLng(e.location!.latitude ?? 0, e.location!.longitude ?? 0));
    }).toList();
    _center = CameraPosition(
      target: LatLng(widget.service.wayPoints.first.location!.latitude ?? 0,
          widget.service.wayPoints.first.location!.longitude ?? 0),
      zoom: 14,
    );
    if (widget.service.getServiceStatus == ServiceStatus.pending &&
        widget.service.user!.id !=
            context.read(authProvider).userData!.user.id) {
      _seconds = DomiFormat.formatDateTZ(widget.service.createdAt)
          .add(Duration(seconds: 300))
          .difference(DateTime.now())
          .inSeconds;
    }
    if (_seconds > 0) {
      _timer = Timer.periodic(Duration(seconds: 1), (timer) {
        _counter++;
        if (!mounted) {
          _timerNotifier.value = 1 - (_counter / _seconds);
        }
        if (_counter >= _seconds - 1) {
          _timerNotifier.value = 0;
          _timer?.cancel();
        }
      });
    }
    super.initState();
  }

  @override
  void dispose() {
    mounted = true;
    _timer?.cancel();
    _timerNotifier.dispose();
    channel?.sink.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final user = userId == widget.service.user!.id
        ? widget.service.domi!
        : widget.service.user!;
    final photo = user.person.photo;
    return Scaffold(
      backgroundColor: inDomiScaffoldGrey,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 17),
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 10),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      IconButton(
                        icon: Icon(
                          Icons.arrow_back,
                          color: inDomiBluePrimary,
                          size: 30,
                        ),
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                      ),
                      Spacer(),
                      Padding(
                        padding: const EdgeInsets.only(right: 12),
                        child: Container(
                          width: 88,
                          height: 30,
                          child: Image(
                            image: AssetImage("assets/icons/Grupo 8@3x.png"),
                            height: 52,
                            width: 52,
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                if (_seconds > 0)
                  ValueListenableBuilder<double>(
                      valueListenable: _timerNotifier,
                      builder: (context, value, child) {
                        return Container(
                          width: double.maxFinite,
                          height: 44,
                          child: ElevatedButton(
                            onPressed: value > 0 ? _takeService : null,
                            child: Container(
                              height: 44,
                              width: double.maxFinite,
                              child: Stack(
                                alignment: Alignment.centerLeft,
                                children: [
                                  Text(
                                    _sendOffer
                                        ? "Esperando al usuario"
                                        : "Tomar servicio",
                                    style: TextStyle(
                                        color: inDomiBluePrimary,
                                        fontSize: 15,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  Positioned(
                                      right: 0,
                                      child: Stack(
                                        alignment: Alignment.center,
                                        children: [
                                          Icon(
                                            Icons.keyboard_arrow_right,
                                            color: inDomiBluePrimary,
                                            size: 28,
                                          ),
                                          CircularProgressIndicator(
                                            strokeWidth: 2,
                                            value: value,
                                            backgroundColor: inDomiBluePrimary
                                                .withAlpha(100),
                                          )
                                        ],
                                      ))
                                ],
                              ),
                            ),
                            style: ElevatedButton.styleFrom(
                              elevation: 0,
                              primary: inDomiYellow,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(9)),
                            ),
                          ),
                        );
                      }),
                SizedBox(
                  height: 20,
                ),
                Container(
                  width: double.maxFinite,
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(9),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black12,
                          blurRadius: 7,
                        ),
                      ]),
                  child: Column(
                    children: [
                      Container(
                        width: double.maxFinite,
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                            color: inDomiScaffoldGrey,
                            border: Border(
                                top: BorderSide(
                                    width: 0.4, color: Colors.black12))),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 15, vertical: 5),
                          child: Row(
                            children: [
                              Text(
                                "Valor",
                                style: TextStyle(
                                    color: inDomiBluePrimary,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 15),
                              ),
                              Spacer(),
                              Text(
                                "${DomiFormat.formatCurrencyCustom(widget.service.offer.toDouble())}",
                                style: TextStyle(
                                    color: inDomiBluePrimary,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 15),
                              ),
                            ],
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(
                            top: 14, left: 14, bottom: 20, right: 14),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                CircleAvatar(
                                  radius: 23,
                                  backgroundImage: (photo != null
                                          ? NetworkImage(photo)
                                          : AssetImage("assets/icons/im.png"))
                                      as ImageProvider,
                                ),
                                SizedBox(
                                  width: 9,
                                ),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      user.firstName,
                                      style: TextStyle(
                                          color: inDomiGreyBlack,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 14),
                                    ),
                                    Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Icon(
                                          Icons.star,
                                          color: inDomiButtonBlue,
                                          size: 15,
                                        ),
                                        Text(
                                          "${DomiFormat.formatCompat(user.person.stars / user.person.reviews)}",
                                          style: TextStyle(
                                              color: inDomiGreyBlack,
                                              fontSize: 12),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                                Spacer(),
                                Text(
                                  getServiceDescription(
                                      widget.service.serviceType),
                                  style: TextStyle(
                                      color: inDomiButtonBlue,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 14),
                                ),
                              ],
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            Container(
                              height: 210,
                              width: double.maxFinite,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(19),
                              ),
                              child: GoogleMap(
                                mapType: MapType.normal,
                                initialCameraPosition: _center,
                                onMapCreated: (GoogleMapController controller) {
                                  _controller.complete(controller);
                                },
                                markers: _markers.toSet(),
                              ),
                            ),
                            SizedBox(
                              height: 5,
                            ),
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Text(
                                  "${DomiFormat.formatCompat(widget.service.distance)} km",
                                  style: TextStyle(
                                      color: inDomiBluePrimary,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 12),
                                ),
                                Spacer(),
                                Text(
                                  "ID: ${widget.service.id}",
                                  style: TextStyle(
                                      color: inDomiGreyBlack, fontSize: 13),
                                ),
                              ],
                            ),
                            SizedBox(
                              height: 5,
                            ),
                            ...widget.service.wayPoints
                                .map(
                                  (e) => Padding(
                                    padding: const EdgeInsets.only(bottom: 7),
                                    child: Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      children: [
                                        Image.asset(
                                          "assets/icons/maps-and-flags@3x.png",
                                          height: 13,
                                          width: 13,
                                        ),
                                        SizedBox(
                                          width: 4,
                                        ),
                                        Flexible(
                                          child: Text(
                                            e.address,
                                            style: TextStyle(
                                                color: inDomiGreyBlack,
                                                fontSize: 13),
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                )
                                .toList(),
                            SizedBox(
                              height: 10,
                            ),
                            Text(
                              "Medio de pago",
                              style: TextStyle(
                                  color: inDomiBluePrimary, fontSize: 13),
                            ),
                            SizedBox(
                              height: 4,
                            ),
                            getPayMethodIcon(widget.service.payMethod),
                            if (widget.service.getServiceType ==
                                ServiceType.pack)
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  SizedBox(
                                    height: 10,
                                  ),
                                  Text(
                                    "Tamaño del paquete",
                                    style: TextStyle(
                                        color: inDomiBluePrimary, fontSize: 13),
                                  ),
                                  Text(
                                    "${widget.service.package!.name} (${widget.service.package!.description})",
                                    style: TextStyle(
                                      color: inDomiGreyBlack,
                                      fontSize: 12,
                                    ),
                                  ),
                                  SizedBox(
                                    height: 10,
                                  ),
                                  Text(
                                    "Peso del paquete",
                                    style: TextStyle(
                                        color: inDomiBluePrimary, fontSize: 13),
                                  ),
                                  Text(
                                    weightPack(),
                                    style: TextStyle(
                                      color: inDomiGreyBlack,
                                      fontSize: 12,
                                    ),
                                  ),
                                ],
                              ),
                            Text(
                              "Debe cancelar: ${getCancelInPlaceDescription(widget.service.cancelInPlace.toDouble())}",
                              style: TextStyle(
                                  color: inDomiGreyBlack, fontSize: 12),
                            ),
                            SizedBox(height: 15),
                            Text(
                              "Total del cobro por domicilio:",
                              style: TextStyle(
                                  color: inDomiBluePrimary, fontSize: 13),
                            ),
                            Text(
                              widget.service.getPayMethod == PayMethod.cash ||
                                      widget.service.getServiceStatus !=
                                          ServiceStatus.pending
                                  ? widget.service.getTotalWithTax
                                  : DomiFormat.formatCurrencyCustom(0),
                              style: TextStyle(
                                  color: inDomiBluePrimary,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 14),
                            ),
                            if (widget.service.getPayMethod == PayMethod.cash ||
                                widget.service.getServiceStatus !=
                                    ServiceStatus.pending)
                              Text(
                                widget.service.getTotalDescription,
                                style: TextStyle(
                                    color: inDomiBluePrimary, fontSize: 12),
                              ),
                            SizedBox(
                              height: 10,
                            ),
                            if (_seconds > 0)
                              ValueListenableBuilder<double>(
                                  valueListenable: _increment,
                                  builder: (context, value, child) {
                                    return Container(
                                      height: 40,
                                      child: ListView(
                                        scrollDirection: Axis.horizontal,
                                        children: List.generate(10, (index) {
                                          final counteroffer = index == 0
                                              ? context
                                                  .read(authProvider)
                                                  .userData!
                                                  .params
                                                  .serviceIncDec
                                              : context
                                                      .read(authProvider)
                                                      .userData!
                                                      .params
                                                      .serviceIncDec *
                                                  2 *
                                                  index;
                                          return Padding(
                                            padding:
                                                const EdgeInsets.only(right: 4),
                                            child: Container(
                                              child: ElevatedButton(
                                                onPressed: () {
                                                  if (counteroffer !=
                                                      _increment.value) {
                                                    _increment.value =
                                                        counteroffer;
                                                  } else {
                                                    _increment.value = 0;
                                                  }
                                                },
                                                child: Text(
                                                  "+ ${DomiFormat.formatCurrencyCustom(counteroffer)}",
                                                  style: TextStyle(
                                                      color: value ==
                                                              counteroffer
                                                          ? inDomiYellow
                                                          : inDomiBluePrimary,
                                                      fontSize: 14,
                                                      fontWeight:
                                                          FontWeight.bold),
                                                ),
                                                style: ElevatedButton.styleFrom(
                                                    elevation: 0,
                                                    primary: value ==
                                                            counteroffer
                                                        ? inDomiBluePrimary
                                                        : inDomiScaffoldGrey,
                                                    side: BorderSide(
                                                        color:
                                                            inDomiBluePrimary,
                                                        width: 1)),
                                              ),
                                            ),
                                          );
                                        }),
                                      ),
                                    );
                                  }),
                            SizedBox(
                              height: 10,
                            ),
                            Text(
                              "Instrucciones adicionales",
                              style: TextStyle(
                                  color: inDomiBluePrimary, fontSize: 13),
                            ),
                            SizedBox(
                              height: 5,
                            ),
                            Text(
                              widget.service.observation == ""
                                  ? "Usuario no ha colocado una descripción."
                                  : widget.service.observation,
                              style: TextStyle(
                                  color: inDomiGreyBlack, fontSize: 13),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  _takeService() async {
    if (_sendOffer) {
      return;
    }
    _sendOffer = true;
    // var status = await ph.Permission.locationAlways.status;
    // if (status.isDenied) {
    //   if (!await ph.Permission.locationAlways.request().isGranted) {
    //     locationDeniedMessage(context, () async {});
    //     _sendOffer = false;
    //     return;
    //   }
    // }

    try {
      final response =
          await DomiRepository.takeService(widget.service.id, _increment.value);
      _waitForResponseWS(response.id);
      print(response);
    } catch (e) {
      showError(context, e, noFound: "La oferta ha expirado");
    }
  }

  _waitForResponseWS(int offerId) async {
    channel = WebSocketChannel.connect(
      Uri.parse(NetworkService.WS_URL + "ws/chat/offers_${widget.service.id}/"),
    );

    channel!.stream.listen((message) {
      try {
        print(message);
        print(offerId);
        final jsonMessage = jsonDecode(message);
        if (jsonMessage["action"] == "remove_offer") {
          if (jsonMessage["data"]["id"] == offerId.toString()) {
            ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text("El usuario ha rechazado su oferta")));
            _timerNotifier.value = 0;
            _timer?.cancel();
          }
        }

        if (jsonMessage["action"] == "accept_offer") {
          if (jsonMessage["data"]["id"] == offerId) {
            Navigator.of(context).pushReplacement(MaterialPageRoute(
                builder: (context) => InService(widget.service.id)));
          } else {
            Navigator.of(context).pop();
          }
        }

        if (jsonMessage["action"] == "cancel_service") {
          ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text("El usuario ha cancelado el servicio.")));
          _timerNotifier.value = 0;
          _timer?.cancel();
        }
      } catch (e) {
        showError(context, e);
      }
    }, onDone: () {
      _reconnect(offerId);
    }, onError: (e) {
      _reconnect(offerId);
    });
  }

  _reconnect(int offerId) async {
    if (!mounted) {
      print('Disconnected');
      if (channel != null) {
        channel?.sink.close();
        await Future.delayed(Duration(seconds: 4));
      }
      channel = null;
      _waitForResponseWS(offerId);
    }
  }

  String weightPack() {
    if (widget.service.weight == 1) {
      return "Menos de 1 Kg";
    }
    if (widget.service.weight == 2) {
      return "Entre 1 y 5 kgs";
    }
    if (widget.service.weight == 3) {
      return "Entre 5 y 10 kgs";
    }
    if (widget.service.weight == 4) {
      return "Superior a 10 Kgs";
    }
    return "";
  }
}
