import 'package:get/get.dart';
import 'package:hrl_2026/moduls/splash_page/splash_controller.dart';

class SplashScreenBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<SplashScreenController>(() => SplashScreenController());
  }
}
