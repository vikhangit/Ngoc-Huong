import 'package:flutter/material.dart';
import 'package:localstorage/localstorage.dart';
import 'package:ngoc_huong/screen/account/accoutScreen.dart';
import 'package:ngoc_huong/screen/booking/booking.dart';
import 'package:ngoc_huong/screen/cart/cart.dart';
import 'package:ngoc_huong/screen/home/home.dart';
import 'package:ngoc_huong/screen/notifications/notification.dart';
import 'package:ngoc_huong/screen/services/kien_thuc.dart';
import 'package:ngoc_huong/screen/services/lam_dep_da.dart';
import 'package:ngoc_huong/screen/services/my_pham.dart';
import 'package:ngoc_huong/screen/services/phu_xam.dart';
import 'package:ngoc_huong/screen/services/spa.dart';
import 'package:ngoc_huong/screen/services/thanh_vien.dart';
import 'package:ngoc_huong/screen/services/tin_tuc.dart';
import 'package:ngoc_huong/screen/services/tu_van.dart';
import 'package:ngoc_huong/screen/services/uu_dai.dart';
import 'package:ngoc_huong/screen/start/start_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  LocalStorage storage = LocalStorage("auth");
  @override
  void dispose() {
    super.dispose();
  }

  @override
  initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Color mainColor = const Color(0xFFDC202E);
    return MaterialApp(
      title: 'Flutter Demo',
      initialRoute: "/",
      routes: {
        'start': (context) => const StartScreen(),
        'home': (context) => const HomeScreen(),
        'cart': (context) => const CartScreen(),
        'account': (context) => const AccountScreen(),
        "notifications": (context) => const NotificationScreen(),
        "phunXam": (context) => const PhunXamScreen(),
        "lamdepda": (context) => const LamDepDaScreen(),
        "spa": (context) => const SpaScreen(),
        "mypham": (context) => const MyPhamScreen(),
        "uudai": (context) => const UuDaiScreen(),
        "kienthuc": (context) => const KienThucScreen(),
        "tuvan": (context) => const TuVanScreen(),
        "tin_tuc": (context) => const TinTucScreen(),
        "hangthanhvien": (context) => const ThanhVienScreen(),
        "booking": (context) => const BookingServices(),
      },
      theme: ThemeData(
          fontFamily: "LexendDeca",
          appBarTheme: const AppBarTheme(),
          pageTransitionsTheme: const PageTransitionsTheme(
            builders: {
              TargetPlatform.android: CupertinoPageTransitionsBuilder(),
            },
          ),
          textTheme: const TextTheme(
            bodyMedium:
                TextStyle(fontWeight: FontWeight.w500, color: Colors.black),
            titleMedium:
                TextStyle(fontWeight: FontWeight.w400, color: Colors.black),
          ),
          textSelectionTheme: const TextSelectionThemeData(
            selectionColor: Colors.grey,
            cursorColor: Color(0xff171d49),
            selectionHandleColor: Color(0xff005e91),
          ),
          colorScheme: ColorScheme.fromSwatch()
              .copyWith(secondary: Colors.green, primary: mainColor),
          brightness: Brightness.light,
          highlightColor: Colors.white,
          floatingActionButtonTheme: FloatingActionButtonThemeData(
              backgroundColor: mainColor,
              focusColor: mainColor,
              splashColor: mainColor),
          bottomNavigationBarTheme: const BottomNavigationBarThemeData(
              type: BottomNavigationBarType.fixed,
              backgroundColor: Colors.white,
              selectedItemColor: Color.fromARGB(255, 4, 194, 207),
              unselectedItemColor: Color.fromRGBO(0, 0, 0, 0.5))),
      home:
          // storage.getItem("start") == null
          //     ?
          const StartScreen(),
      // : ,
      debugShowCheckedModeBanner: false,
    );
  }
}
