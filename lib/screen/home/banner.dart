import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:localstorage/localstorage.dart';
import 'package:ngoc_huong/screen/login/modal_pass_exist.dart';
import 'package:ngoc_huong/screen/login/modal_phone.dart';
import 'package:ngoc_huong/utils/callapi.dart';

Widget banner(
    BuildContext context,
    Function(int index, CarouselPageChangedReason reason) pageChange,
    List bannerList,
    Function(int index) clickDotPageChange,
    String user,
    LocalStorage storage,
    CarouselController buttonCarouselController,
    int current,
    GlobalKey<CarouselSliderState> _sliderKey) {
  return Stack(
    fit: StackFit.passthrough,
    children: [
      CarouselSlider(
        key: _sliderKey,
        carouselController: buttonCarouselController,
        options: CarouselOptions(
          enlargeCenterPage: true,
          autoPlayCurve: Curves.linear,
          height: MediaQuery.of(context).size.height * 0.25,
          viewportFraction: 1,
          // autoPlay: true,
          initialPage: current,
          onPageChanged: pageChange,
        ),
        items: bannerList.map((i) {
          return Builder(
            builder: (BuildContext context) {
              return FractionallySizedBox(
                widthFactor: 1,
                heightFactor: 1,
                child: FittedBox(
                  fit: BoxFit.fill,
                  child: Image.network(
                    "$apiUrl${i["hinh_anh"]}?$token",
                    height: MediaQuery.of(context).size.height * 0.25,
                    width: MediaQuery.of(context).size.width,
                    fit: BoxFit.cover,
                  ),
                ),
              );
            },
          );
        }).toList(),
      ),
      Positioned(
          bottom: 10,
          left: 0,
          width: MediaQuery.of(context).size.width,
          child: Container(
            margin: const EdgeInsets.symmetric(horizontal: 15),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                storage.getItem("authen") == null
                    ? InkWell(
                        onTap: () {
                          storage.deleteItem("typeOTP");
                          showModalBottomSheet<void>(
                              clipBehavior: Clip.antiAliasWithSaveLayer,
                              context: context,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.vertical(
                                  top: Radius.circular(
                                      storage.getItem("authen") == null &&
                                              storage.getItem("lastname") ==
                                                  null
                                          ? 0
                                          : 15.0),
                                ),
                              ),
                              isScrollControlled: true,
                              builder: (BuildContext context) {
                                return Container(
                                  padding: EdgeInsets.only(
                                      bottom: MediaQuery.of(context)
                                          .viewInsets
                                          .bottom),
                                  height: MediaQuery.of(context).size.height *
                                      (storage.getItem("authen") == null &&
                                              storage.getItem("lastname") ==
                                                  null
                                          ? 0.96
                                          : 0.9),
                                  child: storage.getItem("authen") == null &&
                                          storage.getItem("lastname") == null
                                      ? const ModalPhone()
                                      : const ModalPassExist(),
                                );
                              });
                        },
                        child: Container(
                          decoration: const BoxDecoration(
                              color: Colors.transparent,
                              borderRadius:
                                  BorderRadius.all(Radius.circular(20.0))),
                          child: Row(
                            children: [
                              Image.asset(
                                width: 35,
                                height: 35,
                                "assets/images/account.png",
                              ),
                              const Text(
                                "Đăng nhập",
                                style: TextStyle(
                                    fontSize: 16, fontWeight: FontWeight.w400),
                              )
                            ],
                          ),
                        ),
                      )
                    : Text(
                        "Chào $user",
                        style: const TextStyle(
                            fontSize: 16, fontWeight: FontWeight.w400),
                      ),
                Row(
                    children: bannerList.map((e) {
                  int index = bannerList.indexOf(e);
                  return InkWell(
                    onTap: () {
                      clickDotPageChange(index);
                    },
                    child: Container(
                      width: 18,
                      height: 3,
                      margin: EdgeInsets.only(left: index != 0 ? 5 : 0),
                      decoration: BoxDecoration(
                          color: index == current ? Colors.white : Colors.grey,
                          borderRadius:
                              const BorderRadius.all(Radius.circular(20))),
                    ),
                  );
                }).toList())
              ],
            ),
          )),
    ],
  );
}
