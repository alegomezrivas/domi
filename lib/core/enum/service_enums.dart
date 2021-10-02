import 'package:domi/re_use/theme.dart';
import 'package:flutter/material.dart';

enum ServiceType { food, pack, document }

enum PayMethod { cash, wallet, card }

enum ServiceStatus { pending, active, canceled, completed }

String getServiceDescription(int serviceType) {
  switch (ServiceType.values[serviceType - 1]) {
    case ServiceType.food:
      return "Domicilio de comida";
    case ServiceType.pack:
      return "Envío de paquete";
    case ServiceType.document:
      return "Envío de documento";
    default:
      return "";
  }
}

Widget getPayMethodIcon(int payMethod) {
  switch (PayMethod.values[payMethod - 1]) {
    case PayMethod.cash:
      return Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Image.asset(
            "assets/icons/Imagen 6@2x.png",
            height: 16,
            width: 16,
          ),
          SizedBox(
            width: 3,
          ),
          Text(
            "Efectivo",
            style: TextStyle(fontSize: 12, color: inDomiGreen),
          ),
        ],
      );
    case PayMethod.wallet:
      return Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Image.asset(
            "assets/icons/Grupo 541@2x.png",
            height: 16,
            width: 16,
          ),
          SizedBox(
            width: 3,
          ),
          Text(
            "Billetera",
            style: TextStyle(fontSize: 12, color: inDomiGreen),
          ),
        ],
      );
    case PayMethod.card:
      return Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Image.asset(
            "assets/icons/mastercard@2x.png",
            height: 16,
            width: 16,
          ),
          SizedBox(
            width: 3,
          ),
          Text(
            "Tarjeta de credito",
            style: TextStyle(fontSize: 12, color: inDomiGreen),
          ),
        ],
      );
    default:
      return SizedBox();
  }
}

String getCancelInPlaceDescription(double cancelInPlace) {
  if (cancelInPlace == 50000) {
    return "Menos de \$50.000";
  }
  if (cancelInPlace == 100000) {
    return "Entre \$50.000 y \$100.000";
  }

  if (cancelInPlace > 100000) {
    return "Más de \$100.000";
  }

  return "Nada";
}

Widget getServiceStatusText(int serviceStatus,
    {TextStyle textStyle = const TextStyle()}) {
  Color color = inDomiGreyBlack;
  String text = "";
  switch (ServiceStatus.values[serviceStatus - 1]) {
    case ServiceStatus.pending:
      break;
    case ServiceStatus.active:
      color = Colors.amber;
      text = "Activo";
      break;
    case ServiceStatus.canceled:
      color = Colors.redAccent;
      text = "Cancelado";
      break;
    case ServiceStatus.completed:
      color = Colors.green;
      text = "Cumplido";
      break;
    default:
      break;
  }
  return Text(
    text,
    style: textStyle.copyWith(color: color),
  );
}
