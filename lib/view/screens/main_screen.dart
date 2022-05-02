import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:store_user/logic/controller/main_controller.dart';
import 'package:store_user/routes/routes.dart';
import 'package:store_user/utils/constants.dart';
import 'package:store_user/view/widgets/main_screen_widget/chat_room_list_view.dart';
import 'package:store_user/view/widgets/main_screen_widget/chat_search_widget.dart';
import 'package:store_user/view/widgets/utils_widgets/text_utils.dart';
import '../../utils/styles.dart';
import '../widgets/main_screen_widget/all_users_status.dart';
import '../widgets/utils_widgets/circule_image_avatar.dart';

class MainScreen extends StatelessWidget {
  final controller = Get.find<MainController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: homeBackGroundColor,
        body: CustomScrollView(
          slivers: [
            SliverAppBar(
              actions: [
                IconButton(
                    onPressed: () {    SystemChannels.textInput.invokeMethod('TextInput.hide');

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
              child: SizedBox(
                height: Get.width * .01,
              ),
            ),
            SliverToBoxAdapter(
              child: Obx(() {
                return Container(
                  alignment: Alignment.topLeft,
                  margin: EdgeInsets.only(left: Get.width * .04),
                  padding: EdgeInsets.zero,
                  child: KTextUtils(
                      text:controller.isSearching.value==false? "Messages":"Users",
                      size: Get.width * .07,
                      color: Colors.black87,
                      fontWeight: FontWeight.w700,
                      textDecoration: TextDecoration.none),
                );
              }),
            ),
            SliverToBoxAdapter(child: ChatListViewChatRoomsList())
          ],
        ));
  }
}
