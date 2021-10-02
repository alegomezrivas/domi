import 'package:domi/main.dart';
import 'package:domi/re_use/button_domi_form.dart';
import 'package:domi/re_use/button_upload_photo.dart';
import 'package:domi/re_use/domi_button_continue.dart';
import 'package:domi/re_use/indomi_text_form_field.dart';
import 'package:domi/re_use/message_strings.dart';
import 'package:domi/re_use/register/need_help_widget.dart';
import 'package:domi/re_use/theme.dart';
import 'package:domi/re_use/utils/dialogs.dart';
import 'package:domi/screens/register/domiciliary_form/domi_sliver_app_bar.dart';
import 'package:domi/screens/register/domiciliary_form/property_card.dart';
import 'package:domi/screens/register/domiciliary_form/soat.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AboutVehicle extends StatefulWidget {
  @override
  _AboutVehicleState createState() => _AboutVehicleState();
}

class _AboutVehicleState extends State<AboutVehicle> {
  TextEditingController _plate = TextEditingController();
  GlobalKey<FormState> _formState = GlobalKey<FormState>();
  int _selectedType = 2;
  String? frontVehicleKey;
  bool showRequired = false;
  ValueNotifier<bool> _frontLoading = ValueNotifier<bool>(false);

  @override
  void initState() {
    final register = context.read(registerProvider);
    _selectedType = register.selectType ?? 2;
    _plate.text = register.plateNumber ?? "";
    frontVehicleKey = register.vehicleFront;
    super.initState();
  }

  @override
  void dispose() {
    _plate.dispose();
    _frontLoading.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Color(0xffF5F5F5),
        body: CustomScrollView(
          slivers: [
            DomiSliverAppBar("Sobre el vehículo"),
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Form(
                  key: _formState,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      SizedBox(
                        height: 25,
                      ),
                      Container(
                        width: double.maxFinite,
                        height: 44,
                        decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(9)),
                        child: DropdownButtonFormField<int>(
                          value: _selectedType,
                          decoration: InputDecoration(
                              border: InputBorder.none,
                              contentPadding: EdgeInsets.only(left: 16)),
                          hint: Text(
                            "Tipo de vehículo",
                            style:
                                TextStyle(color: inDomiGreyBlack, fontSize: 14),
                          ),
                          items: [
                            DropdownMenuItem(
                              child: Text(
                                "Bicicleta / Ciclomotor",
                                style: TextStyle(
                                    color: inDomiGreyBlack, fontSize: 14),
                              ),
                              value: 1,
                            ),
                            DropdownMenuItem(
                              child: Text(
                                "Moto",
                                style: TextStyle(
                                    color: inDomiGreyBlack, fontSize: 14),
                              ),
                              value: 2,
                            ),
                            DropdownMenuItem(
                              child: Text(
                                "Carro",
                                style: TextStyle(
                                    color: inDomiGreyBlack, fontSize: 14),
                              ),
                              value: 3,
                            ),
                          ],
                          onChanged: (value) {
                            setState(() {
                              _selectedType = value!;
                            });
                          },
                        ),
                      ),
                      SizedBox(
                        height: 16,
                      ),
                      Visibility(
                        visible: _selectedType != 1,
                        child: IndomiTextFormField(
                          hintText: "Placa",
                          radius: 9,
                          maxLength: 6,
                          width: double.maxFinite,
                          controller: _plate,
                          edgeInsetsGeometry: EdgeInsets.only(left: 16),
                          validator: (value) {
                            if (value!.isEmpty) {
                              return REQUIRED_MESSAGE;
                            }
                          },
                        ),
                      ),
                      Visibility(
                        visible: _selectedType != 1,
                        child: SizedBox(
                          height: 14,
                        ),
                      ),
                      Visibility(
                        visible: _selectedType != 1,
                        child: ValueListenableBuilder<bool>(
                            valueListenable: _frontLoading,
                            builder: (context, value, child) {
                              return ButtonUploadPhoto(
                                title: "Foto del vehículo",
                                subTitle: "(Subir foto de frente)",
                                onImageSelected: (value) async {
                                  try {
                                    _frontLoading.value = true;
                                    frontVehicleKey = await context
                                        .read(registerProvider.notifier)
                                        .uploadImageFromPathRegister(value);
                                  } catch (e) {
                                    showError(context, e);
                                  }
                                  _frontLoading.value = false;
                                },
                                valid: frontVehicleKey != null,
                                loading: value,
                              );
                            }),
                      ),
                      if (frontVehicleKey == null && showRequired)
                        messageErrorWidget(REQUIRED_MESSAGE),
                      Consumer(builder: (context, watch, child) {
                        return Column(
                          children: [
                            Visibility(
                              visible: _selectedType != 1,
                              child: SizedBox(
                                height: 14,
                              ),
                            ),
                            Visibility(
                              visible: _selectedType != 1,
                              child: ButtonDomiForm(
                                text: "SOAT",
                                voidCallback: () {
                                  FocusScope.of(context).unfocus();
                                  Navigator.of(context).push(MaterialPageRoute(
                                    builder: (context) => Soat(),
                                  ));
                                },
                                valid: watch(registerProvider).validateSoat(),
                                elevate: 0,
                              ),
                            ),
                            if (!watch(registerProvider).validateSoat() &&
                                showRequired)
                              messageErrorWidget(REQUIRED_MESSAGE),
                            Visibility(
                              visible: _selectedType != 1,
                              child: SizedBox(
                                height: 14,
                              ),
                            ),
                            Visibility(
                              visible: _selectedType != 1,
                              child: ButtonDomiForm(
                                text: "Tarjeta de propiedad",
                                voidCallback: () {
                                  FocusScope.of(context).unfocus();
                                  Navigator.of(context).push(MaterialPageRoute(
                                    builder: (context) => PropertyCard(),
                                  ));
                                },
                                valid: watch(registerProvider)
                                    .validatePropertyCard(),
                                elevate: 0,
                              ),
                            ),
                            if (!watch(registerProvider)
                                    .validatePropertyCard() &&
                                showRequired)
                              messageErrorWidget(REQUIRED_MESSAGE),
                            Visibility(
                              visible: _selectedType != 1,
                              child: SizedBox(
                                height: 14,
                              ),
                            ),
                            DomiContinueButton(voidCallback: _saveInfo),
                          ],
                        );
                      }),
                      SizedBox(
                        height: _selectedType == 1 ? 390 : 180,
                      ),
                      NeedHelpWidget(),
                    ],
                  ),
                ),
              ),
            )
          ],
        ));
  }

  Future<void> _saveInfo() async {
    // if is bike don't validate other fields
    if (_selectedType == 1) {
      // Check with the backend team what data is sent if the bike option is selected.
      context
          .read(registerProvider.notifier)
          .setAboutVehicleBike(_selectedType);
      Navigator.of(context).pop(1);
    } else {
      if (!_formState.currentState!.validate() ||
          frontVehicleKey == null ||
          !context.read(registerProvider).validatePropertyCard() ||
          !context.read(registerProvider).validateSoat()) {
        setState(() {
          showRequired = true;
        });
        return;
      }
      context
          .read(registerProvider.notifier)
          .setAboutVehicle(_selectedType, _plate.text, frontVehicleKey!);
      Navigator.of(context).pop(1);
    }
  }
}
