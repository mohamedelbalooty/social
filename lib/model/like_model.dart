import 'package:flutter/material.dart';

class LikeModel {
  final bool liked;
  final String uName, uImage;

  LikeModel({
    @required this.liked,
    @required this.uName,
    @required this.uImage,
  });

  factory LikeModel.fromJson(Map<String, dynamic> json) {
    return LikeModel(
      liked: json['liked'],
      uName: json['uName'],
      uImage: json['uImage'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'liked': this.liked,
      'uName': this.uName,
      'uImage': this.uImage,
    };
  }
}
