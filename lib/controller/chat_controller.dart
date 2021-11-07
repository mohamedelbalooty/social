import 'package:flutter/material.dart';
import 'package:social_app/constants/firestore_constants.dart';
import 'package:social_app/helper/firebase_helper.dart';
import 'package:social_app/helper/user_id_helper.dart';
import 'package:social_app/model/error_result_model.dart';
import 'package:social_app/model/user_model.dart';
import 'package:social_app/states/chat_controller_states.dart';

class ChatController extends ChangeNotifier {
  ChatControllerGetUsersStates chatControllerGetUsersStates =
      ChatControllerGetUsersStates.InitialState;

  List<UserModel> get users => _users;
  List<UserModel> _users = [];

  ErrorResult get errorResult => _errorResult;
  ErrorResult _errorResult;

  Future<void> getUsers() async {
    chatControllerGetUsersStates = ChatControllerGetUsersStates.LoadingState;
    await FirebaseHelper.firestoreHelper
        .collection(usersCollection)
        .get()
        .then((value) {
      for (var item in value.docs) {
        if(item.data()['uid'] != UserIdHelper.currentUid)
        _users.add(
          UserModel.fromJson(item.data()),
        );
        chatControllerGetUsersStates = ChatControllerGetUsersStates.LoadedState;
        notifyListeners();
      }
    }).catchError((error) {
      _errorResult = ErrorResult(
        errorMessage: 'Something went wrong when get users!',
        errorImage: 'assets/images/error.png',
      );
      chatControllerGetUsersStates = ChatControllerGetUsersStates.ErrorState;
      notifyListeners();
    });
    notifyListeners();
  }
}
