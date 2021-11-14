import 'package:flutter/material.dart';
import 'package:social_app/constants/firestore_constants.dart';
import 'package:social_app/helper/firebase_helper.dart';
import 'package:social_app/model/error_result_model.dart';
import 'package:social_app/model/message_model.dart';
import 'package:social_app/states/messages_controller_states.dart';

class MessagesController extends ChangeNotifier {
  MessagesControllerStates messagesControllerStates;

  ErrorResult get errorResult => _errorResult;
  ErrorResult _errorResult;

  List<MessageModel> get messages => _messages;
  List<MessageModel> _messages = [];

  void getMessages({@required String senderId, @required String receiverId}) {
    try {
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
        messagesControllerStates =
            MessagesControllerStates.MessagesControllerGetMessagesSuccessState;
        notifyListeners();
      });
    } catch (exception) {
      _errorResult = ErrorResult(
          errorMessage: 'Something went wrong when getting messages !',
          errorImage: 'assets/images/noData.png');
      messagesControllerStates =
          MessagesControllerStates.MessagesControllerGetMessagesErrorState;
      notifyListeners();
    }
  }
}
