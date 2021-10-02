import 'package:domi/core/extensions/string.dart';
import 'package:domi/main.dart';
import 'package:domi/provider/wallet/rewards_provider.dart';
import 'package:domi/re_use/theme.dart';
import 'package:domi/re_use/utils/domi_format.dart';
import 'package:domi/screens/register/domiciliary_form/domi_sliver_app_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:share_plus/share_plus.dart';

class ShareAndWin extends StatefulWidget {
  @override
  _ShareAndWinState createState() => _ShareAndWinState();
}

class _ShareAndWinState extends State<ShareAndWin> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      context.read(rewardsProvider.notifier).getRewardsBalance();
    });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: inDomiScaffoldGrey,
      body: CustomScrollView(
        slivers: [
          DomiSliverAppBar("Comparte y gana"),
          Consumer(
            builder: (context, watch, child) {
             final user =  watch(authProvider).userData!;
              return SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 50, horizontal: 17),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 35),
                            child: Text(
                              "Tu amigo recibe hasta ${user.params.referCodeReward.toCurrency()}",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                  color: inDomiBluePrimary),
                            ),
                          ),
                          Image.asset(
                            "assets/icons/Winners-cuate@2x.png",
                            height: 250,
                            width: 250,
                          ),
                        ],
                        crossAxisAlignment: CrossAxisAlignment.center,
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 10, bottom: 8),
                        child: Text(
                          "Compartir con mis amigos",
                          style: TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.bold,
                              color: inDomiGreyBlack),
                        ),
                      ),
                      Container(
                        width: double.maxFinite,
                        decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(5),
                            boxShadow: [
                              BoxShadow(color: Colors.black12, blurRadius: 3)
                            ]),
                        child: Padding(
                          padding: const EdgeInsets.only(
                              left: 30, right: 15, top: 20, bottom: 10),
                          child: Row(
                            children: [
                              Text(
                                "${user.user.person.referCode ?? ""}",
                                style:
                                TextStyle(fontSize: 30, color: inDomiGreyBlack),
                              ),
                              Spacer(),
                              Container(
                                height: 44,
                                child: ElevatedButton(
                                  onPressed: () {
                                    Share.share(
                                        "Mi codigo de referido ${user.user.person.referCode ?? ""}");
                                  },
                                  child: Text(
                                    "Compartir",
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 14,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  style: ElevatedButton.styleFrom(
                                    primary: inDomiButtonBlue,
                                    elevation: 0,
                                    shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(25)),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 10, bottom: 8),
                        child: Text(
                          "Mis recompensas",
                          style: TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.bold,
                              color: inDomiGreyBlack),
                        ),
                      ),
                      Container(
                        width: double.maxFinite,
                        decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(5),
                            boxShadow: [
                              BoxShadow(color: Colors.black12, blurRadius: 3)
                            ]),
                        child: Padding(
                          padding: const EdgeInsets.only(
                              left: 30, right: 30, top: 14, bottom: 14),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Column(
                                children: [
                                  Text(
                                    DomiFormat.formatCurrencyCustom(watch(rewardsProvider).total),
                                    style: TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.w700,
                                        color: inDomiButtonBlue),
                                  ),
                                  Text(
                                    "Ganadas",
                                    style: TextStyle(
                                        fontSize: 12,
                                        color: inDomiGreyBlack),
                                  ),
                                ],
                              ),
                              Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 60),
                                child: Container(
                                  width: 2,
                                  height: 69,
                                  color: Colors.black12,
                                ),
                              ),
                              Column(
                                children: [
                                  Text(
                                    DomiFormat.formatCurrencyCustom(watch(rewardsProvider).pending),
                                    style: TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.w700,
                                        color: inDomiButtonBlue),
                                  ),
                                  Text(
                                    "Pendientes",
                                    style: TextStyle(
                                        fontSize: 12,
                                        color: inDomiGreyBlack),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },

          ),
        ],
      ),
    );
  }
}
