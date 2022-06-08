import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:store_user/logic/controller/auth_controller.dart';
import 'package:store_user/view/widgets/utils_widgets/text_utils.dart';
import 'package:url_launcher/url_launcher.dart';

class CheckWidget extends StatelessWidget {
  final controller = Get.find<AuthController>();

  final Uri _url = Uri.parse('https://sites.google.com/view/chatenger/%D8%A7%D9%84%D8%B5%D9%81%D8%AD%D8%A9-%D8%A7%D9%84%D8%B1%D8%A6%D9%8A%D8%B3%D9%8A%D8%A9');
  @override
  Widget build(BuildContext context) {
    return GetBuilder<AuthController>(builder: (_) {
      return Row(
        children: [
          InkWell(
            onTap: () {
              controller.checked();
            },
            child: Container(
              height: Get.width * .043,
              width: Get.width * .043,
              decoration: BoxDecoration(
                color: Colors.grey.shade300,
                borderRadius: BorderRadius.circular(10),
              ),
              child: SizedBox(
                height: Get.width * .039,
                width: Get.width * .039,
                child: controller.isChecked
                    ? Center(
                        child: Icon(
                        Icons.check_rounded,
                        size: Get.width * .04,
                      ))
                    : Text(""),
              ),
            ),
          ),
          SizedBox(
            width: 10,
          ),
          KTextUtils(
              text: "I accept ",
              size: Get.width * .04,
              fontWeight: FontWeight.normal,
              color: Colors.black87,
              textDecoration: TextDecoration.none),
          InkWell(
            onTap: () async {
      if (!await launchUrl(_url)) throw 'Could not launch $_url';

            },
            child: KTextUtils(
                text: "Privacy Policy",
                size: Get.width * .045,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
                textDecoration: TextDecoration.underline),
          ),
        ],
      );
    });
  }
}
