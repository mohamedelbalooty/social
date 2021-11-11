import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class CommentModel {
  final String uImage, uName, commentText, commentImage, commentDateTime;
  final Timestamp commentTime;

  CommentModel(
      {@required this.uImage,
      @required this.uName,
      @required this.commentText,
      @required this.commentImage,
      @required this.commentDateTime,
      @required this.commentTime});

  factory CommentModel.fromJson(Map<String, dynamic> json) {
    return CommentModel(
        uImage: json['uImage'],
        uName: json['uName'],
        commentText: json['uComment'],
        commentImage: json['commentImage'],
        commentDateTime: json['commentDateTime'],
        commentTime: json['commentTime']);
  }

  Map<String, dynamic> toJson() {
    return {
      'uImage': this.uImage,
      'uName': this.uName,
      'uComment': this.commentText,
      'commentImage': this.commentImage,
      'commentDateTime': this.commentDateTime,
      'commentTime': this.commentTime,
    };
  }
}
