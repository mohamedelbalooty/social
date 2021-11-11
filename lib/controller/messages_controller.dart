import 'package:flutter/material.dart';
import 'package:social_app/constants/firestore_constants.dart';
import 'package:social_app/helper/firebase_helper.dart';
import 'package:social_app/model/message_model.dart';

class MessagesController extends ChangeNotifier {

  List<MessageModel> get messages => _messages;
  List<MessageModel> _messages = [];

  void getMessages({@required String senderId, @required String receiverId}) {
    FirebaseHelper.firestoreHelper
        .collection(usersCollection)
        .doc(senderId)
        .collection(chatsCollection)
        .doc(receiverId)
        .collection(messagesCollection)
        .orderBy('messageTime', descending: true)
        .snapshots()
        .listen((event) {
      _messages = [];
      for (var item in event.docs) {
        _messages.add(
          MessageModel.fromJson(item.data()),
        );
      }
      notifyListeners();
    });
  }
}
