import 'package:cloud_firestore/cloud_firestore.dart';

class StatusModel {
  String? statusCaption;
  Timestamp? statusDate;
  String? statusImageUrl;
  String? userImageUrl;
  String? userName;
  String? userUid;

  StatusModel(
    this.statusCaption,
    this.statusDate,
    this.statusImageUrl,
    this.userImageUrl,
    this.userName,
    this.userUid,
  );

  factory StatusModel.fromMap(map) {
    return StatusModel(
      map['statusCaption'],
      map['statusDate'],
      map['statusImageUrl'],
      map['userImageUrl'],
      map['userName'],
      map['userUid'],
    );
  }
}
