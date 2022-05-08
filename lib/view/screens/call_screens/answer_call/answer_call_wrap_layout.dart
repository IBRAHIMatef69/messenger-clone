import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:store_user/logic/controller/call_controller.dart';

import 'answer_call_screen.dart';

class PickupLayout extends StatelessWidget {
  final Widget scaffold;
  final callController = Get.put(CallController());

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      return callController.isComingCall.value == true
          ? Obx(() {
              return callController.comingCall.value!.hasDialled == false
                  ? PickupScreen(call: callController.comingCall.value!)
                  : scaffold;
            })
          : scaffold;
    });
  }

  PickupLayout({
    required this.scaffold,
  });
}
