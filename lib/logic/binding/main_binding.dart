import 'package:get/get.dart';
 import 'package:store_user/logic/controller/main_controller.dart';

class MainBinding extends Bindings{
  @override
  void dependencies() {
    // TODO: implement dependencies
    Get.put(MainController() ,permanent: false);
  }

}