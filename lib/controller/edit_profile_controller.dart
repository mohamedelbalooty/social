import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:social_app/constants/firestore_constants.dart';
import 'package:social_app/helper/firebase_helper.dart';
import 'package:social_app/helper/image_picker_helper.dart';
import 'package:social_app/helper/user_id_helper.dart';
import 'package:social_app/model/error_result_model.dart';
import 'package:social_app/model/user_model.dart';
import 'package:social_app/states/edit_profile_controller_states.dart';

class EditProfileController extends ChangeNotifier {
  UserProfileControllerPickedImageStates userProfileControllerImageStates;
  UserProfileControllerUploadImageStates userProfileControllerUploadImageStates;
  UserProfileControllerUpdateDataStates userProfileControllerUpdateDataStates;

  ErrorResult get errorResult => _errorResult;
  ErrorResult _errorResult;

  ///PICK IMAGES

  File get profileImage => _profileImage;
  File _profileImage;

  File get coverImage => _coverImage;
  File _coverImage;

  Future<void> pickProfileImage() async {
    var _pickedFile = await ImagePickerHelper.picker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 80,
      maxHeight: 150.0,
      maxWidth: 150.0,
    );
    if (_pickedFile != null) {
      _profileImage = File(_pickedFile.path);
      userProfileControllerImageStates =
          UserProfileControllerPickedImageStates.ProfileImagePickedSuccessState;
    } else {
      _errorResult = ErrorResult(
          errorMessage: 'An error occurred while taking the photo !',
          errorImage: 'assets/images/error.png');
      userProfileControllerImageStates =
          UserProfileControllerPickedImageStates.ProfileImagePickedErrorState;
    }
    notifyListeners();
  }

  Future<void> pickCoverImage() async {
    var _pickedFile = await ImagePickerHelper.picker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 90,
    );
    if (_pickedFile != null) {
      _coverImage = File(_pickedFile.path);
      userProfileControllerImageStates =
          UserProfileControllerPickedImageStates.CoverImagePickedSuccessState;
    } else {
      _errorResult = ErrorResult(
          errorMessage: 'An error occurred while taking the photo !',
          errorImage: 'assets/images/error.png');
      userProfileControllerImageStates =
          UserProfileControllerPickedImageStates.CoverImagePickedErrorState;
    }
    notifyListeners();
  }

  // updateProfileData({
  //   @required String uid,
  //   @required String email,
  //   @required String name,
  //   @required String phone,
  //   @required String bio,
  //   @required String profileImageUrl,
  //   @required String coverImageUrl,
  //   @required getPostCurrentUserData,
  // }) async {
  //   if (_profileImage != null && _coverImage != null) {
  //     uploadProfileImage(
  //       uid: uid,
  //       email: email,
  //       name: name,
  //       phone: phone,
  //       bio: bio,
  //       coverImageUrl: coverImageUrl,
  //       getPostCurrentUserData: getPostCurrentUserData,
  //     );
  //     uploadCoverImage(
  //       uid: uid,
  //       email: email,
  //       name: name,
  //       phone: phone,
  //       bio: bio,
  //       profileImageUrl: profileImageUrl,
  //       getPostCurrentUserData: getPostCurrentUserData,
  //     );
  //   } else if (_profileImage != null) {
  //     uploadProfileImage(
  //       uid: uid,
  //       email: email,
  //       name: name,
  //       phone: phone,
  //       bio: bio,
  //       coverImageUrl: coverImageUrl,
  //       getPostCurrentUserData: getPostCurrentUserData,
  //     );
  //   } else if (_coverImage != null) {
  //     uploadCoverImage(
  //       uid: uid,
  //       email: email,
  //       name: name,
  //       phone: phone,
  //       bio: bio,
  //       profileImageUrl: profileImageUrl,
  //       getPostCurrentUserData: getPostCurrentUserData,
  //     );
  //   } else {
  //     updateData(
  //       uid: uid,
  //       email: email,
  //       name: name,
  //       phone: phone,
  //       bio: bio,
  //       profileImageUrl: profileImageUrl,
  //       coverImageUrl: coverImageUrl,
  //       getPostCurrentUserData: getPostCurrentUserData,
  //     );
  //   }
  // }

  ///USE FIREBASE STORAGE TO UPLOAD IMAGES

  Future<void> uploadProfileImage({
    @required String uid,
    @required String email,
    @required String name,
    @required String phone,
    @required String bio,
    @required String coverImageUrl,
  }) async {
    userProfileControllerUploadImageStates =
        UserProfileControllerUploadImageStates.UploadProfileImageLoadingState;
    notifyListeners();
    try {
      final reference = FirebaseHelper.storageHelper
          .ref()
          .child('users/${Uri.file(_profileImage.path).pathSegments.last}');
      await reference.putFile(_profileImage);
      await reference.getDownloadURL().then((value) async {
        await updateData(
            uid: uid,
            email: email,
            name: name,
            phone: phone,
            bio: bio,
            newProfileImageUrl: value,
            coverImageUrl: coverImageUrl);
        userProfileControllerUploadImageStates =
            UserProfileControllerUploadImageStates
                .UploadProfileImageSuccessState;
        notifyListeners();
      }).catchError((downloadException) {
        _errorResult = ErrorResult(
            errorMessage: 'Error when image downloaded !',
            errorImage: 'assets/images/error.png');
        userProfileControllerUploadImageStates =
            UserProfileControllerUploadImageStates.UploadProfileImageErrorState;
        notifyListeners();
      });
    } catch (uploadException) {
      _errorResult = ErrorResult(
          errorMessage: 'Error when image uploaded !',
          errorImage: 'assets/images/error.png');
      userProfileControllerUploadImageStates =
          UserProfileControllerUploadImageStates.UploadProfileImageErrorState;
      notifyListeners();
    }
    _profileImage = null;
    notifyListeners();
  }

  Future<void> uploadCoverImage({
    @required String uid,
    @required String email,
    @required String name,
    @required String phone,
    @required String bio,
    @required String profileImageUrl,
  }) async {
    userProfileControllerUploadImageStates =
        UserProfileControllerUploadImageStates.UploadCoverImageLoadingState;
    notifyListeners();
    try {
      final reference = FirebaseHelper.storageHelper
          .ref()
          .child('users/${Uri.file(_coverImage.path).pathSegments.last}');
      await reference.putFile(_coverImage);
      await reference.getDownloadURL().then((value) async {
        await updateData(
          uid: uid,
          email: email,
          name: name,
          phone: phone,
          bio: bio,
          profileImageUrl: profileImageUrl,
          newCoverImageUrl: value,
        );
        userProfileControllerUploadImageStates =
            UserProfileControllerUploadImageStates.UploadCoverImageSuccessState;
        notifyListeners();
      }).catchError((downloadException) {
        _errorResult = ErrorResult(
            errorMessage: 'Error when image downloaded !',
            errorImage: 'assets/images/error.png');
        userProfileControllerUploadImageStates =
            UserProfileControllerUploadImageStates.UploadCoverImageErrorState;
        notifyListeners();
      });
    } catch (uploadException) {
      _errorResult = ErrorResult(
          errorMessage: 'Error when image uploaded !',
          errorImage: 'assets/images/error.png');
      userProfileControllerUploadImageStates =
          UserProfileControllerUploadImageStates.UploadCoverImageErrorState;
      notifyListeners();
    }
    _coverImage = null;
    notifyListeners();
  }

  ///UPDATE USER PROFILE DATA

  Future<void> updateData(
      {@required String uid,
      @required String email,
      @required String name,
      @required String phone,
      @required String bio,
      String profileImageUrl,
      String coverImageUrl,
      String newCoverImageUrl,
      String newProfileImageUrl}) async {
    userProfileControllerUpdateDataStates =
        UserProfileControllerUpdateDataStates.LoadingState;
    notifyListeners();
    UserModel userModel = UserModel(
      uid: uid,
      email: email,
      name: name,
      phone: phone,
      bio: bio,
      profileImageUrl: newProfileImageUrl ?? profileImageUrl,
      coverImageUrl: newCoverImageUrl ?? coverImageUrl,
    );
    await FirebaseHelper.firestoreHelper
        .collection(usersCollection)
        .doc(UserIdHelper.currentUid)
        .update(userModel.toJson())
        .then((value) {
      userProfileControllerUpdateDataStates =
          UserProfileControllerUpdateDataStates.LoadedState;
      notifyListeners();
    }).catchError((error) {
      _errorResult = ErrorResult(
          errorMessage: 'Something went wrong !',
          errorImage: 'assets/images/error.png');
      userProfileControllerUpdateDataStates =
          UserProfileControllerUpdateDataStates.ErrorState;
      notifyListeners();
    });
  }
}
