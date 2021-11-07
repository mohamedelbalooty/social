import 'package:flutter/material.dart';

class PostModel {
  final String uid, uName, uImage, datetime, postText, postImage;

  PostModel({
    @required this.uid,
    @required this.uName,
    @required this.uImage,
    @required this.datetime,
    @required this.postText,
    @required this.postImage,
  });

  factory PostModel.fromJson(Map<String, dynamic> json) {
    return PostModel(
      uid: json['uid'],
      uName: json['uName'],
      uImage: json['uImage'],
      datetime: json['datetime'],
      postText: json['postText'],
      postImage: json['postImage'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'uid': this.uid,
      'uName': this.uName,
      'uImage': this.uImage,
      'datetime': this.datetime,
      'postText': this.postText,
      'postImage': this.postImage,
    };
  }
}
