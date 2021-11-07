import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:social_app/constants/firestore_constants.dart';
import 'package:social_app/helper/firebase_helper.dart';
import 'package:social_app/helper/image_picker_helper.dart';
import 'package:social_app/model/comment_model.dart';
import 'package:social_app/model/error_result_model.dart';
import 'package:social_app/states/comment_controller_states.dart';

class CommentController extends ChangeNotifier {
  CommentControllerPickCommentImage commentControllerPickCommentImage;
  CommentControllerUploadCommentImageStates
      commentControllerUploadCommentImageStates;
  CommentControllerCreateCommentOnPost commentControllerCreateCommentOnPost;

  String get errorMessage => _errorMessage;
  String _errorMessage;

  File get commentImage => _commentImage;
  File _commentImage;

  Future<void> pickCommentImage() async {
    var _pickedFile =
        await ImagePickerHelper.picker.pickImage(source: ImageSource.gallery);
    if (_pickedFile != null) {
      _commentImage = File(_pickedFile.path);
      commentControllerPickCommentImage =
          CommentControllerPickCommentImage.CommentImagePickedSuccessState;
    } else {
      _errorMessage = 'An error occurred while taking the photo !';
      commentControllerPickCommentImage =
          CommentControllerPickCommentImage.CommentImagePickedErrorState;
    }
    notifyListeners();
  }

  Future<void> uploadCommentImage(
      {@required String postDocId,
      @required String uName,
      @required String uImage,
      @required String commentText,
      @required Timestamp date}) async {
    commentControllerCreateCommentOnPost =
        CommentControllerCreateCommentOnPost.LoadingState;
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
          date: date,
        );
        commentControllerUploadCommentImageStates =
            CommentControllerUploadCommentImageStates
                .UploadCommentImageSuccessState;
        notifyListeners();
      }).catchError((downloadException) {
        _errorMessage = 'Error when image downloaded !';
        commentControllerUploadCommentImageStates =
            CommentControllerUploadCommentImageStates
                .UploadCommentImageErrorState;
        notifyListeners();
      });
    } catch (uploadException) {
      _errorMessage = 'Error when image uploaded !';
      commentControllerUploadCommentImageStates =
          CommentControllerUploadCommentImageStates
              .UploadCommentImageErrorState;
      notifyListeners();
    }
  }

  Future<void> createCommentOnPost({
    @required String postDocId,
    @required String uName,
    @required String uImage,
    @required String commentText,
    @required Timestamp date,
    String commentImage,
  }) async {
    commentControllerCreateCommentOnPost =
        CommentControllerCreateCommentOnPost.LoadingState;
    notifyListeners();
    CommentModel commentModel = CommentModel(
        uName: uName,
        uImage: uImage,
        commentText: commentText,
        commentImage: commentImage ?? '',
        date: date);
    try {
      await FirebaseHelper.firestoreHelper
          .collection(postsCollection)
          .doc(postDocId)
          .collection(commentsCollection)
          .add(commentModel.toJson());
      commentControllerCreateCommentOnPost =
          CommentControllerCreateCommentOnPost.SuccessState;
    } catch (createCommentException) {
      _errorMessage = 'Oops, Something went wrong when write a comment !';
      commentControllerCreateCommentOnPost =
          CommentControllerCreateCommentOnPost.ErrorState;
    }
    notifyListeners();
  }

  List<CommentModel> get comments => _comments;
  List<CommentModel> _comments = [];

  ErrorResult get errorResult => _errorResult;
  ErrorResult _errorResult;

  CommentControllerGetComments commentControllerGetComments =
      CommentControllerGetComments.InitialState;

  Future<void> getComments({@required String postDocId}) async {
    commentControllerGetComments = CommentControllerGetComments.LoadingState;
    await FirebaseHelper.firestoreHelper
        .collection(postsCollection)
        .doc(postDocId)
        .collection(commentsCollection)
        .get()
        .then((value) {
      for (var item in value.docs) {
        _comments.add(
          CommentModel.fromJson(item.data()),
        );
        commentControllerGetComments = CommentControllerGetComments.LoadedState;
        notifyListeners();
      }
    }).catchError((error) {
      _errorResult = ErrorResult(
        errorMessage: 'Something went wrong !',
        errorImage: 'assets/images/error.png',
      );
      commentControllerGetComments = CommentControllerGetComments.ErrorState;
      notifyListeners();
    });
    notifyListeners();
  }

  Stream<List<CommentModel>> getCommentsk(postDocId) {
    var streamQuerySnapshots = FirebaseHelper.firestoreHelper
        .collection(postsCollection)
        .doc(postDocId)
        .collection(commentsCollection)
        .snapshots();
    return streamQuerySnapshots.map(
      (QuerySnapshot querySnapshot) => querySnapshot.docs
          .map(
            (document) => CommentModel.fromJson(document.data()),
          )
          .toList(),
    );
  }

  Stream<QuerySnapshot> commentss(postDocId) {
    return FirebaseHelper.firestoreHelper
        .collection(postsCollection)
        .doc(postDocId)
        .collection(commentsCollection)
        .snapshots();
  }
}
