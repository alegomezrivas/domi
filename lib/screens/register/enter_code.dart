import 'package:domi/main.dart';
import 'package:domi/models/user/user.dart';
import 'package:domi/models/user/user_app_data.dart';
import 'package:domi/re_use/button_register_login.dart';
import 'package:domi/re_use/domi_register_login.dart';
import 'package:domi/re_use/theme.dart';
import 'package:domi/re_use/utils/dialogs.dart';
import 'package:domi/screens/domi_home/domi_home_page.dart';
import 'package:domi/screens/home/home_page.dart';
import 'package:domi/screens/register/providence_city.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class EnterCoder extends StatefulWidget {
  @override
  _EnterCoderState createState() => _EnterCoderState();
}

class _EnterCoderState extends State<EnterCoder> {
  TextEditingController _textEditingController1 = TextEditingController();
  TextEditingController _textEditingController2 = TextEditingController();
  TextEditingController _textEditingController3 = TextEditingController();
  TextEditingController _textEditingController4 = TextEditingController();
  ButtonRegisterController _registerController = ButtonRegisterController();

  @override
  void dispose() {
    _textEditingController1.dispose();
    _textEditingController2.dispose();
    _textEditingController3.dispose();
    _textEditingController4.dispose();
    _registerController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: inDomiYellow,
      body: DomiRegisterLogin(
        column: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image(
                image: AssetImage("assets/icons/Grupo 8@3x.png"),
                height: 85,
                fit: BoxFit.fitHeight,
              ),
              SizedBox(
                height: 27,
              ),
              Text(
                "Digita el código para continuar:",
                style: TextStyle(color: inDomiBluePrimary, fontSize: 15),
              ),
              SizedBox(
                height: 19,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 70),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Expanded(
                      child: Container(
                        height: 65,
                        decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(16)),
                        child: TextFormField(
                          controller: _textEditingController1,
                          expands: true,
                          maxLength: 1,
                          maxLines: null,
                          minLines: null,
                          inputFormatters: [
                            FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
                          ],
                          style:
                              TextStyle(color: inDomiBluePrimary, fontSize: 25),
                          keyboardType: TextInputType.number,
                          textAlign: TextAlign.center,
                          decoration: InputDecoration(
                            contentPadding: EdgeInsets.only(top: 15, left: 3),
                            counterText: '',
                            isDense: true,
                            border: InputBorder.none,
                          ),
                          onTap: () {
                            _textEditingController1.text = "";
                          },
                          onChanged: (value) {
                            if (value != "") {
                              FocusScope.of(context).nextFocus();
                              _textEditingController2.text = "";
                            }
                          },
                        ),
                      ),
                    ),
                    SizedBox(
                      width: 7,
                    ),
                    Expanded(
                      child: Container(
                        height: 65,
                        decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(16)),
                        child: TextFormField(
                          controller: _textEditingController2,
                          expands: true,
                          maxLength: 1,
                          maxLines: null,
                          minLines: null,
                          inputFormatters: [
                            FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
                          ],
                          style:
                              TextStyle(color: inDomiBluePrimary, fontSize: 25),
                          textAlign: TextAlign.center,
                          keyboardType: TextInputType.number,
                          decoration: InputDecoration(
                            contentPadding: EdgeInsets.only(top: 15, left: 3),
                            counterText: '',
                            isDense: true,
                            border: InputBorder.none,
                          ),
                          onTap: () {
                            _textEditingController2.text = "";
                          },
                          onChanged: (value) {
                            if (value != "") {
                              FocusScope.of(context).nextFocus();
                              _textEditingController3.text = "";
                            }
                          },
                        ),
                      ),
                    ),
                    SizedBox(
                      width: 7,
                    ),
                    Expanded(
                      child: Container(
                        height: 65,
                        decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(16)),
                        child: TextFormField(
                          controller: _textEditingController3,
                          inputFormatters: [
                            FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
                          ],
                          style:
                              TextStyle(color: inDomiBluePrimary, fontSize: 25),
                          expands: true,
                          maxLength: 1,
                          maxLines: null,
                          minLines: null,
                          keyboardType: TextInputType.number,
                          textAlign: TextAlign.center,
                          decoration: InputDecoration(
                            contentPadding: EdgeInsets.only(top: 15, left: 3),
                            counterText: '',
                            isDense: true,
                            border: InputBorder.none,
                          ),
                          onTap: () {
                            _textEditingController3.text = "";
                          },
                          onChanged: (value) {
                            if (value != "") {
                              FocusScope.of(context).nextFocus();
                              _textEditingController4.text = "";
                            }
                          },
                        ),
                      ),
                    ),
                    SizedBox(
                      width: 7,
                    ),
                    Expanded(
                      child: Container(
                        height: 65,
                        decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(16)),
                        child: TextFormField(
                          controller: _textEditingController4,
                          expands: true,
                          maxLength: 1,
                          maxLines: null,
                          minLines: null,
                          inputFormatters: [
                            FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
                          ],
                          style:
                              TextStyle(color: inDomiBluePrimary, fontSize: 25),
                          keyboardType: TextInputType.number,
                          textAlign: TextAlign.center,
                          decoration: InputDecoration(
                            contentPadding: EdgeInsets.only(top: 15, left: 3),
                            counterText: '',
                            isDense: true,
                            border: InputBorder.none,
                          ),
                          onChanged: (value) => _validate(value),
                          onEditingComplete: () =>
                              _validate(_textEditingController4.text),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 20,
              ),
              ButtonRegisterLogin(
                height: 38,
                width: 300,
                controller: _registerController,
                voidCallback: _checkCode,
                text: Text("Siguiente",
                    style: TextStyle(
                        fontSize: 15,
                        color: Colors.white,
                        fontWeight: FontWeight.w600)),
              ),
              SizedBox(
                height: 20,
              ),
              InkWell(
                onTap: () {
                  Navigator.of(context).pop();
                },
                child: Text("No recibí el código",
                    style: TextStyle(
                        fontSize: 13,
                        color: inDomiBluePrimary,
                        decoration: TextDecoration.underline)),
              )
            ],
          ),
        ),
      ),
    );
  }

  void _validate(String value) {
    if (value.isNotEmpty) {
      if (_textEditingController1.text.isNotEmpty &&
          _textEditingController2.text.isNotEmpty &&
          _textEditingController3.text.isNotEmpty &&
          _textEditingController4.text.isNotEmpty) {
        FocusScope.of(context).unfocus();
      }
    }
  }

  void _checkCode() async {
    if (_textEditingController1.text.isEmpty ||
        _textEditingController2.text.isEmpty ||
        _textEditingController3.text.isEmpty ||
        _textEditingController4.text.isEmpty) {
      return;
    }
    _registerController.toggle();
    try {
      final register = context.read(registerProvider.notifier);
      final response = await register.checkCode(
          "${_textEditingController1.text}${_textEditingController2.text}${_textEditingController3.text}${_textEditingController4.text}");
      print(response["user"]);
      if (response["token"] != null) {
        await context
            .read(authProvider)
            .setUserData(UserData.fromJson(response));
        if (context.read(authProvider).userData!.user.isDomi) {
          Navigator.of(context).pushReplacement(MaterialPageRoute(
            builder: (context) => DomiHomePage(),
          ));
        } else {
          Navigator.of(context).pushReplacement(MaterialPageRoute(
            builder: (context) => HomePage(),
          ));
        }
      } else {
        Navigator.of(context).pushReplacement(MaterialPageRoute(
          builder: (context) => ProvidenceCity(),
        ));
      }
    } catch (e) {
      showError(context, e);
      if (e is Map<String, dynamic>) {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text(e["error"] ?? "")));
      } else {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text("Se ha producido un error intente mas tarde")));
      }
    }
    _registerController.toggle();
  }
}
