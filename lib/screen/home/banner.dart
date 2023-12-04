import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:loading_indicator/loading_indicator.dart';
import 'package:ngoc_huong/models/banner.dart';
import 'package:ngoc_huong/screen/start/start_screen.dart';
import 'package:ngoc_huong/utils/CustomTheme/custom_theme.dart';

class BannerSlider extends StatefulWidget {
  const BannerSlider({super.key});

  @override
  State<BannerSlider> createState() => _BannerSliderState();
}

class _BannerSliderState extends State<BannerSlider> {
  final BannerModel bannerModel = BannerModel();
  @override
  Widget build(BuildContext context) {
    return SizedBox(
        height: 250,
        child: FutureBuilder(
            future: bannerModel.getBannerList(),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                List list = snapshot.data!;
                return CarouselSlider.builder(
                  itemCount: list.length,
                  options: CarouselOptions(
                      height: 250,
                      // aspectRatio: 26 / 14,
                      autoPlay: true,
                      autoPlayInterval: const Duration(seconds: 3),
                      viewportFraction: 1,
                      initialPage: 0,
                      onPageChanged: (index, reason) {
                        // goToPage(index, reason);
                      }),
                  itemBuilder: (context, index, realIndex) {
                    return ClipRRect(
                      borderRadius: const BorderRadius.vertical(
                          bottom: Radius.circular(15)),
                      child: Image.network("${list[index]["Image"]}",
                          fit: BoxFit.cover),
                    );
                  },
                );
              } else {
                return const SizedBox(
                  height: 250,
                  child: Center(
                    child: SizedBox(
                      width: 24,
                      height: 24,
                      child: LoadingIndicator(
                        colors: kDefaultRainbowColors,
                        indicatorType: Indicator.lineSpinFadeLoader,
                        strokeWidth: 1,
                        // pathBackgroundColor: Colors.black45,
                      ),
                    ),
                  ),
                );
              }
            }));
  }
}
