import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:store_user/logic/controller/main_controller.dart';
import 'package:store_user/model/user_model.dart';
import 'package:store_user/routes/routes.dart';
import 'package:store_user/utils/constants.dart';
import 'package:store_user/utils/styles.dart';
import 'package:store_user/view/widgets/utils_widgets/text_utils.dart';
import '../../logic/controller/chat_rooms_controller.dart';
import '../widgets/main_screen_widget/friends_cerculer_avatar.dart';

class AllUsersScreen extends StatelessWidget {
  final mainController = Get.find<MainController>();
  final chatRoomController = Get.find<ChatRoomsController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: homeBackGroundColor,
      appBar: AppBar(
        backgroundColor: homeBackGroundColor,
        elevation: 2,
        centerTitle: true,
        title: KTextUtils(
            text: "Users",
            size: 25,
            color: black,
            fontWeight: FontWeight.bold,
            textDecoration: TextDecoration.none),
        leading: IconButton(
          icon: Icon(
            IconBroken.Arrow___Left_2,
            size: 30,
            color: Colors.black,
          ),
          onPressed: () {
            Get.back();
          },
        ),
      ),
      body: Padding(
        padding: EdgeInsets.all(8),
        child: Obx(() {
          return mainController.allUsersList.isEmpty
              ? Center(
                  child: CircularProgressIndicator(),
                )
              : ListView.separated(
                  physics: BouncingScrollPhysics(),
                  itemBuilder: (BuildContext context, int index) {
                    return mainController.userInfoModel.value!.uid ==
                            mainController.allUsersList[index].uid!
                        ? SizedBox()
                        : buildInviteUser(
                            friendData: mainController.allUsersList[index],
                            myUid: chatRoomController.myUid,
                            myData: mainController.userInfoModel.value!);
                  },
                  separatorBuilder: (BuildContext context, int index) {
                    return mainController.userInfoModel.value!.uid ==
                            mainController.allUsersList[index].uid!
                        ? SizedBox()
                        : Divider(
                            color: darkGrey,
                            thickness: .2,
                            indent: Get.width * .05,
                            endIndent: Get.width * .05,
                          );
                  },
                  itemCount: mainController.allUsersList.length,
                );
        }),
      ),
    );
  }

  Widget buildInviteUser({
    required UserModel friendData,
    required UserModel myData,
    required String myUid,
  }) {
    return Container(
      height: Get.height * .07,
      child: Row(
        children: [
          FriendsImageAvatar(
            width: Get.height * .07,
            imageUrl: friendData.profileUrl!,
          ),
          SizedBox(
            width: 8,
          ),
          Expanded(
              flex: 5,
              child: KTextUtils(
                  text: friendData.displayName!,
                  size: 20,
                  color: black,
                  fontWeight: FontWeight.bold,
                  textDecoration: TextDecoration.none)),
          Expanded(
              flex: 2,
              child: GetBuilder<ChatRoomsController>(
                builder: (_) {
                  return ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        primary: mainColor2,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20))),
                    onPressed: () async {
                      String cattRoomId =
                          await chatRoomController.getChatRoomIdByUser(
                              chatRoomController.myUid, friendData.uid!);
                      chatRoomController.createChatRoom(cattRoomId, {
                        "chatRoomId": cattRoomId,
                        "chatRoomUsers": [
                          friendData.uid!,
                          chatRoomController.myUid
                        ],
                        "lastMessageSendTs": DateTime.now(),
                        'lastMessage': ' ',
                        'lastMessageSenderUid': chatRoomController.myUid,
                      }).then((value) {
                        Get.toNamed(Routes.chatScreen, arguments: [
                          friendData,
                          cattRoomId,
                          myUid,
                          myData,
                        ]);
                      });
                    },
                    child: KTextUtils(
                        text: "Message",
                        size: Get.width * .035,
                        color: white,
                        fontWeight: FontWeight.bold,
                        textDecoration: TextDecoration.none),
                  );
                },
              ))
        ],
      ),
    );
  }
}
