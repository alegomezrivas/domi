import 'package:domi/main.dart';
import 'package:domi/re_use/button_register_login.dart';
import 'package:domi/re_use/domi_register_login.dart';
import 'package:domi/re_use/indomi_text_form_field.dart';
import 'package:domi/re_use/message_strings.dart';

import 'package:domi/re_use/theme.dart';
import 'package:domi/screens/register/load_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class NameAndLastname extends StatefulWidget {
  @override
  _NameAndLastnameState createState() => _NameAndLastnameState();
}

class _NameAndLastnameState extends State<NameAndLastname> {
  TextEditingController _name= TextEditingController();
  TextEditingController _lastname = TextEditingController();
  GlobalKey<FormState> _formState = GlobalKey<FormState>();
  @override
  void dispose() {
    _name.dispose();
    _lastname.dispose();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: inDomiYellow,
        body: DomiRegisterLogin(
          column: SingleChildScrollView(
            child: Form(
              key: _formState,
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Bienvenido a",
                      style: TextStyle(color: inDomiBluePrimary, fontSize: 22, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 8,),
                    Image(
                      image: AssetImage("assets/icons/Grupo 8@3x.png"),
                      height: 83,
                      fit: BoxFit.fitHeight,
                    ),
                    SizedBox(
                      height: 25,
                    ),
                    Text(
                      "Conozcámonos ¿cómo es tu nombre?",
                      style: TextStyle(color: inDomiBluePrimary, fontSize: 15),
                    ),
                    SizedBox(height: 20,),
                    IndomiTextFormField(
                      controller: _name,
                      width: 284,
                      hintText: "Nombre",
                      textAlign: TextAlign.center,
                      validator: (value) {
                        if(value!.isEmpty){
                          return REQUIRED_MESSAGE;
                        }
                      },
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    IndomiTextFormField(
                      controller: _lastname,
                      width: 284,
                      hintText: "Apellido",
                      textAlign: TextAlign.center,
                      validator: (value) {
                        if(value!.isEmpty){
                          return REQUIRED_MESSAGE;
                        }
                      },
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    ButtonRegisterLogin(
                      voidCallback: () {
                        if(!_formState.currentState!.validate()){
                          return;
                        }
                        final register = context.read(registerProvider);
                        register.firstName = _name.text;
                        register.lastName = _lastname.text;
                        Navigator.of(context).push(MaterialPageRoute(builder: (context) => LoadScreen(),));
                      },

                      text: Text("Siguiente",
                          style: TextStyle(
                              fontSize: 14,
                              color: Colors.white,
                              fontWeight: FontWeight.w600)),
                      width: 284,
                    )
                  ]),
            ),
          ),
        ));
  }
}
