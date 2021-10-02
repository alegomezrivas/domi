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
  bool _isValidated = false;

  @override
  void initState() { 
    super.initState();
    _isValidated = context.read(registerProvider.notifier).validator();
  }

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
                            voidCallback: () async {
                              await _navigateAndDisplaySelection(
                                  context, AboutMe());
                            },
                            valid: watch(registerProvider).validateAboutMe(),
                          ),
                          SizedBox(
                            height: 14,
                          ),
                          ButtonDomiForm(
                            text: "Documento de ID",
                            voidCallback: () async {
                              await _navigateAndDisplaySelection(
                                  context, IdentificationDocument());
                            },
                            valid: watch(registerProvider)
                                .validateIdentification(),
                          ),
                          SizedBox(
                            height: 14,
                          ),
                          ButtonDomiForm(
                            text: "Confirmación de ID",
                            voidCallback: () async {
                              await _navigateAndDisplaySelection(
                                  context, ConfirmationId());
                            },
                            valid: watch(registerProvider).validatePhotoID(),
                          ),
                          SizedBox(
                            height: 14,
                          ),
                          ButtonDomiForm(
                            text: "Información del vehículo",
                            voidCallback: () async {
                              await _navigateAndDisplaySelection(
                                  context, AboutVehicle());
                            },
                            valid: watch(registerProvider).selectType == 1
                                ? watch(registerProvider)
                                    .validateAboutVehicleBike()
                                : watch(registerProvider)
                                    .validateAboutVehicle(),
                          ),
                          SizedBox(
                            height: 14,
                          ),
                          Visibility(
                            visible: watch(registerProvider).selectType != 1,
                            child: ButtonDomiForm(
                              text: "Licencia de conducir",
                              voidCallback: () async {
                                await _navigateAndDisplaySelection(
                                    context, DriverLicense());
                              },
                              valid:
                                  watch(registerProvider).validateDriverLicense(),
                              ),
                          ),
                          Visibility(
                            visible: watch(registerProvider).selectType != 1,
                            child: SizedBox(
                              height: 14,
                            ),
                          ),
                          ButtonDomiForm(
                            text: "Código referido (opcional)",
                            voidCallback: () async {
                              await _navigateAndDisplaySelection(
                                  context, ReferredCode());
                            },
                            valid: watch(registerProvider).validateReferCode(),
                          ),
                          SizedBox(
                            height: 18,
                          ),
                          ValueListenableBuilder<bool>(
                              valueListenable: _loading,
                              builder: (context, value, child) {
                                return DomiContinueButton(
                                  text: "Enviar datos",
                                  disabled: !(_isValidated && !value),
                                  voidCallback: _isValidated && !value
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
        MaterialPageRoute(builder: (context) => DomiHomePage()),
        (route) => false,
      );
    } catch (e) {
      showError(context, e);
    }
    _loading.value = false;
  }

  Future<void> _navigateAndDisplaySelection(
      BuildContext context, Widget widget) async {
    // Navigator.push returns a Future that completes after calling
    // Navigator.pop on the Selection Screen.
    final result = await Navigator.of(context).push(
      // Create the SelectionScreen in the next step.
      MaterialPageRoute(builder: (context) => widget),
    );
    if (result != null && result == 1) {
      setState(() {
        _isValidated = context.read(registerProvider.notifier).validator();
      });
    }
  }
}
