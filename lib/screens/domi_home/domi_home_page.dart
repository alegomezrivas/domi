import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:domi/core/network/api_keys.dart';
import 'package:domi/main.dart';
import 'package:domi/provider/auth/auth_provider.dart';
import 'package:domi/provider/domi/in_service_provider.dart';
import 'package:domi/provider/service/active_services_provider.dart';
import 'package:domi/re_use/geo_widgets/domi_location_permission.dart';
import 'package:domi/re_use/theme.dart';
import 'package:domi/re_use/utils/dialogs.dart';
import 'package:domi/repositories/domi_repository.dart';
import 'package:domi/screens/domi_home/domi_button_bar/appreciation_domiciliary.dart';
import 'package:domi/screens/domi_home/domi_button_bar/service.dart';
import 'package:domi/screens/domi_home/domi_button_bar/wallet_domiciliary.dart';
import 'package:domi/screens/domi_home/service/in_service.dart';
import 'package:domi/screens/home/configuration_drawer/domi_drawer.dart';
import 'package:domi/screens/service/pages/service_history_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';
import 'package:location_permissions/location_permissions.dart' as pl;

class DomiHomePage extends StatefulWidget {
  @override
  _DomiHomePageState createState() => _DomiHomePageState();
}

class _DomiHomePageState extends State<DomiHomePage> {
  GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  ValueNotifier<bool> _selectedValue = ValueNotifier<bool>(false);
  ValueNotifier<bool> _loadingLocation = ValueNotifier<bool>(false);
  ValueNotifier<int> _pageIndex = ValueNotifier<int>(0);
  PageController _pageController = PageController();
  List<Widget> pages = [
    Service(),
    ServiceHistoryPage(),
    AppreciationDomiciliary(),
    WalletDomiciliary(),
  ];
  Location location = Location();
  StreamSubscription<LocationData>? _locationSubscription;
  Timer _debounce = Timer(Duration(seconds: 0), () {});
  bool mounted = false;
  late int userId;
  bool locationFromSnackBar = false;

  @override
  void initState() {
    _pageController.addListener(() {
      _pageIndex.value = _pageController.page!.toInt();
    });
    _selectedValue.value =
        context.read(authProvider).userData!.user.person.available;
    getDomiStatus();
    context
        .read(inServiceProvider.notifier)
        .listenUser(context.read(authProvider).userData!.user.id);
    userId = context.read(authProvider).userData!.user.id;
    _checkPermissionPage();
    super.initState();
    initPlatformState(context.read(authProvider).userData!.user.id.toString());
  }

