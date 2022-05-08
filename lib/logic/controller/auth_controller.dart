import 'dart:io';
 import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:image_picker/image_picker.dart';
import 'package:store_user/api_services/firestorage_methods.dart';

import '../../api_services/firestore_methods.dart';
import '../../routes/routes.dart';
import '../../utils/constants.dart';
import '../../utils/my_string.dart';

class AuthController extends GetxController {
  FirebaseAuth auth = FirebaseAuth.instance;
  RxBool isLoading = false.obs;

  ////////////////////////////////////////////////
  final GetStorage authBox = GetStorage();
  var googleSignin = GoogleSignIn();

  var patientGender = "".obs;
  String gender = "Gender";

  var uid;

  bool isVisibilty = false;

///////////////////passwordVisibilty///////////////////////
  void visibility() {
    isVisibilty = !isVisibilty;
    update();
  }

  ////////////////////////////getting user image//////////////////////////////////////////////////

  final ImagePicker picker = ImagePicker();
  File? profileImage;

  getImage() async {
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      profileImage = File(pickedFile.path);
      update();
    } else {
      print("No Image Selected");
    }
    update();
  }

  clearImage() {
    profileImage = null;
    update();
  }

  ////////////////////////////////////////////////////////////////////////////////////////////////////////////
  updateUserEmail(String email) async {
    await auth.currentUser!.updateEmail(email);
  }

  ///////////////////////////////////////////////////////////////////////// sign up
  void patientSignUpUsingFirebase({
    required String name,
    required String email,
    required String password,
    required String phoneNumber,
  }) async {
    if (profileImage != null) {
      try {
        isLoading.value = true;
        await auth
            .createUserWithEmailAndPassword(email: email, password: password)
            .then((value) async {
          await authBox.write(KUid, value.user!.uid);
          uid = value.user!.uid;
          update();

          auth.currentUser!.updateDisplayName(name);
          // PatientFireStoreMethods().insertInfoFireStorage(
          //     name,
          //     email,
          //     value.user!.uid,
          //     "profileUrl",
          //     phoneNumber,
          //     patientGender.value,
          //     patientsCollectionKey,
          //     false);

          update();
          await FireStorageMethods()
              .uploadUserImageAndInfo(
            value.user!.uid,
            profileImage!,
            name,
            email,
            phoneNumber,
          )
              .then((v) {
            isLoading.value = false;
            update();
            authBox.write("auth", value.user!.uid);

            Get.offNamed(Routes.mainScreen);
            update();
          });
        });
      } on FirebaseAuthException catch (error) {
        isLoading.value = false;
        update();

        String title = error.code.toString().replaceAll(RegExp('-'), ' ');
        String message = "";
        if (error.code == 'weak-password') {
          message = "password is too weak.";
          title = error.code.toString();

          print('The password provided is too weak.');
        } else if (error.code == 'email-already-in-use') {
          message = "account already exists ";

          print('The account already exists for that email.');
        } else {
          message = error.message.toString();
        }

        Get.defaultDialog(
            title: title,
            middleText: message,
            textCancel: "Ok",
            buttonColor: mainColor2,
            cancelTextColor: mainColor,
            backgroundColor: white);
        // Get.snackbar(
        //   title,
        //   message,
        //   snackPosition: SnackPosition.TOP,
        // );
      } catch (error) {
        Get.snackbar(
          "Error",
          "$error",
          snackPosition: SnackPosition.TOP,
        );
        print(error);
      }
    } else {
      Get.snackbar(
        "empty Image",
        "please add a Image",
        snackPosition: SnackPosition.TOP,
      );
    }
  }

