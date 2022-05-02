import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:store_user/logic/controller/messages_controller.dart';

import '../utils/my_string.dart';
import 'firestore_methods.dart';

class FireStorageMethods {
  final GetStorage authBox = GetStorage();

  FirebaseAuth auth = FirebaseAuth.instance;
  MessagesController messageController = MessagesController();

  static firebase_storage.FirebaseStorage storage =
      firebase_storage.FirebaseStorage.instance;

  Future<void> uploadUserImageAndInfo(String uid, File file, String displayName,
      email, phoneNumber) async {
    await storage
        .ref()
        .child(
        "$usersCollectionKey/$uid/${Uri
            .file(file.path)
            .pathSegments
            .last}")
        .putFile(file)
        .then((value) {
      value.ref.getDownloadURL().then((value) async {
        var token = await FirebaseMessaging.instance.getToken();
        await FireStoreMethods()
            .insertUserInfoFireStorage(
            displayName, email, uid, value, phoneNumber, token.toString())
            .then((a) async {
          await auth.currentUser!.updatePhotoURL(value);
          await auth.currentUser!.updateDisplayName(displayName);

          authBox.write(KUid, uid);
        });
        //  await auth.currentUser!.updatePhoneNumber(phoneNumber);
      }).catchError((onError) {
        print(onError);
      });
    }).catchError((error) {
      print("//////////////////////////////$error");
    });
  }

  Future<void> uploadFile(File file,
      String folderName,
      chatRoomId,
      sendClicked,

      myUserId,
      senderName,) async {
    await storage
        .ref()
        .child("$folderName/${Uri
        .file(file.path)
        .pathSegments
        .last}")
        .putFile(file)
        .then((value) async {
      value.ref.getDownloadURL().then((value) async {
        messageController.sendFileMessage(
            chatRoomId: chatRoomId,
            sendClicked: sendClicked,
            myUserId: myUserId,
            senderName: senderName,

            fileMessage: value

        );
      });
    }).catchError((onError) {
      print("$onError ddddddddddddddddddddddddd");
    });
  }


  ////////////////////////////////////////////addStatus    //////////////////////////////

  Future<void> uploadStatusImage({required File file,
    required String userUid,
     required String statusCaption,
    required String userImageUrl,
    required String userName,
    required statusDate,
  }) async {
    await storage
        .ref()
        .child("$statusCollectionKey/${Uri
        .file(file.path)
        .pathSegments
        .last}")
        .putFile(file)
        .then((value) async {
      value.ref.getDownloadURL().then((value) async {
        FireStoreMethods().addStatus(userUid: userUid,
            statusImageUrl: value,
            statusCaption: statusCaption,
            userImageUrl: userImageUrl,
            userName: userName,
            statusDate: statusDate);
      });
    }).catchError((onError) {
      print("$onError ddddddddddddddddddddddddd");
    });
  }

}
