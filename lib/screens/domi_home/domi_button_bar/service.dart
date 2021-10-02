import 'package:domi/main.dart';
import 'package:domi/provider/domi/available_service_provider.dart';
import 'package:domi/provider/service/active_services_provider.dart';
import 'package:domi/re_use/theme.dart';
import 'package:domi/re_use/utils/dialogs.dart';
import 'package:domi/repositories/domi_repository.dart';
import 'package:domi/screens/domi_home/service/in_service.dart';
import 'package:domi/screens/domi_home/service/widgets/new_service_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:location_permissions/location_permissions.dart' as pl;

class Service extends StatefulWidget {
  _ServiceState? currentState;

  @override
  _ServiceState createState() {
    currentState = _ServiceState();
    return currentState!;
  }
}

class _ServiceState extends State<Service> {
  Location location = Location();
  LocationData? _locationData;
  bool locationFromSnackBar = false;

  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      startDomiServices();
    });
  }

  void startDomiServices() async {
    pl.PermissionStatus actualPermissionStatus = await pl.LocationPermissions()
        .checkPermissionStatus(
            level: pl.LocationPermissionLevel.locationAlways);
    if (actualPermissionStatus != pl.PermissionStatus.granted) {
      return;
    }
    getAvailableServices();
    context
        .read(availableProvider.notifier)
        .connectToWS(context.read(authProvider).userData!.user.id, () {
      getAvailableServices();
    });
  }

  Future<void> refreshDomiStatus() async {
    final status = await DomiRepository.getDomiStatus();
    context
        .read(activeServicesProvider.notifier)
        .setDomiActiveService(status.service ?? 0);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: inDomiScaffoldGrey,
        body: Consumer(
          builder: (context, watch, child) {
            final data = watch(availableProvider).results;
            final serviceId = watch(activeServicesProvider).domiActiveService;
            final userIsActive =
                watch(authProvider).userData!.user.isDomiActive;
            return RefreshIndicator(
              onRefresh: () async {
                refreshDomiStatus();

                if (_locationData == null) {
                  return getAvailableServices();
                }
                return context.read(availableProvider.notifier).refresh(LatLng(
                    _locationData!.latitude!, _locationData!.longitude!));
              },
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  if (serviceId != 0 && userIsActive)
                    Padding(
                      padding: const EdgeInsets.all(10),
                      child: InkWell(
                        onTap: () {
                          Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) => InService(serviceId)));
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
                                        borderRadius: BorderRadius.circular(28),
                                        color: inDomiBluePrimary),
                                    alignment: Alignment.center,
                                    child: Text("1",
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
                    ),
                  if (data.isEmpty && userIsActive)
                    Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: Center(
                        child: Text(
                          "No hay servicios disponibles en su zona",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              color: inDomiBluePrimary,
                              fontWeight: FontWeight.bold,
                              fontSize: 20),
                        ),
                      ),
                    ),
                  if (userIsActive)
                    Expanded(
                      child: ListView.builder(
                          itemCount: data.length,
                          itemBuilder: (context, index) {
                            final service = data[index];
                            return NewServiceWidget(
                              data[index],
                              onTimeOver: () {
                                context
                                    .read(availableProvider.notifier)
                                    .removeItem(service);
                              },
                            );
                          }),
                    ),
                  if (!userIsActive)
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: Container(
                        alignment: Alignment.center,
                        height: 80,
                        width: double.maxFinite,
                        decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(10),
                            boxShadow: [
                              BoxShadow(color: Colors.black12, blurRadius: 3)
                            ]),
                        child: Text(
                          "Estamos revisando tu información",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              color: inDomiBluePrimary,
                              fontWeight: FontWeight.bold,
                              fontSize: 18),
                        ),
                      ),
                    )
                ],
              ),
            );
          },
        ));
  }

  void getAvailableServices() async {
    try {
      _locationData = await getLocationData();
      if (_locationData == null) {
        showError(context, {
          "detail":
              "Debe permitir el uso de la ubicación para consultar servicios disponibles"
        });
        return;
      }
      context.read(availableProvider.notifier).getAvailableServices(
          LatLng(_locationData!.latitude!, _locationData!.longitude!));
    } catch (e) {}
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

    // _permissionGranted = await location.hasPermission();
    // if (_permissionGranted == PermissionStatus.denied) {
    //   _permissionGranted = await location.requestPermission();
    //   if (_permissionGranted != PermissionStatus.granted) {
    //     return null;
    //   }
    // }

    // var status = await ph.Permission.locationAlways.status;
    // if (status.isDenied) {
    //   if (!await ph.Permission.locationAlways.request().isGranted) {
    //     locationDeniedMessage(context, () async {
    //       var status = await ph.Permission.locationAlways.status;
    //       if (status.isGranted && !locationFromSnackBar) {
    //         locationFromSnackBar = true;
    //         return null;
    //       }
    //     });
    //     return null;
    //   }
    // }

    _locationData = await location.getLocation();
    return _locationData;
  }
}
