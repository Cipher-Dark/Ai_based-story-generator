import 'dart:convert';

class UserModel {
  String profileUrl;
  String uid;
  String name;
  String email;

  UserModel({
    required this.profileUrl,
    required this.uid,
    required this.name,
    required this.email,
  });

  factory UserModel.fromRawJson(String str) => UserModel.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory UserModel.fromJson(Map<String, dynamic> json) => UserModel(
        profileUrl: json["profileUrl"],
        uid: json["uid"],
        name: json["name"],
        email: json["email"],
      );

  Map<String, dynamic> toJson() => {
        "profileUrl": profileUrl,
        "uid": uid,
        "name": name,
        "email": email,
      };
}
