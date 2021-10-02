import 'package:domi/core/enum/service_enums.dart';
import 'package:domi/core/extensions/string.dart';
import 'package:domi/models/general/domi_params.dart';
import 'package:domi/models/wallet/card.dart';
import 'package:domi/repositories/general_repository.dart';
import 'package:domi/repositories/service_repository.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final totalServiceProvider =
    StateNotifierProvider.autoDispose<TotalServiceProvider, double>((ref) {
  return TotalServiceProvider(ref.watch(createServiceProvider).getTotal);
});

class TotalServiceProvider extends StateNotifier<double> {
  TotalServiceProvider(double state) : super(state);

  set setTotal(double total) {
    state = total;
  }
}

final createServiceProvider = StateNotifierProvider.autoDispose<
    CreateServiceProvider,
    CreateServiceState>((ref) => CreateServiceProvider(CreateServiceState()));

class CreateServiceProvider extends StateNotifier<CreateServiceState> {
  final repository = ServiceRepository();

  CreateServiceProvider(CreateServiceState state) : super(state);

  Future<void> getVariables() async {
    try {
      state.domiParams = await GeneralRepository.getDomiVars();
      state.offer = state.domiParams!.params.minServiceValue.toDouble();
      state.package = state.domiParams!.packages.first;
      state = state;
    } catch (e) {
      return Future.error(e);
    }
  }

  void incrementOffer() {
    state.offer += state.domiParams!.params.serviceIncDec;
    state = state;
  }

  void decrementOffer() {
    if ((state.offer - state.domiParams!.params.serviceIncDec) >=
        state.domiParams!.params.minServiceValue.toDouble()) {
      state.offer -= state.domiParams!.params.serviceIncDec;
      state = state;
    }
  }

  void setServiceType(ServiceType serviceType) {
    state.serviceType = serviceType;
    state = state;
  }

  void changeInsuranceValue(double insurance) {
    state.insurance = insurance;
    state = state;
  }

  void addWayPoint() {
    state.wayPointIdCount++;
    state.wayPoints.add({
      "id": state.wayPointIdCount,
      "address": "",
      "location": null,
      "controller": TextEditingController()
    });
    state = state;
  }

  void removeWaypoint(int id) {
    if (state.wayPoints.length > 2) {
      TextEditingController? controller;
      state.wayPoints.forEach((element) {
        if (element["id"] == id) {
          controller = element["controller"];
        }
      });
      state.wayPoints.removeWhere((element) => element["id"] == id);
      state = state;
      if (controller != null) {
        Future.delayed(Duration(seconds: 5), () {
          controller!.dispose();
        });
      }
    }
  }

  void updateWaypoints(int index, String address, Map<String, dynamic> data) {
    state.wayPoints[index]["address"] = address;
    state.wayPoints[index]["location"] = {
      "latitude": data["geometry"]["location"]["lat"],
      "longitude": data["geometry"]["location"]["lng"],
    };
    state.wayPoints[index]["controller"].text = address;
    state = state;
  }

  void changePayMethod(PayMethod payMethod, {Card? selectedCard}) {
    state.card = selectedCard;
    state.payMethod = payMethod;
    state = state;
  }

  @override
  void dispose() {
    super.dispose();
  }

  Future<dynamic> createService() async {
    try {
      return await repository.createService(state.getServiceData());
    } catch (e) {
      return Future.error(e);
    }
  }
}

class CreateServiceState {
  DomiParams? domiParams;
  ServiceType serviceType = ServiceType.food;
  PayMethod payMethod = PayMethod.cash;
  double offer = 0;
  Package? package;
  int packageWeight = 1;
  double cancelInPlace = 0;
  double insurance = 0;
  int wayPointIdCount = 2;
  String observation = "";
  Card? card;

  List<Map<String, dynamic>> wayPoints = [
    {
      "id": 1,
      "address": "",
      "location": null,
      "controller": TextEditingController()
    },
    {
      "id": 2,
      "address": "",
      "location": null,
      "controller": TextEditingController()
    }
  ];

  double get getTotal {
    double total = offer +
        (offer * ((domiParams?.params.userTaxPercent.toDouble() ?? 0) / 100));
    if (serviceType == ServiceType.pack) {
      total += insurance * ((domiParams?.params.insuranceValue ?? 0) / 100);
    }
    return total;
  }

  Map<String, dynamic> getServiceData() {
    Map<String, dynamic> data = {};
    data["way_points"] = wayPoints
        .map((e) => {"location": e["location"], "address": e["address"]})
        .toList();
    data["service_type"] = serviceType.index + 1;
    if (serviceType == ServiceType.pack) {
      data["package"] = {
        "package": package!.id,
        "weight": packageWeight,
        "insurance": insurance
      };
    }
    data["offer"] = offer;
    data["cancel_in_place"] = cancelInPlace;
    data["observation"] = observation;
    data["pay_method"] = payMethod.index + 1;
    if (payMethod == PayMethod.card) {
      data["card"] = card!.id;
    }
    return data;
  }

  List<Map<String, dynamic>> getWaypoints() {
    return wayPoints
        .map((e) => {"location": e["location"], "address": e["address"]})
        .toList();
  }

  String payMethodDescription() {
    switch (payMethod) {
      case PayMethod.cash:
        return "Efectivo";
      case PayMethod.wallet:
        return "Billetera";
      case PayMethod.card:
        return "Tarjeta de credito";
    }
  }
}
