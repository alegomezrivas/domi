import 'dart:math' show cos, sqrt, asin;

import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

double calculateDistance(lat1, lon1, lat2, lon2) {
  var p = 0.017453292519943295;
  var c = cos;
  var a = 0.5 -
      c((lat2 - lat1) * p) / 2 +
      c(lat1 * p) * c(lat2 * p) * (1 - c((lon2 - lon1) * p)) / 2;
  return 12742 * asin(sqrt(a));
}

double getTotalDistance(List<Map<String, dynamic>> data) {
  print(data);
  double totalDistance = 0;
  for (var i = 0; i < data.length - 1; i++) {
    totalDistance += calculateDistance(
        data[i]["location"]["latitude"],
        data[i]["location"]["longitude"],
        data[i + 1]["location"]["latitude"],
        data[i + 1]["location"]["longitude"]);
  }
  print("Distance $totalDistance");
  return totalDistance;
}

Future<Uint8List> getBytesFromAsset(BuildContext context, String path) async {
  final size = MediaQuery.of(context).devicePixelRatio;
  int width = 100;
  if(size > 3){
    width = 150;
  }
  ByteData data = await rootBundle.load(path);
  ui.Codec codec = await ui.instantiateImageCodec(data.buffer.asUint8List(), targetWidth: width);
  ui.FrameInfo fi = await codec.getNextFrame();
  return (await fi.image.toByteData(format: ui.ImageByteFormat.png))!.buffer.asUint8List();
}
