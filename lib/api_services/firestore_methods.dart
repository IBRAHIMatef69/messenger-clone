import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:store_user/utils/my_string.dart';

class FireStoreMethods {
  CollectionReference users =
      FirebaseFirestore.instance.collection(usersCollectionKey);
  CollectionReference chatRooms =
      FirebaseFirestore.instance.collection(chatRoomsCollectionKey);
  CollectionReference statusCollection =
      FirebaseFirestore.instance.collection(statusCollectionKey);

  Future<void> insertUserInfoFireStorage(
      String displayName, email, uid, profileUrl, phoneNumber, token) async {
    users.doc(uid).set({
      'displayName': displayName,
      'uid': uid,
      'email': email,
      "profileUrl": profileUrl,
      "phoneNumber": phoneNumber,
      "registerDate": DateTime.now(),
      "token": token
    });
    return;
  }

////////////////////////////////
  editTokenInLogin(token, uid) async {
    await users.doc(uid).update({"token": token});
  }

  /////////////////////////////////
  updateLastMessageSend(
      String chatRoomId, Map<String, dynamic> lastMessageInfoMap) {
    return chatRooms.doc(chatRoomId).update(lastMessageInfoMap);
  }

  Future addMessage(String chatRoomId, String messageId,
      Map<String, dynamic> messageInfoMap) async {
    return chatRooms
        .doc(chatRoomId)
        .collection("chats")
        .doc(messageId)
        .set(messageInfoMap);
  }

////////////////////////////////////deleteMessage    //////////////////////////////
  Future<void> deleteMessage(
    String chatRoomId,
    String messageId,
  ) async {
    return chatRooms
        .doc(chatRoomId)
        .collection("chats")
        .doc(messageId)
        .delete();
  }

////////////////////////////////////addStatus    //////////////////////////////

  Future<void> addStatus({
    required String userUid,
    required String statusImageUrl,
    required String statusCaption,
    required String userImageUrl,
    required bool isVideo,
    required String userName,
    required statusDate,
  }) async {
    await statusCollection.doc(userUid).set({
      "userUid": userUid,
      "statusImageUrl": statusImageUrl,
      "statusCaption": statusCaption,
      "userImageUrl": userImageUrl,
      "isVideo":isVideo,
      "userName": userName,
      "statusDate": statusDate,

    });
  }
}
