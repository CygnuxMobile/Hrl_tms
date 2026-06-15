import 'package:get/get.dart';
import '../../moduls/quick_docket_page/quick_docket_controller.dart';

class QuickDocketBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<QuickDocketController>(() => QuickDocketController());
  }
}
