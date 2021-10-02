import 'package:domi/main.dart';
import 'package:domi/re_use/domi_button_continue.dart';
import 'package:domi/re_use/theme.dart';
import 'package:domi/re_use/utils/domi_format.dart';
import 'package:domi/screens/home/wallet/wallet_recharge_page.dart';
import 'package:domi/screens/register/domiciliary_form/domi_sliver_app_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class Wallet extends StatefulWidget {
  @override
  _WalletState createState() => _WalletState();
}

class _WalletState extends State<Wallet> {
  ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    _scrollController.addListener(scrollListener);
    super.initState();
    Future.microtask(() {
      context.read(walletProvider.notifier).refreshWallet();
    });
  }

  void scrollListener() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent) {
      context.read(walletProvider.notifier).getTransactions();
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: inDomiScaffoldGrey,
        body: Consumer(
          builder: (context, watch, child) {
            final data = watch(walletProvider).results;
            final isLoading = watch(walletProvider).loading;
            final page = watch(walletProvider).page;
            return RefreshIndicator(
              onRefresh: () async {
                return context.read(walletProvider.notifier).refreshWallet();
              },
              child: CustomScrollView(
                controller: _scrollController,
                physics: AlwaysScrollableScrollPhysics(),
                slivers: [
                  DomiSliverAppBar("Billetera"),
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 17, vertical: 18),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            width: double.maxFinite,
                            decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(5),
                                boxShadow: [
                                  BoxShadow(
                                      color: Colors.black12, blurRadius: 3)
                                ]),
                            child: Padding(
                              padding: const EdgeInsets.only(
                                  left: 20, right: 20, top: 21, bottom: 19),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "Saldo total",
                                    style: TextStyle(
                                        color: inDomiGreyBlack,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 14),
                                  ),
                                  Row(
                                    children: [
                                      Text(
                                        "\$${watch(walletProvider).balance}",
                                        style: TextStyle(
                                            color: inDomiBluePrimary,
                                            fontSize: 31),
                                      ),
                                      Spacer(),
                                      DomiContinueButton(
                                        text: "Recargar",
                                        voidCallback: () async {
                                          goToRecharge();
                                        },
                                        width: 117,
                                        height: 36,
                                      )
                                    ],
                                  )
                                ],
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          Text(
                            "Medios de pago disponibles",
                            style: TextStyle(
                                color: inDomiBluePrimary,
                                fontWeight: FontWeight.bold,
                                fontSize: 14),
                          ),
                          SizedBox(
                            height: 17,
                          ),
                          Container(
                            width: double.maxFinite,
                            decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(5),
                                boxShadow: [
                                  BoxShadow(
                                      color: Colors.black12, blurRadius: 3)
                                ]),
                            child: Padding(
                              padding: const EdgeInsets.all(15),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Image.asset(
                                    "assets/icons/Imagen 6@2x.png",
                                    height: 44,
                                    width: 44,
                                  ),
                                  SizedBox(
                                    width: 28,
                                  ),
                                  Text(
                                    "Efectivo",
                                    style: TextStyle(
                                        color: inDomiGreyBlack, fontSize: 14),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 17,
                          ),
                          InkWell(
                            onTap: () {
                              goToRecharge();
                            },
                            child: Container(
                              width: double.maxFinite,
                              decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(5),
                                  boxShadow: [
                                    BoxShadow(
                                        color: Colors.black12, blurRadius: 3)
                                  ]),
                              child: Padding(
                                padding: const EdgeInsets.all(15),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Image.asset(
                                      "assets/icons/Enmascarar grupo 6@3x.png",
                                      height: 44,
                                      width: 44,
                                    ),
                                    SizedBox(
                                      width: 28,
                                    ),
                                    Text(
                                      "Recarga de saldo",
                                      style: TextStyle(
                                          color: inDomiGreyBlack, fontSize: 14),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          Text(
                            "Historial de pagos",
                            style: TextStyle(
                                color: inDomiBluePrimary,
                                fontWeight: FontWeight.bold,
                                fontSize: 14),
                          ),
                        ],
                      ),
                    ),
                  ),
                  SliverList(
                    delegate: SliverChildBuilderDelegate(
                        (BuildContext context, int index) {
                      return Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 17, vertical: 7),
                        child: Container(
                          width: double.maxFinite,
                          decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(5),
                              boxShadow: [
                                BoxShadow(color: Colors.black12, blurRadius: 3)
                              ]),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 17, vertical: 17),
                            child: Row(
                              children: [
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      data[index].getDetail(),
                                      style: TextStyle(
                                          color: inDomiGreyBlack,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 14),
                                    ),
                                    Text(
                                      DomiFormat.formatDateTZString(
                                          data[index].timestamp!),
                                      style: TextStyle(
                                          color: inDomiGreyBlack, fontSize: 11),
                                    )
                                  ],
                                ),
                                Spacer(),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: [
                                    Text(
                                      "${DomiFormat.formatCurrency(double.parse(data[index].total!))} COP",
                                      style: TextStyle(
                                          color:
                                              data[index].transactionType == 1
                                                  ? inDomiButtonBlue
                                                  : Colors.redAccent,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 14),
                                    ),
                                    Text(
                                      data[index].getStatus(),
                                      style: TextStyle(
                                          color: data[index].getStatusColor(),
                                          fontSize: 11),
                                    )
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    }, childCount: data.length),
                  ),
                  if (isLoading)
                    SliverToBoxAdapter(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Center(
                          child: Container(
                            width: 24,
                            height: 24,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          ),
                        ),
                      ),
                    )
                ],
              ),
            );
          },
        ));
  }

  goToRecharge() {
    Navigator.of(context)
        .push(MaterialPageRoute(builder: (context) => WalletRechargePage()));
  }
}
