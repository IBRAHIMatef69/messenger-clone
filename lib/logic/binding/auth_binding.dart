import 'package:get/get.dart';
import 'package:store_user/logic/controller/auth_controller.dart';

class AuthBinding extends Bindings{
  @override
  void dependencies() {
    // TODO: implement dependencies
    Get.lazyPut(()=>AuthController() ,fenix: false);
  }

}