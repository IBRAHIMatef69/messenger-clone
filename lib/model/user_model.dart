class UserModel {
  String? displayName;
  String? email;
  String? profileUrl;
  String? phoneNumber;
  String? uid;
  String? token;

  UserModel(
    this.displayName,
    this.uid,
    this.email,
    this.profileUrl,
    this.phoneNumber,
    this.token,
  );

  Map<String, dynamic> toMap() {
    return {
      'displayName': this.displayName,
      'uid': this.uid,
      'email': this.email,
      'profileUrl': this.profileUrl,
      'phoneNumber': this.phoneNumber,
      'token': this.token,
    };
  }

  factory UserModel.fromMap(map) {
    return UserModel(
      map['displayName'],
      map['uid'],
      map['email'],
      map['profileUrl'],
      map['phoneNumber'],
      map['token'],
    );
  }
}
