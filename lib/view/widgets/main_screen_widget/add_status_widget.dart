import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:store_user/routes/routes.dart';
import 'package:store_user/utils/constants.dart';
import 'package:store_user/utils/styles.dart';
import 'package:store_user/view/widgets/utils_widgets/text_utils.dart';

class AddStatusWidget extends StatelessWidget {
  const AddStatusWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return DottedBorder(
      radius: Radius.circular(Get.width * 3),
      borderType: BorderType.Circle,
      color: mainColor2,
      strokeWidth: 2,
      dashPattern: const [
        3,
        3,
      ],
      child: InkWell(
        onTap: () {
          Get.toNamed(Routes.addStatusScreen);
        },
        child: Container(
            padding: EdgeInsets.zero,
            margin: EdgeInsets.zero,
            //margin: EdgeInsets.only(top: 10),
            alignment: Alignment.center,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(Get.width * 2),
            ),
            child: SizedBox(
                width: Get.height * .116,
                child: ClipRRect(child: Image.asset("assets/images/story.png")))
            // Column(
            //   mainAxisAlignment: MainAxisAlignment.center,
            //   children: [
            //     Icon(IconBroken.Upload),
            //     KTextUtils(
            //         text: "Add Status",
            //         size: Get.width * .035,
            //         color: black,
            //         fontWeight: FontWeight.w800,
            //         textDecoration: TextDecoration.none)
            //   ],
            // ),
            ),
      ),
    );
  }
}
