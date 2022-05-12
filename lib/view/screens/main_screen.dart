import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import 'package:store_user/logic/controller/chat_rooms_controller.dart';
import 'package:store_user/logic/controller/main_controller.dart';
import 'package:store_user/routes/routes.dart';
import 'package:store_user/utils/constants.dart';
import 'package:store_user/view/screens/call_screens/answer_call/answer_call_wrap_layout.dart';
import 'package:store_user/view/widgets/main_screen_widget/chat_room_list_view.dart';
import 'package:store_user/view/widgets/main_screen_widget/chat_search_widget.dart';
import 'package:store_user/view/widgets/utils_widgets/text_utils.dart';
import '../../logic/controller/status_controller.dart';
import '../../utils/styles.dart';
import '../widgets/main_screen_widget/all_users_status.dart';
import '../widgets/utils_widgets/circule_image_avatar.dart';

class MainScreen extends StatelessWidget {
  final controller = Get.find<MainController>();
  final chatRoomController = Get.put(ChatRoomsController());
  final statusController = Get.put(StatusController());

  @override
  Widget build(BuildContext context) {
    return AnswerCallWrapLayout(
      scaffold: Scaffold(
          backgroundColor: homeBackGroundColor,
          body: Obx((){return ConditionalBuilder(
            condition: controller.internetStatus.value == true,
            fallback: (BuildContext context) {
              return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      SizedBox(
                        height: Get.height * .2,
                      ),
                      Container(
                        alignment: Alignment.center,
                        width: MediaQuery.of(context).size.height * .1,
                        height: MediaQuery.of(context).size.height * .1,
                        child: Lottie.asset(
                          "assets/images/connection.json",
                          fit: BoxFit.cover,
                        ),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      const Text(
                        "check your internet connection",
                        style: TextStyle(
                            fontSize: 25,
                            fontWeight: FontWeight.w800,
                            color: Colors.black54),
                      ),
                      SizedBox(
                        height: MediaQuery.of(context).size.height * .2,
                      )
                    ],
                  ));
            },
            builder: (BuildContext context) {
              return RefreshIndicator(
                backgroundColor: homeBackGroundColor,
                color: mainColor2,
                onRefresh: () {
                  controller.getAllUsers();
                  chatRoomController.getAllChatRooms();
                  statusController.getOnlyMyStatus();
                  statusController.getMyFriendsStatus();

                  return controller.getUserData();
                },
                child: CustomScrollView(
                  slivers: [
                    SliverAppBar(
                      actions: [
                        IconButton(
                            onPressed: () {
                              SystemChannels.textInput
                                  .invokeMethod('TextInput.hide');

                              Get.toNamed(Routes.settingProfileScreen);
                            },
                            icon: Icon(
                              IconBroken.Setting,
                              color: homeBackGroundColor,
                            ))
                      ],
                      elevation: 2,
                      floating: true,
                      leading: Container(
                        margin: EdgeInsets.all(5),
                        padding: EdgeInsets.zero,
                        child: Obx(
                              () {
                            return controller.userInfoModel.value == null
                                ? CirculeImageAvatar(
                              width: Get.width,
                              imageUrl:
                              "https://www.stockvault.net//data/2008/04/28/104980/thumb16.jpg",
                            )
                                : CirculeImageAvatar(
                              width: Get.width,
                              imageUrl: controller
                                  .userInfoModel.value!.profileUrl!
                                  .toString(),
                            );
                          },
                        ),
                      ),
                      backgroundColor: mainColor2,
                      title: KTextUtils(
                          text: "chats",
                          size: 25,
                          color: white,
                          fontWeight: FontWeight.bold,
                          textDecoration: TextDecoration.none),
                    ),
                    SliverToBoxAdapter(child: SearchWidget()),
                    SliverToBoxAdapter(child: OnlineUsersChat()),
                    SliverToBoxAdapter(
                      child: Obx(() {
                        return Container(
                          alignment: Alignment.topLeft,
                          margin:
                          EdgeInsets.only(left: Get.width * .03, top: 0),
                          padding: EdgeInsets.zero,
                          child: KTextUtils(
                              text: controller.isSearching.value == false
                                  ? "Messages"
                                  : "Users",
                              size: Get.width * .07,
                              color: Colors.black87,
                              fontWeight: FontWeight.w700,
                              textDecoration: TextDecoration.none),
                        );
                      }),
                    ),
                    SliverToBoxAdapter(child: ChatListViewChatRoomsList())
                  ],
                ),
              );
            },
          );})),
    );
  }
}
