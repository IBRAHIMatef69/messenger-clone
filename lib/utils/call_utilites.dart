import 'dart:math';

import 'package:flutter/material.dart';
import 'package:store_user/api_services/call_methods.dart';
import 'package:store_user/model/call_model.dart';
import 'package:store_user/model/user_model.dart';
import 'package:store_user/view/screens/call_screens/audio_call_screen.dart';
import 'package:store_user/view/screens/call_screens/video_call_screen.dart';

class CallUtils {
  static final CallMethods callMethods = CallMethods();

  static dial(
      {required UserModel from,
      required UserModel to,
      required bool isAudioCall,
      context}) async {
    Call call = Call(
      callerId: from.uid!,
      callerName: from.displayName!,
      callerPic: from.profileUrl!,
      receiverId: to.uid!,
      receiverName: to.displayName!,
      receiverPic: to.profileUrl!,
      channelId: Random().nextInt(10000).toString(),
      isAudioCall: isAudioCall,
    );

    bool callMade = await callMethods.makeCall(call: call);

    call.hasDialled = true;

    if (callMade) {
      isAudioCall
          ? Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => AudioCallScreen(call: call),
              ))
          : Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => VideoCallScreen(call: call),
              ));
    }
  }
}
