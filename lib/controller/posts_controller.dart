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

  Stream getLikes({@required String postDocId}) {
    return FirebaseHelper.firestoreHelper
        .collection(postsCollection)
        .doc(postDocId)
        .collection(likesCollection)
        .snapshots();
  }

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

  Future<void> likePost({@required String postDocId}) async {
    try {
      await FirebaseHelper.firestoreHelper
          .collection(postsCollection)
          .doc(postDocId)
          .collection(likesCollection)
          .doc(UserIdHelper.currentUid)
          .set({
        'like': true,
      });
      postsControllerLikePostStates =
          PostsControllerLikePostStates.SuccessState;
    } catch (likeException) {
      _errorMessage = 'Oops, Something went wrong !';
      postsControllerLikePostStates = PostsControllerLikePostStates.ErrorState;
    }
    notifyListeners();
  }

// NewCommentControllerPickCommentImage commentControllerPickCommentImage;
// // NewCommentControllerUploadCommentImageStates
// // commentControllerUploadCommentImageStates;
// NewCommentControllerCreateComment commentControllerCreateCommentOnPost;

// String get errorMessage => _errorMessage;
// String _errorMessage;

// File get commentImage => _commentImage;
// File _commentImage;
//
// Future<void> pickCommentImage() async {
//   var _pickedFile =
//   await ImagePickerHelper.picker.pickImage(source: ImageSource.gallery);
//   if (_pickedFile != null) {
//     _commentImage = File(_pickedFile.path);
//     commentControllerPickCommentImage =
//         NewCommentControllerPickCommentImage.CommentImagePickedSuccessState;
//   } else {
//     _errorMessage = 'An error occurred while taking the photo !';
//     commentControllerPickCommentImage =
//         NewCommentControllerPickCommentImage.CommentImagePickedErrorState;
//   }
//   notifyListeners();
// }

// Future<void> uploadCommentImage(
//     {@required String postDocId,
//       @required String uName,
//       @required String uImage,
//       @required String commentText,
//       @required String date}) async {
//   commentControllerCreateCommentOnPost =
//       CommentControllerCreateCommentOnPost.LoadingState;
//   notifyListeners();
//   try {
//     final reference = FirebaseHelper.storageHelper
//         .ref()
//         .child('comments/${Uri.file(_commentImage.path).pathSegments.last}');
//     await reference.putFile(_commentImage);
//     await reference.getDownloadURL().then((value) async {
//       await createCommentOnPost(
//         postDocId: postDocId,
//         uName: uName,
//         uImage: uImage,
//         commentText: commentText,
//         commentImage: value,
//         date: date,
//       );
//       commentControllerUploadCommentImageStates =
//           CommentControllerUploadCommentImageStates
//               .UploadCommentImageSuccessState;
//       notifyListeners();
//     }).catchError((downloadException) {
//       _errorMessage = 'Error when image downloaded !';
//       commentControllerUploadCommentImageStates =
//           CommentControllerUploadCommentImageStates
//               .UploadCommentImageErrorState;
//       notifyListeners();
//     });
//   } catch (uploadException) {
//     _errorMessage = 'Error when image uploaded !';
//     commentControllerUploadCommentImageStates =
//         CommentControllerUploadCommentImageStates
//             .UploadCommentImageErrorState;
//     notifyListeners();
//   }
// }
//
// Future<void> createCommentOnPost({
//   @required String postDocId,
//   @required String uName,
//   @required String uImage,
//   @required String commentText,
//   @required String date,
//   String commentImage,
// }) async {
//   commentControllerCreateCommentOnPost =
//       CommentControllerCreateCommentOnPost.LoadingState;
//   notifyListeners();
//   CommentModel commentModel = CommentModel(
//       uName: uName,
//       uImage: uImage,
//       commentText: commentText,
//       commentImage: commentImage ?? '',
//       date: date);
//   try {
//     await FirebaseHelper.firestoreHelper
//         .collection(postsCollection)
//         .doc(postDocId)
//         .collection(commentsCollection)
//         .add(commentModel.toJson());
//     commentControllerCreateCommentOnPost =
//         CommentControllerCreateCommentOnPost.SuccessState;
//   } catch (createCommentException) {
//     _errorMessage = 'Oops, Something went wrong when write a comment !';
//     commentControllerCreateCommentOnPost =
//         CommentControllerCreateCommentOnPost.ErrorState;
//   }
//   notifyListeners();
// }