//////////////////////////////////////////////////////////////////////login with firebase///////////////////////////

  void loginUsingFirebase({
    required String email,
    required String password,
  }) async {
    try {
      isLoading.value = true;
      update();
      await auth
          .signInWithEmailAndPassword(email: email, password: password)
          .then((value) async {
        var token = await FirebaseMessaging.instance.getToken();
        await FireStoreMethods()
            .editTokenInLogin(token, value.user!.uid.toString());
        authBox.write(KUid, value.user!.uid.toString());

        Get.offNamed(Routes.mainScreen);
        isLoading.value = false;

        update();
      });
      update();

//      displayUserId.value = await GetStorage().read("uid");

      update();
    } on FirebaseAuthException catch (error) {
      isLoading.value = false;
      update();
      String title = error.code.toString().replaceAll(RegExp('-'), ' ');
      String message = "";
      if (error.code == 'user-not-found') {
        message =
            "Account does not exists for that $email.. Create your account by signing up..";
      } else if (error.code == 'wrong-password') {
        message = "Invalid Password... PLease try again!";
      } else {
        message = error.message.toString();
      }
      Get.defaultDialog(
          title: title,
          middleText: message,
          textCancel: "Ok",
          buttonColor: mainColor2,
          cancelTextColor: mainColor,
          backgroundColor: white);
    } catch (error) {
      Get.defaultDialog(
          title: "error",
          middleText: "$error",
          textCancel: "Ok",
          buttonColor: mainColor2,
          cancelTextColor: mainColor,
          backgroundColor: white);
      print(error);
    }
  }

//////////////////////////////////////////////////////////////////////login with google///////////////////////////

  Future googleSignupApp() async {
    try {
      final GoogleSignInAccount? googleUser = await googleSignin.signIn();
      // displayUserName.value = googleUser!.displayName!;
      // displayUserPhoto.value = googleUser.photoUrl!;
      // displayUserEmail.value = googleUser.email;

      final GoogleSignInAuthentication? googleAuth =
          await googleUser?.authentication;

      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth?.accessToken,
        idToken: googleAuth?.idToken,
      );

      await auth.signInWithCredential(credential).then((value) async {
        var token = await FirebaseMessaging.instance.getToken();
        await FireStoreMethods().insertUserInfoFireStorage(
          value.user!.displayName!,
          value.user!.email,
          value.user!.uid,
          value.user!.photoURL,
          value.user!.phoneNumber,
          token.toString(),
        );

        await authBox.write(KUid, value.user!.uid);
      });

      update();
      Get.offNamed(Routes.mainScreen);
    } catch (error) {
      Get.defaultDialog(
          title: "error",
          middleText: "$error",
          textCancel: "Ok",
          buttonColor: mainColor2,
          cancelTextColor: mainColor,
          backgroundColor: white);
      print("1111111111111111111111111111111111111111111$error");
    }
  }

  //////////////////////////////////////////////////////////////////////reset  ///////////////////////////

  void resetPassWord(String email) async {
    try {
      await auth.sendPasswordResetEmail(email: email);
      update();
      Get.back();
      Get.defaultDialog(
          title: "Reset Password",
          middleText: "check your gmail messages",
          textCancel: "Ok",
          buttonColor: mainColor,
          cancelTextColor: mainColor2,
          backgroundColor: white);
    } on FirebaseAuthException catch (error) {
      String title = error.code.toString().replaceAll(RegExp('-'), ' ');
      String message = "";
      if (error.code == 'user-not-found') {
        message =
            "Account does not exists for that $email.. Create your account by signing up..";
      } else {
        message = error.message.toString();
      }
      Get.defaultDialog(
          title: title,
          middleText: message,
          textCancel: "Ok",
          buttonColor: mainColor,
          cancelTextColor: mainColor2,
          backgroundColor: white);
    } catch (error) {
      Get.defaultDialog(
          title: "Error",
          middleText: "$error",
          textCancel: "Ok",
          buttonColor: mainColor,
          cancelTextColor: mainColor2,
          backgroundColor: white);
      print(error);
    }
  }

  ////////////////////////////////signOut//////////////////////////////////////
  void signOutFromApp() async {
    try {
      await auth.signOut();
      await googleSignin.signOut();
      // displayUserName.value = "";
      // displayUserPhoto.value = "";
      // displayUserEmail.value = "";
      authBox.remove("auth");
      authBox.erase();

      update();
      Get.offAllNamed(Routes.loginScreen);
    } catch (error) {
      Get.defaultDialog(
          title: "Error",
          middleText: "$error",
          textCancel: "Ok",
          buttonColor: Colors.grey,
          cancelTextColor: Colors.black,
          backgroundColor: Colors.grey.shade200);
    }
  }
}
