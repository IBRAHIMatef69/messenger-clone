import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:store_user/firebase_services/firestore_methods.dart';
import 'package:store_user/model/status_model.dart';
import 'package:store_user/utils/my_string.dart';
import 'package:timer_count_down/timer_controller.dart';

import '../../firebase_services/firestorage_methods.dart';
import '../../model/chat_room_model.dart';

class StatusController extends GetxController {
  ////////////////////////////getting status image//////////////////////////////////////////////////
  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
    getMyFriendsStatus();
  }

  final ImagePicker picker = ImagePicker();
  File? statusImage;
  RxBool isLoading = false.obs;
  RxBool isDeleting = false.obs;
  final GetStorage authBox = GetStorage();
  var statesList = <StatusModel>[].obs;

  getImage() async {
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      statusImage = File(pickedFile.path);
      update();
    } else {
      Fluttertoast.showToast(
        gravity: ToastGravity.TOP,
        msg: "No Item Selected",
        backgroundColor: Colors.red,
      );
      print("No Image Selected");
    }
    update();
  }

  clearImage() {
    statusImage = null;
    update();
  }

  Future uploadingUserStatus(
      String statusCaption, userImageUrl, userName) async {
    if (statusImage != null) {
      isLoading.value = true;
      String userUid = authBox.read(KUid);
      FireStorageMethods()
          .uploadStatusImage(
              file: statusImage!,
              userUid: userUid,
              statusCaption: statusCaption,
              userImageUrl: userImageUrl,
              userName: userName,
              statusDate: DateTime.now())
          .then((value) {
        isLoading.value = false;
        Fluttertoast.showToast(
          gravity: ToastGravity.TOP,
          msg: "Status Uploaded successfully",
          backgroundColor: Colors.green,
        );
        Get.back();
        update();
      }).catchError((onError) {
        isLoading.value = false;

        debugPrint(onError.toString());
        Fluttertoast.showToast(
          gravity: ToastGravity.TOP,
          msg: "$onError",
          backgroundColor: Colors.red,
        );
        update();
      });
    } else {
      isLoading.value = true;
      String userUid = authBox.read(KUid);

      await FireStoreMethods()
          .addStatus(
              userUid: userUid,
              statusImageUrl: "",
              statusCaption: statusCaption,
              userImageUrl: userImageUrl,
              userName: userName,
              statusDate: DateTime.now())
          .then((value) {
        isLoading.value = false;
        Fluttertoast.showToast(
          gravity: ToastGravity.TOP,
          msg: "Status Uploaded successfully",
          backgroundColor: Colors.greenAccent,
        );

        Get.back();
        update();
      }).catchError((onError) {
        isLoading.value = false;

        debugPrint(onError.toString());
        Fluttertoast.showToast(
          gravity: ToastGravity.TOP,
          msg: "$onError",
          backgroundColor: Colors.red,
        );
      });
      update();
    }
  }

  Future getMyFriendsStatus() async {
    FireStoreMethods()
        .statusCollection
        .orderBy("statusDate", descending: true)
        .snapshots()
        .listen((event) {
      statesList.clear();
      for (int i = 0; i < event.docs.length; i++) {
        statesList.add(StatusModel.fromMap(event.docs[i]));
      }
    });
  }

  deleteStatus({required Uid}) async {
    isDeleting.value = true;
    String myUid = authBox.read(KUid);
    await FireStoreMethods().statusCollection.doc(Uid).delete().then((value) {
      isDeleting.value = false;

      if (Uid == myUid) {
        Get.back();
        Fluttertoast.showToast(
          gravity: ToastGravity.TOP,
          msg: "status deleted",
          backgroundColor: Colors.green,
        );
      }
      update();
    }).catchError((onError) {
      isDeleting.value = false;

      Fluttertoast.showToast(
        gravity: ToastGravity.TOP,
        msg: "$onError",
        backgroundColor: Colors.red,
      );
    });
    update();
  }

///////////////////////////is friend status///////////////////////////
  RxBool isFriendStatus = false.obs;

  FunIsFriendStatus(List<ChatRoomModel> chatRoomsList, statusUserUid) {
    isFriendStatus.value = false;
    isFriendStatus.value = chatRoomsList.any((element) {
      return element.chatRoomId.toString().contains(statusUserUid!);
    });
  }

///////////////////////////  getOnlyMyStatus  ///////////////////////////
  RxBool isMyStoryExist = false.obs;
  StatusModel? myStory;

  getOnlyMyStatus() {
    String myUid = authBox.read(KUid);
    for (var i = 0; i < statesList.length; i++) {
      if (statesList[i].userUid == myUid) {
        myStory = statesList[i];
      }
    }
    isMyStoryExist.value = statesList.any((element) {
      return element.userUid!.contains(myUid);
    });
  }
}
