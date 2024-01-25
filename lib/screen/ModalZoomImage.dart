import 'package:dots_indicator/dots_indicator.dart';
import 'package:flutter/material.dart';
import 'package:loading_indicator/loading_indicator.dart';
import 'package:ngoc_huong/screen/start/start_screen.dart';
import 'package:ngoc_huong/utils/CustomTheme/custom_theme.dart';
import 'package:photo_view/photo_view.dart';
import 'package:photo_view/photo_view_gallery.dart';
import 'package:upgrader/upgrader.dart';

class ModalZoomImage extends StatefulWidget {
  final int currentIndex;
  final List<String> imageList;
  const ModalZoomImage(
      {super.key, required this.currentIndex, required this.imageList});

  @override
  State<ModalZoomImage> createState() => _ModalZoomImageState();
}

int currentIndex = 0;

class _ModalZoomImageState extends State<ModalZoomImage> {
  final scaffoldKey = GlobalKey<ScaffoldState>();
  PageController pageController = PageController();
  @override
  void initState() {
    super.initState();
    setState(() {
      currentIndex = widget.currentIndex;
      pageController = PageController(initialPage: widget.currentIndex);
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      bottom: false,
      child: Scaffold(
          key: scaffoldKey,
          backgroundColor: Colors.black,
          resizeToAvoidBottomInset: true,
          // bottomNavigationBar: ScrollToHide(
          //     scrollController: scrollController,
          //     height: 100,
          //     child: const MyBottomMenu(
          //       active: 0,
          //     )),
          appBar: AppBar(
            backgroundColor: Colors.black,
            leadingWidth: 45,
            centerTitle: true,
            leading: GestureDetector(
                onTap: () {
                  Navigator.of(context).pop();
                },
                child: Container(
                  margin: const EdgeInsets.only(left: 10),
                  child: Icon(
                    Icons.west,
                    size: 28,
                    color: mainColor,
                  ),
                )),
          ),
          body: UpgradeAlert(
              upgrader: Upgrader(
                dialogStyle: UpgradeDialogStyle.cupertino,
                canDismissDialog: false,
                showLater: false,
                showIgnore: false,
                showReleaseNotes: false,
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: PhotoViewGallery.builder(
                      scrollPhysics: const BouncingScrollPhysics(),
                      builder: (BuildContext context, int index) {
                        return PhotoViewGalleryPageOptions(
                          minScale: PhotoViewComputedScale.contained * 1,
                          maxScale: PhotoViewComputedScale.contained * 4,
                          imageProvider: NetworkImage(widget.imageList[index]),
                          initialScale: PhotoViewComputedScale.contained * 1,
                          heroAttributes: PhotoViewHeroAttributes(tag: index),
                        );
                      },
                      itemCount: widget.imageList.length,
                      loadingBuilder: (context, event) => const Center(
                        child: SizedBox(
                          width: 20.0,
                          height: 20.0,
                          child: LoadingIndicator(
                            colors: kDefaultRainbowColors,
                            indicatorType: Indicator.lineSpinFadeLoader,
                            strokeWidth: 1,
                            // pathBackgroundColor: Colors.black45,
                          ),
                        ),
                      ),
                      // backgroundDecoration: widget.backgroundDecoration,
                      pageController: pageController,
                      onPageChanged: (int index) {
                        setState(() {
                          currentIndex = index;
                        });
                      },
                    ),
                  ),
                  const SizedBox(
                    height: 30,
                  ),
                  if (widget.imageList.length > 1)
                    DotsIndicator(
                      dotsCount: widget.imageList.length,
                      position: currentIndex,
                      onTap: (int index) => setState(() {
                        currentIndex = index;
                      }),
                      decorator: DotsDecorator(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(4.0),
                          ),
                          size: const Size(6, 6),
                          activeSize: const Size(6, 6),
                          color: Colors.grey.shade800,
                          activeColor: Colors.white,
                          activeShape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(4.0),
                          ),
                          spacing: const EdgeInsets.all(5)),
                    ),
                  const SizedBox(
                    height: 50,
                  ),
                ],
              ))),
    );
  }
}
