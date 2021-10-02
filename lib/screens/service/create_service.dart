import 'dart:async';

import 'package:domi/core/classes/geo.dart';
import 'package:domi/core/enum/service_enums.dart';
import 'package:domi/core/extensions/string.dart';
import 'package:domi/main.dart';
import 'package:domi/models/general/domi_params.dart';
import 'package:domi/provider/service/create_service_provider.dart';
import 'package:domi/re_use/button_register_login.dart';
import 'package:domi/re_use/geo_widgets/domi_search_autocomplete.dart';
import 'package:domi/re_use/indomi_text_form_field.dart';
import 'package:domi/re_use/message_strings.dart';
import 'package:domi/re_use/theme.dart';
import 'package:domi/re_use/utils/dialogs.dart';
import 'package:domi/re_use/utils/domi_format.dart';
import 'package:domi/screens/home/service/deliveries_available.dart';
import 'package:domi/screens/home/service/payment_method.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class CreateService extends StatefulWidget {
  final ServiceType serviceType;

  CreateService(this.serviceType);

  @override
  _CreateServiceState createState() => _CreateServiceState();
}

class _CreateServiceState extends State<CreateService> {
  ValueNotifier<double> _price = ValueNotifier<double>(0);
  Timer? _timer;
  GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  ButtonRegisterController _buttonController = ButtonRegisterController();

  @override
  void initState() {
    context.read(createServiceProvider).serviceType = widget.serviceType;
    super.initState();
    Future.microtask(() {
      context.read(createServiceProvider.notifier).getVariables();
    });
  }

