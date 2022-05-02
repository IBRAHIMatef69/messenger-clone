import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:readmore/readmore.dart';
import 'package:store_user/logic/controller/status_controller.dart';
import 'package:store_user/utils/constants.dart';
import 'package:timer_count_down/timer_controller.dart';
import 'package:timer_count_down/timer_count_down.dart';
import 'dart:math' as math;
import 'dart:ui' as ui;

import '../../model/status_model.dart';
import '../../utils/styles.dart';

class ViewStatusScreen extends StatelessWidget {
  StatusModel statusData = Get.arguments[0];
  bool isMe = Get.arguments[1];
  final statusController = Get.put(StatusController());
  final CountdownController countdownController =
      new CountdownController(autoStart: true);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: mainColor3,
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            SizedBox(
              height: 8,
            ),
            Countdown(
              controller: countdownController,
              seconds: 7,
              build: (BuildContext context, double time) => SizedBox(
                height: 3,
                child: LinearProgressIndicator(
                  color: mainColor2,
                  backgroundColor: mainColor2,
                  valueColor: AlwaysStoppedAnimation<Color>(white),
                  value: time / 7,
                ),
              ),
              interval: Duration(milliseconds: 10),
              onFinished: () {
                Get.back();
                print('Timer is done!');
              },
            ),
            Container(
              alignment: Alignment.center,
              height: Get.height * .08,
              width: Get.width,
              child: Row(
                children: [
                  SizedBox(
                    width: 5,
                  ),
                  InkWell(
                    onTap: () {
                      Get.back();
                      SystemChannels.textInput.invokeMethod('TextInput.hide');
                    },
                    child: Icon(
                      IconBroken.Arrow___Left_2,
                      size: Get.width * .08,
                      color: Colors.black,
                    ),
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  Container(
                    color: Colors.transparent,
                    height: Get.width * .14,
                    width: Get.width * .14,
                    child: ClipRRect(
                        borderRadius: BorderRadius.circular(50),
                        child: FadeInImage.assetNetwork(
                            placeholder: "assets/images/l.gif",
                            image: "${statusData.userImageUrl}")),
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "${(statusData.userName)}",
                        //  "${friendData.displayName}",
                        style: TextStyle(
                            fontWeight: FontWeight.w800,
                            fontSize: Get.width * .05,
                            color: black),
                      ),
                      Text(
                        "${DateFormat.jm().format(statusData.statusDate!.toDate())}",
                        //  "${friendData.displayName}",
                        style: TextStyle(
                            fontWeight: FontWeight.w400,
                            fontSize: Get.width * .04,
                            color: black),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Expanded(
                child: GestureDetector(
              //onTertiaryLongPressMoveUpdate: (g){Get.back();},

              onVerticalDragEnd: (d) {
                Get.back();
              },
              onLongPress: () {
                countdownController.pause();
              },
              onLongPressUp: () {
                countdownController.resume();
              },
              child: Container(
                width: Get.width,
                child: statusData.statusImageUrl == ""
                    ? Center(
                        child: FittedBox(
                          child: SingleChildScrollView(
                            physics: BouncingScrollPhysics(),
                            child: Container(
                              padding: EdgeInsets.symmetric(horizontal: 15),
                              width: Get.width,
                              alignment: Alignment.center,
                              child: ReadMoreText(
                                statusData.statusCaption!,
                                trimLines: 7,
                                trimMode: TrimMode.Line,
                                // textDirection: TextDirection.rtl,

                                textAlign: TextAlign.center,
                                trimCollapsedText: " Show More",
                                trimExpandedText: " Show Less",
                                lessStyle: TextStyle(
                                  fontWeight: FontWeight.w900,
                                  color: mainColor2,
                                ),
                                // TextStyle
                                moreStyle: TextStyle(
                                  fontWeight: FontWeight.w900,
                                  color: mainColor2,
                                ),
                                // TextStyle
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16, height: 1.4,
                                  color: darkGrey,
                                  // TextStyle
                                ),
                              ),
                            ),
                          ),
                        ),
                      )
                    : Stack(
                        alignment: Alignment.center,
                        children: [
                          Positioned(
                            top: Get.height * .002,
                            child: Center(
                              child: Container(
                                color: Colors.transparent,
                                width: Get.width,
                                height: Get.height * .8,
                                child: ClipRRect(
                                    child: FadeInImage.assetNetwork(
                                  placeholder: "assets/images/l.gif",
                                  image: "${statusData.statusImageUrl}",
                                )),
                              ),
                            ),
                          ),
                  statusData.statusCaption==""?SizedBox():        Positioned(
                            top: Get.height * .68,
                            bottom: 10,
                            child: SingleChildScrollView(
                              physics: BouncingScrollPhysics(),
                              child: Container(
                                color: Colors.black45,
                                padding: EdgeInsets.symmetric(
                                    horizontal: 15, vertical: 5),
                                width: Get.width,
                                alignment: Alignment.center,
                                child: ReadMoreText(
                                  statusData.statusCaption!,
                                  trimLines: 2,
                                  trimMode: TrimMode.Line,
                                  // textDirection: TextDirection.rtl,

                                  textAlign: TextAlign.center,
                                  trimCollapsedText: " Show More",
                                  trimExpandedText: " Show Less",
                                  lessStyle: TextStyle(
                                    fontWeight: FontWeight.w900,
                                    color: mainColor2,
                                  ),
                                  // TextStyle
                                  moreStyle: TextStyle(
                                    fontWeight: FontWeight.w900,
                                    color: mainColor2,
                                  ),
                                  // TextStyle
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16, height: 1.4,
                                    color: white,
                                    // TextStyle
                                  ),
                                ),
                              ),
                            ),
                          )
                        ],
                      ),
              ),
            )),
            SizedBox(
              height: Get.height * .03,
            )
          ],
        ),
      ),
      floatingActionButton: isMe == true
          ? GetX(
              init: StatusController(),
              builder: (StatusController statusController) {
                return FloatingActionButton(
                  onPressed: () {
                    statusController.deleteStatus( Uid: statusData.userUid);
                  },
                  child: statusController.isDeleting.value == false
                      ? Icon(IconBroken.Delete)
                      : Padding(
                          padding: EdgeInsets.all(8),
                          child: CircularProgressIndicator(
                            color: Colors.white70,
                          ),
                        ),
                );
              },
            )
          : SizedBox(),
    );
  }
}
