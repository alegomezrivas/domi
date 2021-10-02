import 'package:domi/main.dart';
import 'package:domi/models/user/user.dart';
import 'package:domi/re_use/button_domi_form.dart';
import 'package:domi/re_use/domi_button_continue.dart';
import 'package:domi/re_use/terms_and_conditions.dart';
import 'package:domi/re_use/utils/dialogs.dart';
import 'package:domi/screens/domi_home/domi_home_page.dart';

import 'package:domi/screens/home/home_page.dart';
import 'package:domi/screens/register/domiciliary_form/about_me.dart';
import 'package:domi/screens/register/domiciliary_form/about_vehicle.dart';
import 'package:domi/screens/register/domiciliary_form/confirmation_id.dart';
import 'package:domi/screens/register/domiciliary_form/domi_sliver_app_bar.dart';
import 'package:domi/screens/register/domiciliary_form/driver_license.dart';
import 'package:domi/screens/register/domiciliary_form/identification_document.dart';
import 'package:domi/screens/register/domiciliary_form/referred_code.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class DomiciliaryFormPage extends StatefulWidget {
  @override
  _DomiciliaryFormPageState createState() => _DomiciliaryFormPageState();
}

class _DomiciliaryFormPageState extends State<DomiciliaryFormPage> {
  final ValueNotifier<bool> _loading = ValueNotifier<bool>(false);

  @override
  void dispose() {
    _loading.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Color(0xffF5F5F5),
        body: CustomScrollView(
          slivers: [
            DomiSliverAppBar("Quiero ser repartidor"),
            SliverToBoxAdapter(
              child: Consumer(builder: (context, watch, child) {
                return Column(
                  children: [
                    SizedBox(
                      height: 20,
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 15),
                      child: Column(
                        children: [
                          ButtonDomiForm(
                            text: "Acerca de mi",
                            voidCallback: () {
                              Navigator.of(context).push(MaterialPageRoute(
                                builder: (context) => AboutMe(),
                              ));
                            },
                            valid: watch(registerProvider).validateAboutMe(),
                          ),
                          SizedBox(
                            height: 14,
                          ),
                          ButtonDomiForm(
                            text: "Documento de ID",
                            voidCallback: () {
                              Navigator.of(context).push(MaterialPageRoute(
                                builder: (context) => IdentificationDocument(),
                              ));
                            },
                            valid: watch(registerProvider)
                                .validateIdentification(),
                          ),
                          SizedBox(
                            height: 14,
                          ),
                          ButtonDomiForm(
                            text: "Confirmación de ID",
                            voidCallback: () {
                              Navigator.of(context).push(MaterialPageRoute(
                                builder: (context) => ConfirmationId(),
                              ));
                            },
                            valid: watch(registerProvider).validatePhotoID(),
                          ),
                          SizedBox(
                            height: 14,
                          ),
                          ButtonDomiForm(
                            text: "Licencia de conducir",
                            voidCallback: () {
                              Navigator.of(context).push(MaterialPageRoute(
                                builder: (context) => DriverLicense(),
                              ));
                            },
                            valid:
                                watch(registerProvider).validateDriverLicense(),
                          ),
                          SizedBox(
                            height: 14,
                          ),
                          ButtonDomiForm(
                            text: "Información del vehículo",
                            voidCallback: () {
                              Navigator.of(context).push(MaterialPageRoute(
                                builder: (context) => AboutVehicle(),
                              ));
                            },
                            valid:
                                watch(registerProvider).validateAboutVehicle(),
                          ),
                          SizedBox(
                            height: 14,
                          ),
                          ButtonDomiForm(
                            text: "Código referido (opcional)",
                            voidCallback: () {
                              Navigator.of(context).push(MaterialPageRoute(
                                builder: (context) => ReferredCode(),
                              ));
                            },
                            valid: watch(registerProvider).validateReferCode(),
                          ),
                          SizedBox(
                            height: 18,
                          ),
                          ValueListenableBuilder<bool>(
                              valueListenable: _loading,
                              builder: (context, value, child) {
                                print(watch(registerProvider).validateAll());
                                return DomiContinueButton(
                                  text: "Enviar datos",
                                  disabled:
                                      !(watch(registerProvider).validateAll() &&
                                          !value),
                                  voidCallback:
                                      watch(registerProvider).validateAll() &&
                                              !value
                                          ? watch(registerProvider).covertToDomi
                                              ? _convertToDomi
                                              : _registerDomi
                                          : null,
                                );
                              })
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 18,
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 30),
                      child: TermsAndConditions(),
                    ),
                  ],
                );
              }),
            )
          ],
        ));
  }

  Future<void> _registerDomi() async {
    _loading.value = true;
    try {
      final response =
          await context.read(registerProvider.notifier).registerUser();
      print(response);
      await context.read(authProvider).setUserData(UserData.fromJson(response));
      Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(
            builder: (context) => DomiHomePage(),
          ),
          (route) => false);
    } catch (e) {
      showError(context, e);
    }
    _loading.value = false;
  }

  Future<void> _convertToDomi() async {
    _loading.value = true;
    try {
      final response =
          await context.read(registerProvider.notifier).convertUserToDomi();
      print(response);
      await context.read(authProvider).setUser(response);
      Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(
            builder: (context) => DomiHomePage(),
          ),
              (route) => false);
    } catch (e) {
      showError(context, e);
    }
    _loading.value = false;
  }
}
