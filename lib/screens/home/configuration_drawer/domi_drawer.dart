import 'package:domi/core/enum/service_enums.dart';
import 'package:domi/main.dart';
import 'package:domi/re_use/theme.dart';
import 'package:domi/screens/domi_home/domi_home_page.dart';
import 'package:domi/screens/home/configuration_drawer/configuration_page/configuration.dart';
import 'package:domi/screens/home/configuration_drawer/favorite_deliverers.dart';
import 'package:domi/screens/home/configuration_drawer/help.dart';
import 'package:domi/screens/home/configuration_drawer/share_and_win.dart';
import 'package:domi/screens/home/configuration_drawer/wallet.dart';
import 'package:domi/screens/home/home_page.dart';
import 'package:domi/screens/register/domiciliary_form/domi_sliver_app_bar.dart';
import 'package:domi/screens/service/create_service.dart';
import 'package:domi/screens/service/pages/service_history_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

enum DomiType { user, domi }

class DomiDrawer extends ConsumerWidget {
  final DomiType domyType;
  final PageController? pageController;

  DomiDrawer({this.domyType = DomiType.user, this.pageController});

  @override
  Widget build(BuildContext context, ScopedReader watch) {
    final String? photo = watch(authProvider).userData!.user.person.photo;
    final fontColor =
        domyType == DomiType.domi ? Colors.white : inDomiGreyBlack;
    final iconColor = domyType == DomiType.domi ? inDomiYellow : null;

    return Drawer(
      child: Container(
        color: domyType == DomiType.domi ? inDomiBluePrimary : null,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 29.5, top: 65),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        CircleAvatar(
                          radius: 40,
                          backgroundImage: (photo != null
                                  ? NetworkImage(photo)
                                  : AssetImage("assets/icons/im.png"))
                              as ImageProvider,
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Text(
                          watch(authProvider).userData!.user.fullName,
                          style: TextStyle(
                              color: domyType == DomiType.domi
                                  ? inDomiYellow
                                  : inDomiBluePrimary,
                              fontSize: 15,
                              fontWeight: FontWeight.bold),
                        ),
                        Text(
                          "Usuario ID ${watch(authProvider).userData!.user.id.toString().padLeft(6, "0")}",
                          style: TextStyle(color: fontColor, fontSize: 11),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 60,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 15),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        ListTile(
                          onTap: () {
                            if (pageController != null) {
                              pageController!.jumpToPage(0);
                              Navigator.of(context).pop();
                            } else {
                              Navigator.of(context).push(MaterialPageRoute(
                                  builder: (context) =>
                                      CreateService(ServiceType.food)));
                            }
                          },
                          title: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Image(
                                image:
                                    AssetImage("assets/icons/mapsflags@2x.png"),
                                width: 15,
                                height: 20,
                                color: iconColor,
                              ),
                              SizedBox(
                                width: 10,
                              ),
                              Text(
                                domyType == DomiType.domi
                                    ? "Servicios"
                                    : "Pedir un servicio",
                                style:
                                    TextStyle(color: fontColor, fontSize: 14),
                              ),
                            ],
                          ),
                        ),
                        ListTile(
                          onTap: () {
                            if (pageController != null) {
                              pageController!.jumpToPage(1);
                              Navigator.of(context).pop();
                            } else {
                              Navigator.of(context).push(MaterialPageRoute(
                                builder: (context) => ServiceHistoryPage(
                                  sliverAppBar: DomiSliverAppBar("Mis Domis"),
                                ),
                              ));
                            }
                          },
                          title: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Image(
                                image: AssetImage(
                                    "assets/icons/delivery-man@2x.png"),
                                width: 15,
                                height: 20,
                                color: iconColor,
                              ),
                              SizedBox(
                                width: 10,
                              ),
                              Text(
                                "Mis Domis",
                                style:
                                    TextStyle(color: fontColor, fontSize: 14),
                              ),
                            ],
                          ),
                        ),
                        ListTile(
                          onTap: () {
                            if (pageController != null) {
                              pageController!.jumpToPage(3);
                              Navigator.of(context).pop();
                            } else {
                              Navigator.of(context).push(MaterialPageRoute(
                                  builder: (context) => Wallet()));
                            }
                          },
                          title: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Image(
                                image:
                                    AssetImage("assets/icons/Grupo 65@3x.png"),
                                width: 15,
                                height: 20,
                                color: iconColor,
                              ),
                              SizedBox(
                                width: 10,
                              ),
                              Text(
                                "Billetera",
                                style:
                                    TextStyle(color: fontColor, fontSize: 14),
                              ),
                            ],
                          ),
                        ),
                        if (domyType == DomiType.user)
                          ListTile(
                            onTap: () {
                              Navigator.of(context).push(MaterialPageRoute(
                                  builder: (context) => FavoriteDelivers()));
                            },
                            title: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Image(
                                  image: AssetImage(
                                      "assets/icons/Grupo 229@2x.png"),
                                  width: 15,
                                  height: 20,
                                  color: iconColor,
                                ),
                                SizedBox(
                                  width: 10,
                                ),
                                Text(
                                  "Repartidores favoritos",
                                  style:
                                      TextStyle(color: fontColor, fontSize: 14),
                                ),
                              ],
                            ),
                          ),
                        ListTile(
                          onTap: () {
                            Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) => HelpPage(),
                            ));
                          },
                          title: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Image(
                                image: AssetImage(
                                    "assets/icons/Trazado 57@2x.png"),
                                width: 15,
                                height: 20,
                                color: iconColor,
                              ),
                              SizedBox(
                                width: 10,
                              ),
                              Text(
                                "Ayuda",
                                style:
                                    TextStyle(color: fontColor, fontSize: 14),
                              ),
                            ],
                          ),
                        ),
                        ListTile(
                          onTap: () {
                            Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) => Configuration(),
                            ));
                          },
                          title: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Image(
                                image:
                                    AssetImage("assets/icons/Grupo 67@2x.png"),
                                width: 15,
                                height: 20,
                                color: iconColor,
                              ),
                              SizedBox(
                                width: 10,
                              ),
                              Text(
                                "Configuración",
                                style:
                                    TextStyle(color: fontColor, fontSize: 14),
                              ),
                            ],
                          ),
                        ),
                        if (domyType == DomiType.domi)
                          ListTile(
                            onTap: () {
                              Navigator.of(context).push(MaterialPageRoute(
                                builder: (context) => ShareAndWin(),
                              ));
                            },
                            title: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Image(
                                  image: AssetImage(
                                      "assets/icons/Trazado 64@2x.png"),
                                  width: 15,
                                  height: 20,
                                  color: iconColor,
                                ),
                                SizedBox(
                                  width: 10,
                                ),
                                Text(
                                  "Comparte y gana",
                                  style:
                                      TextStyle(color: fontColor, fontSize: 14),
                                ),
                              ],
                            ),
                          ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            // Spacer(),
            // if (context.read(authProvider).userData!.user.isDomi)
            //   Padding(
            //     padding:
            //         const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
            //     child: Container(
            //       height: 38,
            //       child: ElevatedButton(
            //           style: ElevatedButton.styleFrom(
            //             shape: RoundedRectangleBorder(
            //                 borderRadius: new BorderRadius.circular(19)),
            //             primary: domyType == DomiType.user
            //                 ? inDomiBluePrimary
            //                 : Colors.white,
            //             elevation: 0,
            //           ),
            //           onPressed: () {
            //             Navigator.of(context).pushAndRemoveUntil(
            //                 MaterialPageRoute(
            //                   builder: (context) => domyType == DomiType.user
            //                       ? DomiHomePage()
            //                       : HomePage(),
            //                 ),
            //                 (route) => false);
            //           },
            //           child: Row(
            //             crossAxisAlignment: CrossAxisAlignment.center,
            //             children: [
            //               Text(
            //                 domyType == DomiType.user
            //                     ? "Modo repartidor"
            //                     : "Modo usuario",
            //                 style: TextStyle(
            //                     color: domyType == DomiType.user
            //                         ? Colors.white
            //                         : inDomiBluePrimary,
            //                     fontWeight: FontWeight.bold,
            //                     fontSize: 15),
            //               ),
            //               Spacer(),
            //               Icon(
            //                 Icons.arrow_forward_rounded,
            //                 color: domyType == DomiType.user
            //                     ? Colors.white
            //                     : inDomiBluePrimary,
            //                 size: 18,
            //               )
            //             ],
            //           )),
            //     ),
            //   ),
          ],
        ),
      ),
    );
  }
}
