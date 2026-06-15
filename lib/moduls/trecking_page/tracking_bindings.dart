import 'package:get/get.dart';
import 'package:hrl_2026/moduls/trecking_page/tracking_controller.dart';

class TrackingBinding extends Bindings {
  @override
  void dependencies() {
    // TODO: implement dependencies
    Get.lazyPut<TrackingController>(() => TrackingController());
  }
}
