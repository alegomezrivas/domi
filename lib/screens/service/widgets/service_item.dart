import 'package:domi/core/enum/service_enums.dart';
import 'package:domi/core/extensions/string.dart';
import 'package:domi/models/service/service.dart';
import 'package:domi/re_use/theme.dart';
import 'package:domi/re_use/utils/domi_format.dart';
import 'package:domi/screens/home/configuration_drawer/domi_drawer.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ServiceItem extends StatelessWidget {
  final VoidCallback? onTap;
  final Service service;
  final DomiType domiType;

  ServiceItem(
      {required this.service, this.onTap, this.domiType = DomiType.user});

  @override
  Widget build(BuildContext context) {
    final photo = domiType == DomiType.domi
        ? service.user!.person.photo
        : service.domi!.person.photo;
    final simpleUser =
        domiType == DomiType.domi ? service.user! : service.domi!;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: InkWell(
        onTap: onTap,
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
              Container(
                decoration: BoxDecoration(
                  color: inDomiYellow,
                  borderRadius: BorderRadius.circular(5),
                ),
                height: 8,
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
                            simpleUser.firstName,
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
                                "${simpleUser.getStars}",
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
                                  getServiceDescription(service.serviceType),
                                  style: TextStyle(
                                      color: inDomiGreyBlack,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 14),
                                ),
                                Spacer(),
                                Text(
                                  "ID: ${service.id.toString().padLeft(6, '0')}",
                                  style: TextStyle(
                                      fontSize: 12, color: inDomiGreyBlack),
                                ),
                              ],
                              crossAxisAlignment: CrossAxisAlignment.end,
                            ),
                            SizedBox(
                              height: 5,
                            ),
                            ...service.wayPoints.map((e) {
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
                                        service.offer.toDouble()),
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
                                  "${DomiFormat.formatCompat(service.distance)} km",
                                  style: TextStyle(
                                      color: inDomiGreyBlack, fontSize: 12),
                                ),
                                Spacer(),
                                getPayMethodIcon(service.payMethod)
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
