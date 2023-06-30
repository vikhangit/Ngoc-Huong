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
    LocalStorage storage,
    CarouselController buttonCarouselController,
    int current,
    GlobalKey<CarouselSliderState> _sliderKey,
    LocalStorage storageToken) {
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
                storage.getItem("existAccount") == null &&
                        storage.getItem("phone") == null
                    ? InkWell(
                        onTap: () {
                          storage.deleteItem("typeOTP");
                          showModalBottomSheet<void>(
                              clipBehavior: Clip.antiAliasWithSaveLayer,
                              context: context,
                              shape: const RoundedRectangleBorder(
                                borderRadius: BorderRadius.vertical(
                                  top: Radius.circular(15.0),
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
                                        0.96,
                                    child: const ModalPhone());
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
                    : storage.getItem("existAccount") != null &&
                            storage.getItem("phone") == null
                        ? InkWell(
                            onTap: () {
                              storage.deleteItem("typeOTP");
                              showModalBottomSheet<void>(
                                  clipBehavior: Clip.antiAliasWithSaveLayer,
                                  context: context,
                                  shape: const RoundedRectangleBorder(
                                    borderRadius: BorderRadius.vertical(
                                      top: Radius.circular(15.0),
                                    ),
                                  ),
                                  isScrollControlled: true,
                                  builder: (BuildContext context) {
                                    return Container(
                                      padding: EdgeInsets.only(
                                          bottom: MediaQuery.of(context)
                                              .viewInsets
                                              .bottom),
                                      height:
                                          MediaQuery.of(context).size.height *
                                              0.96,
                                      child: const ModalPassExist(),
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
                                        fontSize: 16,
                                        fontWeight: FontWeight.w400),
                                  )
                                ],
                              ),
                            ),
                          )
                        : FutureBuilder(
                            future: getProfile(storage.getItem("phone")),
                            builder: (context, snapshot) {
                              if (snapshot.hasData) {
                                return Text(
                                  "Chào ${snapshot.data![0]["ten_kh"]}",
                                  style: const TextStyle(
                                      fontWeight: FontWeight.w400),
                                );
                              } else {
                                return const Center(
                                  child: CircularProgressIndicator(),
                                );
                              }
                            },
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
