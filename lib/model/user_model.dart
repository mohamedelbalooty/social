import 'package:flutter/material.dart';

class UserModel {
  final String uid, name, email, phone, profileImageUrl, coverImageUrl, bio;

  UserModel(
      {@required this.uid,
      @required this.name,
      @required this.email,
      @required this.phone,
      @required this.profileImageUrl,
      @required this.coverImageUrl,
      @required this.bio});

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
        uid: json['uid'],
        name: json['name'],
        email: json['email'],
        phone: json['phone'],
        profileImageUrl: json['imageUrl'],
        coverImageUrl: json['imageCover'],
        bio: json['bio']);
  }

  Map<String, dynamic> toJson() {
    return {
      'uid': this.uid,
      'name': this.name,
      'email': this.email,
      'phone': this.phone,
      'imageUrl': this.profileImageUrl,
      'imageCover': this.coverImageUrl,
      'bio': this.bio
    };
  }
}
