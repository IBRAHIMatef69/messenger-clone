import 'package:get/get.dart';
import 'package:store_user/logic/controller/setting_controller.dart';

class SettingBinding extends Bindings{
  @override
  void dependencies() {
    // TODO: implement dependencies
    Get.lazyPut(()=>SettingController() ,);
  }

}