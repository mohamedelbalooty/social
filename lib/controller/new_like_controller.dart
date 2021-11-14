import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:social_app/constants/firestore_constants.dart';
import 'package:social_app/helper/firebase_helper.dart';
import 'package:social_app/helper/user_id_helper.dart';
import 'package:social_app/model/like_model.dart';

class NewLikeProvider extends ChangeNotifier {
  Stream<DocumentSnapshot> likeButtonStream({@required String postDocId}) {
    return FirebaseHelper.firestoreHelper
        .collection(postsCollection)
        .doc(postDocId)
        .collection(likesCollection)
        .doc(UserIdHelper.currentUid)
        .snapshots();
  }

  Future<void> addLikes(bool liked, postDocId,
      {@required bool isLiked,
      @required String uName,
      @required String uImage}) async {
    var reference = FirebaseHelper.firestoreHelper
        .collection(postsCollection)
        .doc(postDocId)
        .collection(likesCollection)
        .doc(UserIdHelper.currentUid);
    LikeModel likeModel =
        LikeModel(liked: isLiked, uName: uName, uImage: uImage);
    liked = !liked;
    if (liked) {
      await reference.set(likeModel.toJson());
    } else {
      await reference.delete();
    }
  }
}
