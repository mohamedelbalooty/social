import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:social_app/constants/firestore_constants.dart';
import 'package:social_app/core/auth_errors.dart';
import 'package:social_app/helper/firebase_helper.dart';
import 'package:social_app/model/user_model.dart';
import 'package:social_app/states/auth_controllers_states.dart';

class SignupController extends ChangeNotifier {
  String uId;
  String errorMessage;
  SignupControllerStates signupStates = SignupControllerStates.InitialState;

  Future<void> userSignup(
      String name, String email, String password, String phone) async {
    signupStates = SignupControllerStates.LoadingState;
    notifyListeners();
    try {
      UserCredential userCredential = await FirebaseHelper.authHelper
          .createUserWithEmailAndPassword(email: email, password: password);
      uId = userCredential.user.uid;
      UserModel userModel = UserModel(
        uid: userCredential.user.uid,
        name: name,
        email: email,
        phone: phone,
        profileImageUrl: initialProfileImage ?? secondProfileImage,
        coverImageUrl: initialCoverImage ?? secondCoverImage,
        bio: 'write your bio...',
      );
      await FirebaseHelper.firestoreHelper
          .collection(usersCollection)
          .doc(userCredential.user.uid)
          .set(userModel.toJson())
          .catchError(
        (error) {
          errorMessage = error;
          signupStates = SignupControllerStates.ErrorState;
          notifyListeners();
        },
      );
      signupStates = SignupControllerStates.SuccessState;
      notifyListeners();
    } on FirebaseAuthException catch (exception) {
      print(exception.code);
      errorMessage = handlingAuthError(exception.code);
      signupStates = SignupControllerStates.ErrorState;
      notifyListeners();
    }
  }
}
