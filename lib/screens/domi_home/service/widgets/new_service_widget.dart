import 'dart:async';

import 'package:domi/core/enum/service_enums.dart';
import 'package:domi/core/extensions/string.dart';
import 'package:domi/main.dart';
import 'package:domi/models/service/service.dart';
import 'package:domi/re_use/theme.dart';
import 'package:domi/re_use/utils/domi_format.dart';
import 'package:domi/screens/domi_home/service/service_description.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class NewServiceWidget extends StatefulWidget {
  final Service service;
  final VoidCallback? onTimeOver;

  NewServiceWidget(this.service, {this.onTimeOver});

  @override
  _NewServiceWidgetState createState() => _NewServiceWidgetState();
}

class _NewServiceWidgetState extends State<NewServiceWidget> {
  Timer? _timer;
  ValueNotifier<double> _timerNotifier = ValueNotifier<double>(1);
  int _counter = 0;
  bool mounted = false;

  @override
  void initState() {
    final seconds = DomiFormat.formatDateTZ(widget.service.createdAt)
        .add(Duration(
            seconds:
                context.read(authProvider).userData!.params.serviceLifeTime))
        .difference(DateTime.now())
        .inSeconds;
    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      _counter++;
      if (!mounted) {
        _timerNotifier.value = 1 - (_counter / seconds);
      }
      if (_counter >= seconds - 1) {
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
    final photo = widget.service.user!.person.photo;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: InkWell(
        onTap: () async {
          Navigator.of(context).push(MaterialPageRoute(
            builder: (context) => ServiceDescriptionPage(widget.service),
          ));
        },
        child: Container(
          width: double.maxFinite,
          decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(5),
              boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 3)]),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
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
                    top: 7,
                    left: 12,
                    right: 12,
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          CircleAvatar(
                            radius: 25,
                            backgroundImage: (photo != null
                                    ? NetworkImage(photo)
                                    : AssetImage("assets/icons/im.png"))
                                as ImageProvider,
                          ),
                          SizedBox(
                            height: 4,
                          ),
                          Text(
                            widget.service.user!.firstName,
                            style: TextStyle(
                                color: inDomiGreyBlack,
                                fontWeight: FontWeight.bold,
                                fontSize: 13),
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
                                "${widget.service.user!.getStars}",
                                style: TextStyle(
                                    color: inDomiGreyBlack, fontSize: 12),
                              ),
                            ],
                          )
                        ],
                      ),
                      SizedBox(
                        width: 20,
                      ),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Text(
                                  getServiceDescription(
                                      widget.service.serviceType),
                                  style: TextStyle(
                                      color: inDomiGreyBlack,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 14),
                                ),
                                Spacer(),
                                Text(
                                  "ID: ${widget.service.id.toString().padLeft(6, '0')}",
                                  style: TextStyle(
                                      fontSize: 12, color: inDomiGreyBlack),
                                ),
                              ],
                              crossAxisAlignment: CrossAxisAlignment.end,
                            ),
                            SizedBox(
                              height: 5,
                            ),
                            ...widget.service.wayPoints.map((e) {
                              return Padding(
                                padding: const EdgeInsets.only(bottom: 7),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Image.asset(
                                      "assets/icons/maps-and-flags@3x.png",
                                      height: 13,
                                      width: 13,
                                    ),
                                    SizedBox(
                                      width: 4,
                                    ),
                                    Expanded(
                                      child: Text(
                                        e.address,
                                        style: TextStyle(
                                            color: inDomiGreyBlack,
                                            fontSize: 11),
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            }).toList(),
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(left: 1.5),
                                  child: Text(
                                    DomiFormat.formatCurrencyCustom(
                                        widget.service.offer.toDouble()),
                                    style: TextStyle(
                                        color: inDomiButtonBlue,
                                        fontSize: 13,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ),
                                SizedBox(
                                  width: 20,
                                ),
                                Text(
                                  "${DomiFormat.formatCompat(widget.service.distance)} km",
                                  style: TextStyle(
                                      color: inDomiGreyBlack, fontSize: 12),
                                ),
                                Spacer(),
                                getPayMethodIcon(widget.service.payMethod)
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  )),
            ],
          ),
        ),
      ),
    );
  }
}
