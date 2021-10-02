import 'package:domi/main.dart';
import 'package:domi/models/user/user.dart';
import 'package:domi/re_use/domi_register_login.dart';
import 'package:domi/re_use/theme.dart';
import 'package:domi/re_use/utils/dialogs.dart';
import 'package:domi/screens/home/home_page.dart';
import 'package:domi/screens/register/domiciliary_form_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class UserOrDomi extends StatefulWidget {
  @override
  _UserOrDomiState createState() => _UserOrDomiState();
}

class _UserOrDomiState extends State<UserOrDomi> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: inDomiYellow,
        body: DomiRegisterLogin(
          image: Image(
            image: AssetImage("assets/icons/Grupo 8@3x.png"),
            height: 51,
            fit: BoxFit.fitHeight,
          ),
          column: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 30),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Escoge una opción:",
                    style: TextStyle(
                        fontSize: 25,
                        color: inDomiBluePrimary,
                        fontWeight: FontWeight.bold),
                  ),
                  SizedBox(
                    height: 26,
                  ),
                  InkWell(
                    onTap: () async {
                      try {
                        loading(context);
                        final response = await context
                            .read(registerProvider.notifier)
                            .registerUser();
                        print(response);
                        await context
                            .read(authProvider)
                            .setUserData(UserData.fromJson(response));
                        Navigator.of(context).pop();
                        Navigator.of(context).pushAndRemoveUntil(
                            MaterialPageRoute(
                              builder: (context) => HomePage(),
                            ),
                            (route) => false);
                      } catch (e) {
                        Navigator.of(context).pop();
                        showError(context, e);
                      }
                    },
                    child: Container(
                      height: 110,
                      width: double.maxFinite,
                      alignment: Alignment.topLeft,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(14),
                      ),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Image(
                            image:
                                AssetImage("assets/icons/Enmascarar1@3x.png"),
                            width: 120,
                            fit: BoxFit.cover,
                          ),
                          Text(
                            "Soy usuario",
                            style: TextStyle(
                                fontSize: 22,
                                color: inDomiBluePrimary,
                                fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  InkWell(
                    onTap: () {
                      Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => DomiciliaryFormPage(),
                      ));
                    },
                    child: Container(
                      height: 110,
                      width: double.maxFinite,
                      alignment: Alignment.topLeft,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(14),
                      ),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(left: 37),
                            child: Text(
                              "Soy Domi",
                              style: TextStyle(
                                  fontSize: 22,
                                  color: inDomiBluePrimary,
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
                          Spacer(),
                          Image(
                            image:
                                AssetImage("assets/icons/Enmascarar 5@3x.png"),
                            width: 133,
                            fit: BoxFit.cover,
                          ),
                        ],
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
        ));
  }
}
