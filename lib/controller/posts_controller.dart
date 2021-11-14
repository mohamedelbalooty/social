import 'package:flutter/material.dart';
import 'package:social_app/constants/firestore_constants.dart';
import 'package:social_app/helper/firebase_helper.dart';
import 'package:social_app/helper/user_id_helper.dart';
import 'package:social_app/model/error_result_model.dart';
import 'package:social_app/model/post_model.dart';
import 'package:social_app/states/posts_controller_states.dart';

class PostsController extends ChangeNotifier {
  PostsControllerGetPostsStates postsControllerGetPostsStates =
      PostsControllerGetPostsStates.InitialState;
  PostsControllerLikePostStates postsControllerLikePostStates;

  ErrorResult get errorResult => _errorResult;
  ErrorResult _errorResult;

  String get errorMessage => _errorMessage;
  String _errorMessage;

  List<PostModel> get posts => _posts;
  List<PostModel> _posts = [];

  List<String> get postsId => _postsId;
  List<String> _postsId = [];

  List<int> get likes => _likes;
  List<int> _likes = [];

  Future<void> getPosts() async {
    postsControllerGetPostsStates = PostsControllerGetPostsStates.LoadingState;
    await FirebaseHelper.firestoreHelper
        .collection(postsCollection)
        .orderBy('datetime')
        .get()
        .then((value) {
      for (var item in value.docs) {
        item.reference.collection(likesCollection).get().then((value) {
          _likes.add(value.docs.length);
          _posts.add(PostModel.fromJson(item.data()));
          _postsId.add(item.id);
          postsControllerGetPostsStates =
              PostsControllerGetPostsStates.LoadedState;
          notifyListeners();
        }).catchError((error) {
          _errorResult = ErrorResult(
            errorMessage: 'Something went wrong !',
            errorImage: 'assets/images/error.png',
          );
          postsControllerGetPostsStates =
              PostsControllerGetPostsStates.ErrorState;
          notifyListeners();
        });
      }
    }).catchError((error) {
      _errorResult = ErrorResult(
        errorMessage: 'Something went wrong !',
        errorImage: 'assets/images/error.png',
      );
      postsControllerGetPostsStates = PostsControllerGetPostsStates.ErrorState;
      notifyListeners();
    });
    notifyListeners();
  }
}
