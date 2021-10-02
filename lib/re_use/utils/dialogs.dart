import 'package:domi/re_use/button_register_login.dart';
import 'package:domi/re_use/theme.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

loading(BuildContext context) {
  showDialog(
    context: context,
    barrierDismissible: false,
    builder: (context) {
      return WillPopScope(
        onWillPop: () {
          return Future.value(false);
        },
        child: Container(
          color: Colors.transparent,
          child: Center(
            child: CircularProgressIndicator(
              strokeWidth: 2,
            ),
          ),
        ),
      );
    },
  );
}

Future<ImageSource?> imageSourceBottomSheet(BuildContext context) {
  return showModalBottomSheet<ImageSource?>(
      context: context,
      builder: (context) {
        return Container(
          height: 150,
          child: Column(
            children: [
              ListTile(
                onTap: () {
                  Navigator.of(context).pop(ImageSource.gallery);
                },
                leading: Icon(Icons.photo),
                title: Text("Galería"),
              ),
              Divider(),
              ListTile(
                onTap: () {
                  Navigator.of(context).pop(ImageSource.camera);
                },
                leading: Icon(Icons.camera),
                title: Text("Cámara"),
              ),
            ],
          ),
        );
      });
}

enum SnackBarDomiType { normal, error, success }

ScaffoldFeatureController<SnackBar, SnackBarClosedReason> snackBarMessage(BuildContext context, String text,
    {SnackBarDomiType type = SnackBarDomiType.normal, SnackBarAction? action}) {
  switch (type) {
    case SnackBarDomiType.normal:
      return ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(text)));
    case SnackBarDomiType.error:
      return ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(
          text,
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.redAccent,
        action: action,
      ));
    case SnackBarDomiType.success:
     return  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(
          text,
          style: TextStyle(color: inDomiBluePrimary),
        ),
        backgroundColor: Colors.greenAccent,
      ));
      break;
  }
}

showError(BuildContext context, dynamic error, {String noFound = ""}) {
  String errorMessage = "Se ha producido un error";
  print(error.runtimeType);
  print(error);
  if (error is List) {
    if (error.length > 0) {
      if (error[0] is String) {
        errorMessage = error[0];
      }
    }
  }
  if (error is Map<String, dynamic>) {
    if (error["detail"] != null) {
      if (error["detail"] is List) {
        if (error["detail"].length > 0) {
          errorMessage = error["detail"][0].toString();
        }
      }
      if (error["detail"] is String) {
        errorMessage = error["detail"];
      }
    }
    if (error["non_field_errors"] != null) {
      if (error["non_field_errors"] is List) {
        if (error["non_field_errors"].length > 0) {
          errorMessage = error["non_field_errors"][0].toString();
        }
      }

      if (error["non_field_errors"] is String) {
        errorMessage = error["non_field_errors"];
      }
    }

    if (error["message"] != null) {
      errorMessage = error["message"];
    }
    if (error["error"] != null) {
      if (error["error"] is List) {
        if (error["error"].length > 0) {
          errorMessage = error["error"][0].toString();
        }
      }
      if (error["error"] is Map) {
        if (error["error"]["detail"] != null) {
          errorMessage = error["error"]["detail"];
        }
      }
      if (error["error"] is String) {
        errorMessage = error["error"];
      }
    }
  }
  errorMessage =
      errorMessage.toLowerCase().contains("found") ? noFound : errorMessage;
  snackBarMessage(context, errorMessage, type: SnackBarDomiType.error);
}

void showContainer(BuildContext context, VoidCallback voidCallback,
    ButtonRegisterController buttonRegisterController) {
  showDialog(
    context: context,
    builder: (context) {
      return Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: Container(
          height: 150,
          width: 250,
          child: Container(
            child: Padding(
                padding: const EdgeInsets.only(
                  top: 21,
                  left: 18,
                  right: 18,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text(
                      "¿Deseas cancelar el servicio?",
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                          color: inDomiBluePrimary),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    ButtonRegisterLogin(
                        controller: buttonRegisterController,
                        text: Text(
                          "Aceptar",
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 14,
                              color: Colors.white),
                        ),
                        height: 36,
                        color: inDomiButtonBlue,
                        voidCallback: voidCallback),
                    TextButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      child: Text(
                        "CERRAR",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            color: inDomiGreyBlack,
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                            decoration: TextDecoration.underline),
                      ),
                    ),
                  ],
                )),
          ),
        ),
      );
    },
  );
}

Future<dynamic> showConfirmationDialog(BuildContext context,
    {String text = "", String positiveButton = "", VoidCallback? voidCallback} ) {
  return showDialog(
    context: context,
    builder: (context) {
      return Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: Container(
          width: 250,
          child: Container(
            child: Padding(
                padding: const EdgeInsets.only(
                  top: 21,
                  left: 18,
                  right: 18,
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text(
                      text,
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                          color: inDomiBluePrimary),
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    ButtonRegisterLogin(
                      text: Text(
                        positiveButton,
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                            color: Colors.white),
                      ),
                      height: 36,
                      color: inDomiButtonBlue,
                      voidCallback: voidCallback!=null? voidCallback: () {
                        Navigator.of(context).pop(true);
                      },
                    ),
                    TextButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      child: Text(
                        "CERRAR",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            color: inDomiGreyBlack,
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                            decoration: TextDecoration.underline),
                      ),
                    ),
                  ],
                )),
          ),
        ),
      );
    },
  );
}

// locationDeniedMessage(BuildContext context, VoidCallback voidCallback){
//   snackBarMessage(context,
//       "Para tomar servicios, debe habilitar el uso de su ubicación en todo momento",
//       type: SnackBarDomiType.error,
//       action: SnackBarAction(
//           label: "App settings",
//           onPressed: () async {
//             await AppSettings.openLocationSettings();
//             voidCallback();
//           }));
// }
