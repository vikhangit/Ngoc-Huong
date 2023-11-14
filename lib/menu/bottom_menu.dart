import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:loading_indicator/loading_indicator.dart';
import 'package:localstorage/localstorage.dart';
import 'package:ngoc_huong/models/cartModel.dart';
import 'package:ngoc_huong/models/productModel.dart';
import 'package:ngoc_huong/models/profileModel.dart';
import 'package:ngoc_huong/models/servicesModel.dart';
import 'package:ngoc_huong/screen/account/booking_history/booking_history.dart';
import 'package:ngoc_huong/screen/booking/booking.dart';
import 'package:ngoc_huong/screen/cosmetic/cosmetic.dart';
import 'package:ngoc_huong/screen/login/loginscreen/login_screen.dart';
import 'package:ngoc_huong/screen/services/all_service.dart';
import 'package:ngoc_huong/screen/start/start_screen.dart';
import 'package:ngoc_huong/utils/CustomModalBottom/custom_modal.dart';
import 'package:ngoc_huong/utils/CustomTheme/custom_theme.dart';


class MyBottomMenu extends StatefulWidget {
  final int active;
  const MyBottomMenu({super.key, required this.active});

  @override
  State<MyBottomMenu> createState() => _MyBottomMenuState();
}

int selectedTab = 0;

List bottomList = [
  {
    "icon": "assets/images/icon/home.png",
    "title": "Trang chủ"
  },
  {
    "icon": "assets/images/icon/dich-vu.png",
    "title": "Dịch vụ"
  },
  {
    "icon": "assets/images/icon/tu-van.png",
    "title": "Tư vấn"
  },
  {
    "icon": "assets/images/icon/my-pham.png",
    "title": "Mỹ phẩm cao cấp"
  },
  {
    "icon": "assets/images/telesales-black.png",
    "title": "Tư vấn"
  },
];

class _MyBottomMenuState extends State<MyBottomMenu> {
  final LocalStorage storageCustomer = LocalStorage('customer_token');
  final CustomModal customModal = CustomModal();
  final ProductModel productModel = ProductModel();
  final ProfileModel profileModel = ProfileModel();
  final CartModel cartModel = CartModel();
  final ServicesModel servicesModel = ServicesModel();
  String a = "";

  @override
  void initState() {
    setState(() {
      selectedTab = widget.active;
    });

    super.initState();
  }

  void onItemTapped(int index) {
    setState(() {
      selectedTab = index;
    });
   {
     if(index == 4){
       if (storageCustomer.getItem("customer_token") != null) {
         Navigator.pushNamed(context, "account");
       } else if (storageCustomer.getItem("customer_Token") == null) {
         Navigator.push(context,
             MaterialPageRoute(builder: ((context) => const LoginScreen())));
       }
     }else{
       switch (index) {
         case 0:{
           Navigator.pushNamed(context, "home");
           break;
         }
         case 1:
          {
            servicesModel.getGroupServiceByBranch().then((value) => Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => AllServiceScreen(
                      listTab: value,
                    ))));
            break;
          }
         case 3:
           {
             productModel.getGroupProduct().then((value) => Navigator.push(
                 context,
                 MaterialPageRoute(
                     builder: (context) => Cosmetic(
                       listTab: value,
                     ))));
             break;
           }
         case 2:
           {
             customModal.showBottomToolDialog(context);
             break;
           }
         default:
       }
     }

    }
  }

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    return Stack(
      children: [
        Container(
          width: size.width,
          padding: EdgeInsets.only(top: 15),
          decoration: BoxDecoration(
            color: Colors.white,
            boxShadow: <BoxShadow>[
              BoxShadow(
                  color: Colors.black38,
                  blurRadius: 10.0,
                  offset: Offset(0.0, 0.75)
              )
            ],
          ),
          height: 70,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: bottomList.map((e) {
              int index = bottomList.indexOf(e);
              if(index == 4){
                if(storageCustomer.getItem("customer_token") != null){
                  return Container(
                      // margin: EdgeInsets.only(
                      //     left: index == 2 ? 60 : 0, right: index == 1 ? 30 : 0),
                      width: MediaQuery.of(context).size.width / 5,
                      alignment: Alignment.center,
                      child: GestureDetector(
                        // style: ButtonStyle(
                        //     padding: MaterialStateProperty.all(
                        //         const EdgeInsets.symmetric(
                        //             vertical: 0.0, horizontal: 0.0))),
                          onTap: () => onItemTapped(index),
                          child: Column(
                            children: [
                              FutureBuilder(future: profileModel.getProfile(),
                                builder: (context, snapshot) {
                                  if(snapshot.hasData){
                                    return SizedBox(
                                        width: 28,
                                        height: 28,
                                      child: CircleAvatar(
                                        backgroundColor: const Color(0xff00A3FF),
                                        backgroundImage: NetworkImage(snapshot.data["CustomerImage"],),
                                      )
                                    );
                                  }else{
                                    return const SizedBox(
                                      width: 28,
                                      height: 28,
                                      child: LoadingIndicator(
                                        colors: kDefaultRainbowColors,
                                        indicatorType: Indicator.lineSpinFadeLoader,
                                        strokeWidth: 1,
                                        // pathBackgroundColor: Colors.black45,
                                      ),
                                    );
                                  }
                                },
                              ),
                              const  SizedBox(height: 5),
                              Text(
                                "Tài khoản",
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    fontSize: 10,
                                    fontWeight: FontWeight.w400,
                                    color: widget.active == index
                                        ? Theme.of(context).colorScheme.primary
                                        : Colors.black),
                              )
                            ],
                          ))
                  );
                }else{
                  return Container(
                    width:  MediaQuery.of(context).size.width / 5,
                    alignment: Alignment.center,
                    child: GestureDetector(
                      // style: ButtonStyle(
                      //     padding: MaterialStateProperty.all(
                      //         const EdgeInsets.symmetric(
                      //             vertical: 0.0, horizontal: 0.0))),
                        onTap: () => onItemTapped(index),
                        child: Column(
                          children: [
                            Image.asset(
                               "assets/images/icon/profile-red.png",
                              width: 28,
                              height: 28,
                              fit: BoxFit.contain,
                            ),
                            const  SizedBox(height: 5),
                            Text(
                              "Tài khoản",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  fontSize: 10,
                                  fontWeight: FontWeight.w400,
                                  color: widget.active == index
                                      ? Theme.of(context).colorScheme.primary
                                      : Colors.black),
                            )
                          ],
                        )),
                  );
                }
              }else{
                return Container(
                  width: index == 3 ? 100 :  (MediaQuery.of(context).size.width - 100) / 4 - 5,
                  alignment: Alignment.center,
                  child: GestureDetector(
                    // style: ButtonStyle(
                    //     padding: MaterialStateProperty.all(
                    //         const EdgeInsets.symmetric(
                    //             vertical: 0.0, horizontal: 0.0))),
                      onTap: () => onItemTapped(index),
                      child: Column(
                        children: [
                          Image.asset(
                            e["icon"],
                            width: 28,
                            height: 28,
                            fit: BoxFit.contain,
                          ),
                        const  SizedBox(height: 5),
                          Text(
                            "${e["title"]}",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                fontSize: 10,
                                fontWeight: FontWeight.w400,
                                color: widget.active == index
                                    ? Theme.of(context).colorScheme.primary
                                    : Colors.black),
                          )
                        ],
                      )),
                );
              }
            }).toList(),
          ),
        )
      ],
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
