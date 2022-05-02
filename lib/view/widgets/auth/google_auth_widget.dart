import 'package:flutter/material.dart';
import 'package:get/get.dart';

class GoogleAuthImage extends StatelessWidget {
  final Function() onPressed;

  const GoogleAuthImage({Key? key, required this.onPressed}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        InkWell(
            onTap: onPressed,
            child: Container(
              width: Get.width*.1,
              height: Get.width*.1,
              child: Image.asset(
                "assets/images/google.png",
              ),
            )),
      ],
    );
  }
}
