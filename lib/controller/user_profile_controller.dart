import 'package:flutter/material.dart';
import 'package:social_app/constants/firestore_constants.dart';
import 'package:social_app/helper/firebase_helper.dart';
import 'package:social_app/helper/user_id_helper.dart';
import 'package:social_app/model/error_result_model.dart';
import 'package:social_app/model/user_model.dart';
import 'package:social_app/states/user_profile_controller_states.dart';

class UserProfileController extends ChangeNotifier {
  UserProfileControllerGetUserProfileDataStates
      userProfileControllerGetUserProfileDataStates =
      UserProfileControllerGetUserProfileDataStates.InitialState;

  UserModel get userProfileData => _userProfileData;
  UserModel _userProfileData;

  ErrorResult get errorResult => _errorResult;
  ErrorResult _errorResult;

  Future<void> getUserProfileData() async {
    userProfileControllerGetUserProfileDataStates =
        UserProfileControllerGetUserProfileDataStates.LoadingState;
    await FirebaseHelper.firestoreHelper
        .collection(usersCollection)
        .doc(UserIdHelper.currentUid)
        .get()
        .then((value) {
      _userProfileData = UserModel.fromJson(value.data());
      userProfileControllerGetUserProfileDataStates =
          UserProfileControllerGetUserProfileDataStates.LoadedState;
      notifyListeners();
    }).catchError((error) {
      _errorResult = ErrorResult(
          errorMessage: 'Something went wrong !',
          errorImage: 'assets/images/error.png');
      userProfileControllerGetUserProfileDataStates =
          UserProfileControllerGetUserProfileDataStates.ErrorState;
    });
    notifyListeners();
  }
}
