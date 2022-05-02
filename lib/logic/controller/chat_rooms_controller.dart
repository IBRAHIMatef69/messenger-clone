import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:store_user/firebase_services/firestore_methods.dart';
import 'package:store_user/model/chat_room_model.dart';
import 'package:store_user/model/user_model.dart';
import 'package:store_user/routes/routes.dart';
import 'package:store_user/utils/my_string.dart';

class ChatRoomsController extends GetxController {
  GetStorage authBox = GetStorage();
  var myUid;

  var chatRoomsList = <ChatRoomModel>[].obs;

  // final friendInfoModel = Rxn<UserModel>();
  var friendInfoModel = <UserModel>[].obs;

  @override
  void onInit() async {
    await GetStorage.init();
    getAllChatRooms();
    myUid = authBox.read(KUid);
    super.onInit();
  }

  getChatRoomIdByUser(
    String a,
    String b,
  ) {
    if (a.substring(0, 1).codeUnitAt(0) > b.substring(0, 1).codeUnitAt(0)) {
      return "$b\_$a";
    } else {
      return "$a\_$b";
    }
  }

/////////////////////////////////////////createChatRoom///////////////////////////
  Future createChatRoom(
      String chatRoomId, Map<String, dynamic> chatRoomInfoMap) async {
    final snapShot = await FireStoreMethods().chatRooms.doc(chatRoomId).get();
    if (snapShot.exists) {
      return true;
    } else {
      return FireStoreMethods().chatRooms.doc(chatRoomId).set(chatRoomInfoMap);
    }
  }

///////////////////////////////////////// getAllChatRooms ///////////////////////////

  getAllChatRooms() async {
    String myUid = await authBox.read(KUid);

    await FireStoreMethods()
        .chatRooms
        .orderBy("lastMessageSendTs", descending: true)
        .where("chatRoomUsers", arrayContains: myUid)
        .snapshots()
        .listen((event) {
      chatRoomsList.clear();
    friendInfoModel.clear();
      for (int i = 0; i < event.docs.length; i++) {
        chatRoomsList.add(ChatRoomModel.fromMap(event.docs[i]));
      }
    });
  }

  /////////////////////////getFriendDataByUid/////////////////////////

  getFriendDataByUid(ChatRoomId) {
    var myFriendId =
        ChatRoomId.replaceAll(authBox.read(KUid), "").replaceAll("_", "");

    FireStoreMethods().users.doc(myFriendId).snapshots().listen((event) {
      friendInfoModel.add(UserModel.fromMap(event));
      //update();
    });
  }
}
