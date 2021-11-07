import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:social_app/core/auth_errors.dart';
import 'package:social_app/helper/firebase_helper.dart';
import 'package:social_app/states/auth_controllers_states.dart';

class LoginController extends ChangeNotifier {
  String uId;
  String errorMessage;
  LoginControllerStates loginStates = LoginControllerStates.InitialState;

  Future<void> userLogin(String email, String password) async {
    loginStates = LoginControllerStates.LoadingState;
    notifyListeners();
    try {
      UserCredential userCredential = await FirebaseHelper.authHelper
          .signInWithEmailAndPassword(email: email, password: password);
      uId = userCredential.user.uid;
      loginStates = LoginControllerStates.SuccessState;
      notifyListeners();
    } on FirebaseAuthException catch (exception) {
      errorMessage = handlingAuthError(exception.code);
      loginStates = LoginControllerStates.ErrorState;
      notifyListeners();
    }
  }
}
