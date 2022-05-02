import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:store_user/logic/controller/auth_controller.dart';
import 'package:store_user/logic/controller/main_controller.dart';
import 'package:store_user/logic/controller/setting_controller.dart';
import 'package:store_user/model/user_model.dart';
import 'package:store_user/utils/constants.dart';
import 'package:store_user/utils/my_string.dart';
import 'package:store_user/view/widgets/auth/auth_button.dart';
import 'package:store_user/view/widgets/auth/auth_text_from_field.dart';
import 'package:store_user/view/widgets/utils_widgets/circule_image_avatar.dart';

import '../../utils/styles.dart';
import '../widgets/utils_widgets/height_size_box.dart';

class UpdateProfile extends StatelessWidget {
  UpdateProfile({Key? key}) : super(key: key);
  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final authController = Get.find<AuthController>();
  final settingController = Get.find<SettingController>();
  UserModel data = Get.arguments[0];
  final formUpdateKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    nameController.text = data.displayName!;
    emailController.text = data.email!;
    phoneController.text = data.phoneNumber ?? "";

    return Scaffold(
      backgroundColor: homeBackGroundColor,
      appBar: AppBar(
        // actions: [
        //   TextButton(
        //       onPressed: () {},
        //       child: Text(
        //         "Done",
        //         style: TextStyle(
        //           fontSize: 15,
        //           fontWeight: FontWeight.bold,
        //           color: homeBackGroundColor,
        //         ),
        //       ))
        // ],
        leading: GetBuilder<MainController>(
          builder: (_) {
            return IconButton(
              onPressed: () {
                Get.back();
                settingController.clearImage();
              },
              icon: Icon(   IconBroken.Arrow___Left_2,
                size: Get.width*.1,),
            );
          },
        ),
        centerTitle: true,
        title: const Text(
          "Update Profile",
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: white,
          ),
        ),
        backgroundColor: mainColor2,
        elevation: 0,
      ),
      body: Container(
        height: Get.height,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              mainColor2,
              mainColor4,
              mainColor,
              Color(0xffB4ECE3),
            ],
          ),
        ),
        child: Padding(
          padding: EdgeInsets.all(8),
          child: SingleChildScrollView(
            child: Form(
              key: formUpdateKey,
              child: Column(
                children: [
                  HeightSizeBox(Get.width * .07),
                  GetBuilder<SettingController>(
                    builder: (_) {
                      return Stack(
                        children: [
                          CirculeImageAvatar(
                            width: Get.width * .28,
                            imageUrl: data.profileUrl!,
                            color: Colors.white,
                          ),
                          Positioned(
                            bottom: 0,
                            right: 0,
                            child: CircleAvatar(
                              backgroundColor: white.withOpacity(.8),
                              maxRadius: Get.width * .06,
                              child: IconButton(
                                onPressed: () {
                                   settingController.getImage();
                                },
                                icon: Icon(
                                  Icons.edit,
                                  color: black,
                                  size: Get.width * .06,
                                ),
                              ),
                            ),
                          )
                        ],
                      );
                    },
                  ),
                  HeightSizeBox(Get.width * .07),
                  AuthTextFromField(
                    controller: nameController,
                    obscureText: false,
                    validator: (value) {
                      if (value.length == 0) {
                        return 'Please enter name';
                      } else if (value.toString().length <= 2 ||
                          !RegExp(validationName).hasMatch(value)) {
                        return "Enter valid name";
                      } else {
                        return null;
                      }
                    },
                    hintText: "Full name",
                    textInputType: TextInputType.name,
                    suffixIcon: Text(""),
                    prefixIcon: Icon(
                      Icons.account_circle_outlined,
                      color: white,
                    ),
                    color: white,
                  ),
                  HeightSizeBox(Get.width * .07),
                  AuthTextFromField(
                    color: white,
                    controller: phoneController,
                    obscureText: false,
                    validator: (value) {
                      if (value.length == 0) {
                        return 'Please enter mobile number';
                      } else if (!RegExp(validationPhone).hasMatch(value)) {
                        return 'Please enter valid mobile number';
                      }
                      return null;
                    },
                    hintText: "Phone number",
                    textInputType: TextInputType.phone,
                    suffixIcon: Text(""),
                    prefixIcon: Icon(
                      Icons.phone_android,
                      color: white,
                    ),
                  ),
                  HeightSizeBox(Get.width * .07),
                  AuthTextFromField(
                    color: white,
                    controller: emailController,
                    obscureText: false,
                    validator: (value) {
                      if (value.length == 0) {
                        return 'Please enter email';
                      } else if (!RegExp(validationEmail).hasMatch(value)) {
                        return "Invalid Email";
                      } else {
                        return null;
                      }
                    },
                    hintText: 'Email',
                    textInputType: TextInputType.emailAddress,
                    prefixIcon: Icon(
                      Icons.email_outlined,
                      color: white,
                    ),
                    suffixIcon: Text(""),
                  ),
                  HeightSizeBox(Get.width * .07),
                  HeightSizeBox(Get.width * .07 * 2),
                  GetBuilder<SettingController>(
                    builder: (_) {
                      return GetBuilder<AuthController>(
                        builder: (_) {
                          return AuthButton(
                              onPressed: () {
                                  if (formUpdateKey.currentState!.validate()) {
                                    //     cc.auth.currentUser!.updateEmail(emailController.text);

                                    settingController
                                        .updateUserImageStorage(
                                        data.uid!,
                                        data.profileUrl!,
                                        nameController.text,
                                        phoneController.text,
                                        emailController.text,

                                        context)
                                        .then((value) {authController.updateUserEmail(
                                        emailController.text);

                                    });
                                  }
                              },
                              text:
                                  settingController.isLoading == true
                                      ? Container(margin: EdgeInsets.all(5),
                                      child: CircularProgressIndicator())
                                      :
                                  Text("Update",
                                      style: TextStyle(
                                          fontSize: 22,
                                          color: Colors.black,
                                          fontWeight: FontWeight.w700)),
                              width: Get.width * .7);
                        },
                      );
                    },
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
