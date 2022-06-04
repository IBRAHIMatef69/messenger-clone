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
    "AAAAufCaM-E:APA91bEPCEa-j_ue9iHUCXZry-86orgVLOBvfnibuRaniIoxvlGzYWQ-68b97ahAuZxlfCaF2L40b2EdfxZ3cNDxuo5hqRpSy97B6V50RyRgYh-WgytARo2pd8B-9uXq93QUtHctIHCj";
const String APP_ID = "6819746e0af644c597f2899840c1773a";
// const String Agora_Token =
//     "0062205aa6bfae04f738229f011f405ba7eIACCUHgRSKH222Ymudo3SEBifDmpjyL81b4fwDDbHbhT70VE42sAAAAAEAB5wLBGEU53YgEAAQARTndi";
