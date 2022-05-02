import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:store_user/routes/routes.dart';
import 'package:store_user/utils/my_string.dart';

class SettingController extends GetxController {
  bool isLoading = false;

  firebase_storage.FirebaseStorage storage =
      firebase_storage.FirebaseStorage.instance;

  //////////////////////////////
  final ImagePicker picker = ImagePicker();
  File? profileImageFile;

  getImage() async {
    clearImage();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      profileImageFile = File(pickedFile.path);
      update();
    } else {
      print("No Image Selected");
    }
    update();
  }

  clearImage() {
    profileImageFile = null;
    update();
  }

  ///////////////////////////

  updateUserInfo(Map<String, Object> map, uid,context) {
    isLoading = true;
    update();
    return FirebaseFirestore.instance
        .collection(usersCollectionKey)
        .doc(uid)
        .update(map)
        .then((value) {
      Get.snackbar(
        "Updated ✔✔",
        "Updated successfully",
        backgroundColor: Colors.green,
        snackPosition: SnackPosition.TOP,
      );
      isLoading = false;
      update();
     // Get.offNamed(Routes.settingProfileScreen);
      clearImage();
      Navigator.pop(context);
    }).catchError((error) {
      isLoading = false;
      update();
      Get.snackbar(
        "Error",
        "please add eee$error",
        backgroundColor: Colors.red,
        snackPosition: SnackPosition.TOP,
      );
    });
  }

  Future updateUserImageStorage(
      uid, imageUrl, name, phoneNumber, email,context) async {
    isLoading = true;
    update();
    if (profileImageFile != null) {
      storage
          .ref()
          .child(
              "$usersCollectionKey/$uid/${Uri.file(profileImageFile!.path).pathSegments.last}")
          .putFile(profileImageFile!)
          .then((value) {
        value.ref.getDownloadURL().then((value) async {
          updateUserInfo({
            'displayName': name,
            'email': email,
            "profileUrl": value,
            "phoneNumber": phoneNumber,
          }, uid, context);
          Get.snackbar(
            "Uploaded ✔✔",
            "Uploaded successfully",
            backgroundColor: Colors.green,
            snackPosition: SnackPosition.TOP,
          );
        }).catchError((onError) {
          isLoading = false;
          update();
          Get.snackbar(
            "Error",
            "please add eee$onError",
            backgroundColor: Colors.red,
            snackPosition: SnackPosition.TOP,
          );
          print(onError);
        });
      }).catchError((onError) {
        print(onError);
      });
    } else {
      updateUserInfo({
        'displayName': name,
        'email': email,
        "profileUrl": imageUrl,
        "phoneNumber": phoneNumber,
      }, uid,context);
    }
  }
}
