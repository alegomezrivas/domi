import 'package:domi/re_use/domi_web_view.dart';
import 'package:domi/re_use/theme.dart';
import 'package:domi/re_use/utils/dialogs.dart';
import 'package:domi/repositories/general_repository.dart';
import 'package:flutter/material.dart';

class NeedHelpWidget extends StatelessWidget {
  bool clickOn = false;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        navigateTo(context);
      },
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.help_outline,
            color: inDomiBluePrimary,
            size: 18,
          ),
          SizedBox(
            width: 5,
          ),
          Text(
            "Necesito ayuda",
            style: TextStyle(
                color: inDomiBluePrimary,
                fontSize: 13,
                decoration: TextDecoration.underline),
          ),
        ],
      ),
    );
  }

  void navigateTo(BuildContext context) async {
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
          url: GeneralRepository.domiParams!.params.helpUrl,
        ),
      ));
    } catch (e) {
      showError(context, e);
    }
    clickOn = false;
  }
}
