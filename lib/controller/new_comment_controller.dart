import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:social_app/constants/firestore_constants.dart';
import 'package:social_app/helper/firebase_helper.dart';
import 'package:social_app/helper/image_picker_helper.dart';
import 'package:social_app/model/comment_model.dart';
import 'package:social_app/states/new_comment_controller_states.dart';

class NewCommentController extends ChangeNotifier {
  NewCommentControllerPickCommentImage newCommentControllerPickCommentImage;
  // NewCommentControllerUploadCommentImageStates
  //     newCommentControllerUploadCommentImageStates;
  NewCommentControllerCreateComment
      newCommentControllerCreateComment;

  String get errorMessage => _errorMessage;
  String _errorMessage;

  File get commentImage => _commentImage;
  File _commentImage;

  Future<void> pickCommentImage() async {
    var _pickedFile =
        await ImagePickerHelper.picker.pickImage(source: ImageSource.gallery);
    if (_pickedFile != null) {
      _commentImage = File(_pickedFile.path);
      newCommentControllerPickCommentImage =
          NewCommentControllerPickCommentImage.CommentImagePickedSuccessState;
    } else {
      _errorMessage = 'An error occurred while taking the photo !';
      newCommentControllerPickCommentImage =
          NewCommentControllerPickCommentImage.CommentImagePickedErrorState;
    }
    notifyListeners();
  }

  void removePickedImage() {
    _commentImage = null;
    notifyListeners();
  }

  Future<void> uploadCommentImage(
      {@required String postDocId,
      @required String uName,
      @required String uImage,
      @required String commentText,
      @required String commentDateTime,
      @required Timestamp commentTime}) async {
    newCommentControllerCreateComment =
        NewCommentControllerCreateComment.LoadingState;
    notifyListeners();
    try {
      final reference = FirebaseHelper.storageHelper
          .ref()
          .child('comments/${Uri.file(_commentImage.path).pathSegments.last}');
      await reference.putFile(_commentImage);
      await reference.getDownloadURL().then((value) async {
        await createCommentOnPost(
          postDocId: postDocId,
          uName: uName,
          uImage: uImage,
          commentText: commentText,
          commentImage: value,
          commentDateTime: commentDateTime,
          commentTime: commentTime,
        );
        newCommentControllerCreateComment =
            NewCommentControllerCreateComment.SuccessState;
        notifyListeners();
      }).catchError((downloadException) {
        _errorMessage = 'Error when image downloaded !';
        newCommentControllerCreateComment =
            NewCommentControllerCreateComment.ErrorState;
        notifyListeners();
      });
    } catch (uploadException) {
      _errorMessage = 'Error when image uploaded !';
      newCommentControllerCreateComment =
          NewCommentControllerCreateComment.ErrorState;
      notifyListeners();
    }
    _commentImage = null;
    notifyListeners();
  }

  Future<void> createCommentOnPost({
    @required String postDocId,
    @required String uName,
    @required String uImage,
    @required String commentText,
    @required String commentDateTime,
    @required Timestamp commentTime,
    String commentImage,
  }) async {
    newCommentControllerCreateComment =
        NewCommentControllerCreateComment.LoadingState;
    notifyListeners();
    CommentModel commentModel = CommentModel(
        uName: uName,
        uImage: uImage,
        commentText: commentText,
        commentImage: commentImage ?? '',
        commentDateTime: commentDateTime,
        commentTime: commentTime);
    try {
      await FirebaseHelper.firestoreHelper
          .collection(postsCollection)
          .doc(postDocId)
          .collection(commentsCollection)
          .add(commentModel.toJson());
      newCommentControllerCreateComment =
          NewCommentControllerCreateComment.SuccessState;
    } catch (createCommentException) {
      _errorMessage = 'Oops, Something went wrong when write a comment !';
      newCommentControllerCreateComment =
          NewCommentControllerCreateComment.ErrorState;
    }
    notifyListeners();
  }
}
