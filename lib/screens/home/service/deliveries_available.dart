import 'dart:async';

import 'package:domi/provider/auth/auth_provider.dart';
import 'package:domi/provider/service/offers_provider.dart';
import 'package:domi/re_use/theme.dart';
import 'package:domi/re_use/utils/dialogs.dart';
import 'package:domi/repositories/service_repository.dart';
import 'package:domi/screens/home/service/widgets/service_offer_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class DeliveriesAvailable extends StatefulWidget {
  final int serviceId;

  DeliveriesAvailable(this.serviceId);

  @override
  _DeliveriesAvailableState createState() => _DeliveriesAvailableState();
}

class _DeliveriesAvailableState extends State<DeliveriesAvailable> {
  bool _selectAService = false;

  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      context.read(offersProvider.notifier).getOffers(widget.serviceId);
      context.read(offersProvider.notifier).listenOffers(widget.serviceId);
    });
  }

  @override
  void dispose() {
    // if (!_selectAService) {
    //   _cancelService();
    // }
    AuthProvider.availableScreen = false;
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        return false;
      },
      child: Scaffold(
        backgroundColor: inDomiScaffoldGrey,
        body: SafeArea(
            child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.only(right: 17, top: 20, left: 17),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // IconButton(
                  //   icon: Icon(
                  //     Icons.arrow_back,
                  //     color: inDomiBluePrimary,
                  //     size: 30,
                  //   ),
                  //   onPressed: () {
                  //     Navigator.of(context).pop();
                  //   },
                  // ),
                  Spacer(),
                  Padding(
                    padding: const EdgeInsets.only(right: 5),
                    child: Container(
                      width: 88,
                      height: 30,
                      child: Image(
                        image: AssetImage("assets/icons/Grupo 8@3x.png"),
                        height: 52,
                        width: 52,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 7,
            ),
            Consumer(
              builder: (context, watch, child) {
                final data = watch(offersProvider).results;
                final favorites =
                    data.where((element) => element.isFavorite).toList();
                final others =
                    data.where((element) => !element.isFavorite).toList();
                return Expanded(
                  child: RefreshIndicator(
                    onRefresh: () {
                      return context
                          .read(offersProvider.notifier)
                          .getOffers(widget.serviceId);
                    },
                    child: CustomScrollView(
                      slivers: [
                        if (favorites.isNotEmpty)
                          SliverToBoxAdapter(
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Container(
                                alignment: Alignment.center,
                                child: Text(
                                  "Mis Domis favoritos",
                                  style: TextStyle(
                                      color: inDomiBluePrimary,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16),
                                ),
                              ),
                            ),
                          ),
                        SliverList(
                            delegate: SliverChildBuilderDelegate(
                                (BuildContext context, int index) {
                          final offer = favorites[index];
                          return ServiceOfferWidget(offer, onTimeOver: () {
                            context
                                .read(offersProvider.notifier)
                                .removeItem(offer);
                          });
                        }, childCount: favorites.length)),
                        SliverToBoxAdapter(
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Container(
                              alignment: Alignment.center,
                              child: Text(
                                "Todos los Domis",
                                style: TextStyle(
                                    color: inDomiBluePrimary,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16),
                              ),
                            ),
                          ),
                        ),
                        SliverList(
                            delegate: SliverChildBuilderDelegate(
                                (BuildContext context, int index) {
                          final offer = others[index];
                          return ServiceOfferWidget(
                            offer,
                            onTimeOver: () {
                              context
                                  .read(offersProvider.notifier)
                                  .removeItem(offer);
                            },
                          );
                        }, childCount: others.length))
                      ],
                    ),
                  ),
                );
              },
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: TextButton(
                  onPressed: _cancelService,
                  child: Text(
                    "Cancelar servicio",
                    style: TextStyle(
                        color: inDomiBluePrimary,
                        decoration: TextDecoration.underline),
                  )),
            )
          ],
        )),
      ),
    );
  }

  Future<void> _cancelService() async {
    try {
      loading(context);
      await ServiceRepository.cancelService(widget.serviceId);
      Navigator.of(context).pop();
      Navigator.of(context).pop();
    } catch (e) {
      if (mounted) {
        Navigator.of(context).pop();
        Navigator.of(context).pop();
        // showError(context, e);
      }
    }
  }
}
