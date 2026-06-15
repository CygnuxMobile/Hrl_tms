import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hrl_2026/moduls/splash_page/splash_controller.dart';
import 'package:video_player/video_player.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetBuilder<SplashScreenController>(
      init: SplashScreenController(),
      builder: (_) => Container(color: Colors.white, child: const VideoWidget()),
    );
  }
}

class VideoWidget extends StatefulWidget {
  const VideoWidget({Key? key}) : super(key: key);

  @override
  State<VideoWidget> createState() => _VideoWidgetState();
}

class _VideoWidgetState extends State<VideoWidget> {
  late VideoPlayerController _controller;
  SplashScreenController splashScreenController =
  Get.put(SplashScreenController());
  @override
  void initState() {
    super.initState();
    _controller = VideoPlayerController.asset('assets/videos/TMS_splash_Screen1.mp4')
      ..initialize().then((_) {
        _controller.setVolume(0.0);
        _controller.setLooping(true);
        _controller.play();
        setState(() {});
      });
    // Connectivity()
    //     .checkConnectivity()
    //     .then((value) => splashScreenController.noInterNetDialog(value));
    // Connectivity().onConnectivityChanged.listen((event) {
    //   splashScreenController.noInterNetDialog(event);
    // });
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: _controller.value.isInitialized
          ? LayoutBuilder(
              builder: (context, constraints) {
                return SizedBox.expand(
                  child: FittedBox(
                    fit: BoxFit.fill,
                    child: SizedBox(
                      width: constraints.maxWidth * _controller.value.aspectRatio,
                      height: constraints.maxHeight,
                      child: Stack(
                        children: [
                          VideoPlayer(_controller),
                          Container(
                            color: Colors.black54,
                            alignment: Alignment.center,
                            child: Container(
                              child: Image.asset(
                                'assets/images/TMS 512X512.png',
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            )
          : Container(),
    );
  }

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }
}
