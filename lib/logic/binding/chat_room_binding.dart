import 'package:get/get.dart';
import 'package:store_user/logic/controller/chat_rooms_controller.dart';

class ChatRoomBinding extends Bindings{
  @override
  void dependencies() {
    // TODO: implement dependencies
    Get.put(ChatRoomsController() ,permanent: false);
  }

}