import 'package:audioplayers/audioplayers.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:video_player/video_player.dart';
import '../../app_routes.dart';
import '../../utils/pref.dart';
import '../../widgets/tost.dart';

RxBool isNetOn = false.obs;

class SplashScreenController extends GetxController {
  final player = AudioPlayer();

  @override
  void onInit() {
    player.play(AssetSource('audio/welcome_tms_app.mp3'));
    Connectivity().checkConnectivity().then((value) => noInterNetDialog(value));
    Connectivity().onConnectivityChanged.listen((event) {
      noInterNetDialog(event);
    });
    super.onInit();
  }

  @override
  void onReady() {
    checkLogin();
    super.onReady();
  }

  void noInterNetDialog(List<ConnectivityResult> result) {
    bool isConnected = (result != ConnectivityResult.none);
    if (!isConnected) {
      TmsToast.msg("please check your internet");
      Get.defaultDialog(
        title: 'No Internet Connection',
        backgroundColor: Colors.white,
        middleText: 'Please check your internet connection and try again.',
        barrierDismissible: false,
        confirm: ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.black,
          ),
          child: const Text(
            'OK',
          ),
          onPressed: () {
            Connectivity().checkConnectivity().then((value) {
              if (value == ConnectivityResult.none) {
                isNetOn = false.obs;
              } else {
                Get.back();
                isNetOn = true.obs;
              }
            });
          },
        ),
      );
    } else {
      // isNetOn = true.obs;
    }
  }

  Future checkLogin() async {
    Future.delayed(
      const Duration(seconds: 3, milliseconds: 500),
      () {
        if (Pref().getIsLogin() == false) {
          Get.offAllNamed(AppRoutes.loginScreen);
        } else {
          Get.offAllNamed(AppRoutes.dashboardScreen);
        }
      },
    );
  }
}
