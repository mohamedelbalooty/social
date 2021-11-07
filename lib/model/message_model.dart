import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';

class MessageModel {
  final String senderId, receiverId, messageText, messageImage, messageTime;

  // final Timestamp messageTime;

  MessageModel(
      {@required this.senderId,
      @required this.receiverId,
      @required this.messageText,
      @required this.messageImage,
      @required this.messageTime});

  factory MessageModel.fromJson(Map<String, dynamic> json) {
    return MessageModel(
      senderId: json['senderId'],
      receiverId: json['receiverId'],
      messageText: json['messageText'],
      messageImage: json['messageImage'],
      messageTime: json['messageTime'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'senderId': this.senderId,
      'receiverId': this.receiverId,
      'messageText': this.messageText,
      'messageImage': this.messageImage,
      'messageTime': this.messageTime
    };
  }
}
