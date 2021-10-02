import 'package:domi/main.dart';
import 'package:domi/models/service/service_review.dart';
import 'package:domi/provider/domi/service_reviews_provider.dart';
import 'package:domi/re_use/theme.dart';
import 'package:domi/re_use/utils/domi_format.dart';
import 'package:domi/re_use/utils/loading_sliver.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AppreciationDomiciliary extends StatefulWidget {
  @override
  _AppreciationDomiciliaryState createState() =>
      _AppreciationDomiciliaryState();
}

class _AppreciationDomiciliaryState extends State<AppreciationDomiciliary> {
  ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    Future.microtask(() async {
      context.read(walletProvider.notifier).getWalletBalance();
      context.read(serviceReviewsProvider.notifier).getReviewStatus();
      context.read(serviceReviewsProvider.notifier).getReviews();
    });
  }

  void scrollListener() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent) {
      context.read(serviceReviewsProvider.notifier).getReviews();
    }
  }

  @override
  void dispose() {
    _scrollController.removeListener(scrollListener);
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: inDomiScaffoldGrey,
      body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 17),
          child: Consumer(
            builder: (context, watch, child) {
              final userData = watch(authProvider);
              final data = watch(serviceReviewsProvider).results;
              return CustomScrollView(
                controller: _scrollController,
                slivers: [
                  SliverToBoxAdapter(
                    child: Column(
                      children: [
                        Container(
                          height: 152,
                          width: 152,
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(76),
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Image.asset(
                                "assets/icons/review@2x.png",
                                height: 27,
                                width: 59,
                              ),
                              Text(
                                userData.userData!.user.getStars,
                                style: TextStyle(
                                    fontSize: 48,
                                    fontWeight: FontWeight.bold,
                                    color: inDomiBluePrimary),
                              ),
                              Text(
                                "${userData.userData!.user.person.reviews - 5} reseñas",
                                style: TextStyle(
                                    fontSize: 11, color: inDomiGreyBlack),
                              )
                            ],
                          ),
                        ),
                        SizedBox(
                          height: 25,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Column(
                              children: [
                                Text(
                                  "${userData.userData!.user.person.domiCount}",
                                  style: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                      color: inDomiBluePrimary),
                                ),
                                Text(
                                  "Viajes",
                                  style: TextStyle(
                                      fontSize: 11, color: inDomiGreyBlack),
                                )
                              ],
                            ),
                            Container(
                              height: 65,
                              width: 1,
                              color: Colors.black12,
                            ),
                            Column(
                              children: [
                                Text(
                                  "${userData.userData!.user.person.reviews - 5}",
                                  style: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                      color: inDomiBluePrimary),
                                ),
                                Text(
                                  "reseñas",
                                  style: TextStyle(
                                      fontSize: 11, color: inDomiGreyBlack),
                                )
                              ],
                            ),
                            Container(
                              height: 65,
                              width: 1,
                              color: Colors.black12,
                            ),
                            Column(
                              children: [
                                Text(
                                  watch(walletProvider).getBalance,
                                  style: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                      color: inDomiBluePrimary),
                                ),
                                Text(
                                  "Saldo",
                                  style: TextStyle(
                                      fontSize: 11, color: inDomiGreyBlack),
                                )
                              ],
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 30,
                        ),
                      ],
                    ),
                  ),
                  SliverList(
                      delegate: SliverChildBuilderDelegate((context, index) {
                    return QualificationItem(serviceReview: data[index]);
                  }, childCount: data.length)),
                  if (watch(serviceReviewsProvider.notifier).isLoading)
                    LoadingSliver()
                ],
              );
            },
          )),
    );
  }
}

class QualificationItem extends StatelessWidget {
  final ServiceReview serviceReview;

  QualificationItem({required this.serviceReview});

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
              padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 5),
              child: Row(
                children: [
                  Text(
                    serviceReview.user.firstName,
                    style: TextStyle(
                        color: inDomiBluePrimary,
                        fontWeight: FontWeight.bold,
                        fontSize: 15),
                  ),
                  Spacer(),
                  Text(
                    DomiFormat.timeAgoFormat(serviceReview.createdAt),
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
                const EdgeInsets.only(top: 15, bottom: 15, left: 12, right: 12),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Calificación",
                      style: TextStyle(
                          color: inDomiGreyBlack,
                          fontWeight: FontWeight.bold,
                          fontSize: 14),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    RatingBar.builder(
                      initialRating: serviceReview.stars,
                      minRating: 1,
                      itemSize: 23,
                      direction: Axis.horizontal,
                      allowHalfRating: true,
                      glow: false,
                      updateOnDrag: false,
                      ignoreGestures: true,
                      itemCount: 5,
                      itemPadding: EdgeInsets.only(right: 3),
                      itemBuilder: (context, _) => Icon(
                        Icons.star,
                        color: inDomiYellow,
                        size: 16,
                      ),
                      onRatingUpdate: (rating) {
                        print(rating);
                      },
                    ),
                  ],
                ),
                Container(
                  height: 90,
                  width: 0.5,
                  color: Colors.black12,
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      serviceReview.stars >= 3
                          ? "Lo que más gustó"
                          : "Lo que no me gusto",
                      style: TextStyle(
                          color: inDomiGreyBlack,
                          fontWeight: FontWeight.bold,
                          fontSize: 14),
                    ),
                    SizedBox(
                      height: 13,
                    ),
                    ...serviceReview.messages.map((e) {
                      return Text(
                        "- ${e.description}",
                        style: TextStyle(color: inDomiGreyBlack, fontSize: 11),
                      );
                    }).toList()
                  ],
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