  @override
  void dispose() {
    mounted = true;
    _selectedValue.dispose();
    _loadingLocation.dispose();
    _pageIndex.dispose();
    _pageController.dispose();
    _locationSubscription?.cancel();
    _debounce.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        key: _scaffoldKey,
        backgroundColor: inDomiScaffoldGrey,
        drawer: SafeArea(
            child: DomiDrawer(
          domyType: DomiType.domi,
          pageController: _pageController,
        )),
        body: SafeArea(
          child: Stack(
            alignment: Alignment.topCenter,
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 80),
                child: Container(
                  child: PageView(
                    controller: _pageController,
                    children: pages,
                    scrollDirection: Axis.horizontal,
                  ),
                ),
              ),
              SizedBox(
                height: 20,
              ),
              Padding(
                padding: const EdgeInsets.only(top: 20, left: 17, right: 17),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(left: 5),
                      child: InkWell(
                          onTap: () {
                            _scaffoldKey.currentState!.openDrawer();
                          },
                          child: Image(
                            image: AssetImage("assets/icons/Component4@3x.png"),
                            height: 52,
                            width: 52,
                          )),
                    ),
                    Spacer(),
                    ValueListenableBuilder<bool>(
                        valueListenable: _selectedValue,
                        builder: (context, value, child) {
                          return Row(
                            children: [
                              Text(
                                value ? "Libre" : "Ocupado",
                                style: TextStyle(
                                    color: value ? inDomiGreen : Colors.red,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16),
                              ),
                              SizedBox(
                                height: 20,
                              ),
                              Container(
                                height: 30,
                                width: 58,
                                child: FittedBox(
                                  child: CupertinoSwitch(
                                    value: value,
                                    activeColor: inDomiGreen,
                                    onChanged: (value) {
                                      _selectedValue.value = value;
                                      _availableStatus();
                                    },
                                  ),
                                ),
                              ),
                              ValueListenableBuilder<bool>(
                                valueListenable: _loadingLocation,
                                builder: (context, value, child) {
                                  if (!value) return SizedBox();
                                  return Container(
                                      height: 24,
                                      width: 24,
                                      child: CircularProgressIndicator(
                                          strokeWidth: 2));
                                },
                              )
                            ],
                          );
                        }),
                  ],
                ),
              ),
            ],
          ),
        ),
        bottomNavigationBar: ValueListenableBuilder(
            valueListenable: _pageIndex,
            builder: (BuildContext context, value, child) {
              return Container(
                height: 65,
                decoration: BoxDecoration(
                  boxShadow: <BoxShadow>[
                    BoxShadow(
                        color: Colors.black26,
                        offset: Offset(0, 1),
                        blurRadius: 10.0)
                  ],
                ),
                child: Container(
                  color: Colors.white,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      InkWell(
                        onTap: () {
                          _pageController.jumpToPage(0);
                        },
                        child: Container(
                          constraints: BoxConstraints(maxWidth: 80),
                          width: 80,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Image(
                                image: AssetImage(
                                    "assets/icons/delivery-man@2x.png"),
                                width: value == 0 ? 26 : 22,
                                height: value == 0 ? 25 : 21,
                                color: value == 0
                                    ? inDomiBluePrimary
                                    : inDomiGreyBlack,
                              ),
                              SizedBox(
                                height: 3,
                              ),
                              Text(
                                'Servicios',
                                style: TextStyle(
                                    color: value == 0
                                        ? inDomiBluePrimary
                                        : inDomiGreyBlack,
                                    fontSize: value == 0 ? 12 : 11,
                                    fontWeight:
                                        value == 0 ? FontWeight.bold : null),
                              )
                            ],
                          ),
                        ),
                      ),
                      InkWell(
                        onTap: () {
                          _pageController.jumpToPage(1);
                        },
                        child: Container(
                          constraints: BoxConstraints(maxWidth: 80),
                          width: 80,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Image(
                                image:
                                    AssetImage("assets/icons/064-list@2x.png"),
                                width: value == 1 ? 26 : 22,
                                height: value == 1 ? 25 : 21,
                                color: value == 1
                                    ? inDomiBluePrimary
                                    : inDomiGreyBlack,
                              ),
                              SizedBox(
                                height: 3,
                              ),
                              Text(
                                "Historial",
                                style: TextStyle(
                                    color: value == 1
                                        ? inDomiBluePrimary
                                        : inDomiGreyBlack,
                                    fontSize: value == 1 ? 12 : 11,
                                    fontWeight:
                                        value == 1 ? FontWeight.bold : null),
                              )
                            ],
                          ),
                        ),
                      ),
                      InkWell(
                        onTap: () {
                          _pageController.jumpToPage(2);
                        },
                        child: Container(
                          constraints: BoxConstraints(
                            maxWidth: 80,
                          ),
                          width: 80,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Image(
                                image:
                                    AssetImage("assets/icons/checked@2x.png"),
                                width: value == 2 ? 26 : 22,
                                height: value == 2 ? 25 : 21,
                                color: value == 2
                                    ? inDomiBluePrimary
                                    : inDomiGreyBlack,
                              ),
                              SizedBox(
                                height: 3,
                              ),
                              Text("Valoración",
                                  style: TextStyle(
                                      color: value == 2
                                          ? inDomiBluePrimary
                                          : inDomiGreyBlack,
                                      fontSize: value == 2 ? 12 : 11,
                                      fontWeight:
                                          value == 2 ? FontWeight.bold : null)),
                            ],
                          ),
                        ),
                      ),
                      InkWell(
                        onTap: () {
                          _pageController.jumpToPage(3);
                        },
                        child: Container(
                          constraints: BoxConstraints(
                            maxWidth: 80,
                          ),
                          width: 80,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Image(
                                image:
                                    AssetImage("assets/icons/Grupo 65@3x.png"),
                                width: value == 3 ? 26 : 22,
                                height: value == 3 ? 25 : 21,
                                color: value == 3
                                    ? inDomiBluePrimary
                                    : inDomiGreyBlack,
                              ),
                              SizedBox(
                                height: 3,
                              ),
                              Text("Billetera",
                                  style: TextStyle(
                                      color: value == 3
                                          ? inDomiBluePrimary
                                          : inDomiGreyBlack,
                                      fontSize: value == 3 ? 12 : 11,
                                      fontWeight:
                                          value == 3 ? FontWeight.bold : null)),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }));
  }

  getDomiStatus() async {
    try {
      final status = await DomiRepository.getDomiStatus();
      if (status.service != null) {
        context
            .read(activeServicesProvider.notifier)
            .setDomiActiveService(status.service!);
        Navigator.of(context).push(MaterialPageRoute(
          builder: (context) => InService(status.service!),
        ));
      }
    } catch (e) {
      showError(context, e);
    }
  }

  _availableStatus() async {
    try {
      _loadingLocation.value = !_loadingLocation.value;
      final location = await getLocationData();
      if (location == null) {
        return;
      }
      final status = await DomiRepository.available(_selectedValue.value,
          {"latitude": location.latitude, "longitude": location.longitude});
      final user = context.read(authProvider).userData!.user;
      user.person.available = _selectedValue.value;
      context.read(authProvider).setUser(user);
    } catch (e) {
      _selectedValue.value = !_selectedValue.value;
      showError(context, e);
    } finally {
      _loadingLocation.value = !_loadingLocation.value;
    }
  }

  Future<LocationData?> getLocationData() async {
    bool _serviceEnabled;
    PermissionStatus _permissionGranted;
    LocationData? _locationData;

    _serviceEnabled = await location.serviceEnabled();
    if (!_serviceEnabled) {
      _serviceEnabled = await location.requestService();
      if (!_serviceEnabled) {
        return null;
      }
    }

    _permissionGranted = await location.hasPermission();
    if (_permissionGranted == PermissionStatus.denied) {
      _permissionGranted = await location.requestPermission();
      if (_permissionGranted != PermissionStatus.granted) {
        return null;
      }
    }

    _locationData = await location.getLocation();
    return _locationData;
  }

  initLocation() async {
    print("Locatiooooooooooooooooooooooooooooooooooonnnnnnnnnnnnnnnnnnnnn");
    // bool _serviceEnabled;
    //
    // _serviceEnabled = await location.serviceEnabled();
    // if (!_serviceEnabled) {
    //   _serviceEnabled = await location.requestService();
    //   if (!_serviceEnabled) {
    //     return;
    //   }
    // }
    //
    // pl.PermissionStatus actualPermissionStatus =
    //     await pl.LocationPermissions().checkPermissionStatus();
    // if (actualPermissionStatus != pl.PermissionStatus.granted) {
    //   bool isShown = await pl.LocationPermissions()
    //       .shouldShowRequestPermissionRationale(
    //           permissionLevel: pl.LocationPermissionLevel.locationAlways);
    //   print(isShown);
    //
    //   if (isShown) {
    //     pl.PermissionStatus permission = await pl.LocationPermissions()
    //         .requestPermissions(
    //             permissionLevel: pl.LocationPermissionLevel.location);
    //     if (permission != pl.PermissionStatus.granted) {
    //       return;
    //     }
    //   }
    // }
    //
    // pl.PermissionStatus permission = await pl.LocationPermissions()
    //     .requestPermissions(
    //         permissionLevel: pl.LocationPermissionLevel.locationAlways);
    // if (permission != pl.PermissionStatus.granted) {
    //   locationDeniedMessage(context, () async {
    //     pl.PermissionStatus actualPermissionStatus =
    //         await pl.LocationPermissions().checkPermissionStatus(
    //             level: pl.LocationPermissionLevel.locationAlways);
    //     if (actualPermissionStatus == pl.PermissionStatus.granted &&
    //         !locationFromSnackBar) {
    //       locationFromSnackBar = true;
    //       initLocation();
    //     }
    //   });
    //   return;
    // }

    bool res = await location.isBackgroundModeEnabled();
    print("Background mode enableeeeeeeeeeeeeed $res");
    if (!res) {
      try {
        bool result2 = await location.enableBackgroundMode(enable: true);
      } catch (e) {
        Future.delayed(Duration(seconds: 15), () {
          location
              .enableBackgroundMode(enable: true)
              .catchError((onError) => print(onError));
        });
      }
    }
    await location.changeSettings(
        accuracy: LocationAccuracy.high, interval: 10000, distanceFilter: 5);
    _locationSubscription = location.onLocationChanged
        .distinct()
        .listen((LocationData currentLocation) {
      print(currentLocation);
      if (!mounted) {
        context.read(inServiceProvider.notifier).updateDomiPosition(
            LatLng(currentLocation.latitude!, currentLocation.longitude!),
            giros: currentLocation.heading ?? 0);

        if (!_debounce.isActive) {
          _debounce = Timer(Duration(seconds: 10), () {
            if (!mounted) {
              try {
                context
                    .read(inServiceProvider.notifier)
                    .channel
                    ?.sink
                    .add(jsonEncode({
                      "message": {
                        "lat": currentLocation.latitude,
                        "lng": currentLocation.longitude,
                        "giros": currentLocation.heading,
                        "user": userId
                      }
                    }));
              } catch (e) {
                print(e);
              }
            }
          });
        }
      }
    });
  }

  Future<void> initPlatformState(String externalId) async {
    if (kDebugMode) {
      OneSignal.shared.setLogLevel(OSLogLevel.verbose, OSLogLevel.none);
    }

    // OneSignal.shared.setRequiresUserPrivacyConsent(true);

    await OneSignal.shared.setAppId(kONE_SIGNAL_APP_ID);

    OneSignal.shared.promptUserForPushNotificationPermission().then((accepted) {
      print("Accepted permission: $accepted");
    });

    OneSignal.shared
        .setNotificationOpenedHandler((OSNotificationOpenedResult result) {
      print('NOTIFICATION OPENED HANDLER CALLED WITH: ${result}');
      print(
          "Opened notification: \n${result.notification.jsonRepresentation().replaceAll("\\n", "\n")}");
      print(result.notification.additionalData);
      if (result.notification.additionalData != null) {}
    });

    OneSignal.shared.setNotificationWillShowInForegroundHandler(
        (OSNotificationReceivedEvent event) {
      print('FOREGROUND HANDLER CALLED WITH: ${event}');

      /// Display Notification, send null to not display
      event.complete(null);

      print(
          "Notification received in foreground notification: \n${event.notification.jsonRepresentation().replaceAll("\\n", "\n")}");
    });

    // OneSignal.shared.disablePush(false);

    // bool userProvidedPrivacyConsent =
    //     await OneSignal.shared.userProvidedPrivacyConsent();
    // print("USER PROVIDED PRIVACY CONSENT: $userProvidedPrivacyConsent");
    // bool requiresConsent = await OneSignal.shared.requiresUserPrivacyConsent();
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

  void _checkPermissionPage() async {
    pl.PermissionStatus actualPermissionStatus = await pl.LocationPermissions()
        .checkPermissionStatus(
            level: pl.LocationPermissionLevel.locationAlways);
    if (actualPermissionStatus != pl.PermissionStatus.granted) {
      await Navigator.of(context).push(
          MaterialPageRoute(builder: (context) => DomiLocationPermission()));

      // check again the permission
      actualPermissionStatus = await pl.LocationPermissions()
          .checkPermissionStatus(
              level: pl.LocationPermissionLevel.locationAlways);
      if (actualPermissionStatus == pl.PermissionStatus.granted) {
        initLocation();
        if ((pages[0] as Service).currentState != null) {
          (pages[0] as Service).currentState!.startDomiServices();
        }
      }
    } else {
      initLocation();
    }
  }
}
