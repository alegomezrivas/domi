import 'dart:async';

import 'package:domi/re_use/domi_register_login.dart';
import 'package:domi/re_use/theme.dart';
import 'package:domi/screens/log_in/user_or_domi.dart';
import 'package:flutter/material.dart';

class LoadScreen extends StatefulWidget {
  @override
  _LoadScreenState createState() => _LoadScreenState();
}

class _LoadScreenState extends State<LoadScreen> {
  final splashDelay = 1;

  @override
  void initState() {
    super.initState();

    _loadWidget();
  }

  _loadWidget() async {
    var _duration = Duration(seconds: splashDelay);
    return Timer(_duration, navigationPage);
  }

  void navigationPage() {
    Navigator.pushReplacement(context,
        MaterialPageRoute(builder: (BuildContext context) => UserOrDomi()));
  }

  @override
  Widget build(BuildContext context) {
    final media = MediaQuery.of(context);
    return Scaffold(
        backgroundColor: inDomiYellow,
        body: DomiRegisterLogin(
            column: Container(
          height: media.size.height,
          width: media.size.width,
          child: SingleChildScrollView(
            child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  SizedBox(
                    height: 95,
                  ),
                  Text(
                    "Aquí tu pones el precio",
                    style: TextStyle(
                        color: inDomiBluePrimary,
                        fontSize: 15,
                        fontWeight: FontWeight.bold),
                  ),
                  SizedBox(
                    height: 80,
                  ),
                  Container(
                    width: 300,
                    height: 270,
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        Image(
                          image: AssetImage("assets/icons/Grupo 8@3x.png"),
                          height: 83,
                          fit: BoxFit.fitHeight,
                        ),
                        Positioned(
                          bottom: 0,
                          right: 35,
                          child: Image(
                            image:
                                AssetImage("assets/icons/Enmascarar 5@3x.png"),
                            height: 140,
                            fit: BoxFit.fitHeight,
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 150,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 74),
                    child: Text(
                      "Somos seguridad, confianza agilidad y respaldo",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          color: inDomiBluePrimary,
                          fontSize: 15,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                ]),
          ),
        )));
  }
}
