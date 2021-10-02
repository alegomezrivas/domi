import 'package:domi/re_use/domi_web_view.dart';
import 'package:domi/re_use/theme.dart';
import 'package:domi/re_use/utils/dialogs.dart';
import 'package:domi/repositories/general_repository.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

class TermsAndConditions extends StatelessWidget {
  bool clickOn = false;

  @override
  Widget build(BuildContext context) {
    return Container(
      child: RichText(
          textAlign: TextAlign.center,
          text: TextSpan(children: [
            TextSpan(
                text: "Al tocar “Enviar datos”, acepto los ",
                style: TextStyle(color: inDomiGreyBlack, fontSize: 11),
                children: [
                  TextSpan(
                      recognizer: TapGestureRecognizer()
                        ..onTap = () {
                          navigateTo(context, 1);
                        },
                      text: "Términos y condiciones",
                      style: TextStyle(
                          color: Color(0xff00BEDE),
                          decoration: TextDecoration.underline,
                          fontSize: 11)),
                  TextSpan(
                      text:
                          ", así como reconozco y acepto el procesamiento y transferencia de datos personales de acuerdo con la ",
                      style: TextStyle(color: inDomiGreyBlack, fontSize: 11)),
                  TextSpan(
                    recognizer: TapGestureRecognizer()
                      ..onTap = () {
                        navigateTo(context, 0);
                      },
                    text: "Politica de privacidad",
                    style: TextStyle(
                        color: Color(0xff00BEDE),
                        decoration: TextDecoration.underline,
                        fontSize: 11),
                  )
                ])
          ])),
    );
  }

  void navigateTo(BuildContext context, int link) async {
    if (clickOn) {
      return;
    }
    clickOn = true;
    try {
      if (GeneralRepository.domiParams == null) {
        GeneralRepository.domiParams = await GeneralRepository.getDomiVars();
      }

      Navigator.of(context).push(MaterialPageRoute(
        builder: (context) => DomiWebView(
          url: link == 0
              ? GeneralRepository.domiParams!.params.privacyUrl
              : GeneralRepository.domiParams!.params.termsUrl,
        ),
      ));
    } catch (e) {
      showError(context, e);
    }
    clickOn = false;
  }
}
