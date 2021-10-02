import 'package:domi/core/enum/service_enums.dart';
import 'package:domi/provider/service/create_service_provider.dart';
import 'package:domi/provider/service/credit_card_povider.dart';
import 'package:domi/re_use/theme.dart';
import 'package:domi/re_use/utils/dialogs.dart';
import 'package:domi/re_use/utils/loading_sliver.dart';
import 'package:domi/screens/home/service/credit_card/credit_card_form.dart';
import 'package:domi/screens/home/service/credit_card/payment_card.dart';
import 'package:flutter/material.dart';
import 'package:domi/models/wallet/card.dart' as cc;
import 'package:flutter_riverpod/flutter_riverpod.dart';

class PaymentMethodPage extends StatefulWidget {
  @override
  _PaymentMethodPageState createState() => _PaymentMethodPageState();
}

class _PaymentMethodPageState extends State<PaymentMethodPage> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      context.read(creditCardProvider.notifier).getCards();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: inDomiScaffoldGrey,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15),
          child: Consumer(
            builder: (context, watch, child) {
              final state = watch(creditCardProvider);
              final payMethod = watch(createServiceProvider).payMethod;
              final selectedCard = watch(createServiceProvider).card;
              return CustomScrollView(
                slivers: [
                  SliverToBoxAdapter(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(top: 20, bottom: 30),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              IconButton(
                                icon: Icon(
                                  Icons.arrow_back,
                                  color: inDomiBluePrimary,
                                  size: 30,
                                ),
                                onPressed: () {
                                  Navigator.of(context).pop();
                                },
                              ),
                              Spacer(),
                              Padding(
                                padding: const EdgeInsets.only(right: 12),
                                child: Container(
                                  width: 88,
                                  height: 30,
                                  child: Image(
                                    image: AssetImage(
                                        "assets/icons/Grupo 8@3x.png"),
                                    height: 52,
                                    width: 52,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Text(
                          "Medios de pago disponibles",
                          style: TextStyle(
                              color: inDomiBluePrimary,
                              fontSize: 15,
                              fontWeight: FontWeight.bold),
                        ),
                        SizedBox(
                          height: 15,
                        ),
                        InkWell(
                          onTap: () {
                            context
                                .read(createServiceProvider.notifier)
                                .changePayMethod(PayMethod.cash);
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
                              padding: const EdgeInsets.all(16),
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
                                  Padding(
                                    padding: const EdgeInsets.only(top: 5),
                                    child: Text(
                                      "Efectivo",
                                      style: TextStyle(
                                          color: inDomiGreyBlack, fontSize: 14),
                                    ),
                                  ),
                                  Spacer(),
                                  CircularCheck(
                                    check: payMethod == PayMethod.cash,
                                  )
                                ],
                              ),
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 15,
                        ),
                        InkWell(
                          onTap: () {
                            context
                                .read(createServiceProvider.notifier)
                                .changePayMethod(PayMethod.wallet);
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
                              padding: const EdgeInsets.all(16),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Container(
                                    width: 44,
                                    height: 44,
                                    alignment: Alignment.center,
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(8),
                                        color: inDomiButtonBlue),
                                    child: Image.asset(
                                      "assets/icons/Grupo 541@2x.png",
                                      height: 20,
                                      width: 22,
                                    ),
                                  ),
                                  SizedBox(
                                    width: 28,
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(top: 5),
                                    child: Text(
                                      "Billetera",
                                      style: TextStyle(
                                          color: inDomiGreyBlack, fontSize: 14),
                                    ),
                                  ),
                                  Spacer(),
                                  CircularCheck(
                                    check: payMethod == PayMethod.wallet,
                                  )
                                ],
                              ),
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 15,
                        ),
                      ],
                    ),
                  ),
                  SliverList(
                      delegate: SliverChildBuilderDelegate((context, index) {
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 15),
                      child:
                          creditCardWidget(state.results[index], selectedCard),
                    );
                  }, childCount: state.results.length)),
                  if (context.read(creditCardProvider.notifier).isLoading)
                    LoadingSliver(),
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: const EdgeInsets.only(bottom: 15),
                      child: Column(
                        children: [
                          SizedBox(
                            height: 20,
                          ),
                          Text(
                            "Agregar metodo de pago",
                            style: TextStyle(
                                color: inDomiBluePrimary,
                                fontSize: 15,
                                fontWeight: FontWeight.bold),
                          ),
                          SizedBox(
                            height: 15,
                          ),
                          InkWell(
                            onTap: () {
                              Navigator.of(context).push(MaterialPageRoute(
                                builder: (context) => CreditCardForm(),
                              ));
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
                                padding: const EdgeInsets.all(16),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Image.asset(
                                      "assets/icons/Imagen 11@2x.png",
                                      height: 44,
                                      width: 44,
                                    ),
                                    SizedBox(
                                      width: 28,
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(top: 5),
                                      child: Text(
                                        "Agregar tarjeta",
                                        style: TextStyle(
                                            color: inDomiGreyBlack,
                                            fontSize: 14),
                                      ),
                                    ),
                                    Spacer(),
                                    Icon(
                                      Icons.arrow_forward_ios,
                                      size: 14,
                                      color: inDomiGreyBlack,
                                    )
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }

  Widget creditCardWidget(cc.Card card, cc.Card? selectedCard) {
    return InkWell(
      onTap: () {
        context
            .read(createServiceProvider.notifier)
            .changePayMethod(PayMethod.card, selectedCard: card);
      },
      child: Container(
        width: double.maxFinite,
        decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(5),
            boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 3)]),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                width: 44,
                height: 44,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    color: Colors.white),
                child: CardUtils.getCardIconFromFranchise(card.franchise != null
                    ? card.franchise!.toLowerCase()
                    : ""),
              ),
              SizedBox(
                width: 28,
              ),
              Padding(
                padding: const EdgeInsets.only(top: 5),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      card.mask,
                      style: TextStyle(color: inDomiBlack, fontSize: 11),
                    ),
                    Text(
                      "${card.firstName.toUpperCase()} ${card.lastName.toUpperCase()}",
                      style: TextStyle(color: inDomiGreyBlack, fontSize: 11),
                    ),
                  ],
                ),
              ),
              Spacer(),
              IconButton(
                  onPressed: () async {
                    await showConfirmationDialog(context,
                        text: "¿Deseas eliminar tarjeta?",
                        positiveButton: "Aceptar", voidCallback: () async {
                      await context
                          .read(creditCardProvider.notifier)
                          .deletedCreditCard(card.id);
                      context
                          .read(createServiceProvider.notifier)
                          .changePayMethod(PayMethod.cash);
                      Navigator.of(context).pop();
                    });
                  },
                  icon: Icon(
                    Icons.delete,
                    color: Colors.red,
                  )),
              CircularCheck(
                check: selectedCard == card,
              )
            ],
          ),
        ),
      ),
    );
  }
}

class CircularCheck extends StatelessWidget {
  final bool check;

  CircularCheck({this.check = false});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 25,
      width: 25,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: inDomiScaffoldGrey,
        borderRadius: BorderRadius.circular(20),
      ),
      child: check
          ? Padding(
              padding: const EdgeInsets.all(5),
              child: Container(
                alignment: Alignment.center,
                height: 20,
                width: 20,
                decoration: BoxDecoration(
                  color: inDomiButtonBlue,
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
            )
          : Container(),
    );
  }
}
