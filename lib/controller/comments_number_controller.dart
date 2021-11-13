import 'package:flutter/material.dart';
import 'package:social_app/constants/firestore_constants.dart';
import 'package:social_app/helper/firebase_helper.dart';

class CommentsNumberController extends ChangeNotifier{

  int get commentsNumber => _commentsNumber;
  int _commentsNumber = 0;

  List coms = [];

  void getCommentsNumber({@required String postDocId}) async {
    // try {
    //   _commentsNumber = await FirebaseHelper.firestoreHelper
    //       .collection(postsCollection)
    //       .doc(postDocId)
    //       .collection(commentsCollection)
    //       .snapshots().length;
    //   //     .listen((event) {
    //   //    for(var item in event.docs){
    //   //      _commentsNumber.add(item.data());
    //   //    }
    //   // });
    //     commentsControllerStates =
    //         CommentsControllerStates.CommentsControllerGetCommentsSuccessState;
    //     notifyListeners();
    // } catch (exception) {
    //   commentsControllerStates =
    //       CommentsControllerStates.CommentsControllerGetCommentsSuccessState;
    //   notifyListeners();
    // }

    // FirebaseHelper.firestoreHelper
    //     .collection(postsCollection)
    //     .doc(postDocId)
    //     .collection(commentsCollection)
    //     .snapshots().listen((event) {
    //       for(var item in coms){
    //         coms.add(item.)
    //       }
    // });


    _commentsNumber = await FirebaseHelper.firestoreHelper
        .collection(postsCollection)
        .doc(postDocId)
        .collection(commentsCollection)
        .snapshots().length;
    notifyListeners();

  }
}