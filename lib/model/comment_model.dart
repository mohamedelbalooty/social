import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class CommentModel {
  final String uImage, uName, commentText, commentImage;
  final Timestamp date;

  CommentModel(
      {@required this.uImage,
      @required this.uName,
      @required this.commentText,
      @required this.commentImage,
      @required this.date});

  factory CommentModel.fromJson(Map<String, dynamic> json) {
    return CommentModel(
        uImage: json['uImage'],
        uName: json['uName'],
        commentText: json['uComment'],
        commentImage: json['commentImage'],
        date: json['date']);
  }

  Map<String, dynamic> toJson() {
    return {
      'uImage': this.uImage,
      'uName': this.uName,
      'uComment': this.commentText,
      'date': this.date,
      'commentImage': this.commentImage,
    };
  }
}
