import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:store_user/logic/controller/status_controller.dart';
import 'package:store_user/utils/constants.dart';
import 'dart:math' as math;
import 'dart:ui' as ui;

import 'package:store_user/utils/styles.dart';

import '../../logic/controller/main_controller.dart';

class AddStatusScreen extends StatelessWidget {
  final statusController = Get.find<StatusController>();
  final mainController = Get.find<MainController>();
  TextEditingController captionController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: mainColor4,
      body: Stack(
        alignment: Alignment.center,
        children: [
          GetBuilder<StatusController>(
            builder: (_) {
              return Transform(
                alignment: Alignment.center,
                transform: Matrix4.rotationY(math.pi),
                child: Padding(
                  padding: const EdgeInsets.all(0.0),
                  child: statusController.statusImage == null
                      ? Image.asset(
                          "assets/images/add_image.png",
                          fit: BoxFit.cover,
                        )
                      : Container(
                          height: Get.height,
                          width: Get.width,
                          color: Colors.transparent,
                          child: Image.file(
                            statusController.statusImage!,
                            fit: BoxFit.cover,
                          ),
                        ),
                ),
              );
            },
          ),
          BackdropFilter(
            filter: ui.ImageFilter.blur(
              sigmaX: 10,
              sigmaY: 10,
            ),
            child: Container(
              color: black.withOpacity(.3),
            ),
          ),
          Scaffold(
            appBar: AppBar(
              backgroundColor: Colors.transparent,
              elevation: 0,
              leading: GetBuilder<StatusController>(
                builder: (_) {
                  return IconButton(
                    icon: Icon(
                      IconBroken.Arrow___Left_2,
                      size: 34,
                    ),
                    onPressed: () {
                      statusController.clearImage();

                      Get.back();
                    },
                  );
                },
              ),
            ),
            backgroundColor: Colors.transparent,
            body: Center(
              child: Container(
                  alignment: Alignment.center,
                  height: Get.height * .8,
                  margin: EdgeInsets.symmetric(horizontal: 20),
                  child: TextField(
                    controller: captionController,
                    keyboardType: TextInputType.multiline,
                    maxLines: null,
                    style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.white70),
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      hintText: "Type Your status...",
                      hintStyle: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.white54),
                    ),
                    cursorColor: Colors.white38,
                    cursorHeight: 20,
                    cursorRadius: Radius.circular(20),
                  )),
            ),
            floatingActionButton: Obx(
              () {
                return FloatingActionButton(
                  onPressed: () {
                    if (statusController.statusImage == null &&
                        captionController.text.isEmpty) {
                      Fluttertoast.showToast(
                        gravity: ToastGravity.TOP,
                        msg: "please add status",
                        backgroundColor: Colors.red,
                      );
                    } else {
                      statusController.uploadingUserStatus(
                        captionController.text.toString(),
                        mainController.userInfoModel.value!.profileUrl,
                        mainController.userInfoModel.value!.displayName,
                      );
                    }
                  },
                  child: statusController.isLoading.value
                      ? Padding(
                          padding: EdgeInsets.all(3),
                          child: CircularProgressIndicator(
                            color: mainColor2,
                          ),
                        )
                      : Icon(
                          IconBroken.Send,
                          color: mainColor2,
                        ),
                  backgroundColor: white,
                );
              },
            ),
          ),
          Positioned(
              bottom: Get.height * .02,
              left: Get.height * .02,
              child: GetBuilder<StatusController>(
                builder: (_) {
                  return FloatingActionButton(
                    onPressed: () {
                      statusController.getImage();
                    },
                    child: Icon(
                      IconBroken.Camera,
                      color: mainColor2,
                    ),
                    backgroundColor: white,
                  );
                },
              ))
        ],
      ),
    );
  }
}
