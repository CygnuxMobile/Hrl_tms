import 'package:get/get.dart';
import '../../moduls/pod_page/pod_controller.dart';



class PodBinding extends Bindings {


  @override
  void dependencies() {
    Get.lazyPut<PODController>(() => PODController());
  }
}
