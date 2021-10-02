import 'dart:async';
import 'dart:convert';

import 'package:domi/core/enum/service_enums.dart';
import 'package:domi/main.dart';
import 'package:domi/models/service/service.dart';
import 'package:domi/provider/domi/in_service_provider.dart';
import 'package:domi/provider/service/active_services_provider.dart';
import 'package:domi/re_use/button_register_login.dart';
import 'package:domi/re_use/theme.dart';
import 'package:domi/re_use/utils/dialogs.dart';
import 'package:domi/repositories/service_repository.dart';
import 'package:domi/screens/home/configuration_drawer/domi_drawer.dart';
import 'package:domi/screens/service/pages/service_completed_page.dart';
import 'package:domi/screens/service/pages/service_qualification.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:url_launcher/url_launcher.dart';

class InService extends StatefulWidget {
  final int service;

  InService(this.service);

  @override
  _InServiceState createState() => _InServiceState();
}

class _InServiceState extends State<InService> with WidgetsBindingObserver {
  GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  GoogleMapController? _mapController;

  late final CameraPosition _kMapCenter;

  ButtonRegisterController _buttonController = ButtonRegisterController();
  ButtonRegisterController buttonControllerCancel = ButtonRegisterController();
  ButtonRegisterController buttonCancel = ButtonRegisterController();

