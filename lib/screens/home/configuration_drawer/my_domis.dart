import 'package:domi/re_use/theme.dart';
import 'package:domi/screens/register/domiciliary_form/domi_sliver_app_bar.dart';
import 'package:flutter/material.dart';

class MyDomis extends StatefulWidget {
  @override
  _MyDomisState createState() => _MyDomisState();
}

class _MyDomisState extends State<MyDomis> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: inDomiScaffoldGrey,
      body: CustomScrollView(
        slivers: [
          DomiSliverAppBar("Mis Domis"),
          SliverToBoxAdapter(child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 17, vertical: 18),
            child: Container(
              width: double.maxFinite,
              decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(5),
                  boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 3)]),
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Domicilio de comida",
                              style: TextStyle(
                                  color: inDomiGreyBlack,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 14),
                            ),
                            Text(
                              "15/02/2021, 15:42 am",
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
                              "2,500 COP",
                              style: TextStyle(
                                  color: inDomiButtonBlue,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 14),
                            ),
                            Text(
                              "Finalizado",
                              style: TextStyle(
                                  color: inDomiButtonBlue, fontSize: 11),
                            )
                          ],
                        ),
                      ],
                    ),
                    Divider(),
                    Row(
                      children: [
                        Image.asset(
                          "assets/icons/maps-and-flags@3x.png",
                          height: 20,
                          width: 20,
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        Text(
                          "Calle 78 #55-77 Barranquilla",
                          style:
                              TextStyle(color: inDomiGreyBlack, fontSize: 12),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 7,
                    ),
                    Row(
                      children: [
                        Image.asset(
                          "assets/icons/maps-and-flags@3x.png",
                          height: 20,
                          width: 20,
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        Text(
                          "Calle 78 #55-77 Barranquilla",
                          style:
                              TextStyle(color: inDomiGreyBlack, fontSize: 12),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ))
        ],
      ),
    );
  }
}
