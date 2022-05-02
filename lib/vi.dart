import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:store_user/controller.dart';
import 'package:store_user/utils/styles.dart';

class VI extends StatelessWidget {
  String audio =
      "https://firebasestorage.googleapis.com/v0/b/user-17bfd.appspot.com/o/audio%2FD07Q3f145482.mp4?alt=media&token=cfcdcd92-1f30-46c5-a0f7-d18622fe03e6";

  final controll = Get.put(Control());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: GetBuilder<Control>(builder: (_) {
          return Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Slider.adaptive(
                        value: controll.position.inSeconds.toDouble(),
                        max: controll.duration.inSeconds.toDouble(),
                        onChanged: (value) {}),
                  ),
                  GestureDetector(
                    onTap: () {controll.play(audio);
                      controll.getPlaybackFn(audio);
                    },
                    child: controll.isPlaying.value
                        ? Icon(IconBroken.Close_Square)
                        : Icon(IconBroken.Play),
                  )
                ],
              ),
            ],
          );
        }),
      ),
    );
  }
}
