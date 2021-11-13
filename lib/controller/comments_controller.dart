import 'package:flutter/material.dart';
import 'package:social_app/constants/firestore_constants.dart';
import 'package:social_app/helper/firebase_helper.dart';
import 'package:social_app/model/comment_model.dart';
import 'package:social_app/model/error_result_model.dart';
import 'package:social_app/states/comments_controller_stats.dart';

class CommentsController extends ChangeNotifier {
  CommentsControllerStates commentsControllerStates;

  List<CommentModel> get comments => _comments;
  List<CommentModel> _comments = [];

  ErrorResult get errorResult => _errorResult;
  ErrorResult _errorResult;

  void getComments({@required String postDocId}) {
    try {
      FirebaseHelper.firestoreHelper
          .collection(postsCollection)
          .doc(postDocId)
          .collection(commentsCollection)
          .orderBy('commentTime')
          .snapshots()
          .listen((event) {
        _comments = [];
        for (var item in event.docs) {
          _comments.add(
            CommentModel.fromJson(item.data()),
          );
        }
        commentsControllerStates =
            CommentsControllerStates.CommentsControllerGetCommentsSuccessState;
        notifyListeners();
      });
    } catch (exception) {
      _errorResult = ErrorResult(
          errorMessage: 'Oops, Something went wrong !',
          errorImage: 'assets/images/error.png');
      commentsControllerStates =
          CommentsControllerStates.CommentsControllerGetCommentsSuccessState;
      notifyListeners();
    }
  }
}
