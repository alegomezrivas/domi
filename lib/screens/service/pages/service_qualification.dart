import 'package:domi/models/general/review_message.dart';
import 'package:domi/models/service/service.dart';
import 'package:domi/provider/config/favorites_provider.dart';
import 'package:domi/provider/service/active_services_provider.dart';
import 'package:domi/re_use/button_register_login.dart';
import 'package:domi/re_use/theme.dart';
import 'package:domi/re_use/utils/dialogs.dart';
import 'package:domi/repositories/general_repository.dart';
import 'package:domi/repositories/service_repository.dart';
import 'package:domi/screens/home/configuration_drawer/domi_drawer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ServiceQualification extends StatefulWidget {
  final Service service;
  final DomiType domiType;

  ServiceQualification(this.service, {this.domiType = DomiType.user});

  @override
  _ServiceQualificationState createState() => _ServiceQualificationState();
}

class _ServiceQualificationState extends State<ServiceQualification> {
  ValueNotifier<int> _selectedQualification = ValueNotifier<int>(0);
  ValueNotifier<bool> _domiFavorite = ValueNotifier<bool>(false);
  ValueNotifier<List<ReviewMessage>> _reviewMessages =
      ValueNotifier<List<ReviewMessage>>([]);
  double _selectedStars = 0;

  @override
  void initState() {
    _domiFavorite.value = widget.service.isFavorite;
    getReviewMessages();
    super.initState();
  }

  @override
  void dispose() {
    _selectedQualification.dispose();
    _reviewMessages.dispose();
    super.dispose();
  }

  getReviewMessages() async {
    try {
      _reviewMessages.value = await GeneralRepository.getReviewMessages();
    } catch (e) {
      showError(context, e);
    }
  }

  @override
  Widget build(BuildContext context) {
    final photo = widget.domiType == DomiType.user
        ? widget.service.domi!.person.photo
        : widget.service.user!.person.photo;
    return Scaffold(
      backgroundColor: inDomiScaffoldGrey,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(right: 10, top: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(right: 12),
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
              height: 40,
            ),
            Text(
              widget.domiType == DomiType.user
                  ? "Califique el servicio de su Domi"
                  : "Califique al usuario",
              style: TextStyle(
                  color: inDomiBluePrimary,
                  fontWeight: FontWeight.bold,
                  fontSize: 15),
            ),
            SizedBox(
              height: 30,
            ),
            CircleAvatar(
              radius: 60,
              backgroundImage: (photo != null
                  ? NetworkImage(photo)
                  : AssetImage("assets/icons/im.png")) as ImageProvider,
            ),
            SizedBox(
              height: 4,
            ),
            Text(
              widget.domiType == DomiType.user
                  ? widget.service.domi!.fullName
                  : widget.service.user!.fullName,
              style: TextStyle(
                  color: inDomiGreyBlack,
                  fontWeight: FontWeight.bold,
                  fontSize: 15),
            ),
            SizedBox(
              height: 10,
            ),
            if (widget.domiType == DomiType.user)
              ValueListenableBuilder(
                  valueListenable: _domiFavorite,
                  builder: (context, value, child) {
                    return InkWell(
                      onTap: () {
                        if (!_domiFavorite.value) {
                          _domiFavorite.value = true;
                          context
                              .read(favoritesProvider.notifier)
                              .createFavorite(widget.service.domi!.id);
                        }
                        // else {
                        //   _domiFavorite.value = false;
                        //   context
                        //       .read(favoritesProvider.notifier)
                        //       .deleteFavorite(widget.service.domi!.id);
                        // }
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          color: value == true
                              ? Color(0xffFFCB00)
                              : inDomiBluePrimary,
                          borderRadius: BorderRadius.circular(19),
                        ),
                        width: 190,
                        height: 28,
                        child: Stack(
                          alignment: Alignment.center,
                          children: [
                            Text(
                              value == false
                                  ? "Marca como favorito"
                                  : "Domi favorito",
                              style: TextStyle(
                                  color: value == true
                                      ? inDomiBluePrimary
                                      : Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 13),
                            ),
                            value == true
                                ? Positioned(
                                    left: 7,
                                    child: Icon(
                                      Icons.check_circle_outline,
                                      color: inDomiBluePrimary,
                                      size: 22,
                                    ),
                                  )
                                : SizedBox(),
                          ],
                        ),
                      ),
                    );
                  }),
            SizedBox(
              height: 21,
            ),
            RatingBar.builder(
              initialRating: 0,
              minRating: 1,
              itemSize: 32,
              direction: Axis.horizontal,
              allowHalfRating: false,
              glow: false,
              updateOnDrag: true,
              itemCount: 5,
              itemPadding: EdgeInsets.only(right: 3),
              itemBuilder: (context, _) => Icon(
                Icons.star,
                color: inDomiYellow,
                size: 16,
              ),
              onRatingUpdate: (rating) {
                setState(() {
                  _selectedStars = rating;
                });
              },
            ),
            SizedBox(
              height: 30,
            ),
            Text(
              "¿Qué fue lo que más te gustó?",
              style: TextStyle(
                  color: inDomiBluePrimary,
                  fontWeight: FontWeight.bold,
                  fontSize: 15),
            ),
            SizedBox(
              height: 9,
            ),
            ValueListenableBuilder<List<ReviewMessage>>(
                valueListenable: _reviewMessages,
                builder: (context, value, child) {
                  return Wrap(
                    children: value
                        .where((element) =>
                            element.fromStar <= _selectedStars &&
                            element.toStar >= _selectedStars)
                        .map((e) {
                      return buttonQualification(e.description, () {
                        e.selected = !e.selected;
                        _reviewMessages.notifyListeners();
                      }, e.selected ? inDomiButtonBlue : inDomiGreyBlack);
                    }).toList(),
                  );
                }),
            SizedBox(
              height: 15,
            ),
            ButtonRegisterLogin(
              height: 37,
              width: 202,
              color: inDomiBluePrimary,
              text: Text(
                "Enviar",
                style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 14),
              ),
              voidCallback: () {
                if (widget.domiType == DomiType.user) {
                  context
                      .read(activeServicesProvider.notifier)
                      .removeService(widget.service.id);
                }
                if (_selectedStars != 0) {
                  ServiceRepository.sendServiceQualification(
                      widget.service.id,
                      _selectedStars,
                      _reviewMessages.value
                          .where((element) =>
                              element.fromStar <= _selectedStars &&
                              element.toStar >= _selectedStars &&
                              element.selected)
                          .map((e) => e.id)
                          .toList());
                }
                Navigator.of(context).pop();
              },
            ),
            SizedBox(
              height: 10,
            ),
            TextButton(
              onPressed: () {
                context
                    .read(activeServicesProvider.notifier)
                    .removeService(widget.service.id);
                Navigator.of(context).pop();
              },
              child: Text(
                "Omitir y continuar",
                style: TextStyle(
                    color: inDomiBluePrimary,
                    decoration: TextDecoration.underline,
                    fontSize: 12),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buttonQualification(
      String text, VoidCallback voidCallback, Color color) {
    return Padding(
      padding: const EdgeInsets.all(4.0),
      child: ElevatedButton(
          onPressed: voidCallback,
          style: ElevatedButton.styleFrom(
              elevation: 0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(19),
                side: BorderSide(color: color),
              ),
              primary: Colors.white),
          child: Text(
            text,
            style: TextStyle(color: inDomiGreyBlack, fontSize: 14),
          )),
    );
  }
}
