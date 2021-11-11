import 'package:flutter/material.dart';
import 'package:social_app/constants/firestore_constants.dart';
import 'package:social_app/helper/firebase_helper.dart';
import 'package:social_app/model/comment_model.dart';

class CommentsController extends ChangeNotifier {
  List<CommentModel> get comments => _comments;
  List<CommentModel> _comments = [];

  void getComments({@required String postDocId}) {
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
      notifyListeners();
    });
  }
}
