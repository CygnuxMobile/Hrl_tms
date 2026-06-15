import 'package:get/get.dart';
import '../../moduls/manifest_page/manifest_controller.dart';

import 'manifest_controller.dart';

class HarshManifestBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<HarshManifestController>(() => HarshManifestController());
  }
}
