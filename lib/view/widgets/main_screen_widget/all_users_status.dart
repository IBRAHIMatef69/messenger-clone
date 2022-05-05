import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:store_user/logic/controller/chat_rooms_controller.dart';
import 'package:store_user/logic/controller/status_controller.dart';
import 'package:store_user/utils/constants.dart';
import 'package:store_user/view/widgets/main_screen_widget/friends_cerculer_avatar.dart';
import 'package:store_user/view/widgets/main_screen_widget/status_widget.dart';
import 'package:store_user/view/widgets/utils_widgets/text_utils.dart';

import '../../../logic/controller/main_controller.dart';
import '../../../routes/routes.dart';
import 'add_status_widget.dart';

class OnlineUsersChat extends StatelessWidget {
  final statusController = Get.put(StatusController());
  final mainController = Get.put(MainController());
  final chatRoomsController = Get.put(ChatRoomsController());

  @override
  Widget build(BuildContext context) {
    return GetX(
      //  initState: statusController.getOnlyMyStatus(),
      builder: (StatusController controller) {
        statusController.getOnlyMyStatus();
        return Row(
          children: [
            statusController.statesList.any((element) {
              return element.userUid == mainController.userInfoModel.value!.uid;
            })
                ? statusController.myStory != null &&
                        chatRoomsController.chatRoomsList.length == 0
                    ? Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: StatusWidget(
                            statusModel: statusController.myStory!, isMe: true),
                      )
                    : SizedBox()
                : Container(
                    padding: EdgeInsets.only(
                      left: 8,
                    ),
                    margin: EdgeInsets.only(
                      bottom: 8,
                    ),
                    height: Get.height * .10,
                    width: Get.height * .10,
                    child: AddStatusWidget(),
                  ),
            statusController.statesList.length == 0 ||
                    mainController.isSearching.value == true
                ? SizedBox()
                : Expanded(
                    child: Container(
                      padding: EdgeInsets.symmetric(horizontal: 5, vertical: 0),
                      margin: EdgeInsets.only(top: 10),
                      height: Get.height * .13,
                      child: ListView.separated(
                        physics: BouncingScrollPhysics(),
                        shrinkWrap: true,
                        scrollDirection: Axis.horizontal,
                        itemCount: statusController.statesList.length,
                        itemBuilder: (BuildContext context, int index) {
                          if (statusController.statesList[index].statusDate!
                              .toDate()
                              .add(Duration(days: 1))
                              .isBefore(DateTime.now())) {
                            try {
                              statusController.deleteStatus(
                                  Uid: statusController
                                      .statesList[index].userUid);
                            } catch (e) {
                              Fluttertoast.showToast(
                                gravity: ToastGravity.TOP,
                                msg: "check your internet connection" +
                                    e.toString(),
                                backgroundColor: Colors.green,
                              );
                            }
                          }
                          //  return AddStatusWidget();
                          statusController.FunIsFriendStatus(
                              chatRoomsController.chatRoomsList,
                              statusController.statesList[index].userUid!);

                          return statusController.isFriendStatus.value == true
                              ? StatusWidget(
                                  statusModel:
                                      statusController.statesList[index],
                                  isMe:
                                      mainController.userInfoModel.value!.uid ==
                                              statusController
                                                  .statesList[index].userUid
                                          ? true
                                          : false,
                                )
                              : SizedBox(
                                  width: 0,
                                );
                        },
                        separatorBuilder: (BuildContext context, int index) {
                          statusController.FunIsFriendStatus(
                              chatRoomsController.chatRoomsList,
                              statusController.statesList[index].userUid!);
                          return statusController.isFriendStatus.value == true
                              ? SizedBox(width: Get.width * .04)
                              : SizedBox(
                                  width: 0,
                                );
                        },
                      ),
                    ),
                  ),
          ],
        );
      },
    );
  }
}
