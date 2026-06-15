import 'package:get/get.dart';
import '../../moduls/attendance_page/attendance_controller.dart';

class AttendanceBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<AttendanceController>(() => AttendanceController());
    // TODO: implement dependencies
  }
}
