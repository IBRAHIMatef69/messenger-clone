import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:store_user/utils/my_string.dart';

import '../../routes/routes.dart';

class SplashController extends GetxController {


  @override
  void onInit() async {
    GetStorage authBox = GetStorage();
    // TODO: implement onInit
    Future.delayed(Duration(seconds: 0), () {
      Get.offNamed(
          authBox.read(KUid) == null ? Routes.loginScreen : Routes.mainScreen);
    });
    super.onInit();
  }
}
