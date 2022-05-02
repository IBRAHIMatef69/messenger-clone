import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:store_user/model/user_model.dart';

import '../../../logic/controller/chat_rooms_controller.dart';
import '../../../logic/controller/main_controller.dart';
import '../../../routes/routes.dart';
import '../../../utils/constants.dart';

class SearchUserListTile extends StatelessWidget {
  int index;
  UserModel friendData;
  String myUid;
  UserModel myData;
  final mainController = Get.find<MainController>();
  final chatRoomController = Get.find<ChatRoomsController>();

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: () async {
        String cattRoomId = await chatRoomController.getChatRoomIdByUser(
            chatRoomController.myUid, friendData.uid!);
        chatRoomController.createChatRoom(cattRoomId, {
          "chatRoomId": cattRoomId,
          "chatRoomUsers": [friendData.uid!, chatRoomController.myUid],
          "lastMessageSendTs": DateTime.now(),
          'lastMessage': 'lastMessage',
          'lastMessageSenderUid': 'lastMessageSenderUid',
        }).then((value) {
          Get.toNamed(Routes.chatScreen, arguments: [
            friendData,
            cattRoomId,
            myUid,
            myData,
          ]);
        });
      },
      hoverColor: mainColor2,
      focusColor: mainColor2,
      leading: ClipRRect(
        borderRadius: BorderRadius.circular(30),
        child: Image.network(
          friendData.profileUrl!,
          fit: BoxFit.cover,
          width: Get.width * .15,
          height: Get.width * .15,
        ),
      ),
      title: Text(friendData.displayName!),
      subtitle: Text(friendData.email!),
    );
  }

  SearchUserListTile({
    required this.index,
    required this.friendData,
    required this.myUid,
    required this.myData,
  });
}
