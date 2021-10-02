import 'dart:async';

import 'package:domi/core/enum/service_enums.dart';
import 'package:domi/core/extensions/string.dart';
import 'package:domi/main.dart';
import 'package:domi/provider/domi/in_service_provider.dart';
import 'package:domi/provider/service/active_services_provider.dart';
import 'package:domi/re_use/button_register_login.dart';
import 'package:domi/re_use/theme.dart';
import 'package:domi/re_use/utils/dialogs.dart';
import 'package:domi/re_use/utils/domi_format.dart';
import 'package:domi/repositories/service_repository.dart';
import 'package:domi/screens/service/pages/service_completed_page.dart';
import 'package:domi/screens/service/pages/service_qualification.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher.dart';

class DeliveryStatus extends StatefulWidget {
  final int service;

  DeliveryStatus(this.service);

  @override
  _DeliveryStatusState createState() => _DeliveryStatusState();
}

class _DeliveryStatusState extends State<DeliveryStatus>
    with WidgetsBindingObserver {
  GoogleMapController? _mapController;

  ButtonRegisterController _buttonControllerCancel = ButtonRegisterController();
  ButtonRegisterController _buttonCancel = ButtonRegisterController();
  Timer? _timerServicesMessage;

  ValueNotifier<int> _messageIndex = ValueNotifier<int>(0);
  late final CameraPosition _kMapCenter;
  bool mounted = false;

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      if (_mapController != null) {
        setState(() {
          _mapController!.setMapStyle("[]");
        });
      }
    }
  }

  @override
  void initState() {
    context.read(inServiceProvider).service = null;
    final cityData = context.read(authProvider).userData!.user.person.city;
    _kMapCenter = CameraPosition(
        target: LatLng(cityData.latitude, cityData.longitude), zoom: 15);
    super.initState();
    WidgetsBinding.instance!.addObserver(this);
    Future.microtask(() async {
      await context
          .read(inServiceProvider.notifier)
          .createMarkerImageFromAsset(context);
      context
          .read(inServiceProvider.notifier)
          .getServiceDetail(widget.service)
          .then((value) async {
        if (context.read(inServiceProvider).service!.getServiceStatus ==
            ServiceStatus.active) {
          context.read(activeServicesProvider.notifier).setService(value!);
          context.read(inServiceProvider.notifier).listenDomi(widget.service);
        } else {
          context
              .read(activeServicesProvider.notifier)
              .removeService(widget.service);
        }
      });
    });
    _timerServicesMessage = Timer.periodic(Duration(seconds: 5), (timer) {
      if (!mounted) {
        _messageIndex.value = _messageIndex.value == 0 ? 1 : 0;
      }
    });
  }

  @override
  void dispose() {
    WidgetsBinding.instance!.removeObserver(this);
    mounted = true;
    _messageIndex.dispose();
    _timerServicesMessage?.cancel();
    _buttonCancel.dispose();
    _buttonControllerCancel.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final media = MediaQuery.of(context);
    return Scaffold(
      body: SafeArea(
        child: Consumer(
          builder: (context, watch, child) {
            final state = watch(inServiceProvider);

            if (state.service == null) {
              return Container(
                  child: Center(child: CircularProgressIndicator()));
            }

            if (state.service!.getServiceStatus != ServiceStatus.active) {
              return ServiceCompletedPage(state.service!.getServiceStatus);
            }

            if (state.serviceCompleted) {
              return ServiceQualification(state.service!);
            }
            final photo = state.service!.domi!.person.photo;
            centerMap(state.markers);
            return Container(
              child: Stack(
                
                alignment: Alignment.bottomCenter,
                children: [
                  GoogleMap(
                    mapType: MapType.normal,
                    initialCameraPosition: _kMapCenter,
                    markers: state.markers.toSet(),
                    onMapCreated: (GoogleMapController controller) {
                      _mapController = controller;
                      Future.delayed(Duration(seconds: 1), () {
                        centerMap(state.markers);
                      });
                    },
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 17),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Padding(
                          padding:
                              const EdgeInsets.only(left: 5, right: 5, top: 20),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              IconButton(
                                icon: Icon(
                                  Icons.arrow_back,
                                  color: inDomiBluePrimary,
                                  size: 35,
                                ),
                                onPressed: () {
                                  context
                                      .read(activeServicesProvider.notifier)
                                      .getActiveServices();
                                  Navigator.of(context).pop();
                                },
                              ),
                              Spacer(),
                              Padding(
                                padding: const EdgeInsets.only(right: 5),
                                child: Container(
                                  width: 88,
                                  height: 30,
                                  child: Image(
                                    image: AssetImage(
                                        "assets/icons/Grupo 8@3x.png"),
                                    height: 52,
                                    width: 52,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        ValueListenableBuilder(
                          valueListenable: _messageIndex,
                          builder: (context, value, child) {
                            return Padding(
                              padding: const EdgeInsets.only(
                                  left: 20, right: 20, top: 20),
                              child: Text(
                                value == 0
                                    ? state.service!.getPayMethod ==
                                            PayMethod.cash
                                        ? "Total a pagar ${state.service!.getTotalWithTax} en efectivo por el domicilio"
                                        : ""
                                    : watch(inServiceProvider)
                                        .getUserDomiStatus(),
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold,
                                    color: inDomiBluePrimary),
                              ),
                            );
                          },
                        )
                      ],
                    ),
                  ),
                  Positioned(
                    bottom: 20,
                    child: Stack(
                      children: [
                        Container(
                          width: media.size.width,
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 15, vertical: 15),
                            child: Container(
                              decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(6),
                                  boxShadow: [
                                    BoxShadow(
                                        color: Colors.black12, blurRadius: 3)
                                  ]),
                              child: Column(
                                children: [
                                  Container(
                                    width: double.maxFinite,
                                    height: 8,
                                    decoration: BoxDecoration(
                                        color: inDomiYellow,
                                        borderRadius: BorderRadius.only(
                                          bottomLeft: Radius.circular(4),
                                          bottomRight: Radius.circular(4),
                                        )),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(
                                        left: 15,
                                        right: 15,
                                        top: 10,
                                        bottom: 10),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Row(
                                          children: [
                                            CircleAvatar(
                                              radius: 23,
                                              backgroundImage: (photo != null
                                                      ? NetworkImage(
                                                          photo.replaceAll(
                                                              "https", "http"))
                                                      : AssetImage(
                                                          "assets/icons/im.png"))
                                                  as ImageProvider,
                                            ),
                                            SizedBox(
                                              width: 9,
                                            ),
                                            Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  state.service!.domi!.fullName,
                                                  style: TextStyle(
                                                      color: inDomiGreyBlack,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      fontSize: 14),
                                                ),
                                                Text(
                                                  "${state.service!.domi!.vehicleTypeString()} - ${state.service!.domi!.plate}",
                                                  style: TextStyle(
                                                      color: inDomiGreyBlack,
                                                      fontSize: 14),
                                                ),
                                              ],
                                            ),
                                            Spacer(),
                                            Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.end,
                                              children: [
                                                Text(
                                                  state.service!.getPayMethod ==
                                                          PayMethod.cash
                                                      ? "${state.service!.getTotalWithTax}"
                                                      : "\$0",
                                                  style: TextStyle(
                                                      color: inDomiButtonBlue,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      fontSize: 14),
                                                ),
                                                Text(
                                                  "${state.service!.domi!.person.domiCount} viajes",
                                                  style: TextStyle(
                                                      color: inDomiGreyBlack,
                                                      fontSize: 14),
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                        SizedBox(
                                          height: 7,
                                        ),
                                        Divider(
                                          color: Colors.black26,
                                        ),
                                        SizedBox(
                                          height: 7,
                                        ),
                                        ...state.service!.wayPoints.map((e) {
                                          return Padding(
                                            padding: const EdgeInsets.only(
                                                bottom: 7),
                                            child: Row(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.center,
                                              children: [
                                                Image.asset(
                                                  "assets/icons/maps-and-flags@3x.png",
                                                  height: 20,
                                                  width: 20,
                                                ),
                                                SizedBox(
                                                  width: 4,
                                                ),
                                                Flexible(
                                                  child: Text(
                                                    e.address,
                                                    style: TextStyle(
                                                        color: inDomiGreyBlack,
                                                        fontSize: 14,
                                                        decoration: e.check
                                                            ? TextDecoration
                                                                .lineThrough
                                                            : null),
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          );
                                        }).toList(),
                                        SizedBox(
                                          height: 16,
                                        ),
                                        Row(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Expanded(
                                              child: Container(
                                                height: 36,
                                                width: 100,
                                                child: ElevatedButton(
                                                    onPressed: () {
                                                      final Uri _whatsAppUri = Uri(
                                                          scheme: 'https',
                                                          path:
                                                              'wa.me/${state.service!.domi!.username}',
                                                          queryParameters: {
                                                            "text": "Hola"
                                                          });

                                                      launch(_whatsAppUri
                                                          .toString());
                                                    },
                                                    style: ElevatedButton
                                                        .styleFrom(
                                                            elevation: 0,
                                                            shape:
                                                                RoundedRectangleBorder(
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          19),
                                                              side: BorderSide(
                                                                  color:
                                                                      inDomiButtonBlue),
                                                            ),
                                                            primary:
                                                                Colors.white),
                                                    child: Text(
                                                      "Chatear",
                                                      style: TextStyle(
                                                          color:
                                                              inDomiButtonBlue,
                                                          fontSize: 14),
                                                    )),
                                              ),
                                            ),
                                            Expanded(
                                              child: Padding(
                                                padding: const EdgeInsets.only(
                                                    left: 10),
                                                child: ButtonRegisterLogin(
                                                  height: 36,
                                                  width: 100,
                                                  color: inDomiBluePrimary,
                                                  text: Text(
                                                    "Llamar",
                                                    style: TextStyle(
                                                        color: Colors.white,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        fontSize: 14),
                                                  ),
                                                  voidCallback: () {
                                                    try {
                                                      final Uri _phoneUri = Uri(
                                                        scheme: 'tel',
                                                        path:
                                                            "+${state.service!.domi!.username}",
                                                      );

                                                      launch(
                                                          _phoneUri.toString());
                                                    } catch (e) {
                                                      showError(context, e);
                                                    }
                                                  },
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(
                                        bottom: 10, left: 15, right: 15),
                                    child: ButtonRegisterLogin(
                                        height: 36,
                                        width: media.size.width,
                                        radius: 20,
                                        color: inDomiButtonBlue,
                                        text: Text(
                                          "Cancelar servicio",
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontWeight: FontWeight.bold,
                                              fontSize: 14),
                                        ),
                                        controller: _buttonCancel,
                                        voidCallback: () {
                                          showContainer(context, () {
                                            _cancelInService(state.service!.id);
                                          }, _buttonControllerCancel);
                                        }),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        Positioned(
                          right: 0,
                          top: 0,
                          child: FractionalTranslation(
                            translation: Offset(-0.5, -0.35),
                            child: Container(
                              alignment: Alignment.center,
                              height: 44,
                              width: 44,
                              decoration: BoxDecoration(
                                color: Colors.white,
                                boxShadow: [
                                  BoxShadow(
                                      color: Colors.black12, blurRadius: 3)
                                ],
                                borderRadius: BorderRadius.circular(40),
                              ),
                              child: IconButton(
                                onPressed: () async {
                                  try {
                                    final shareLink =
                                        await ServiceRepository.createShareCode(
                                            widget.service);
                                    Share.share(
                                        "Puedes seguir tu domi en $shareLink");
                                  } catch (e) {
                                    showError(context, e);
                                  }
                                },
                                icon: Icon(
                                  Icons.share,
                                  color: inDomiBluePrimary,
                                  size: 26,
                                ),
                              ),
                            ),
                          ),
                        )
                      ],
                    ),
                  )
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  LatLngBounds boundsFromLatLngList(List<LatLng> list) {
    assert(list.isNotEmpty);
    double? x0, x1, y0, y1;
    for (LatLng latLng in list) {
      if (x0 == null) {
        x0 = x1 = latLng.latitude;
        y0 = y1 = latLng.longitude;
      } else {
        if (latLng.latitude > x1!) x1 = latLng.latitude;
        if (latLng.latitude < x0) x0 = latLng.latitude;
        if (latLng.longitude > y1!) y1 = latLng.longitude;
        if (latLng.longitude < y0!) y0 = latLng.longitude;
      }
    }
    return LatLngBounds(
        northeast: LatLng(x1!, y1!), southwest: LatLng(x0!, y0!));
  }

  Future<void> centerMap(List<Marker> points) async {
    final pointList = points.map((e) => e.position).toList();
    if (_mapController != null) {
      _mapController!.animateCamera(
          CameraUpdate.newLatLngBounds(boundsFromLatLngList(pointList), 100));
    }
  }

  Future<void> _cancelInService(int id) async {
    try {
      await ServiceRepository.cancelInService(id);
      context.read(activeServicesProvider.notifier).getActiveServices();
      Navigator.of(context).pop();
    } catch (e) {
      showError(context, e);
    }
  }
}
