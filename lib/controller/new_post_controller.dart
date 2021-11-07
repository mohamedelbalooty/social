import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:social_app/constants/firestore_constants.dart';
import 'package:social_app/helper/firebase_helper.dart';
import 'package:social_app/helper/image_picker_helper.dart';
import 'package:social_app/model/error_result_model.dart';
import 'package:social_app/model/post_model.dart';
import 'package:social_app/states/new_post_controller_states.dart';

class NewPostController extends ChangeNotifier {
  NewPostControllerPickPostImageStates newPostControllerPickPostImageStates;
  NewPostControllerCreatePostStates newPostControllerCreatePostStates;

  ErrorResult get errorResult => _errorResult;
  ErrorResult _errorResult;

  File get postImage => _postImage;
  File _postImage;

  Future<void> pickPostImage() async {
    var _pickedFile = await ImagePickerHelper.picker
        .pickImage(source: ImageSource.gallery, imageQuality: 80);
    if (_pickedFile != null) {
      _postImage = File(_pickedFile.path);
      newPostControllerPickPostImageStates =
          NewPostControllerPickPostImageStates.PostImagePickedSuccessState;
    } else {
      _errorResult = ErrorResult(
          errorMessage: 'An error occurred while taking the photo !',
          errorImage: 'assets/images/error.png');
      newPostControllerPickPostImageStates =
          NewPostControllerPickPostImageStates.PostImagePickedErrorState;
    }
    notifyListeners();
  }

  void removePickedImage() {
    _postImage = null;
    notifyListeners();
  }


  Future<void> uploadPostImage({
    @required String uid,
    @required String uName,
    @required String uImage,
    @required String postText,
    @required String datetime,
  }) async {
    newPostControllerCreatePostStates =
        NewPostControllerCreatePostStates.LoadingState;
    notifyListeners();
    try {
      var _reference = FirebaseHelper.storageHelper
          .ref()
          .child('posts/${Uri.file(_postImage.path).pathSegments.last}');
      await _reference.putFile(_postImage);
      await _reference.getDownloadURL().then((value) async {
        await createNewPost(
            uid: uid,
            uName: uName,
            uImage: uImage,
            postText: postText,
            postImage: value,
            datetime: datetime);
        newPostControllerCreatePostStates =
            NewPostControllerCreatePostStates.SuccessState;
      }).catchError((downloadException) {
        _errorResult = ErrorResult(
            errorMessage: 'Error when image downloaded !',
            errorImage: 'assets/images/error.png');
        newPostControllerCreatePostStates =
            NewPostControllerCreatePostStates.ErrorState;
        notifyListeners();
      });
    } catch (uploadException) {
      _errorResult = ErrorResult(
          errorMessage: 'Error when image uploaded !',
          errorImage: 'assets/images/error.png');
      newPostControllerCreatePostStates =
          NewPostControllerCreatePostStates.ErrorState;
    }
    notifyListeners();
  }

  Future<void> createNewPost(
      {@required String uid,
      @required String uName,
      @required String uImage,
      @required String postText,
      @required String datetime,
      String postImage}) async {
    newPostControllerCreatePostStates =
        NewPostControllerCreatePostStates.LoadingState;
    notifyListeners();
    PostModel _postModel = PostModel(
        uid: uid,
        uName: uName,
        uImage: uImage,
        datetime: datetime,
        postText: postText,
        postImage: postImage ?? '');
    try {
      await FirebaseHelper.firestoreHelper
          .collection(postsCollection)
          .add(_postModel.toJson());
      newPostControllerCreatePostStates =
          NewPostControllerCreatePostStates.SuccessState;
    } catch (createPostException) {
      _errorResult = ErrorResult(
          errorMessage: 'Oops error occurred when create a post !',
          errorImage: 'assets/images/error.png');
      newPostControllerCreatePostStates =
          NewPostControllerCreatePostStates.ErrorState;
    }
    notifyListeners();
  }
}
