import 'package:domi/core/extensions/string.dart';
import 'package:domi/main.dart';
import 'package:domi/re_use/button_domi_form.dart';
import 'package:domi/re_use/domi_web_view.dart';
import 'package:domi/re_use/theme.dart';
import 'package:domi/screens/home/configuration_drawer/configuration_page/address.dart';
import 'package:domi/screens/home/configuration_drawer/configuration_page/my_profile.dart';
import 'package:domi/screens/register/domiciliary_form/domi_sliver_app_bar.dart';
import 'package:domi/screens/register/domiciliary_form_page.dart';
import 'package:domi/screens/register/enter_number.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class Configuration extends ConsumerWidget {
  @override
  Widget build(BuildContext context, ScopedReader watch) {
    final isDomi = watch(authProvider).userData!.user.isDomi;
    return Scaffold(
      backgroundColor: inDomiScaffoldGrey,
      body: CustomScrollView(
        slivers: [
          DomiSliverAppBar("Configuración"),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 17, vertical: 18),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (!isDomi)
                    ButtonDomiForm(
                        text: "Mi perfil",
                        voidCallback: () {
                          Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) => MyProfile(),
                          ));
                        }),
                  if (!isDomi)
                    SizedBox(
                      height: 14,
                    ),
                  ButtonDomiForm(
                    text: "Lugares favoritos",
                    voidCallback: () {
                      Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => AddressPage(),
                      ));
                    },
                  ),
                  SizedBox(
                    height: 14,
                  ),
                  if (watch(authProvider)
                      .userData!
                      .params
                      .aboutUrl
                      .isNotEmptyOrNull())
                    ButtonDomiForm(
                      text: "Acerca de inDomi",
                      voidCallback: () {
                        Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => DomiWebView(
                            url: context
                                .read(authProvider)
                                .userData!
                                .params
                                .aboutUrl,
                          ),
                        ));
                      },
                    ),
                  if (watch(authProvider)
                      .userData!
                      .params
                      .aboutUrl
                      .isNotEmptyOrNull())
                    SizedBox(
                      height: 14,
                    ),
                  if (!isDomi)
                    ButtonDomiForm(
                      text: "Convertirme en repartidor",
                      voidCallback: () {
                        context.read(registerProvider.notifier).convertToDomi(
                            context.read(authProvider).userData!.user);
                        Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => DomiciliaryFormPage(),
                        ));
                      },
                    ),
                  if (!isDomi)
                    SizedBox(
                      height: 14,
                    ),
                  ButtonDomiForm(
                    text: "Cerrar sesión",
                    voidCallback: () {
                      context.read(registerProvider.notifier).restart();
                      context.read(authProvider).logout();
                      Navigator.of(context).pushAndRemoveUntil(
                          MaterialPageRoute(
                              builder: (context) => EnterNumber()),
                          (route) => false);
                    },
                  ),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
