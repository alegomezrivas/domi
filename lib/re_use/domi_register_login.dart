import 'package:domi/main.dart';
import 'package:domi/re_use/theme.dart';
import 'package:domi/repositories/user_repository.dart';
import 'package:domi/screens/domi_home/domi_home_page.dart';
import 'package:domi/screens/home/home_page.dart';
import 'package:domi/screens/home/service/deliveries_available.dart';
import 'package:domi/screens/register/enter_number.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';

class DomiRegisterLogin extends StatefulWidget {
  final Widget? column;
  final Image? image;
  final bool splash;
  final int? deliveries;

  DomiRegisterLogin(
      {this.column, this.image, this.splash = false, this.deliveries});

  @override
  _DomiRegisterLoginState createState() => _DomiRegisterLoginState();
}

class _DomiRegisterLoginState extends State<DomiRegisterLogin> {
  @override
  void initState() {
    super.initState();
    // if (widget.splash) {
    //   this.initUserData();
    // }
  }

  initUserData() async {
    final provider = context.read(authProvider);
    try {
      if (await provider.getUserData()) {
        await UserRepository.refreshToken();
        await provider.getUserInfo();
        Future.delayed(Duration(milliseconds: 300), () {
          if (widget.deliveries != null) {
            Navigator.of(context).pushReplacementNamed("/deliveries",
                arguments: widget.deliveries!);
          } else {
            Navigator.of(context).pushReplacementNamed(
                provider.userData!.user.isDomi ? "/domihome" : "/home");
          }
        });
      } else {
        Future.delayed(Duration(milliseconds: 300), () {
          Navigator.of(context).pushReplacement(
              MaterialPageRoute(builder: (context) => EnterNumber()));
        });
      }
    } catch (e) {
      await provider.logout();
      Future.delayed(Duration(milliseconds: 300), () {
        Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: (context) => EnterNumber()));
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final media = MediaQuery.of(context);
    return Container(
      width: media.size.width,
      height: media.size.height,
      decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/icons/Grupo 2@3x.png"),
            fit: BoxFit.cover,
          ),
          color: inDomiYellow),
      child: Stack(
        alignment: Alignment.center,
        children: [
          if (widget.column != null) widget.column!,
          if (widget.splash)
            Image(
              image: AssetImage("assets/icons/Grupo 8@3x.png"),
              height: 80,
              fit: BoxFit.fitHeight,
            ),
          widget.image != null
              ? Positioned(
                  right: 30,
                  top: media.viewPadding.top + 25,
                  child: widget.image!)
              : SizedBox(),
        ],
      ),
    );
  }
}
