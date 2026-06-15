import 'package:get/get.dart';
import 'package:hrl_2026/moduls/login_page/login_controller.dart';

class LoginScreenBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<LoginController>(() => LoginController());
  }
}
