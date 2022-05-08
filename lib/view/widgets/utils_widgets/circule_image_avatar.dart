import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:store_user/logic/controller/setting_controller.dart';
import 'package:store_user/utils/constants.dart';
import 'package:store_user/view/widgets/utils_widgets/image_viewer.dart';

class CirculeImageAvatar extends StatelessWidget {
  String imageUrl;
  double width;
  Color? color;
  File? image;
  bool? openImageViewer;
  final settingController = Get.put(SettingController());

  @override
  Widget build(BuildContext context) {
    return Container(
      height: width,
      width: width,
      decoration: BoxDecoration(
        // image: DecorationImage(
        //   image: NetworkImage(
        //     "$imageUrl",
        //   ),
        // ),
        borderRadius: BorderRadius.circular(width * 2),
        border: Border.all(
          color: color ?? mainColor2,
          width: 1.3,
        ),
      ),
      child: Card(
        margin: EdgeInsets.all(2),
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(width * 2)),
        child: GetBuilder<SettingController>(
          builder: (_) {
            return ClipRRect(
              borderRadius: BorderRadius.circular(width * 2),
              child: settingController.profileImageFile == null
                  ? InkWell(borderRadius: BorderRadius.circular(width),
                      onTap: () {
                        openImageViewer == null
                            ? Get.to(
                                () => ImageViewer(
                                  imageUrl: imageUrl,
                                ),
                                transition: Transition.topLevel,
                              )
                            : null;
                      },
                      child: FadeInImage.assetNetwork(
                          fit: BoxFit.cover,
                          placeholder: "assets/images/63065-profile-in-out.gif",
                          image: imageUrl),
                    )
                  : Image.file(
                      settingController.profileImageFile!,
                      fit: BoxFit.cover,
                    ),
            );
          },
        ),
      ),
    );
  }

  CirculeImageAvatar(
      {required this.imageUrl, required this.width, this.color, this.image,this.openImageViewer});
}
