import 'package:get/get.dart';
import 'package:store_user/logic/controller/messages_controller.dart';

class MessagesBinding extends Bindings{
  @override
  void dependencies() {
    // TODO: implement dependencies
    Get.put(MessagesController() ,permanent: false);
  }

}