import 'package:domi/core/network/api_keys.dart';
import 'package:domi/main.dart';
import 'package:domi/models/general/country.dart';
import 'package:domi/provider/register/register_provider.dart';
import 'package:domi/re_use/button_register_login.dart';
import 'package:domi/re_use/domi_register_login.dart';
import 'package:domi/re_use/indomi_text_form_field.dart';

import 'package:domi/re_use/message_strings.dart';
import 'package:domi/re_use/privacy.dart';

import 'package:domi/re_use/theme.dart';
import 'package:domi/re_use/utils/dialogs.dart';
import 'package:domi/repositories/general_repository.dart';
import 'package:domi/screens/register/enter_code.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class EnterNumber extends StatefulWidget {
  @override
  _EnterNumberState createState() => _EnterNumberState();
}

class _EnterNumberState extends State<EnterNumber> {
  TextEditingController _number = TextEditingController();
  GlobalKey<FormState> formState = GlobalKey<FormState>();
  ValueNotifier<List<Country>> _countries = ValueNotifier<List<Country>>([]);
  Country? _selectedCountry;
  ButtonRegisterController _registerController = ButtonRegisterController();
  int _retries = 0;

  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      getCountryData();
    });
  }

  getCountryData() async {
    try {
      final value = await GeneralRepository.getCountries();
      if (value.isNotEmpty) {
        _selectedCountry = value.first;
        _countries.value = value;
      }
    } catch (e) {
      await Future.delayed(Duration(seconds: 5));
      if (_retries < 4) {
        _retries++;
        getCountryData();
      }
    }
  }

  @override
  void dispose() {
    _countries.dispose();
    _registerController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final media = MediaQuery.of(context);
    return Scaffold(
      backgroundColor: inDomiYellow,
      body: DomiRegisterLogin(
        column: SingleChildScrollView(
          child: Form(
            key: formState,
            child: Container(
              height: media.size.height,
              width: media.size.width,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image(
                    image: AssetImage("assets/icons/Grupo 8@3x.png"),
                    height: 80,
                    fit: BoxFit.fitHeight,
                  ),
                  SizedBox(
                    height: 27,
                  ),
                  Text(
                    "Digita el número de celular para continuar:",
                    style: TextStyle(color: inDomiBluePrimary, fontSize: 15),
                  ),
                  SizedBox(
                    height: 19,
                  ),
                  ValueListenableBuilder<List<Country>>(
                      valueListenable: _countries,
                      builder: (context, value, child) {
                        return Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                              alignment: Alignment.center,
                              width: 96,
                              height: 44,
                              decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(19)),
                              child: DropdownButtonFormField<Country>(
                                  value: _selectedCountry,
                                  decoration: InputDecoration(
                                    border: InputBorder.none,
                                    isDense: true,
                                  ),
                                  onChanged: (value) {},
                                  items: value
                                      .map((e) => DropdownMenuItem<Country>(
                                          value: e,
                                          child: Row(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.center,
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              Padding(
                                                padding: const EdgeInsets.only(
                                                    right: 6, left: 10),
                                                child: Image(
                                                  image: NetworkImage(e.icon!),
                                                  height: 24,
                                                  width: 24,
                                                ),
                                              ),
                                              Text("+${e.phoneCode}"),
                                            ],
                                          )))
                                      .toList()),
                            ),
                            SizedBox(
                              width: 7,
                            ),
                            IndomiTextFormField(
                              width: 163,
                              formatters: [
                                FilteringTextInputFormatter.allow(
                                    RegExp(r'[0-9]')),
                              ],
                              keyboardType: TextInputType.number,
                              validator: (value) {
                                if (value == "") {
                                  return REQUIRED_MESSAGE;
                                }
                                if (value!.length < 10) {
                                  return NOT_VALID_NUMBER_MESSAGE;
                                }
                                return null;
                              },
                              maxLength: 10,
                              maxLines: 1,
                              controller: _number,
                              hintText: "Número telefónico",
                            ),
                          ],
                        );
                      }),
                  // if (_number.text.isEmpty)
                  //   Text(
                  //     "Campo vacio",
                  //     style: TextStyle(color: Colors.red, fontSize: 12),
                  //   ),
                  SizedBox(
                    height: 10,
                  ),
                  ButtonRegisterLogin(
                    height: 38,
                    width: 270,
                    controller: _registerController,
                    voidCallback: _sendCode,
                    text: Text("Siguiente",
                        style: TextStyle(
                            fontSize: 15,
                            color: Colors.white,
                            fontWeight: FontWeight.w600)),
                  ),
                  SizedBox(
                    height: 30,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 30),
                    child: Privacy(),
                  ),
                  Text(kVERSION,
                      style: TextStyle(fontSize: 11, color: inDomiGreyBlack))
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  _sendCode() async {
    FocusScope.of(context).unfocus();
    if (!formState.currentState!.validate() || _selectedCountry == null) {
      return;
    }
    _registerController.toggle();
    try {
      final RegisterNotifier register = context.read(registerProvider.notifier);
      register.setPhoneData(_selectedCountry!, _number.text);
      await register.sendCode();
      Navigator.of(context).push(MaterialPageRoute(
        builder: (context) => EnterCoder(),
      ));
    } catch (e) {
      showError(context, e);
    }
    _registerController.toggle();
  }
}
