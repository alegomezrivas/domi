import 'dart:async';

import 'package:domi/core/extensions/string.dart';
import 'package:domi/main.dart';
import 'package:domi/models/service/service_offer.dart';
import 'package:domi/provider/domi/in_service_provider.dart';
import 'package:domi/re_use/button_register_login.dart';
import 'package:domi/re_use/theme.dart';
import 'package:domi/re_use/utils/dialogs.dart';
import 'package:domi/re_use/utils/domi_format.dart';
import 'package:domi/repositories/service_repository.dart';
import 'package:domi/screens/home/service/delivery_status.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ServiceOfferWidget extends StatefulWidget {
  final ServiceOffer offer;
  final VoidCallback? onTimeOver;

  ServiceOfferWidget(this.offer, {this.onTimeOver});

  @override
  _ServiceOfferWidgetState createState() => _ServiceOfferWidgetState();
}

class _ServiceOfferWidgetState extends State<ServiceOfferWidget> {
  Timer? _timer;
  ValueNotifier<double> _timerNotifier = ValueNotifier<double>(1);
  int _counter = 0;
  bool mounted = false;
  int seconds = 0;

  @override
  void initState() {
    seconds = DomiFormat.formatDateTZ(widget.offer.createdAt)
        .add(Duration(
            seconds:
                context.read(authProvider).userData!.params.offerLifeTime))
        .difference(DateTime.now())
        .inSeconds;
    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      _counter++;
      if (!mounted) {
        _timerNotifier.value = 1 - (_counter / seconds);
      }
      if (_counter >= seconds) {
        if (widget.onTimeOver != null) {
          widget.onTimeOver!();
        }
      }
    });
    super.initState();
  }

  @override
  void dispose() {
    mounted = true;
    _timer?.cancel();
    _timerNotifier.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final photo = widget.offer.domi.person.photo;
    print(seconds);

    if (seconds <= 0) {
      return SizedBox();
    }

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 17, vertical: 16),
      child: Container(
        width: double.maxFinite,
        decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(6),
            boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 3)]),
        child: Column(
          children: [
            ValueListenableBuilder<double>(
              valueListenable: _timerNotifier,
              builder: (context, value, child) {
                return LinearProgressIndicator(
                  value: value,
                  color: inDomiYellow,
                  backgroundColor: inDomiBluePrimary.withAlpha(100),
                  minHeight: 8,
                );
              },
            ),
            Padding(
              padding: const EdgeInsets.only(
                  left: 15, right: 15, top: 10, bottom: 10),
              child: Column(
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      CircleAvatar(
                        radius: 23,
                        backgroundImage: (photo != null
                                ? NetworkImage(photo)
                                : AssetImage("assets/icons/im.png"))
                            as ImageProvider,
                      ),
                      SizedBox(
                        width: 9,
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            widget.offer.domi.firstName,
                            style: TextStyle(
                                color: inDomiGreyBlack,
                                fontWeight: FontWeight.bold,
                                fontSize: 14),
                          ),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.star,
                                color: inDomiButtonBlue,
                                size: 15,
                              ),
                              Text(
                                "${DomiFormat.formatCompat(widget.offer.domi.person.stars / widget.offer.domi.person.reviews)}",
                                style: TextStyle(
                                    color: inDomiGreyBlack, fontSize: 12),
                              ),
                              Text(
                                " - ${DomiFormat.formatCompat(widget.offer.domi.person.domiCount)} enviós",
                                style: TextStyle(
                                    color: inDomiGreyBlack, fontSize: 12),
                              ),
                            ],
                          ),

                          Text(
                           "Ofrece ${widget.offer.counteroffer.toCurrency()}",
                            style: TextStyle(
                                color: inDomiBluePrimary, fontSize: 14, fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                      Spacer(),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text(
                            "Distancia: ${widget.offer.getDistance}",
                            style:
                                TextStyle(color: inDomiGreyBlack, fontSize: 14),
                          ),
                          Text(
                            "${widget.offer.getTime} min",
                            style:
                                TextStyle(color: inDomiGreyBlack, fontSize: 14),
                          ),
                        ],
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Expanded(
                        child: Container(
                          height: 36,
                          width: 100,
                          child: ElevatedButton(
                              onPressed: () {
                                if (widget.onTimeOver != null) {
                                  ServiceRepository.rejectOffer(
                                      widget.offer.id);
                                  widget.onTimeOver!();
                                }
                              },
                              style: ElevatedButton.styleFrom(
                                  elevation: 0,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(19),
                                    side: BorderSide(color: inDomiButtonBlue),
                                  ),
                                  primary: Colors.white),
                              child: Text(
                                "Rechazar",
                                style: TextStyle(
                                    color: inDomiButtonBlue, fontSize: 14),
                              )),
                        ),
                      ),
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.only(left: 10),
                          child: ButtonRegisterLogin(
                            height: 36,
                            width: 100,
                            color: inDomiBluePrimary,
                            text: Text(
                              "Aceptar",
                              style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 14),
                            ),
                            voidCallback: () async {
                              try {
                                loading(context);
                                await ServiceRepository.acceptOffer(
                                    widget.offer.id);
                                context
                                    .read(inServiceProvider)
                                    .serviceCompleted = false;
                                Navigator.of(context).pop();
                                Navigator.of(context).pushReplacement(
                                    MaterialPageRoute(
                                        builder: (context) => DeliveryStatus(
                                            widget.offer.service)));
                              } catch (e) {
                                Navigator.of(context).pop();
                                showError(context, e);
                              }
                            },
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
