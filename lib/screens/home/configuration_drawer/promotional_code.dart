import 'package:domi/re_use/button_register_login.dart';
import 'package:domi/re_use/indomi_text_form_field.dart';
import 'package:domi/re_use/theme.dart';
import 'package:domi/screens/register/domiciliary_form/domi_sliver_app_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class PromotionalCode extends StatefulWidget {

  @override
  _PromotionalCodeState createState() => _PromotionalCodeState();
}

class _PromotionalCodeState extends State<PromotionalCode> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Color(0xffF5F5F5),
        body: CustomScrollView(
          slivers: [
            DomiSliverAppBar("Códigos promocionales"),
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
                      edgeInsetsGeometry: EdgeInsets.only(left: 16),
                      formatters: [
                        FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
                      ],
                      keyboardType: TextInputType.number,
                    ),
                    SizedBox(
                      height: 14,
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 10),
                      child: Text(
                        "Ver las condiciones de la promoción >",
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
                          "Siguiente",
                          style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 14),
                        ),
                        color: inDomiBluePrimary,
                        voidCallback: () {

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
