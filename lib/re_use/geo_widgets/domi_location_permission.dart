import 'dart:io';

import 'package:flutter/material.dart';
import 'package:location_permissions/location_permissions.dart' as pl;

class DomiLocationPermission extends StatefulWidget {
  @override
  _DomiLocationPermissionState createState() => _DomiLocationPermissionState();
}

class _DomiLocationPermissionState extends State<DomiLocationPermission>
    with WidgetsBindingObserver {
  bool granted = false;
  bool dialogIsShowed = false;
  bool _mounted = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance!.addObserver(this);
  }

  @override
  void dispose() {
    _mounted = true;
    WidgetsBinding.instance!.removeObserver(this);
    granted = false;
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) async {
    if (state == AppLifecycleState.resumed) {
      pl.PermissionStatus permission = await pl.LocationPermissions()
          .checkPermissionStatus(
              level: pl.LocationPermissionLevel.locationAlways);
      if (pl.PermissionStatus.granted == permission) {
        if(!_mounted) {
          setState(() {
            granted = true;
          });
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        return granted;
      },
      child: Scaffold(
        body: SafeArea(
          child: Stack(
            alignment: Alignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.location_pin, size: 48),
                    SizedBox(height: 20),
                    Text("Uso de la ubicación y la información del télefono",
                        style: TextStyle(fontWeight: FontWeight.bold)),
                    SizedBox(height: 20),
                    Text(
                      """1. Para que puedas aceptar y tramitar las órdenes más cercanas a tu ubicación, la Aplicación "Indomi" recoge datos de localización, aún cuando la Aplicación se encuentre cerrada o no se esté usando.\n\n2. El app Indomi recoge y almacena el número telefónico del usuario el cual es almacenado en nuestra base de datos usando métodos de encriptación para garantizar la protección de la información personal del usuario. La data recolectada se utiliza para identificar posibles comportamientos atípicos dentro de la aplicación y no es compartida ni transferida""",
                      textAlign: TextAlign.justify,
                    ),
                    SizedBox(height: 20),
                    ElevatedButton(
                        onPressed: () async {
                          if (granted) {
                            Navigator.of(context).pop(true);
                            return;
                          }
                          pl.PermissionStatus permission =
                              await pl.LocationPermissions().requestPermissions(
                                  permissionLevel: pl.LocationPermissionLevel
                                      .locationWhenInUse);
                          if (permission == pl.PermissionStatus.denied) {
                            setState(() {
                              dialogIsShowed = true;
                            });
                            return;
                          }

                          permission =
                              await pl.LocationPermissions().requestPermissions(
                                  permissionLevel: pl
                                      .LocationPermissionLevel.locationAlways);
                          if (permission == pl.PermissionStatus.denied) {
                            setState(() {
                              dialogIsShowed = true;
                            });
                            return;
                          }
                          if (permission == pl.PermissionStatus.granted) {
                            granted = true;
                            print("Granteeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeed");
                            Navigator.of(context).pop(true);
                            granted = false;
                          }
                        },
                        child: Text(granted ? "Continuar" : "Entendido"))
                  ],
                ),
              ),
              if (dialogIsShowed && !granted)
                PermissionDeniedMessage(onSettings: () {
                  setState(() {
                    dialogIsShowed = false;
                  });
                })
            ],
          ),
        ),
      ),
    );
  }

  _showDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return Dialog(
          child: Container(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Align(
                      alignment: Alignment.centerLeft,
                      child: Text("Permiso denegado",
                          style: TextStyle(fontWeight: FontWeight.bold))),
                  SizedBox(height: 5),
                  Text(
                      "Has denegado el permiso de ubicación, tienes que hablitarlo de manera manual para poder continuar.",
                      textAlign: TextAlign.justify),
                  Align(
                    alignment: Alignment.centerRight,
                    child: TextButton(
                        onPressed: () async {
                          bool isOpened =
                              await pl.LocationPermissions().openAppSettings();
                        },
                        child: Text("HABILITAR")),
                  )
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

class PermissionDeniedMessage extends StatelessWidget {
  final VoidCallback onSettings;

  PermissionDeniedMessage({required this.onSettings});

  @override
  Widget build(BuildContext context) {
    final media = MediaQuery.of(context).size;
    return GestureDetector(
      onTap: () {
        onSettings();
      },
      child: Container(
        width: media.width,
        height: media.height,
        alignment: Alignment.center,
        color: Colors.black.withAlpha(100),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Container(
                decoration: BoxDecoration(
                    color: Colors.white,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black38,
                        blurRadius: 10.0,
                      )
                    ],
                    borderRadius: BorderRadius.circular(10)),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Align(
                          alignment: Alignment.centerLeft,
                          child: Text("Permiso denegado",
                              style: TextStyle(fontWeight: FontWeight.bold))),
                      SizedBox(height: 5),
                      Text(
                          "Has denegado el permiso de ubicación, tienes que hablitarlo de manera manual para poder continuar.",
                          textAlign: TextAlign.justify),
                      Align(
                        alignment: Alignment.centerRight,
                        child: TextButton(
                            onPressed: () async {
                              bool isOpened = await pl.LocationPermissions()
                                  .openAppSettings();
                              onSettings();
                            },
                            child: Text("HABILITAR")),
                      )
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