  @override
  void dispose() {
    _price.dispose();
    _buttonController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        body: SafeArea(child: Consumer(builder: (context, watch, child) {
          final createServiceState = watch(createServiceProvider);
          final domiParams = createServiceState.domiParams;
          if (domiParams == null) {
            return Center(
              child: CircularProgressIndicator(strokeWidth: 2),
            );
          }
          return SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(top: 20),
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
                  Text(
                    "¿En qué podemos ayudarte hoy?",
                    style: TextStyle(color: inDomiBluePrimary, fontSize: 14),
                  ),
                  Divider(
                    color: Colors.black26,
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  Container(
                    width: double.maxFinite,
                    height: 44,
                    decoration: BoxDecoration(
                        color: Colors.white,
                        border: Border.all(width: 1, color: Colors.black12),
                        borderRadius: BorderRadius.circular(19)),
                    child: DropdownButtonFormField<ServiceType>(
                      value: createServiceState.serviceType,
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        contentPadding: EdgeInsets.only(left: 16, right: 16),
                      ),
                      items: [
                        DropdownMenuItem<ServiceType>(
                          child: Text(
                            "Domicilio de comida",
                            style:
                                TextStyle(color: inDomiGreyBlack, fontSize: 14),
                          ),
                          value: ServiceType.food,
                        ),
                        DropdownMenuItem<ServiceType>(
                          child: Text(
                            "Enviar paquete",
                            style:
                                TextStyle(color: inDomiGreyBlack, fontSize: 14),
                          ),
                          value: ServiceType.pack,
                        ),
                        DropdownMenuItem<ServiceType>(
                          child: Text(
                            "Enviar documentos",
                            style:
                                TextStyle(color: inDomiGreyBlack, fontSize: 14),
                          ),
                          value: ServiceType.document,
                        ),
                      ],
                      onChanged: (value) {
                        context
                            .read(createServiceProvider.notifier)
                            .setServiceType(value!);
                      },
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Form(
                    key: _formKey,
                    child: Column(
                      children: List.generate(
                          createServiceState.wayPoints.length, (index) {
                        return Column(
                          children: [
                            InkWell(
                              onTap: () {
                                print(createServiceState.wayPoints[index]);
                                showPredictions(index);
                              },
                              child: IndomiTextFormField(
                                controller: createServiceState.wayPoints[index]
                                    ["controller"],
                                enabledNumber: false,
                                textAlign: TextAlign.left,
                                pointYellow: true,
                                hintText: index ==
                                        createServiceState.wayPoints.length - 1
                                    ? "¿En donde entregamos?"
                                    : "Calle 78 #55-77",
                                radius: 19,
                                width: double.maxFinite,
                                edgeInsetsGeometry:
                                    EdgeInsets.only(left: 16, top: 10),
                                color: Color(0xffF5F5F5),
                                suffix: createServiceState.wayPoints.length > 2
                                    ? IconButton(
                                        icon: Icon(
                                          Icons.remove_circle,
                                          color: Colors.red,
                                        ),
                                        onPressed: () {
                                          context
                                              .read(createServiceProvider
                                                  .notifier)
                                              .removeWaypoint(createServiceState
                                                  .wayPoints[index]["id"]);
                                        },
                                      )
                                    : null,
                                validator: (value) {
                                  if (value!.isEmpty) {
                                    return REQUIRED_MESSAGE;
                                  }
                                  return null;
                                },
                              ),
                            ),
                            SizedBox(
                              height: 12,
                            ),
                          ],
                        );
                      }),
                    ),
                  ),
                  if (createServiceState.wayPoints.length < 5)
                    InkWell(
                      onTap: () {
                        context
                            .read(createServiceProvider.notifier)
                            .addWayPoint();
                      },
                      child: Padding(
                        padding: const EdgeInsets.all(4.0),
                        child: Text(
                          "+ Agregar nuevas paradas",
                          style: TextStyle(
                              color: inDomiBluePrimary,
                              fontSize: 11,
                              decoration: TextDecoration.underline),
                        ),
                      ),
                    ),
                  SizedBox(
                    height: 20,
                  ),
                  if (createServiceState.serviceType == ServiceType.pack)
                    packWidget(createServiceState, domiParams),
                  Text(
                    "Selecciona la tarifa a ofrecer",
                    style: TextStyle(color: inDomiBluePrimary, fontSize: 14),
                  ),
                  Divider(
                    color: Colors.black26,
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      InkWell(
                        onTap: () {
                          context
                              .read(createServiceProvider.notifier)
                              .decrementOffer();
                        },
                        child: Container(
                          height: 37,
                          width: 77,
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                              color: inDomiYellow,
                              borderRadius: BorderRadius.circular(19)),
                          child: Text(
                            "- ${DomiFormat.formatCurrencyCustom(domiParams.params.serviceIncDec)}",
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 14,
                                color: inDomiGreyBlack),
                          ),
                        ),
                      ),
                      SizedBox(
                        width: 6,
                      ),
                      Container(
                        height: 37,
                        width: 147,
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(19),
                            border:
                                Border.all(color: Colors.black12, width: 1)),
                        child: Text(
                          DomiFormat.formatCurrencyCustom(
                              createServiceState.offer),
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 14,
                              color: inDomiGreyBlack),
                        ),
                      ),
                      SizedBox(
                        width: 6,
                      ),
                      InkWell(
                        onTap: () {
                          context
                              .read(createServiceProvider.notifier)
                              .incrementOffer();
                        },
                        child: Container(
                          height: 37,
                          width: 77,
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                              color: inDomiYellow,
                              borderRadius: BorderRadius.circular(19)),
                          child: Text(
                            "+ ${DomiFormat.formatCurrencyCustom(domiParams.params.serviceIncDec)}",
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 14,
                                color: inDomiGreyBlack),
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  if (domiParams.params.userTaxPercent != 0)
                    Text(
                      "+ ${DomiFormat.formatCurrencyCustom(domiParams.params.userTaxPercent)}% de tarifa de servicio",
                      style: TextStyle(fontSize: 11, color: inDomiGreyBlack),
                    ),
                  if (domiParams.params.userTaxPercent != 0)
                    SizedBox(
                      height: 13,
                    ),
                  Text(
                    "Seleccionar método de pago",
                    style: TextStyle(color: inDomiBluePrimary, fontSize: 14),
                  ),
                  Divider(
                    color: Colors.black26,
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Container(
                    height: 37,
                    width: double.maxFinite,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                        color: inDomiYellow,
                        borderRadius: BorderRadius.circular(19),
                        border: Border.all(color: Colors.black12, width: 1)),
                    child: Text(
                      createServiceState.payMethodDescription(),
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                          color: inDomiGreyBlack),
                    ),
                  ),
                  SizedBox(
                    height: 2,
                  ),
                  InkWell(
                    onTap: () {
                      Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => PaymentMethodPage(),
                      ));
                    },
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        "Cambiar método de pago",
                        style: TextStyle(
                            color: inDomiBluePrimary,
                            fontSize: 12,
                            decoration: TextDecoration.underline),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 12,
                  ),
                  Text(
                    "¿Cuánto debe cancelar el Domi en el lugar?",
                    style: TextStyle(color: inDomiBluePrimary, fontSize: 14),
                  ),
                  Divider(
                    color: Colors.black26,
                  ),
                  Container(
                    width: double.maxFinite,
                    height: 44,
                    decoration: BoxDecoration(
                        color: Colors.white,
                        border: Border.all(width: 1, color: Colors.black12),
                        borderRadius: BorderRadius.circular(19)),
                    child: DropdownButtonFormField<double>(
                      value: createServiceState.cancelInPlace,
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        contentPadding: EdgeInsets.only(left: 16, right: 16),
                      ),
                      hint: Text(
                        "Domicilio de comida",
                        style: TextStyle(color: inDomiGreyBlack, fontSize: 14),
                      ),
                      items: [
                        DropdownMenuItem(
                          child: Text(
                            "Nada",
                            style:
                                TextStyle(color: inDomiGreyBlack, fontSize: 14),
                          ),
                          value: 0,
                        ),
                        DropdownMenuItem(
                          child: Text(
                            "Menos de \$50.000",
                            style:
                                TextStyle(color: inDomiGreyBlack, fontSize: 14),
                          ),
                          value: 50000,
                        ),
                        DropdownMenuItem(
                          child: Text(
                            "Entre \$50.000 y \$100.000",
                            style:
                                TextStyle(color: inDomiGreyBlack, fontSize: 14),
                          ),
                          value: 100000,
                        ),
                        DropdownMenuItem(
                          child: Text(
                            "Más de \$100.000",
                            style:
                                TextStyle(color: inDomiGreyBlack, fontSize: 14),
                          ),
                          value: 200000,
                        ),
                      ],
                      onChanged: (value) {
                        createServiceState.cancelInPlace = value!;
                      },
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Text(
                    "¿Alguna instrucción adicional?",
                    style: TextStyle(color: inDomiBluePrimary, fontSize: 14),
                  ),
                  Divider(
                    color: Colors.black26,
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  IndomiTextFormField(
                    height: 53,
                    textAlign: TextAlign.left,
                    hintText: "¡Escribe la instrucción aquí!",
                    maxLength: 500,
                    maxLines: 4,
                    minLines: 4,
                    radius: 19,
                    width: double.maxFinite,
                    edgeInsetsGeometry: EdgeInsets.only(left: 16, top: 10),
                    color: Color(0xffF5F5F5),
                    onChanged: (value) {
                      createServiceState.observation = value;
                    },
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Consumer(
                    builder: (context, watch, child) {
                      return ButtonRegisterLogin(
                        height: 44,
                        width: double.maxFinite,
                        voidCallback: _createService,
                        controller: _buttonController,
                        text: Text(
                            "Buscar Repartidor por ${DomiFormat.formatCurrencyCustom(watch(totalServiceProvider))}",
                            style: TextStyle(
                                fontSize: 15,
                                color: Colors.white,
                                fontWeight: FontWeight.w600)),
                      );
                    },
                  ),
                  SizedBox(
                    height: 20,
                  )
                ],
              ),
            ),
          );
        })));
  }

  Future<void> _createService() async {
    FocusScope.of(context).unfocus();

    if (!_formKey.currentState!.validate()) {
      snackBarMessage(context, "¡Debes agregar las direcciones de tu servicio!",
          type: SnackBarDomiType.error);
      return;
    }

    if (!(await checkOfferValue())) {
      return;
    }

    try {
      _buttonController.toggle();
      final response =
          await context.read(createServiceProvider.notifier).createService();
      print(response);
      Navigator.of(context).push(MaterialPageRoute(
        builder: (context) => DeliveriesAvailable(response["id"]),
      ));
    } catch (e) {
      showError(context, e);
    }
    _buttonController.toggle();
  }

  Future<bool> checkOfferValue() async {
    final domiParams = context.read(createServiceProvider).domiParams!.params;

    if (domiParams.kmValue.toDouble() == 0) {
      return true;
    }
    final totalDistance =
        getTotalDistance(context.read(createServiceProvider).getWaypoints())
            .toInt();
    final suggestedValue = domiParams.minServiceValue.toDouble() +
        ((totalDistance - 3) * domiParams.kmValue.toDouble());
    if (totalDistance > 3) {
      if (context.read(createServiceProvider).offer < suggestedValue) {
        final response = await showConfirmationDialog(context,
            text:
                "Tu oferta es demasiado baja, te recomendamos ofrecer \n${DomiFormat.formatCurrencyCustom(suggestedValue)}",
            positiveButton: "Continuar de todas formas");
        if (response == null) {
          return false;
        }
      }
    }
    return true;
  }

  Widget packWidget(CreateServiceState state, DomiParams domiParams) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(
          "Selecciona un tamaño de paquete",
          style: TextStyle(color: inDomiBluePrimary, fontSize: 14),
        ),
        Divider(
          color: Colors.black26,
        ),
        SizedBox(
          height: 5,
        ),
        Container(
          width: double.maxFinite,
          height: 44,
          decoration: BoxDecoration(
              color: Colors.white,
              border: Border.all(width: 1, color: Colors.black12),
              borderRadius: BorderRadius.circular(19)),
          child: DropdownButtonFormField<Package>(
            value: state.package,
            decoration: InputDecoration(
              border: InputBorder.none,
              contentPadding: EdgeInsets.only(left: 16, right: 16),
            ),
            items: state.domiParams!.packages
                .map((e) => DropdownMenuItem<Package>(
                      child: Text(
                        "${e.name} (${e.description})",
                        style: TextStyle(color: inDomiGreyBlack, fontSize: 14),
                      ),
                      value: e,
                    ))
                .toList(),
            onChanged: (value) {
              context.read(createServiceProvider).package = value;
            },
          ),
        ),
        SizedBox(
          height: 20,
        ),
        Text(
          "Peso aproximado",
          style: TextStyle(color: inDomiBluePrimary, fontSize: 14),
        ),
        Divider(
          color: Colors.black26,
        ),
        SizedBox(
          height: 5,
        ),
        Container(
          width: double.maxFinite,
          height: 44,
          decoration: BoxDecoration(
              color: Colors.white,
              border: Border.all(width: 1, color: Colors.black12),
              borderRadius: BorderRadius.circular(19)),
          child: DropdownButtonFormField<int>(
            value: state.packageWeight,
            decoration: InputDecoration(
              border: InputBorder.none,
              contentPadding: EdgeInsets.only(left: 16, right: 16),
            ),
            items: [
              DropdownMenuItem(
                child: Text(
                  "Menos de 1 Kg",
                  style: TextStyle(color: inDomiGreyBlack, fontSize: 14),
                ),
                value: 1,
              ),
              DropdownMenuItem(
                child: Text(
                  "Entre 1 y 5 kgs",
                  style: TextStyle(color: inDomiGreyBlack, fontSize: 14),
                ),
                value: 2,
              ),
              DropdownMenuItem(
                child: Text(
                  "Entre 5 y 10 kgs",
                  style: TextStyle(color: inDomiGreyBlack, fontSize: 14),
                ),
                value: 3,
              ),
              DropdownMenuItem(
                child: Text(
                  "Superior a 10 Kgs",
                  style: TextStyle(color: inDomiGreyBlack, fontSize: 14),
                ),
                value: 4,
              ),
            ],
            onChanged: (value) {
              context.read(createServiceProvider).packageWeight = value!;
            },
          ),
        ),
        SizedBox(
          height: 20,
        ),
        Text(
          "Asegura tu envío",
          style: TextStyle(color: inDomiBluePrimary, fontSize: 14),
        ),
        Divider(
          color: Colors.black26,
        ),
        SizedBox(
          height: 10,
        ),
        ValueListenableBuilder<double>(
            valueListenable: _price,
            builder: (context, value, child) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(
                        "Selecciona el valor declarado",
                        style: TextStyle(fontSize: 11, color: inDomiGreyBlack),
                      ),
                      Spacer(),
                      Text(
                        "Valor: ${DomiFormat.formatCurrencyCustom(value)}",
                        style: TextStyle(fontSize: 11, color: inDomiGreyBlack),
                      ),
                    ],
                  ),
                  Slider(
                    value: _price.value,
                    label: DomiFormat.formatCurrencyCustom(value),
                    min: 0,
                    max: domiParams.params.insuranceMaxValue.toDouble(),
                    divisions: 100,
                    activeColor: inDomiYellow,
                    onChanged: (value) {
                      _price.value = value;
                      if (_timer != null) {
                        if (_timer!.isActive) _timer!.cancel();
                      }
                      _timer = Timer(Duration(milliseconds: 200), () {
                        state.insurance = value;
                        context.read(totalServiceProvider.notifier).setTotal =
                            state.getTotal;
                      });
                    },
                  ),
                ],
              );
            }),
        Row(
          children: [
            Column(
              children: [
                Text(
                  "Mín.",
                  style: TextStyle(fontSize: 11, color: inDomiGreyBlack),
                ),
                Text(
                  "\$0",
                  style: TextStyle(fontSize: 11, color: inDomiGrey),
                ),
              ],
            ),
            Spacer(),
            Column(
              children: [
                Text(
                  "Máx.",
                  style: TextStyle(fontSize: 11, color: inDomiGreyBlack),
                ),
                Text(
                  domiParams.params.insuranceMaxValue
                      .toCurrency(decimalPlaces: 0),
                  style: TextStyle(fontSize: 11, color: inDomiGrey),
                ),
              ],
            ),
          ],
        ),
        SizedBox(
          height: 20,
        ),
      ],
    );
  }

  showPredictions(int wayPoint) {
    final media = MediaQuery.of(context).size;
    showModalBottomSheet(
      isScrollControlled: true,
      context: context,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
            topLeft: Radius.circular(10.0), topRight: Radius.circular(10.0)),
      ),
      builder: (context) {
        return Container(
          height: media.height * 0.8,
          child: IndomiSearchAutocomplete(
            hintText: "Escribe la dirección",
            showAddressBook: true,
            country: context
                .read(authProvider)
                .userData!
                .user
                .person
                .city
                .countryName,
            onSelectAnPlace: (value) {
              context
                  .read(createServiceProvider.notifier)
                  .updateWaypoints(wayPoint, value["name"] ?? "", value);
              Navigator.of(context).pop();
            },
          ),
        );
      },
    );
  }
}
