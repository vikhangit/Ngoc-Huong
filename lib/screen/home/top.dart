import 'package:flutter/material.dart';
import 'package:ngoc_huong/screen/home/action.dart';
import 'package:ngoc_huong/screen/home/banner.dart';

class TopBanner extends StatefulWidget {
  const TopBanner({super.key});

  @override
  State<TopBanner> createState() => _TopBannerState();
}

class _TopBannerState extends State<TopBanner> {
  @override
  Widget build(BuildContext context) {
    return const SizedBox(
      height: 360,
      child: Stack(
        clipBehavior: Clip.none,
        children: [BannerSlider(), ActionHome()],
      ),
    );
  }
}
