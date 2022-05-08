import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:get/get.dart';
import 'package:spring/spring.dart';
import 'package:store_user/logic/controller/chat_rooms_controller.dart';
import 'package:store_user/logic/controller/main_controller.dart';
import 'package:store_user/routes/routes.dart';
import 'package:store_user/utils/constants.dart';
import 'package:store_user/utils/styles.dart';
import 'package:store_user/view/widgets/main_screen_widget/chat_room_list_tile.dart';
import 'package:store_user/view/widgets/main_screen_widget/search_user_list_tile.dart';
import 'package:store_user/view/widgets/utils_widgets/text_utils.dart';

class ChatListViewChatRoomsList extends StatelessWidget {
  final mainController = Get.put(MainController());
  final chatRoomController = Get.put(ChatRoomsController());

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      return mainController.searchList.isNotEmpty
          ? ListView.separated(
              padding: EdgeInsets.zero,
              physics: BouncingScrollPhysics(),
              shrinkWrap: true,
              itemBuilder: (context, index) {
                return chatRoomController.myUid ==
                        mainController.searchList[index].uid!
                    ? SizedBox()
                    : SearchUserListTile(
                        index: index,
                        myData: mainController.userInfoModel.value!,
                        myUid: mainController.searchList[index].uid!,
                        friendData: mainController.searchList[index],
                      );
              },
              separatorBuilder: (context, index) {
                return SizedBox(
                  height: Get.height * .004,
                );
              },
              itemCount: mainController.searchList.length)
          : chatRoomController.chatRoomsList.length != 0
              ? ListView.separated(
                  padding: EdgeInsets.zero,
                  physics: BouncingScrollPhysics(),
                  shrinkWrap: true,
                  itemBuilder: (context, index) {
                    return AnimationConfiguration.staggeredList(
                      position: index,
                      duration: const Duration(milliseconds: 1000),
                      child: SlideAnimation(
                        horizontalOffset: 300,
                        child: FadeInAnimation(
                          child: ChatRoomListTil(
                            chatRoomId: chatRoomController
                                .chatRoomsList[index].chatRoomId,
                            myUid: mainController.userInfoModel.value!.uid!,
                            index: index,
                            myData: mainController.userInfoModel.value!,
                          ),
                        ),
                      ),
                    );
                  },
                  separatorBuilder: (context, i) {
                    return SizedBox(
                      height: Get.height * .004,
                    );
                  },
                  itemCount: chatRoomController.chatRoomsList.length)
              : Container(
                  margin: EdgeInsets.only(top: 15),
                  alignment: Alignment.center,
                  height: Get.height * .5,
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Container(
                          margin: EdgeInsets.only(
                            bottom: Get.width * .05,
                          ),
                          child: Stack(
                            alignment: Alignment.center,
                            children: [
                              Spring.slide(
                                child: SizedBox(
                                  width: Get.width * .67,
                                  height: Get.width * .67,
                                  child: ClipRRect(
                                      child: Image.asset(
                                          "assets/images/friendship.png")),
                                ),
                                slideType: SlideType.slide_in_right,
                                delay: Duration(milliseconds: 1100),
                                animDuration: Duration(milliseconds: 1200),
                                curve: Curves.bounceOut,
                                extend: 30,
                                withFade: true,
                              ),
                              Positioned(
                                bottom: 0,
                                child: Spring.slide(
                                  slideType: SlideType.slide_in_left,
                                  delay: Duration(milliseconds: 1100),
                                  animDuration: Duration(milliseconds: 1200),
                                  curve: Curves.bounceOut,
                                  extend: 30,
                                  withFade: true,
                                  child: Stack(
                                    alignment: Alignment.center,
                                    children: [
                                      Card(
                                        margin: EdgeInsets.zero,
                                        elevation: 5,
                                        shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(
                                                Get.width * .06)),
                                        child: CircleAvatar(
                                          backgroundColor: mainColor3,
                                          minRadius: Get.width * .06,
                                          maxRadius: Get.width * .06,
                                        ),
                                      ),
                                      CircleAvatar(
                                        child: Center(
                                          child: IconButton(
                                              onPressed: () {
                                                Get.toNamed(
                                                    Routes.allUsersScreen);
                                              },
                                              icon: Icon(
                                                IconBroken.Add_User,
                                                size: Get.width * .055,
                                                color: white,
                                              )),
                                        ),
                                        backgroundColor: Color(0xff7bd7fd),
                                        minRadius: Get.width * .055,
                                        maxRadius: Get.width * .055,
                                      ),
                                    ],
                                  ),
                                ),
                              )
                            ],
                          ),
                        ),
                        Spring.slide(
                            slideType: SlideType.slide_in_bottom,
                          delay: Duration(milliseconds: 1100),
                          animDuration: Duration(milliseconds: 1200),
                          curve: Curves.bounceOut,
                          extend: 30,
                          withFade: true,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              KTextUtils(
                                  text: "You Don't Have Any Conversations,",
                                  size: Get.width * .038,
                                  color: black,
                                  fontWeight: FontWeight.bold,
                                  textDecoration: TextDecoration.none),
                              InkWell(
                                onTap: () {
                                  Get.toNamed(Routes.allUsersScreen);
                                },
                                child: KTextUtils(
                                    text: "Add New!?",
                                    size: Get.width * .042,
                                    color: mainColor2,
                                    fontWeight: FontWeight.bold,
                                    textDecoration: TextDecoration.none),
                              )
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                );
    });
  }
}
