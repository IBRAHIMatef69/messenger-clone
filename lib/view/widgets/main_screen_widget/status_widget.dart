import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:just_audio/just_audio.dart';
import 'package:store_user/logic/controller/status_controller.dart';
import 'package:store_user/model/status_model.dart';
import 'package:store_user/model/user_model.dart';
import 'package:store_user/routes/routes.dart';
import '../../../logic/controller/chat_rooms_controller.dart';
import '../../../utils/constants.dart';
import '../utils_widgets/text_utils.dart';

class StatusWidget extends StatelessWidget {
  StatusModel statusModel;
  bool isMe;


  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        GetBuilder(
          init: StatusController(),
          builder: (StatusController controller) {
            return InkWell(
              onTap: () {
                Get.toNamed(Routes.viewStatusScreen,
                    arguments: [statusModel, isMe]);

              },
              child: Container(
                height: Get.width * .19,
                width: Get.width * .19,
                decoration: BoxDecoration(
                  // image: DecorationImage(
                  //   image: NetworkImage(
                  //     "$imageUrl",
                  //   ),
                  // ),
                  borderRadius: BorderRadius.circular(Get.width * 2),
                  border: Border.all(
                    color: mainColor2,
                    width: 1.5,
                  ),
                ),
                child: Card(
                  margin: EdgeInsets.all(2),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(Get.width * 2)),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(Get.width * 2),
                    child: FadeInImage.assetNetwork(
                        fit: BoxFit.cover,
                        placeholder: "assets/images/l.gif",
                        image: "${statusModel.userImageUrl}"),
                  ),
                ),
              ),
            );
          },
        ),
        SizedBox(
          height: 3,
        ),
        statusModel.userName!.toString().contains(" ") == true
            ? KTextUtils(
                text: "${(statusModel.userName!).substring(
                  0,
                  (statusModel.userName!).indexOf(" "),
                )}",
                size: Get.width * .04,
                color: black,
                fontWeight: FontWeight.bold,
                textDecoration: TextDecoration.none)
            : KTextUtils(
                text: "${(statusModel.userName!)}",
                size: Get.width * .04,
                color: black,
                fontWeight: FontWeight.bold,
                textDecoration: TextDecoration.none)
      ],
    );
  }

  StatusWidget({
    required this.statusModel,
    required this.isMe,
  });
}
