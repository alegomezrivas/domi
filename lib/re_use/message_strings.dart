import 'package:flutter/material.dart';

const REQUIRED_MESSAGE = "*Campo requerido";
const MIN_RECHARGE_VALUE_MESSAGE = "*La recarga debe ser mayor o igual a \$10.000";
const NOT_VALID_NUMBER_MESSAGE = "*Número no valido";
const VALID_EMAIL_MESSAGE = "*Tiene que ser un email válido";
const IMAGE_SIZE_MESSAGE = "¡La imagen excede el tamaño maximo permitido!";
const MAX_IMAGE_SIZE = 5000000;

Widget messageErrorWidget(String message, {Alignment alignment = Alignment.centerLeft}) => Align(
    alignment: alignment,
    child: Padding(
      padding: const EdgeInsets.only(left: 5),
      child: Text(message, style: TextStyle(color: Colors.red, fontSize: 12)),
    ));
