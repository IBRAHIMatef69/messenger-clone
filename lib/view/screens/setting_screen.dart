import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:store_user/logic/controller/auth_controller.dart';
import 'package:store_user/routes/routes.dart';
import 'package:store_user/utils/constants.dart';
import 'package:store_user/utils/styles.dart';
import 'package:store_user/view/widgets/utils_widgets/circule_image_avatar.dart';
import 'package:store_user/view/widgets/utils_widgets/height_size_box.dart';
import 'package:store_user/view/widgets/utils_widgets/text_utils.dart';

import '../../logic/controller/main_controller.dart';
import 'call_screens/answer_call/answer_call_wrap_layout.dart';
import 'package:url_launcher/url_launcher.dart';

class SettingProfileScreen extends StatelessWidget {
  SettingProfileScreen({Key? key}) : super(key: key);
  final controller1 = Get.find<AuthController>();

  final controller = Get.find<MainController>();
  final Uri _url = Uri.parse('https://play.google.com/store/apps/details?id=com.chat.store_user');
  final Uri _url1 = Uri.parse('https://sites.google.com/view/chatenger/%D8%A7%D9%84%D8%B5%D9%81%D8%AD%D8%A9-%D8%A7%D9%84%D8%B1%D8%A6%D9%8A%D8%B3%D9%8A%D8%A9');

  @override
  Widget build(BuildContext context) {
    return AnswerCallWrapLayout(
      scaffold: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          leading: IconButton(
            icon: Icon(
              IconBroken.Arrow___Left_2,
              size: 30,
              color: Colors.black,
            ),
            onPressed: () {    SystemChannels.textInput.invokeMethod('TextInput.hide');

            Get.back();
            },
          ),
        ),
        backgroundColor: homeBackGroundColor,
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Spacer(
                flex: 1,
              ),
              Obx(
                () {
                  if (controller.userInfoModel.value != null) {
                    return Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        CirculeImageAvatar(
                          imageUrl: controller.userInfoModel.value!.profileUrl
                              .toString(),
                          width: Get.height * .12,
                        ),
                        HeightSizeBox(Get.height * .01),
                        KTextUtils(
                            text:
                                "${controller.userInfoModel.value!.displayName}",
                            size: 22,
                            color: darkGrey,
                            fontWeight: FontWeight.w700,
                            textDecoration: TextDecoration.none),
                        HeightSizeBox(Get.height * .007),
                        KTextUtils(
                            text: "${controller.userInfoModel.value!.email}",
                            size: 15,
                            color: grey,
                            fontWeight: FontWeight.w500,
                            textDecoration: TextDecoration.none)
                      ],
                    );
                  } else {
                    return CircularProgressIndicator();
                  }
                },
              ),
              Divider(
                color: darkGrey,
                thickness: .5,
                indent: Get.width * .1,
                endIndent: Get.width * .1,
              ),
              const Spacer(
                flex: 1,
              ),
              buildTextButtonIcon(
                backColor: white,
                onPressed: () {
                  Get.toNamed(Routes.updateProfile,
                      arguments: [controller.userInfoModel.value]);
                },
                icon: IconBroken.Edit,
                iconColor: Colors.black,
                label: '  Edit Profile    ',
                style: TextStyle(fontSize: 20, color: Colors.black),
              ),
              const SizedBox(height: 20),
              buildTextButtonIcon(
                backColor: white,
                onPressed: () async {
                  if (!await launchUrl(_url)) throw 'Could not launch $_url';

                },
                icon: Icons.messenger_outline_outlined,
                iconColor: Colors.black,
                label: '  Invite a friend   ',
                style: TextStyle(fontSize: 20, color: Colors.black),
              ),
              const SizedBox(height: 20),
              buildTextButtonIcon(
                backColor: white,
                onPressed: () async {
                  if (!await launchUrl(_url1)) throw 'Could not launch $_url';

                },
                icon: Icons.help,
                iconColor: Colors.black,
                label: '  Help    ',
                style: TextStyle(fontSize: 20, color: Colors.black),
              ),
              const Spacer(flex: 1),
              GetBuilder<AuthController>(
                builder: (_) {
                  return buildTextButtonIcon(
                      onPressed: () {
                        Get.defaultDialog(onConfirm: (){Get.back();},
                            onCancel: () {
                              controller1.signOutFromApp();
                            },
                            title: "Logout",
                            textConfirm: "No",
                            middleText: "Are you sure to Logout...!",
                            confirmTextColor: Colors.white,
                            textCancel: "Yes",
                            buttonColor: mainColor2,
                            cancelTextColor: mainColor2,
                            backgroundColor: white);
                      },
                      label: "LogOut",
                      icon: Icons.logout,
                      iconColor: Colors.red,
                      style: TextStyle(fontSize: 20, color: Colors.black),
                      backColor: white);
                },
              ),
              const Spacer(flex: 5),
            ],
          ),
        ),
      ),
    );
  }

  buildTextButtonIcon({
    required Function()? onPressed,
    required String label,
    required IconData icon,
    Color? iconColor,
    Color? backColor,
    TextStyle? style,
  }) {
    return Container(
      alignment: Alignment.topLeft,
      width: double.infinity,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10), color: Colors.grey[200]),
      child: TextButton.icon(
        onPressed: onPressed,
        icon: Container(
            width: Get.height * .04,
            height: Get.height * .04,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(50), color: backColor),
            child: Icon(
              icon,
              color: iconColor,
            )),
        label: Row(
          children: [
            Text(label, style: style),
          ],
        ),
      ),
    );
  }
}
