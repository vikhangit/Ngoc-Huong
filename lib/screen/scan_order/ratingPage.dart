import 'package:elegant_notification/elegant_notification.dart';
import 'package:elegant_notification/resources/arrays.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_rating_stars/flutter_rating_stars.dart';
import 'package:intl/intl.dart';
import 'package:loading_indicator/loading_indicator.dart';
import 'package:ngoc_huong/menu/bottom_menu.dart';
import 'package:ngoc_huong/models/profileModel.dart';
import 'package:ngoc_huong/models/ratingModel.dart';
import 'package:ngoc_huong/screen/home/home.dart';
import 'package:ngoc_huong/screen/scan_order/Ques1.dart';
import 'package:ngoc_huong/screen/scan_order/Ques2.dart';
import 'package:ngoc_huong/screen/scan_order/Ques3.dart';
import 'package:ngoc_huong/screen/scan_order/Ques4.dart';
import 'package:ngoc_huong/screen/scan_order/Ques5.dart';
import 'package:ngoc_huong/screen/scan_order/Ques6.dart';
import 'package:ngoc_huong/screen/start/start_screen.dart';
import 'package:ngoc_huong/utils/CustomModalBottom/custom_modal.dart';
import 'package:ngoc_huong/utils/CustomTheme/custom_theme.dart';
import 'package:scroll_to_hide/scroll_to_hide.dart';
import 'package:upgrader/upgrader.dart';

class RatingPage extends StatefulWidget {
  final String item;
  const RatingPage({super.key, required this.item});

  @override
  State<RatingPage> createState() => _RatingPageState();
}

List dataQuestionRating = [];
List listRating = [];
String nhanxet = '';
bool focusInput = false;
bool loading = true;
Map profile = {};
List detailList = [];
List star = [];

class _RatingPageState extends State<RatingPage> {
  final ScrollController scrollController = ScrollController();
  final TextEditingController controller = TextEditingController();
  final ProfileModel profileModel = ProfileModel();
  final DataCustom theme = DataCustom();
  final RatingrModel ratingrModel = RatingrModel();
  final CustomModal customModal = CustomModal();
  @override
  void initState() {
    super.initState();
    Upgrader.clearSavedSettings();
    setState(() {
      focusInput = false;
      star.clear();
    });
    profileModel.getProfile().then((value) => setState(() {
          profile = value;
        }));
    // ratingrModel.getRatingList().then((value) => setState(() {
    //       listRating = value;
    //     }));
    ratingrModel.getQuestionList().then((value) => setState(() {
          dataQuestionRating = value;
          for (var i = 0; i < value.length; i++) {
            star.add(1);
          }
          loading = false;
        }));
  }

  @override
  void dispose() {
    super.dispose();
    controller.dispose();
    focusInput = false;
    star.clear();
  }

  void changeComent(String value) {
    setState(() {
      nhanxet = value;
    });
  }