// List<CommentModel> get comments => _comments;
// List<CommentModel> _comments = [];
//
// // ErrorResult get errorResult => _errorResult;
// // ErrorResult _errorResult;
//
// CommentControllerGetComments commentControllerGetComments =
//     CommentControllerGetComments.InitialState;
//
// Future<void> getComments({@required String postDocId}) async {
//   commentControllerGetComments = CommentControllerGetComments.LoadingState;
//   notifyListeners();
//   await FirebaseHelper.firestoreHelper
//       .collection(postsCollection)
//       .doc(postDocId)
//       .collection(commentsCollection)
//       .get()
//       .then((value) {
//     for (var item in value.docs) {
//       _comments.add(
//         CommentModel.fromJson(item.data()),
//       );
//       commentControllerGetComments = CommentControllerGetComments.LoadedState;
//       notifyListeners();
//     }
//   }).catchError((error) {
//     _errorResult = ErrorResult(
//       errorMessage: 'Something went wrong !',
//       errorImage: 'assets/images/error.png',
//     );
//     commentControllerGetComments = CommentControllerGetComments.ErrorState;
//     notifyListeners();
//   });
// }

// PostsControllerPickCommentImage postsControllerPickCommentImage;
//
// File get commentImage => _commentImage;
// File _commentImage;
//
// Future<void> pickCommentImage() async {
//   var _pickedFile =
//       await ImagePickerHelper.picker.pickImage(source: ImageSource.gallery);
//   if (_pickedFile != null) {
//     _commentImage = File(_pickedFile.path);
//     postsControllerPickCommentImage =
//         PostsControllerPickCommentImage.CommentImagePickedSuccessState;
//   } else {
//     _errorMessage = 'An error occurred while taking the photo !';
//     postsControllerPickCommentImage =
//         PostsControllerPickCommentImage.CommentImagePickedErrorState;
//   }
//   notifyListeners();
// }
//
// PostsControllerUploadImageStates postsControllerUploadImageStates;
//
// Future<void> uploadCommentImage(
//     {@required String postDocId,
//     @required String uName,
//     @required String uImage,
//     @required String commentText,
//     @required DateTime date}) async {
//   postsControllerCreateCommentOnPost =
//       PostsControllerCreateCommentOnPost.LoadingState;
//   notifyListeners();
//   try {
//     final reference = FirebaseHelper.storageHelper
//         .ref()
//         .child('comments/${Uri.file(_commentImage.path).pathSegments.last}');
//     await reference.putFile(_commentImage);
//     await reference.getDownloadURL().then((value) async {
//       await createCommentOnPost(
//         postDocId: postDocId,
//         uName: uName,
//         uImage: uImage,
//         commentText: commentText,
//         commentImage: value,
//         date: date,
//       );
//       postsControllerUploadImageStates =
//           PostsControllerUploadImageStates.UploadCommentImageSuccessState;
//       notifyListeners();
//     }).catchError((downloadException) {
//       _errorMessage = 'Error when image downloaded !';
//       postsControllerUploadImageStates =
//           PostsControllerUploadImageStates.UploadCommentImageErrorState;
//       notifyListeners();
//     });
//   } catch (uploadException) {
//     _errorMessage = 'Error when image uploaded !';
//     postsControllerUploadImageStates =
//         PostsControllerUploadImageStates.UploadCommentImageErrorState;
//     notifyListeners();
//   }
// }
//
//
// Stream<List<CommentModel>> getComments(postDocId) {
//   var streamQuerySnapshots = FirebaseHelper.firestoreHelper
//       .collection(postsCollection)
//       .doc(postDocId)
//       .collection(commentsCollection)
//       .snapshots();
//   return streamQuerySnapshots.map(
//     (QuerySnapshot querySnapshot) => querySnapshot.docs
//         .map(
//           (document) => CommentModel.fromJson(document.data()),
//         )
//         .toList(),
//   );
// }
//
// PostsControllerCreateCommentOnPost postsControllerCreateCommentOnPost;
//
// Future<void> createCommentOnPost({
//   @required String postDocId,
//   @required String uName,
//   @required String uImage,
//   @required String commentText,
//   @required DateTime date,
//   String commentImage,
// }) async {
//   postsControllerCreateCommentOnPost =
//       PostsControllerCreateCommentOnPost.LoadingState;
//   notifyListeners();
//   CommentModel commentModel = CommentModel(
//       uName: uName,
//       uImage: uImage,
//       commentText: commentText,
//       commentImage: commentImage ?? '',
//       date: date);
//   try {
//     await FirebaseHelper.firestoreHelper
//         .collection(postsCollection)
//         .doc(postDocId)
//         .collection(commentsCollection)
//         .add(commentModel.toJson());
//     // .doc(UserIdHelper.currentUid)
//     // .set(commentModel.toJson());
//     postsControllerCreateCommentOnPost =
//         PostsControllerCreateCommentOnPost.SuccessState;
//   } catch (createCommentException) {
//     _errorMessage = 'Oops, Something went wrong when write a comment !';
//     postsControllerCreateCommentOnPost =
//         PostsControllerCreateCommentOnPost.ErrorState;
//   }
//   notifyListeners();
// }

}
