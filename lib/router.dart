import 'package:domi/re_use/domi_register_login.dart';
import 'package:domi/screens/domi_home/domi_home_page.dart';
import 'package:domi/screens/home/home_page.dart';
import 'package:domi/screens/home/service/deliveries_available.dart';
import 'package:domi/screens/register/enter_number.dart';
import 'package:flutter/material.dart';

const SPLASH = "/splash";
const HOME = "/home";
const DOMIHOME = "/domihome";
const ENTER_NUMBER = "/enter_number";
const DELIVERIES = "/deliveries";

generateDomiRoutes(settings) {
  switch (settings.name) {
    case SPLASH:
      return MaterialPageRoute(
          builder: (context) => DomiRegisterLogin(
                splash: true,
              ));
    case HOME:
      return MaterialPageRoute(builder: (context) => HomePage());
    case DOMIHOME:
      return MaterialPageRoute(builder: (context) => DomiHomePage());
    case ENTER_NUMBER:
      return MaterialPageRoute(builder: (context) => EnterNumber());
    case DELIVERIES:
      return MaterialPageRoute(
          builder: (context) => DeliveriesAvailable(settings.arguments as int));
    default:
      return null;
  }
}