  Location location = new Location();
  StreamSubscription<LocationData>? _locationSubscription;
  Timer _debounce = Timer(Duration(seconds: 0), () {});
  bool mounted = false;
  Timer? _timerServicesMessage;
  ValueNotifier<int> _messageIndex = ValueNotifier<int>(0);

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
      final service = await context
          .read(inServiceProvider.notifier)
          .getServiceDetail(widget.service);
      if (service != null) {
        context.read(activeServicesProvider.notifier).setDomiActiveService(
            service.getServiceStatus == ServiceStatus.active ? service.id : 0);
      }
      // context.read(inServiceProvider.notifier).listenUser(widget.service);
    });
    initLocation();
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
    buttonControllerCancel.dispose();
    _buttonController.dispose();
    _locationSubscription?.cancel();
    _debounce.cancel();
    _messageIndex.dispose();
    _timerServicesMessage?.cancel();
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

            final photo = state.service!.user!.person.photo;
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
                                          ? "Cobrar ${state.service!.getTotalWithTax} en efectivo para el domicilio"
                                          : ""
                                      : state.service?.observation ?? "",
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.bold,
                                      color: inDomiBluePrimary),
                                ),
                              );
                            }),
                      ],
                    ),
                  ),
                  Positioned(
                    bottom: 20,
                    child: Container(
                      width: media.size.width,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 15, vertical: 15),
                        child: Container(
                          decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(6),
                              boxShadow: [
                                BoxShadow(color: Colors.black12, blurRadius: 3)
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
                                    left: 15, right: 15, top: 10, bottom: 10),
                                child: Column(
                                  children: [
                                    Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
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
                                              state.service!.user!.firstName,
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
                                                  state.service!.user!.getStars,
                                                  style: TextStyle(
                                                      color: inDomiGreyBlack,
                                                      fontSize: 12),
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                        Spacer(),
                                        Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.end,
                                          children: [
                                            Text(
                                              getServiceDescription(
                                                  state.service!.serviceType),
                                              style: TextStyle(
                                                  color: inDomiButtonBlue,
                                                  fontWeight: FontWeight.bold,
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
                                        padding:
                                            const EdgeInsets.only(bottom: 7),
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
                                                overflow: TextOverflow.ellipsis,
                                              ),
                                            ),
                                          ],
                                        ),
                                      );
                                    }).toList(),
                                    SizedBox(
                                      height: 10,
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
                                                          'wa.me/${state.service!.user!.username}',
                                                      queryParameters: {
                                                        "text": "Hola"
                                                      });

                                                  launch(
                                                      _whatsAppUri.toString());
                                                },
                                                style: ElevatedButton.styleFrom(
                                                    elevation: 0,
                                                    shape:
                                                        RoundedRectangleBorder(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              19),
                                                      side: BorderSide(
                                                          color:
                                                              inDomiButtonBlue),
                                                    ),
                                                    primary: Colors.white),
                                                child: Text(
                                                  "Chatear",
                                                  style: TextStyle(
                                                      color: inDomiButtonBlue,
                                                      fontSize: 14),
                                                )),
                                          ),
                                        ),
                                        Expanded(
                                          child: Padding(
                                            padding:
                                                const EdgeInsets.only(left: 10),
                                            child: ButtonRegisterLogin(
                                              height: 36,
                                              width: 100,
                                              color: inDomiBluePrimary,
                                              text: Text(
                                                "Llamar",
                                                style: TextStyle(
                                                    color: Colors.white,
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 14),
                                              ),
                                              voidCallback: () {
                                                try {
                                                  final Uri _phoneUri = Uri(
                                                    scheme: 'tel',
                                                    path:
                                                        "+${state.service!.user!.username}",
                                                  );

                                                  launch(_phoneUri.toString());
                                                } catch (e) {
                                                  showError(context, e);
                                                }
                                              },
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                    SizedBox(
                                      height: 10,
                                    ),
                                    ButtonRegisterLogin(
                                      height: 36,
                                      width: double.maxFinite,
                                      color: inDomiBluePrimary,
                                      text: Text(
                                        state.getServiceWayPointStatus(),
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold,
                                            fontSize: 14),
                                      ),
                                      controller: _buttonController,
                                      voidCallback: () => _nextStatus(context
                                          .read(inServiceProvider)
                                          .service!),
                                    ),
                                    SizedBox(
                                      height: 10,
                                    ),
                                    ButtonRegisterLogin(
                                        height: 36,
                                        width: double.maxFinite,
                                        radius: 19,
                                        color: inDomiButtonBlue,
                                        text: Text(
                                          "Cancelar servicio",
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontWeight: FontWeight.bold,
                                              fontSize: 14),
                                        ),
                                        controller: buttonCancel,
                                        voidCallback: () {
                                          showContainer(context, () async {
                                            _cancelInService(state.service!.id);
                                          }, buttonControllerCancel);
                                        }),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  _nextStatus(Service service) async {
    try {
      _buttonController.toggle();
      final response =
          await context.read(inServiceProvider.notifier).nextStatus();
      if (response["completed"] != null) {
        context.read(activeServicesProvider.notifier).setDomiActiveService(0);
        Navigator.of(context).pushReplacement(MaterialPageRoute(
            builder: (context) =>
                ServiceQualification(service, domiType: DomiType.domi)));
      }
    } catch (e) {
      showError(context, e);
    } finally {
      _buttonController.toggle();
    }
  }

  initLocation() async {
    bool _serviceEnabled;
    PermissionStatus _permissionGranted;
    LocationData _locationData;

    _serviceEnabled = await location.serviceEnabled();
    if (!_serviceEnabled) {
      _serviceEnabled = await location.requestService();
      if (!_serviceEnabled) {
        return;
      }
    }

    _permissionGranted = await location.hasPermission();
    if (_permissionGranted == PermissionStatus.denied) {
      _permissionGranted = await location.requestPermission();
      if (_permissionGranted != PermissionStatus.granted) {
        return;
      }
    }

    _locationData = await location.getLocation();
    // bool res = await location.isBackgroundModeEnabled();
    // if (!res) {
    //   try {
    //     bool result2 = await location.enableBackgroundMode(enable: true);
    //   } catch (e) {
    //     Future.delayed(Duration(seconds: 15), () {
    //       location
    //           .enableBackgroundMode(enable: true)
    //           .catchError((onError) => print(onError));
    //     });
    //   }
    // }
    // await location.changeSettings(
    //     accuracy: LocationAccuracy.high, interval: 10000, distanceFilter: 0);
    //
    // _locationSubscription = location.onLocationChanged
    //     .distinct()
    //     .listen((LocationData currentLocation) {
    //   if (!mounted) {
    //     context.read(inServiceProvider.notifier).updateDomiPosition(
    //         LatLng(currentLocation.latitude!, currentLocation.longitude!),
    //         giros: currentLocation.heading ?? 0);
    //
    //     if (!_debounce.isActive) {
    //       _debounce = Timer(Duration(seconds: 10), () {
    //         if (!mounted) {
    //           context
    //               .read(inServiceProvider.notifier)
    //               .channel
    //               ?.sink
    //               .add(jsonEncode({
    //                 "message": {
    //                   "lat": currentLocation.latitude,
    //                   "lng": currentLocation.longitude,
    //                   "giros": currentLocation.heading
    //                 }
    //               }));
    //         }
    //       });
    //     }
    //   }
    // });

    print(_locationData);
    try {
      if (!mounted) {
        context.read(inServiceProvider.notifier).channel?.sink.add(jsonEncode({
              "message": {
                "lat": _locationData.latitude,
                "lng": _locationData.longitude,
                "giros": _locationData.heading,
                "user": context.read(authProvider).userData!.user.id
              }
            }));
      }
    } catch (e) {}

    if (_mapController != null) {
      _mapController!.animateCamera(CameraUpdate.newCameraPosition(
          CameraPosition(
              target: LatLng(_locationData.latitude!, _locationData.longitude!),
              zoom: 15)));
    }
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
      Navigator.of(context).pop();
      context.read(activeServicesProvider.notifier).setDomiActiveService(0);
      Navigator.of(context).pop();
    } catch (e) {
      showError(context, e, noFound: "Servicio no encontrado");
    }
  }
}
