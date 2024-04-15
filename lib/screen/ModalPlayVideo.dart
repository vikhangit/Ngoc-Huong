import 'package:dots_indicator/dots_indicator.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_html_v3/flutter_html.dart';
import 'package:loading_indicator/loading_indicator.dart';
import 'package:ngoc_huong/screen/start/start_screen.dart';
import 'package:ngoc_huong/utils/CustomTheme/custom_theme.dart';
import 'package:photo_view/photo_view.dart';
import 'package:photo_view/photo_view_gallery.dart';
import 'package:upgrader/upgrader.dart';
import 'package:scroll_to_hide/scroll_to_hide.dart';
import 'package:video_player/video_player.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';

class ModalPlayVideo extends StatefulWidget {
  final String url;
  final Map item;
  const ModalPlayVideo({super.key, required this.url, required this.item});

  @override
  State<ModalPlayVideo> createState() => _ModalPlayVideoState();
}

int currentIndex = 0;

class _ModalPlayVideoState extends State<ModalPlayVideo> {
  final scaffoldKey = GlobalKey<ScaffoldState>();
  final ScrollController scrollController = ScrollController();
  late VideoPlayerController videoController;
  @override
  void initState() {
    super.initState();
    // videoController = VideoPlayerController.networkUrl(Uri.parse(widget.url));
    // videoController.addListener(() {
    //   setState(() {});
    // });
    // videoController.setLooping(true);
    // videoController.initialize().then((_) => setState(() {}));
    // videoController.play();
  }

  @override
  void dispose() {
    super.dispose();
    videoController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Map detail = widget.item;
    return SafeArea(
      bottom: false,
      top: false,
      child: Scaffold(
          key: scaffoldKey,
          backgroundColor: Colors.black,
          resizeToAvoidBottomInset: true,
          appBar: null,
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
                  Row(
                    children: [
                      GestureDetector(
                          onTap: () {
                            Navigator.of(context).pop();
                            SystemChrome.setSystemUIOverlayStyle(
                                SystemUiOverlayStyle(
                                    statusBarColor: mainColor,
                                    systemNavigationBarColor: Colors.white,
                                    systemNavigationBarIconBrightness:
                                        Brightness.dark));
                          },
                          child: Container(
                            margin: const EdgeInsets.only(left: 10, top: 60),
                            child: Icon(
                              Icons.west,
                              size: 28,
                              color: mainColor,
                            ),
                          ))
                    ],
                  ),
                  // AspectRatio(
                  //   aspectRatio: videoController.value.aspectRatio,
                  //   child: Stack(
                  //     alignment: Alignment.bottomCenter,
                  //     children: <Widget>[
                  //       VideoPlayer(videoController),
                  //       ClosedCaption(text: videoController.value.caption.text),
                  //       _ControlsOverlay(controller: videoController),
                  //       VideoProgressIndicator(videoController,
                  //           allowScrubbing: true),
                  //     ],
                  //   ),
                  // ),

                  HtmlWidget(
                    detail["content"],
                  ),
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 10, vertical: 20),
                    child: Text(
                      "${detail["title"]}",
                      textAlign: TextAlign.left,
                      style: const TextStyle(
                          fontSize: 14,
                          height: 1.3,
                          color: Colors.white,
                          fontWeight: FontWeight.w500),
                    ),
                  )
                ],
              ))),
    );
  }
}

class _ControlsOverlay extends StatelessWidget {
  const _ControlsOverlay({required this.controller});

  static const List<Duration> _exampleCaptionOffsets = <Duration>[
    Duration(seconds: -10),
    Duration(seconds: -3),
    Duration(seconds: -1, milliseconds: -500),
    Duration(milliseconds: -250),
    Duration.zero,
    Duration(milliseconds: 250),
    Duration(seconds: 1, milliseconds: 500),
    Duration(seconds: 3),
    Duration(seconds: 10),
  ];
  static const List<double> _examplePlaybackRates = <double>[
    0.25,
    0.5,
    1.0,
    1.5,
    2.0,
    3.0,
    5.0,
    10.0,
  ];

  final VideoPlayerController controller;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        AnimatedSwitcher(
          duration: const Duration(milliseconds: 50),
          reverseDuration: const Duration(milliseconds: 200),
          child: controller.value.isPlaying
              ? const SizedBox.shrink()
              : const ColoredBox(
                  color: Colors.black26,
                  child: Center(
                    child: Icon(
                      Icons.play_arrow,
                      color: Colors.white,
                      size: 100.0,
                      semanticLabel: 'Play',
                    ),
                  ),
                ),
        ),
        GestureDetector(
          onTap: () {
            controller.value.isPlaying ? controller.pause() : controller.play();
          },
        ),
        Align(
          alignment: Alignment.topLeft,
          child: PopupMenuButton<Duration>(
            initialValue: controller.value.captionOffset,
            tooltip: 'Caption Offset',
            onSelected: (Duration delay) {
              controller.setCaptionOffset(delay);
            },
            itemBuilder: (BuildContext context) {
              return <PopupMenuItem<Duration>>[
                for (final Duration offsetDuration in _exampleCaptionOffsets)
                  PopupMenuItem<Duration>(
                    value: offsetDuration,
                    child: Text('${offsetDuration.inMilliseconds}ms'),
                  )
              ];
            },
            child: Padding(
              padding: const EdgeInsets.symmetric(
                // Using less vertical padding as the text is also longer
                // horizontally, so it feels like it would need more spacing
                // horizontally (matching the aspect ratio of the video).
                vertical: 12,
                horizontal: 16,
              ),
              child: Text('${controller.value.captionOffset.inMilliseconds}ms'),
            ),
          ),
        ),
        Align(
          alignment: Alignment.topRight,
          child: PopupMenuButton<double>(
            initialValue: controller.value.playbackSpeed,
            tooltip: 'Playback speed',
            onSelected: (double speed) {
              controller.setPlaybackSpeed(speed);
            },
            itemBuilder: (BuildContext context) {
              return <PopupMenuItem<double>>[
                for (final double speed in _examplePlaybackRates)
                  PopupMenuItem<double>(
                    value: speed,
                    child: Text('${speed}x'),
                  )
              ];
            },
            child: Padding(
              padding: const EdgeInsets.symmetric(
                // Using less vertical padding as the text is also longer
                // horizontally, so it feels like it would need more spacing
                // horizontally (matching the aspect ratio of the video).
                vertical: 12,
                horizontal: 16,
              ),
              child: Text('${controller.value.playbackSpeed}x'),
            ),
          ),
        ),
      ],
    );
  }
}
