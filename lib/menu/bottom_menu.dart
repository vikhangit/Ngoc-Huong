import 'package:flutter/material.dart';
import 'package:localstorage/localstorage.dart';
import 'package:ngoc_huong/screen/login/modal_pass_exist.dart';
import 'package:ngoc_huong/screen/login/modal_phone.dart';

class MyBottomMenu extends StatefulWidget {
  final int active;
  const MyBottomMenu({super.key, required this.active});

  @override
  State<MyBottomMenu> createState() => _MyBottomMenuState();
}

List bottomList = [
  {
    "icon": "assets/images/icon/home-black.png",
    "icon_active": "assets/images/icon/home-red.png",
    "title": "Trang chủ"
  },
  {
    "icon": "assets/images/cart-black.png",
    "icon_active": "assets/images/cart-red.png",
    "title": "Giỏ hàng"
  },
  {
    "icon": "assets/images/icon/notifications-black.png",
    "icon_active": "assets/images/icon/notifications-red.png",
    "title": "Thông báo"
  },
  {
    "icon": "assets/images/icon/profile-black.png",
    "icon_active": "assets/images/icon/profile-red.png",
    "title": "Tài khoản"
  },
];

class _MyBottomMenuState extends State<MyBottomMenu> {
  final LocalStorage storage = LocalStorage('auth');
  String a = "";
  void onItemTapped(int index) {
    if (index == 0) {
      Navigator.pushNamed(context, "home");
    } else {
      if (storage.getItem("authen") != null &&
          storage.getItem("lastname") != null) {
        switch (index) {
          case 1:
            {
              Navigator.pushNamed(context, "cart");
              break;
            }
          case 2:
            {
              Navigator.pushNamed(context, "notifications");
              break;
            }
          case 3:
            {
              Navigator.pushNamed(context, "account");
              break;
            }
          case 4:
            {
              Navigator.pushNamed(context, "booking");
              break;
            }
          default:
        }
      } else if (storage.getItem("authen") == null &&
          storage.getItem("lastname") != null) {
        showModalBottomSheet<void>(
            clipBehavior: Clip.antiAliasWithSaveLayer,
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.vertical(top: Radius.circular(15)),
            ),
            context: context,
            isScrollControlled: true,
            builder: (BuildContext context) {
              return Container(
                padding: EdgeInsets.only(
                    bottom: MediaQuery.of(context).viewInsets.bottom),
                height: MediaQuery.of(context).size.height * 0.9,
                child: const ModalPassExist(),
              );
            });
      } else {
        showModalBottomSheet<void>(
            clipBehavior: Clip.antiAliasWithSaveLayer,
            context: context,
            isScrollControlled: true,
            builder: (BuildContext context) {
              return Container(
                padding: EdgeInsets.only(
                    bottom: MediaQuery.of(context).viewInsets.bottom),
                height: MediaQuery.of(context).size.height * 0.96,
                child: const ModalPhone(),
              );
            });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    return Container(
      color: Colors.transparent,
      width: size.width,
      height: 90,
      child: Stack(
        children: [
          CustomPaint(
            size: Size(size.width, 90),
            painter: BNBCustomPainter(),
          ),
          Center(
              heightFactor: 0.55,
              child: SizedBox(
                width: 65,
                height: 65,
                child: FloatingActionButton(
                  backgroundColor: Colors.white,
                  focusColor: Colors.white,
                  splashColor: Colors.white,
                  onPressed: () {
                    onItemTapped(4);
                  },
                  child: Image.asset(
                    "assets/images/logo.png",
                  ),
                ),
              )),
          SizedBox(
            width: size.width,
            height: 110,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: bottomList.map((e) {
                int index = bottomList.indexOf(e);
                return Container(
                  height: 56,
                  margin: EdgeInsets.only(
                      left: index == 2 ? 15 : 0, right: index == 1 ? 15 : 0),
                  alignment: Alignment.center,
                  child: InkWell(
                      // style: ButtonStyle(
                      //     padding: MaterialStateProperty.all(
                      //         const EdgeInsets.symmetric(
                      //             vertical: 0.0, horizontal: 0.0))),
                      onTap: () => onItemTapped(index),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Image.asset(
                            index == widget.active
                                ? e["icon_active"]
                                : e["icon"],
                            width: 26,
                            height: 26,
                          ),
                          Text(
                            "${e["title"]}",
                            style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w300,
                                color: widget.active == index
                                    ? Theme.of(context).colorScheme.primary
                                    : Colors.black),
                          )
                        ],
                      )),
                );
              }).toList(),
            ),
          )
        ],
      ),
    );
  }
}

class BNBCustomPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    Paint paint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.fill;
    Path path = Path()..moveTo(0, 60);
    path.quadraticBezierTo(size.width * 0.0, 0, size.width * 0.35, 0);
    path.quadraticBezierTo(size.width * 0.40, 0, size.width * 0.40, 20);
    path.arcToPoint(Offset(size.width * 0.6, 20),
        radius: const Radius.circular(10.0), clockwise: false);
    path.quadraticBezierTo(size.width * 0.6, 0, size.width * 0.65, 0);
    path.quadraticBezierTo(size.width, 0, size.width, 60);
    path.lineTo(size.width, size.height);
    path.lineTo(0, size.height);
    path.close();
    canvas.drawShadow(path, Colors.black, 35, true);
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}
