import 'package:domi/core/enum/service_enums.dart';
import 'package:domi/models/service/service.dart';
import 'package:domi/re_use/theme.dart';
import 'package:domi/re_use/utils/domi_format.dart';
import 'package:flutter/material.dart';

class ServiceHistoryItem extends StatelessWidget {
  final Service service;
  final bool showDomiTax;

  ServiceHistoryItem({required this.service, this.showDomiTax = false});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.maxFinite,
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(5),
          boxShadow: [
            BoxShadow(
              color: Colors.black12,
              blurRadius: 10,
            ),
          ]),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: double.maxFinite,
            alignment: Alignment.center,
            decoration: BoxDecoration(
                color: inDomiScaffoldGrey,
                border:
                    Border(top: BorderSide(width: 0.4, color: Colors.black12))),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
              child: Row(
                children: [
                  Text(
                    DomiFormat.formatDateTZString(service.createdAt),
                    style: TextStyle(
                        color: inDomiBluePrimary,
                        fontWeight: FontWeight.bold,
                        fontSize: 15),
                  ),
                  Spacer(),
                  Text(
                    service.getTotal,
                    style: TextStyle(
                        color: inDomiBluePrimary,
                        fontWeight: FontWeight.bold,
                        fontSize: 15),
                  ),
                ],
              ),
            ),
          ),
          Padding(
            padding:
                const EdgeInsets.only(top: 7, bottom: 10, left: 15, right: 15),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      DomiFormat.timeAgoFormat(service.createdAt),
                      style: TextStyle(color: inDomiBluePrimary, fontSize: 12),
                    ),
                    Spacer(),
                    getServiceStatusText(service.serviceStatus)
                  ],
                ),
                SizedBox(
                  height: 10,
                ),
                ...service.wayPoints.map((e) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 4),
                    child: Row(
                      children: [
                        Image.asset(
                          "assets/icons/maps-and-flags@3x.png",
                          height: 16,
                          width: 16,
                        ),
                        SizedBox(
                          width: 4,
                        ),
                        Flexible(
                          child: Text(
                            e.address,
                            style: TextStyle(color: inDomiGreyBlack, fontSize: 14),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                  );
                }).toList(),
                SizedBox(
                  height: 10,
                ),
                Row(
                  children: [
                    Text(
                      showDomiTax ? "Comisión ${service.getTotalDomiTax}" : "",
                      style: TextStyle(color: inDomiBluePrimary, fontSize: 12),
                    ),
                    Spacer(),
                    Text(
                      "ID: ${service.id.toString().padLeft(6, "0")}",
                      style: TextStyle(
                        color: inDomiGreyBlack,
                        fontSize: 15,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