  @override
  Widget build(BuildContext context) {
    final scaffoldKey = GlobalKey<ScaffoldState>();
    final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
    return Form(
        key: _formKey,
        child: Builder(
            builder: (context) => SafeArea(
                bottom: false,
                top: false,
                child: Scaffold(
                    key: scaffoldKey,
                    backgroundColor: Colors.white,
                    resizeToAvoidBottomInset: true,
                    bottomNavigationBar: ScrollToHide(
                        scrollController: scrollController,
                        height: 100,
                        child: const MyBottomMenu(
                          active: 4,
                        )),
                    appBar: AppBar(
                      leadingWidth: 45,
                      centerTitle: true,
                      leading: GestureDetector(
                          onTap: () {
                            Navigator.of(context).pop();
                          },
                          child: Container(
                            margin: const EdgeInsets.only(left: 15),
                            decoration: const BoxDecoration(
                                shape: BoxShape.circle, color: Colors.white),
                            child: const Icon(
                              Icons.west,
                              size: 16,
                              color: Colors.black,
                            ),
                          )),
                      title: const Text("Đánh giá",
                          style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                              color: Colors.white)),
                    ),
                    body: UpgradeAlert(
                      upgrader: Upgrader(
                        dialogStyle: UpgradeDialogStyle.cupertino,
                        canDismissDialog: false,
                        showLater: false,
                        showIgnore: false,
                        showReleaseNotes: false,
                      ),
                      child: !loading
                          ? Column(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Expanded(
                                  child: ListView(
                                    controller: scrollController,
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 10, vertical: 20),
                                    children: [
                                      const Text(
                                        "ĐÁNH GIÁ CHẤT LƯỢNG LÀM ĐẸP",
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                            fontWeight: FontWeight.w600),
                                      ),
                                      const SizedBox(
                                        height: 20,
                                      ),
                                      const Text(
                                          "Cảm ơn quý khách hàng đã làm đẹp tại hệ thồng Thẩm Mỹ Viện Ngọc Hường, quý khách thấy chất lượng làm đẹp và phục vụ thế nào? Xin hãy để lại đánh giá nhé"),
                                      const SizedBox(
                                        height: 20,
                                      ),
                                      Column(
                                        children: dataQuestionRating.map((e) {
                                          int index =
                                              dataQuestionRating.indexOf(e);
                                          return Ques1(
                                              question: e["cau_hoi"],
                                              index: index);
                                        }).toList(),
                                      ),
                                      GestureDetector(
                                        onTap: () {
                                          setState(() {
                                            focusInput = true;
                                          });
                                        },
                                        child: Container(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 5, vertical: 10),
                                          decoration: BoxDecoration(
                                              border: Border.all(
                                                  width: 1, color: mainColor)),
                                          child: Column(children: [
                                            Row(
                                              children: [
                                                Image.asset(
                                                  "assets/images/editing.png",
                                                  width: 24,
                                                  height: 24,
                                                ),
                                                const SizedBox(
                                                  width: 5,
                                                ),
                                                Text(
                                                  "Viết nhận xét",
                                                  style: TextStyle(
                                                      fontSize: 14,
                                                      color: mainColor),
                                                )
                                              ],
                                            ),
                                            comment(
                                                context,
                                                focusInput,
                                                controller,
                                                (value) => changeComent(value))
                                          ]),
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                                GestureDetector(
                                    onTap: () {
                                      final isValid =
                                          _formKey.currentState!.validate();
                                      FocusManager.instance.primaryFocus!
                                          .unfocus();
                                      List detail = [];

                                      for (var i = 0;
                                          i < dataQuestionRating.length;
                                          i++) {
                                        detail.add({
                                          "cau_hoi": dataQuestionRating[i]
                                              ["cau_hoi"],
                                          "diem": star[i],
                                          "id_starquote_question":
                                              dataQuestionRating[i]["_id"]
                                        });
                                      }
                                      Map data = {
                                        "ngay": DateFormat("yyyy/MM/dd")
                                            .format(DateTime.now()),
                                        "mo_ta": controller.text,
                                        "details": [...detail],
                                        "ma_kh": profile["Phone"]
                                      };

                                      customModal.showAlertDialog(
                                          context,
                                          "error",
                                          "Gửi đánh giá",
                                          "Bạn có chắc chắn gửi đánh giá đên Ngọc Hường?",
                                          () {
                                        Navigator.of(context).pop();
                                        EasyLoading.show(
                                            status: "Vui lòng chờ...");
                                        Future.delayed(
                                            const Duration(seconds: 2), () {
                                          ratingrModel
                                              .addRatingForUser(data)
                                              .then((value) {
                                            EasyLoading.dismiss();
                                            star.clear();

                                            Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                    builder: (context) =>
                                                        HomeScreen(
                                                          callBack: () {
                                                            setState(() {});
                                                          },
                                                        )));
                                            setState(() {
                                              valueRating1 = 1.0;
                                              for (var i = 0;
                                                  i < dataQuestionRating.length;
                                                  i++) {
                                                star.add(1);
                                              }
                                              ElegantNotification.success(
                                                width: MediaQuery.of(context)
                                                    .size
                                                    .width,
                                                height: 50,
                                                notificationPosition:
                                                    NotificationPosition
                                                        .topCenter,
                                                toastDuration: const Duration(
                                                    milliseconds: 2000),
                                                animation:
                                                    AnimationType.fromTop,
                                                // title: const Text('Cập nhật'),
                                                description: const Text(
                                                  'Gửi đánh giá thành công!!! Cảm ơn quý khách đã đòng góp ý kiến',
                                                  style: TextStyle(
                                                      fontSize: 14,
                                                      fontWeight:
                                                          FontWeight.w300),
                                                ),
                                                onDismiss: () {},
                                              ).show(context);
                                            });
                                          });
                                        });
                                      }, () => Navigator.of(context).pop());
                                    },
                                    child: Container(
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 15),
                                      alignment: Alignment.center,
                                      margin: const EdgeInsets.symmetric(
                                          horizontal: 12.5),
                                      decoration: BoxDecoration(
                                          color: mainColor,
                                          borderRadius: const BorderRadius.all(
                                              Radius.circular(15))),
                                      child: const Text(
                                        "Gửi",
                                        style: TextStyle(
                                            color: Colors.white, fontSize: 16),
                                      ),
                                    )),
                                const SizedBox(
                                  height: 15,
                                )
                              ],
                            )
                          : const Center(
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  SizedBox(
                                    width: 40,
                                    height: 40,
                                    child: LoadingIndicator(
                                      colors: kDefaultRainbowColors,
                                      indicatorType:
                                          Indicator.lineSpinFadeLoader,
                                      strokeWidth: 1,
                                      // pathBackgroundColor: Colors.black45,
                                    ),
                                  ),
                                  SizedBox(
                                    width: 10,
                                  ),
                                  Text("Đang lấy dữ liệu")
                                ],
                              ),
                            ),
                    )))));
  }
}

