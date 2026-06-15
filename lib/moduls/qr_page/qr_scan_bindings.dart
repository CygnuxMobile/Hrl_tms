import 'package:get/get.dart';
import '../../moduls/qr_page/qr_scan_ontroller.dart';

class QrScanBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<QrScanController>(() => QrScanController());
  }
}
