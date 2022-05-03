import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';
import 'package:store_user/routes/routes.dart';

import 'package:get_storage/get_storage.dart';
import 'package:store_user/utils/constants.dart';


Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  // If you're going to use other Firebase services in the background, such as Firestore,
  // make sure you call `initializeApp` before using other Firebase services.
  debugPrint("on ${message.notification!.body} message ");
  print(message.notification!.body.toString());

  Fluttertoast.showToast(
    gravity: ToastGravity.TOP,
    msg: "New message from " + message.notification!.title.toString(),
    backgroundColor: mainColor2,
  );
}

void main() async {
  //بيتاكد ان كل حاجه هنا خلصانه وبعدين يفتح التطبيق
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp();
  await GetStorage.init();

  var token = await FirebaseMessaging.instance.getToken();
  debugPrint(token.toString());
  FirebaseMessaging.onMessage.listen((event) {
    // debugPrint(event.notification!.body.toString());
    //
    // Fluttertoast.showToast(
    //   gravity: ToastGravity.TOP,
    //   msg: "on Message",
    //   backgroundColor: Colors.red,
    // );
  });
  FirebaseMessaging.onMessageOpenedApp.listen((event) {
    print(event.notification!.body.toString());

    Fluttertoast.showToast(
      gravity: ToastGravity.TOP,
      msg: "New message from " + event.notification!.title.toString(),
      backgroundColor: Colors.red,
    );
  });
  FirebaseMessaging.onBackgroundMessage(firebaseMessagingBackgroundHandler);

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Chat',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      //home: VI(),
           getPages: Routes.routes,
            initialRoute: Routes.splashScreen,
      //Fraon
    );
  }
}
