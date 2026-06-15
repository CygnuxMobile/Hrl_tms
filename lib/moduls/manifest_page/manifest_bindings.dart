import 'package:get/get.dart';
import '../../moduls/manifest_page/manifest_controller.dart';

class ManifestBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ManifestController>(() => ManifestController());
  }
}
