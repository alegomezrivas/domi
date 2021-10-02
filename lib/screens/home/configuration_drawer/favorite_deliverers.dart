import 'package:domi/provider/config/favorites_provider.dart';
import 'package:domi/re_use/theme.dart';
import 'package:domi/re_use/utils/domi_format.dart';
import 'package:domi/screens/register/domiciliary_form/domi_sliver_app_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class FavoriteDelivers extends StatefulWidget {
  @override
  _FavoriteDeliversState createState() => _FavoriteDeliversState();
}

class _FavoriteDeliversState extends State<FavoriteDelivers> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      context.read(favoritesProvider.notifier).getFavorites();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: inDomiScaffoldGrey,
      body: CustomScrollView(
        slivers: [
          DomiSliverAppBar("Repartidores favoritos"),
          Consumer(
            builder: (context, watch, child) {
              final data = watch(favoritesProvider).results;
              return SliverList(
                  delegate: SliverChildBuilderDelegate((context, index) {
                final photo = data[index].domi.person.photo;
                return Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 17, vertical: 18),
                  child: Container(
                    width: double.maxFinite,
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(5),
                        boxShadow: [
                          BoxShadow(color: Colors.black12, blurRadius: 3)
                        ]),
                    child: Column(
                      children: [
                        Container(
                          color: inDomiYellow,
                          width: double.maxFinite,
                          height: 8,
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 10, vertical: 12),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              CircleAvatar(
                                radius: 22,
                                backgroundImage: (photo != null
                                        ? NetworkImage(photo)
                                        : AssetImage("assets/icons/im.png"))
                                    as ImageProvider,
                              ),
                              SizedBox(
                                width: 10,
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    data[index].domi.fullName,
                                    style: TextStyle(
                                        color: inDomiGreyBlack,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 14),
                                  ),
                                  Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Icon(
                                        Icons.star,
                                        color: inDomiButtonBlue,
                                        size: 16,
                                      ),
                                      Text(
                                        "${DomiFormat.formatCompat(data[index].domi.person.stars / data[index].domi.person.reviews)}",
                                        style: TextStyle(
                                            color: inDomiGreyBlack,
                                            fontSize: 13),
                                      ),
                                    ],
                                  )
                                ],
                              ),
                              Spacer(),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  Text(
                                    "${data[index].domi.person.domiCount} Servicios",
                                    style: TextStyle(
                                        color: inDomiBluePrimary, fontSize: 14),
                                  ),
                                  InkWell(
                                    onTap: () {
                                      context
                                          .read(favoritesProvider.notifier)
                                          .deleteFavorite(data[index].id);
                                    },
                                    child: Text(
                                      "Eliminar",
                                      style: TextStyle(
                                          color: inDomiButtonBlue,
                                          fontSize: 12,
                                          decoration: TextDecoration.underline),
                                    ),
                                  )
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              }, childCount: data.length));
            },
          )
        ],
      ),
    );
  }
}