class RatingQuestion extends StatefulWidget {
  final double valueRating;
  final String question;
  final Function(double a) setRating;
  const RatingQuestion(
      {super.key,
      required this.valueRating,
      required this.question,
      required this.setRating});

  @override
  State<RatingQuestion> createState() => _RatingQuestionState();
}

class _RatingQuestionState extends State<RatingQuestion> {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          margin: const EdgeInsets.only(bottom: 10),
          child: Text(widget.question),
        ),
        Center(
          child: RatingStars(
            value: widget.valueRating,
            onValueChanged: (v) {
              widget.setRating(v);
            },
            starCount: 5,
            starSize: 24,
            maxValue: 5,
            starSpacing: 5,
            maxValueVisibility: true,
            valueLabelVisibility: false,
            animationDuration: const Duration(milliseconds: 1000),
            starBuilder: (index1, color) {
              return SizedBox(
                child: widget.valueRating.round() >= index1 + 1
                    ? Image.asset(
                        "assets/images/star-solid.png",
                        width: 28,
                        height: 28,
                      )
                    : Image.asset("assets/images/star-outline.png",
                        width: 28, height: 28),
              );
            },
            starOffColor: mainColor,
            starColor: mainColor,
          ),
        )
      ],
    );
  }
}

Widget comment(BuildContext context, bool focus,
    TextEditingController controller, Function(String value) changeValue) {
  return TextFormField(
    textAlignVertical: TextAlignVertical.center,
    style: const TextStyle(
        fontSize: 14, color: Colors.black, fontWeight: FontWeight.w400),
    onChanged: (value) {
      // changeValue(value);
    },
    // validator: (value) {
    //   if (value == null || value.isEmpty) {
    //     return "Vui lòng nhập địa chỉ";
    //   }
    //   return null;
    // },
    autofocus: focus,
    controller: controller,
    maxLines: 3,
    decoration: InputDecoration(
      border: InputBorder.none,
      prefix: const Padding(padding: EdgeInsets.only(left: 10)),
      contentPadding:
          const EdgeInsets.only(left: 5, top: 5, right: 15, bottom: 0),
      hintStyle: TextStyle(
          fontSize: 14,
          color: Colors.black.withOpacity(0.5),
          fontWeight: FontWeight.w400),
      // hintText: 'Nhập địa chỉ',
    ),
  );
}
