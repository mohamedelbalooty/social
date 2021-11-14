import 'package:flutter/material.dart';
import 'package:social_app/constants/firestore_constants.dart';
import 'package:social_app/helper/firebase_helper.dart';
import 'package:social_app/model/error_result_model.dart';
import 'package:social_app/model/like_model.dart';
import 'package:social_app/states/likes_controller_states.dart';

class LikesController extends ChangeNotifier {
  LikesControllerStates likesControllerStates;

  List<LikeModel> get likes => _likes;
  List<LikeModel> _likes = [];

  ErrorResult get errorResult => _errorResult;
  ErrorResult _errorResult;

  void getLikes({@required String postDocId}) {
    try {
      FirebaseHelper.firestoreHelper
          .collection(postsCollection)
          .doc(postDocId)
          .collection(likesCollection)
          .snapshots()
          .listen((event) {
        _likes = [];
        for (var item in event.docs) {
          _likes.add(
            LikeModel.fromJson(item.data()),
          );
        }
        likesControllerStates = LikesControllerStates.LikesControllerGetLikesSuccessState;
        notifyListeners();
      });
    } catch (exception) {
      _errorResult = ErrorResult(
          errorMessage: 'Oops, Something went wrong !',
          errorImage: 'assets/images/error.png');
      likesControllerStates = LikesControllerStates.LikesControllerGetLikesErrorState;
      notifyListeners();
    }
  }
}
