import 'package:store_user/logic/binding/setting_binding.dart';
import 'package:store_user/view/screens/all_users_screen.dart';
import 'package:store_user/view/screens/auth_screen/forgot_password.dart';
import 'package:store_user/view/screens/auth_screen/login_screen.dart';
import 'package:store_user/view/screens/main_screen.dart';
import 'package:store_user/view/screens/auth_screen/splash_screen.dart';
import 'package:get/get.dart';
import 'package:store_user/view/screens/setting_screen.dart';
import 'package:store_user/view/screens/user_update_profile.dart';

import '../logic/binding/add_status_binding.dart';
import '../logic/binding/auth_binding.dart';
import '../logic/binding/chat_room_binding.dart';
import '../logic/binding/main_binding.dart';
import '../logic/binding/message_binding.dart';
import '../logic/binding/splash_binding.dart';
import '../view/screens/add_status_screen.dart';
import '../view/screens/auth_screen/sign_up_screen.dart';
import '../view/screens/chat_screen.dart';
import '../view/screens/view_status_screen.dart';

class Routes {
  static const splashScreen = "/splashScreen";
  static const updateProfile = "/updateProfile";
  static const mainScreen = "/mainScreen";
  static const signUpScreen = "/signUpScreen";
  static const loginScreen = "/loginScreen";
  static const forgotPassword = "/forgotPassword";
  static const settingProfileScreen = "/settingProfileScreen";
  static const allUsersScreen = "/almlUsersScreen";
  static const chatScreen = "/chatScreen";
  static const addStatusScreen = "/addStatusScreen";
  static const viewStatusScreen = "/viewStatusScreen";
  static const pickupLayout = "/pickupLayout";
  static final routes = [
    GetPage(
      name: splashScreen,
      page: () => SplashScreen(),
      binding: SplashBinding(),
    ),
    GetPage(
      name: mainScreen,
      page: () => MainScreen(),
      binding: MainBinding(),
    ),
    GetPage(
      name: signUpScreen,
      page: () => SignUpScreen(),
      binding: AuthBinding(),
    ),
    GetPage(
      name: allUsersScreen,
      page: () => AllUsersScreen(),
      bindings: [
        MainBinding(),
        ChatRoomBinding(),
      ],
      transition: Transition.rightToLeft,
    ),
    GetPage(
      name: loginScreen,
      page: () => LoginScreen(),
      binding: AuthBinding(),
    ),
    GetPage(
      name: forgotPassword,
      page: () => ForgotPassword(),
      binding: AuthBinding(),
    ),
    GetPage(
      name: updateProfile,
      page: () => UpdateProfile(),
      transition: Transition.rightToLeft,
      bindings: [
        AuthBinding(),
        SettingBinding(),
      ],
    ),
    GetPage(
        name: settingProfileScreen,
        page: () => SettingProfileScreen(),
        transition: Transition.rightToLeft,
        bindings: [
          AuthBinding(),
          MainBinding(),
        ]),
    GetPage(
        name: chatScreen,
        page: () => ChatScreen(),
        transition: Transition.rightToLeft,
        bindings: [
          MessagesBinding(),
        ]),
    GetPage(
        name: addStatusScreen,
        page: () => AddStatusScreen(),
        transition: Transition.downToUp,
        bindings: [
          AddStatusBinding(),
          MainBinding(),
        ]),
    GetPage(
      name: viewStatusScreen,
      page: () => ViewStatusScreen(),
      transition: Transition.downToUp,
    ),
  ];
}
