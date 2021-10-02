import 'dart:async';
import 'dart:io';
import 'package:domi/core/enum/service_enums.dart';
import 'package:domi/core/network/api_keys.dart';
import 'package:domi/main.dart';
import 'package:domi/provider/auth/auth_provider.dart';
import 'package:domi/provider/real_time/home_channel.dart';
import 'package:domi/provider/service/active_services_provider.dart';
import 'package:domi/re_use/theme.dart';
import 'package:domi/router.dart';
import 'package:domi/screens/home/configuration_drawer/domi_drawer.dart';
import 'package:domi/screens/service/active_service_page.dart';
import 'package:domi/screens/service/create_service.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage>
    with TickerProviderStateMixin, WidgetsBindingObserver {
  Location location = new Location();
  GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  TextEditingController _textEditingController = TextEditingController();
  Completer<GoogleMapController> _controller = Completer();
  GoogleMapController? _mapController;
  bool activeButton = false;
  late CameraPosition _kGooglePlex;
  StreamSubscription<LocationData>? _locationSubscription;
  Timer _debounce = Timer(Duration(seconds: 0), () {});


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
    final cityData = context.read(authProvider).userData!.user.person.city;
    _kGooglePlex = CameraPosition(
        target: LatLng(cityData.latitude, cityData.longitude), zoom: 15);
    Future.microtask(() async {
      await context
          .read(homeDomisProvider.notifier)
          .createMarkerImageFromAsset(context);
      context
          .read(homeDomisProvider.notifier)
          .listenWS(context.read(authProvider).userData!.user.id, () {
        getActiveAndPendingServices();
      });

      initLocation();
      getActiveAndPendingServices();
    });
    super.initState();
    WidgetsBinding.instance!.addObserver(this);
    if (mounted) {
      initPlatformState(
          context.read(authProvider).userData!.user.id.toString());
    }
  }

  void getActiveAndPendingServices() {
    context
        .read(activeServicesProvider.notifier)
        .getActiveServices()
        .then((value) {
      if (value != null) {
        if(!AuthProvider.availableScreen) {
          Future.delayed(Duration(milliseconds: 300), () {
            if (!AuthProvider.availableScreen) {
              AuthProvider.availableScreen = true;
              Navigator.of(context).pushNamed(DELIVERIES, arguments: value.id);
            }
          });
        }
      }
    });
  }

  @override
  void dispose() {
    WidgetsBinding.instance!.removeObserver(this);
    _textEditingController.dispose();
    _locationSubscription?.cancel();
    _debounce.cancel();
    super.dispose();
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
    // bool result = await location.isBackgroundModeEnabled();
    // bool result2 = await location.enableBackgroundMode(enable: true);
    // await location.changeSettings(
    //     accuracy: LocationAccuracy.high, interval: 10000, distanceFilter: 0);
    // _locationSubscription = location.onLocationChanged
    //     .distinct()
    //     .listen((LocationData currentLocation) {
    //   if (!_debounce.isActive) {
    //     _debounce = Timer(Duration(seconds: 10), () {
    //       context
    //           .read(homeDomisProvider.notifier)
    //           .channel
    //           ?.sink
    //           .add(jsonEncode({
    //         "message": {
    //           "lat": currentLocation.latitude,
    //           "lng": currentLocation.longitude,
    //           "giros": currentLocation.heading
    //         }
    //       }));
    //     });
    //   }
    // });

    print(_locationData);
    (await _controller.future).animateCamera(CameraUpdate.newCameraPosition(
        CameraPosition(
            target: LatLng(_locationData.latitude!, _locationData.longitude!),
            zoom: 15)));
    context
        .read(homeDomisProvider.notifier)
        .getNearDomis(_locationData.latitude!, _locationData.longitude!);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      key: _scaffoldKey,
      drawer: SafeArea(child: DomiDrawer()),
      body: SafeArea(
        child: Container(
          child: Stack(
            alignment: Alignment.topCenter,
            children: [
              Consumer(
                builder: (context, watch, child) {
                  return GoogleMap(
                    mapType: MapType.normal,
                    initialCameraPosition: _kGooglePlex,
                    markers: watch(homeDomisProvider).toSet(),
                    onMapCreated: (GoogleMapController controller) {
                      _mapController = controller;
                      _controller.complete(controller);
                    },
                    myLocationEnabled: true,
                  );
                },
              ),
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                child: Column(
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        InkWell(
                            onTap: () {
                              _scaffoldKey.currentState!.openDrawer();
                            },
                            child: Image(
                              image:
                                  AssetImage("assets/icons/Component4@3x.png"),
                              height: 52,
                              width: 52,
                            )),
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
                        )
                      ],
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    AnimatedSize(
                      duration: Duration(milliseconds: 300),
                      curve: Curves.elasticOut,
                      vsync: this,
                      alignment: Alignment.topCenter,
                      child: Container(
                        width: double.maxFinite,
                        decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(12)),
                        child: Padding(
                          padding: const EdgeInsets.only(
                              right: 12, left: 12, bottom: 12, top: 20),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Text(
                                "¿En qué podemos ayudarte hoy?",
                                style: TextStyle(
                                    color: inDomiBluePrimary, fontSize: 14),
                              ),
                              SizedBox(
                                height: 12,
                              ),
                              Container(
                                width: double.maxFinite,
                                height: 37,
                                child: ElevatedButton(
                                  onPressed: () {
                                    if (activeButton == false) {
                                      setState(() {
                                        activeButton = true;
                                      });
                                    } else {
                                      setState(() {
                                        activeButton = false;
                                      });
                                    }
                                  },
                                  child: Container(
                                    height: 37,
                                    width: double.maxFinite,
                                    child: Stack(
                                      alignment: Alignment.center,
                                      children: [
                                        Text(
                                          "Necesito un…",
                                          style: TextStyle(
                                              color: Color(0xffA3A3A3),
                                              fontSize: 14),
                                        ),
                                        Positioned(
                                            right: 0,
                                            child: Icon(
                                              activeButton == false
                                                  ? Icons.keyboard_arrow_down
                                                  : Icons.keyboard_arrow_up,
                                              color: inDomiGreyBlack,
                                              size: 20,
                                            ))
                                      ],
                                    ),
                                  ),
                                  style: ElevatedButton.styleFrom(
                                    elevation: 0,
                                    primary: inDomiScaffoldGrey,
                                    shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(19)),
                                  ),
                                ),
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              if (activeButton == true)
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 20),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      InkWell(
                                        onTap: () {
                                          Navigator.of(context)
                                              .push(MaterialPageRoute(
                                            builder: (context) =>
                                                CreateService(ServiceType.food),
                                          ));
                                        },
                                        child: Container(
                                          alignment: Alignment.center,
                                          decoration: BoxDecoration(
                                              border: Border(
                                                  bottom: BorderSide(
                                                      width: 1,
                                                      color: Colors.black12))),
                                          child: Padding(
                                            padding: const EdgeInsets.symmetric(
                                                vertical: 12),
                                            child: Text(
                                              "Domicilio de comida",
                                              style: TextStyle(
                                                  color: Color(0xff707071),
                                                  fontSize: 14),
                                            ),
                                          ),
                                        ),
                                      ),
                                      InkWell(
                                        onTap: () {
                                          Navigator.of(context)
                                              .push(MaterialPageRoute(
                                            builder: (context) =>
                                                CreateService(ServiceType.pack),
                                          ));
                                        },
                                        child: Container(
                                          alignment: Alignment.center,
                                          decoration: BoxDecoration(
                                              border: Border(
                                                  bottom: BorderSide(
                                                      width: 1,
                                                      color: Colors.black12))),
                                          child: Padding(
                                            padding: const EdgeInsets.symmetric(
                                                vertical: 12),
                                            child: Text(
                                              "Enviar paquete",
                                              style: TextStyle(
                                                  color: Color(0xff707071),
                                                  fontSize: 14),
                                            ),
                                          ),
                                        ),
                                      ),
                                      InkWell(
                                        onTap: () {
                                          Navigator.of(context)
                                              .push(MaterialPageRoute(
                                            builder: (context) => CreateService(
                                                ServiceType.document),
                                          ));
                                        },
                                        child: Container(
                                          alignment: Alignment.center,
                                          child: Padding(
                                            padding: const EdgeInsets.symmetric(
                                                vertical: 12),
                                            child: Text(
                                              "Enviar documentos",
                                              style: TextStyle(
                                                  color: Color(0xff707071),
                                                  fontSize: 14),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              // ButtonRegisterLogin(
                              //   voidCallback: () {
                              //     //Navigator.of(context).push(MaterialPageRoute(builder: (context) => LoadScreen(),));
                              //   },
                              //   text: Text("Siguiente",
                              //       style: TextStyle(
                              //           fontSize: 14,
                              //           color: Colors.white,
                              //           fontWeight: FontWeight.w600)),
                              //   width: double.maxFinite,
                              // ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    Consumer(
                      builder: (context, watch, child) {
                        final state = watch(activeServicesProvider);
                        if (state.results.isEmpty) {
                          return SizedBox();
                        }
                        return Padding(
                          padding: const EdgeInsets.only(top: 10),
                          child: InkWell(
                            onTap: () {
                              getActiveAndPendingServices();
                              Navigator.of(context).push(MaterialPageRoute(
                                  builder: (context) => ActiveServicePage()));
                            },
                            child: Container(
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  color: inDomiYellow),
                              child: Padding(
                                padding: const EdgeInsets.all(12.0),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Container(
                                        width: 28,
                                        height: 28,
                                        decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(28),
                                            color: inDomiBluePrimary),
                                        alignment: Alignment.center,
                                        child: Text("${state.results.length}",
                                            style: TextStyle(
                                                color: Colors.white,
                                                fontWeight: FontWeight.bold))),
                                    Expanded(
                                      child: Text(
                                        "Pedido en curso",
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            color: inDomiBluePrimary),
                                        textAlign: TextAlign.center,
                                      ),
                                    ),
                                    Icon(
                                      Icons.arrow_forward_ios,
                                      size: 20,
                                      color: inDomiBluePrimary,
                                    )
                                  ],
                                ),
                              ),
                            ),
                          ),
                        );
                      },
                    )
                  ],
                ),
              ),
              // Positioned(
              //   bottom: 20,
              //   child: Container(
              //     decoration: BoxDecoration(
              //       color: inDomiYellow,
              //       borderRadius: BorderRadius.circular(28),
              //     ),
              //     child: Padding(
              //       padding: const EdgeInsets.only(
              //           left: 21, right: 12, top: 11, bottom: 11),
              //       child: Row(
              //         children: [
              //           Text(
              //             "¡Invita amigos y gana!",
              //             style: TextStyle(
              //                 color: inDomiBluePrimary,
              //                 fontSize: 14,
              //                 fontWeight: FontWeight.bold),
              //           ),
              //           SizedBox(
              //             width: 15,
              //           ),
              //           IndomiTextFormField(
              //             height: 35,
              //             textAlign: TextAlign.center,
              //             hintText: "KDLASJ",
              //             radius: 19,
              //             width: 91,
              //             controller: _textEditingController,
              //           ),
              //           SizedBox(
              //             width: 5,
              //           ),
              //           Container(
              //             width: 36,
              //             height: 36,
              //             alignment: Alignment.center,
              //             decoration: BoxDecoration(
              //               color: inDomiBluePrimary,
              //               borderRadius: BorderRadius.circular(36),
              //             ),
              //             child: Image(
              //               image: AssetImage(
              //                 "assets/icons/Grupo 25@2x.png",
              //               ),
              //               height: 15,
              //               width: 14,
              //             ),
              //           )
              //         ],
              //       ),
              //     ),
              //   ),
              // ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> initPlatformState(String externalId) async {
    if (kDebugMode) {
      OneSignal.shared.setLogLevel(OSLogLevel.verbose, OSLogLevel.none);
    }

    OneSignal.shared.setRequiresUserPrivacyConsent(true);

    OneSignal.shared
        .setNotificationOpenedHandler((OSNotificationOpenedResult result) {
      print('NOTIFICATION OPENED HANDLER CALLED WITH: ${result}');
      print(
          "Opened notification: \n${result.notification.jsonRepresentation().replaceAll("\\n", "\n")}");
      // if (result.notification.additionalData != null) {
      //   if (result.notification.additionalData!["offer"]) {
      //     print("demooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooo");
      //     Future.delayed(Duration(milliseconds: 300), () {
      //       Navigator.of(context).pushNamed(DELIVERIES,
      //           arguments: result.notification.additionalData!["offer"]);
      //     });
      //   }
      // }
    });

    OneSignal.shared.setNotificationWillShowInForegroundHandler(
        (OSNotificationReceivedEvent event) {
      print('FOREGROUND HANDLER CALLED WITH: ${event}');

      /// Display Notification, send null to not display
      event.complete(null);

      print(
          "Notification received in foreground notification: \n${event.notification.jsonRepresentation().replaceAll("\\n", "\n")}");

      // if (event.notification.additionalData != null) {
      //   showDelivery = event.notification.additionalData!["offer"];
      //   navigatorKey.currentState!.pushNamed("/deliveries",
      //       arguments: event.notification.additionalData!["offer"]);
      // }
    });

    // OneSignal.shared
    //     .setSubscriptionObserver((OSSubscriptionStateChanges changes) {
    //   print("SUBSCRIPTION STATE CHANGED: ${changes.jsonRepresentation()}");
    // });
    //
    // OneSignal.shared.setPermissionObserver((OSPermissionStateChanges changes) {
    //   print("PERMISSION STATE CHANGED: ${changes.jsonRepresentation()}");
    // });

    // NOTE: Replace with your own app ID from https://www.onesignal.com
    await OneSignal.shared.setAppId(kONE_SIGNAL_APP_ID);

    bool requiresConsent = await OneSignal.shared.requiresUserPrivacyConsent();

    OneSignal.shared.disablePush(false);

    bool userProvidedPrivacyConsent =
        await OneSignal.shared.userProvidedPrivacyConsent();
    print("USER PROVIDED PRIVACY CONSENT: $userProvidedPrivacyConsent");
    if (Platform.isAndroid) {
      _handleConsent();
      if (!await AuthProvider.checkUserExternalIdOpenSignal(externalId)) {
        _handleSetExternalUserId(externalId);
      }
    } else {
      Future.delayed(Duration(seconds: 5), () {
        _askForConsent(externalId);
      });
    }
  }

  void _handleConsent() {
    OneSignal.shared.consentGranted(true);
  }

  void _handleSetExternalUserId(String externalId) async {
    try {
      print("Setting external user ID");
      final results = await OneSignal.shared.setExternalUserId(externalId);
      if (results == null) return;
      AuthProvider.setUserExternalIdOpenSignal(externalId);
    } catch (e) {
      print(e);
    }
  }

  void _askForConsent(String externalId) async {
    _handleConsent();
    if (!await AuthProvider.checkUserExternalIdOpenSignal(externalId)) {
      await OneSignal.shared.promptUserForPushNotificationPermission();
      bool allowed =
          await OneSignal.shared.promptUserForPushNotificationPermission();
      if (allowed) {
        _handleConsent();
        _handleSetExternalUserId(externalId);
      }
    }
  }
}
