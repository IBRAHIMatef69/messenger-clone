import 'package:get/get.dart';

import '../controller/status_controller.dart';

class AddStatusBinding extends Bindings {
  @override
  void dependencies() {
    // TODO: implement dependencies
    Get.put(StatusController(),permanent:false );
  }
}
