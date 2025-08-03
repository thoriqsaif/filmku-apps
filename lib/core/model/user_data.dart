import 'dart:convert';

UserData userDataFromJson(String str) => UserData.fromJson(json.decode(str));

String userDataToJson(UserData data) => json.encode(data.toJson());

class UserData {
  String userId;
  String userName;
  String userEmail;

  UserData({
    required this.userId,
    required this.userName,
    required this.userEmail,
  });

  factory UserData.fromJson(Map<String, dynamic> json) => UserData(
    userId: json["user_id"],
    userName: json["user_name"],
    userEmail: json["user_email"],
  );

  Map<String, dynamic> toJson() => {
    "user_id": userId,
    "user_name": userName,
    "user_email": userEmail,
  };
}
