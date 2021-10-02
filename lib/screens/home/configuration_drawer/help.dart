import 'package:domi/core/extensions/string.dart';
import 'package:domi/main.dart';
import 'package:domi/models/general/domi_params.dart';
import 'package:domi/re_use/button_domi_form.dart';
import 'package:domi/re_use/domi_web_view.dart';
import 'package:domi/re_use/theme.dart';
import 'package:domi/screens/register/domiciliary_form/domi_sliver_app_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class HelpPage extends StatefulWidget {
  @override
  _HelpPageState createState() => _HelpPageState();
}

class _HelpPageState extends State<HelpPage> {
  late Params _params;

  @override
  void initState() {
    _params = context.read(authProvider).userData!.params;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: inDomiScaffoldGrey,
      body: CustomScrollView(
        slivers: [
          DomiSliverAppBar("Ayuda"),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 17, vertical: 18),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (_params.rewardUrl.isNotEmptyOrNull())
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 5),
                      child: ButtonDomiForm(
                        text: "Abrir un PQRS",
                        voidCallback: () {
                          navigateTo(_params.pqrUrl +
                              "?username=" +
                              context
                                  .read(authProvider)
                                  .userData!
                                  .user
                                  .username);
                        },
                      ),
                    ),
                  if (_params.termsUrl.isNotEmptyOrNull())
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 5),
                      child: ButtonDomiForm(
                        text: "Términos y condiciones",
                        voidCallback: () {
                          navigateTo(_params.termsUrl);
                        },
                      ),
                    ),
                  if (_params.privacyUrl.isNotEmptyOrNull())
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 5),
                      child: ButtonDomiForm(
                        text: "Políticas de privacidad",
                        voidCallback: () {
                          navigateTo(_params.privacyUrl);
                        },
                      ),
                    ),
                  if (_params.frequentlyUrl.isNotEmptyOrNull())
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 5),
                      child: ButtonDomiForm(
                        text: "Preguntas frecuentes",
                        voidCallback: () {
                          navigateTo(_params.frequentlyUrl);
                        },
                      ),
                    ),
                  if (_params.paymentUrl.isNotEmptyOrNull())
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 5),
                      child: ButtonDomiForm(
                        text: "Método de pago",
                        voidCallback: () {
                          navigateTo(_params.paymentUrl);
                        },
                      ),
                    ),
                  if (_params.helpUrl.isNotEmptyOrNull())
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 5),
                      child: ButtonDomiForm(
                        text: "Solución de inconvenientes",
                        voidCallback: () {
                          navigateTo(_params.helpUrl);
                        },
                      ),
                    ),
                  if (_params.rewardUrl.isNotEmptyOrNull())
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 5),
                      child: ButtonDomiForm(
                        text: "Sistema de recompensas",
                        voidCallback: () {
                          navigateTo(_params.rewardUrl);
                        },
                      ),
                    ),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }

  void navigateTo(String url) {
    Navigator.of(context).push(MaterialPageRoute(
      builder: (context) => DomiWebView(
        url: url,
      ),
    ));
  }
}
