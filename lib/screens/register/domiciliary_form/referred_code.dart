import 'package:domi/main.dart';
import 'package:domi/re_use/button_register_login.dart';
import 'package:domi/re_use/indomi_text_form_field.dart';
import 'package:domi/re_use/theme.dart';
import 'package:domi/screens/register/domiciliary_form/domi_sliver_app_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ReferredCode extends StatefulWidget {
  @override
  _ReferredCodeState createState() => _ReferredCodeState();
}

class _ReferredCodeState extends State<ReferredCode> {
  TextEditingController _code = TextEditingController();

  @override
  void dispose() {
    _code.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Color(0xffF5F5F5),
        body: CustomScrollView(
          slivers: [
            DomiSliverAppBar("Código de referido"),
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 30),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      height: 25,
                    ),
                    Text(
                      "Ingresa tu código a continuación:",
                      style: TextStyle(
                          color: inDomiGreyBlack,
                          fontSize: 14,
                          fontWeight: FontWeight.bold),
                    ),
                    SizedBox(
                      height: 14,
                    ),
                    IndomiTextFormField(
                      width: 310,
                      textAlign: TextAlign.center,
                      hintText: "CÓDIGO AQUÍ",
                      maxLength: 8,
                      controller: _code,
                      edgeInsetsGeometry: EdgeInsets.only(left: 16),
                    ),
                    SizedBox(
                      height: 14,
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 10),
                      child: Text(
                        "Paso opcional, sino tienes puedes continuar:",
                        style: TextStyle(
                          color: inDomiGreyBlack,
                          fontSize: 11,
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 14,
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 1),
                      child: ButtonRegisterLogin(
                        text: Text(
                          "Continuar",
                          style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 14),
                        ),
                        color: inDomiBluePrimary,
                        voidCallback: () {
                          if (_code.text.isNotEmpty) {
                            context
                                .read(registerProvider.notifier)
                                .setReferCode(_code.text);
                            Navigator.of(context).pop(1);
                          }
                        },
                        width: 314,
                      ),
                    )
                  ],
                ),
              ),
            )
          ],
        ));
  }
}
