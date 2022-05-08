import 'package:flutter_sound_platform_interface/flutter_sound_recorder_platform_interface.dart';

String validationEmail =
    r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+";

String validationName = r'^[a-z A-Z]+$';
String validationPhone = r'(^(?:[+0]9)?[0-9]{10,12}$)';

const String usersCollectionKey = "users";
const String statusCollectionKey = "status";
const String chatRoomsCollectionKey = "chatRooms";
const String callsCollectionKey = "calls";
const String KUid = "uid";

const theSource = AudioSource.microphone;
const String fcmBaseUrl = "https://fcm.googleapis.com/fcm/send";
const String cloudMessagingKey =
    "AAAAy2ZqUL8:APA91bHD-WnNl8ApQA8CwltPm6pvW5gPXH5Ick7B9pW2CJARJmwlgJcfwDl1cXAe-G5Zy4siLj6FhJ63pxyjZuhg1ldAjVW2QHkEebOSPPO43hLibNfwttrPAu4iIMuXDsI9e3mVfx9R";
const String APP_ID = "6819746e0af644c597f2899840c1773a";
// const String Agora_Token =
//     "0062205aa6bfae04f738229f011f405ba7eIACCUHgRSKH222Ymudo3SEBifDmpjyL81b4fwDDbHbhT70VE42sAAAAAEAB5wLBGEU53YgEAAQARTndi";
