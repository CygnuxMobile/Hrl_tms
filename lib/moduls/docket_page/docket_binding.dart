import 'package:get/get.dart';
import 'package:hrl_2026/moduls/docket_page/docket_controller.dart';



class DocketBinding extends Bindings {


  @override
  void dependencies() {
    Get.lazyPut<DocketController>(() => DocketController());
  }
}

