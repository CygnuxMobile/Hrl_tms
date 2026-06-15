import 'package:get/get.dart';
import 'package:hrl_2026/moduls/stock_update_page/stock_update_controller.dart';

class StockUpdateBinding extends Bindings {
  @override
  void dependencies() {
    // TODO: implement dependencies
    Get.lazyPut<StockUpdateController>(() => StockUpdateController());
  }
}
