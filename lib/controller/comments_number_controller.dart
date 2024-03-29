import 'package:flutter/material.dart';
import 'package:social_app/constants/firestore_constants.dart';
import 'package:social_app/helper/firebase_helper.dart';

class CommentsNumberController extends ChangeNotifier {
  Stream getCommentsNumber({@required String postDocId}) {
    return FirebaseHelper.firestoreHelper
        .collection(postsCollection)
        .doc(postDocId)
        .collection(commentsCollection)
        .snapshots();
  }
}