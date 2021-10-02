import 'package:domi/provider/auth/auth_provider.dart';
import 'package:domi/provider/register/register_provider.dart';
import 'package:domi/provider/wallet/wallet_provider.dart';
import 'package:domi/re_use/domi_register_login.dart';
import 'package:domi/repositories/user_repository.dart';
import 'package:domi/router.dart';
import 'package:domi/screens/domi_home/domi_home_page.dart';
import 'package:domi/screens/home/home_page.dart';
import 'package:domi/screens/register/enter_number.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';

final authProvider = Provider<AuthProvider>((ref) => AuthProvider());
final registerProvider = StateNotifierProvider<RegisterNotifier, Register>(
    (ref) => RegisterNotifier(Register()));
final walletProvider = StateNotifierProvider<WalletProvider, WalletState>(
    (ref) => WalletProvider(WalletState()));

void main() {
  runApp(ProviderScope(child: MyApp()));
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    super.initState();
  }

  Future<String> initUserData() async {
    final provider = context.read(authProvider);
    try {
      if (await provider.getUserData()) {
        await UserRepository.refreshToken();
        await provider.getUserInfo();
        return provider.userData!.user.isDomi ? DOMIHOME : HOME;
      } else {
        return ENTER_NUMBER;
      }
    } catch (e) {
      await provider.logout();
      return ENTER_NUMBER;
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: true,
      theme: ThemeData(
        textTheme: GoogleFonts.poppinsTextTheme(),
        primaryColor: Color(0xff006696),
        backgroundColor: Colors.white,
        scaffoldBackgroundColor: Colors.white,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      localizationsDelegates: [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate
      ],
      supportedLocales: [const Locale('en'), const Locale('es')],
      home: FutureBuilder(
        future: initUserData(),
        builder: (context, snapshot) {
          if (snapshot.data == HOME) {
            return HomePage();
          }

          if (snapshot.data == DOMIHOME) {
            return DomiHomePage();
          }

          if (snapshot.data == ENTER_NUMBER) {
            return EnterNumber();
          }

          return DomiRegisterLogin(
            splash: true,
          );
        },
      ),
      onGenerateRoute: (settings) => generateDomiRoutes(settings),
    );
  }
}
