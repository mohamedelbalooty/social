// import 'dart:io';
// import 'package:flutter/material.dart';
// import 'package:image_picker/image_picker.dart';
// import 'package:social_app/constants/firestore_constants.dart';
// import 'package:social_app/helper/firebase_helper.dart';
// import 'package:social_app/helper/image_picker_helper.dart';
// import 'package:social_app/model/error_result_model.dart';
// import 'package:social_app/model/post_model.dart';
// import 'package:social_app/model/user_model.dart';
// import 'package:social_app/states/user_controller_states.dart';
//
// class UserController extends ChangeNotifier {
//   UserControllerGetUserProfileDataStates
//       userControllerGetUserProfileDataStates =
//       UserControllerGetUserProfileDataStates.InitialState;
//   UserControllerGetPostsStates userControllerGetPostsStates =
//       UserControllerGetPostsStates.InitialState;
//   UserControllerCreatePostStates userControllerCreatePostStates;
//   UserControllerPickPostImageStates userControllerPickPostImageStates;
//
//   UserModel get currentUserProfileData => _userProfileData;
//   UserModel _userProfileData;
//
//   ErrorResult get errorResult => _errorResult;
//   ErrorResult _errorResult;
//
//   File get postImage => _postImage;
//   File _postImage;
//
//   List<PostModel> get posts => _posts;
//   List<PostModel> _posts = [];
//
//   String _currentUid = FirebaseHelper.authHelper.currentUser.uid;
//
//   Future<void> getUserProfileData() async {
//     print('getUserProfileData');
//     userControllerGetUserProfileDataStates =
//         UserControllerGetUserProfileDataStates.LoadingState;
//     await FirebaseHelper.firestoreHelper
//         .collection(usersCollection)
//         .doc(_currentUid)
//         .get()
//         .then((value) {
//       _userProfileData = UserModel.fromJson(value.data());
//       userControllerGetUserProfileDataStates =
//           UserControllerGetUserProfileDataStates.LoadedState;
//       notifyListeners();
//     }).catchError((error) {
//       _errorResult = ErrorResult(
//           errorMessage: 'Something went wrong !',
//           errorImage: 'assets/images/error.png');
//       userControllerGetUserProfileDataStates =
//           UserControllerGetUserProfileDataStates.ErrorState;
//       userControllerGetPostsStates = UserControllerGetPostsStates.ErrorState;
//     });
//     notifyListeners();
//   }
//
//   Future<void> pickPostImage() async {
//     ImagePicker _picker = ImagePicker();
//     var _pickedFile =
//         await _picker.pickImage(source: ImageSource.gallery, imageQuality: 80);
//     if (_pickedFile != null) {
//       _postImage = File(_pickedFile.path);
//       userControllerPickPostImageStates =
//           UserControllerPickPostImageStates.PostImagePickedSuccessState;
//     } else {
//       _errorResult = ErrorResult(
//           errorMessage: 'An error occurred while taking the photo !',
//           errorImage: 'assets/images/error.png');
//       userControllerPickPostImageStates =
//           UserControllerPickPostImageStates.PostImagePickedErrorState;
//     }
//     notifyListeners();
//   }
//
//   void removePickedImage() {
//     _postImage = null;
//     notifyListeners();
//   }
//
//   Future<void> uploadPostImage({
//     @required String datetime,
//     @required String postText,
//   }) async {
//     userControllerCreatePostStates =
//         UserControllerCreatePostStates.LoadingState;
//     notifyListeners();
//     try {
//       var _reference = FirebaseHelper.storageHelper
//           .ref()
//           .child('posts/${Uri.file(_postImage.path).pathSegments.last}');
//       await _reference.putFile(_postImage);
//       await _reference.getDownloadURL().then((value) async {
//         await createNewPost(
//             datetime: datetime, postText: postText, postImage: value);
//         userControllerCreatePostStates =
//             UserControllerCreatePostStates.SuccessState;
//       }).catchError((downloadException) {
//         _errorResult = ErrorResult(
//             errorMessage: 'Error when image downloaded !',
//             errorImage: 'assets/images/error.png');
//         userControllerCreatePostStates =
//             UserControllerCreatePostStates.ErrorState;
//         notifyListeners();
//       });
//     } catch (uploadException) {
//       _errorResult = ErrorResult(
//           errorMessage: 'Error when image uploaded !',
//           errorImage: 'assets/images/error.png');
//       userControllerCreatePostStates =
//           UserControllerCreatePostStates.ErrorState;
//     }
//     notifyListeners();
//   }
//
//   Future<void> createNewPost(
//       {@required String postText,
//       @required String datetime,
//       String postImage}) async {
//     userControllerCreatePostStates =
//         UserControllerCreatePostStates.LoadingState;
//     notifyListeners();
//     PostModel _postModel = PostModel(
//         uid: _userProfileData.uid,
//         uName: _userProfileData.name,
//         uImage: _userProfileData.profileImageUrl,
//         datetime: datetime,
//         postText: postText,
//         postImage: postImage ?? '');
//     try {
//       await FirebaseHelper.firestoreHelper
//           .collection(postsCollection)
//           .add(_postModel.toJson());
//       userControllerCreatePostStates =
//           UserControllerCreatePostStates.SuccessState;
//     } catch (createPostException) {
//       _errorResult = ErrorResult(
//           errorMessage: 'Oops error occurred when create a post !',
//           errorImage: 'assets/images/error.png');
//       userControllerCreatePostStates =
//           UserControllerCreatePostStates.ErrorState;
//     }
//     notifyListeners();
//   }
//
//   Future<void> getPosts() async {
//     userControllerGetPostsStates = UserControllerGetPostsStates.LoadingState;
//     await FirebaseHelper.firestoreHelper
//         .collection(postsCollection)
//         .get()
//         .then((value) {
//       for (var item in value.docs) {
//         posts.add(PostModel.fromJson(item.data()));
//       }
//       userControllerGetPostsStates = UserControllerGetPostsStates.LoadedState;
//       notifyListeners();
//     }).catchError((error) {
//       ErrorResult(
//         errorMessage: 'Something went wrong !',
//         errorImage: 'assets/images/error.png',
//       );
//       userControllerGetPostsStates = UserControllerGetPostsStates.ErrorState;
//       notifyListeners();
//     });
//     notifyListeners();
//   }
//
//   /// TODO ANY THING HERE
//
//   File get profileImage => _profileImage;
//   File _profileImage;
//
//   File get coverImage => _coverImage;
//   File _coverImage;
//
//   UserControllerPickProfileImagesStates userControllerPickProfileImagesStates;
//
//   Future<void> pickProfileImage() async {
//     var _pickedFile = await ImagePickerHelper.picker.pickImage(
//       source: ImageSource.gallery,
//       imageQuality: 80,
//       maxHeight: 120.0,
//       maxWidth: 120.0,
//     );
//     if (_pickedFile != null) {
//       _profileImage = File(_pickedFile.path);
//       userControllerPickProfileImagesStates =
//           UserControllerPickProfileImagesStates.ProfileImagePickedSuccessState;
//     } else {
//       _errorResult = ErrorResult(
//           errorMessage: 'An error occurred while taking the photo !',
//           errorImage: 'assets/images/error.png');
//       userControllerPickProfileImagesStates =
//           UserControllerPickProfileImagesStates.ProfileImagePickedErrorState;
//     }
//     notifyListeners();
//   }
//
//   Future<void> pickCoverImage() async {
//     var _pickedFile = await ImagePickerHelper.picker.pickImage(
//       source: ImageSource.gallery,
//       imageQuality: 90,
//     );
//     if (_pickedFile != null) {
//       _coverImage = File(_pickedFile.path);
//       userControllerPickProfileImagesStates =
//           UserControllerPickProfileImagesStates.CoverImagePickedSuccessState;
//     } else {
//       _errorResult = ErrorResult(
//           errorMessage: 'An error occurred while taking the photo !',
//           errorImage: 'assets/images/error.png');
//       userControllerPickProfileImagesStates =
//           UserControllerPickProfileImagesStates.CoverImagePickedErrorState;
//     }
//     notifyListeners();
//   }
//
//   UserControllerUploadImageStates userControllerUploadImageStates;
//
//   Future<void> uploadProfileImage({
//     @required String name,
//     @required String phone,
//     @required String bio,
//   }) async {
//     userControllerUploadImageStates =
//         UserControllerUploadImageStates.UploadProfileImageLoadingState;
//     notifyListeners();
//     try {
//       final reference = FirebaseHelper.storageHelper
//           .ref()
//           .child('users/${Uri.file(_profileImage.path).pathSegments.last}');
//       await reference.putFile(_profileImage);
//       await reference.getDownloadURL().then((value) async {
//         await updateData(
//           name: name,
//           phone: phone,
//           bio: bio,
//           newProfileImageUrl: value,
//         );
//         userControllerUploadImageStates =
//             UserControllerUploadImageStates.UploadProfileImageSuccessState;
//         notifyListeners();
//       }).catchError((downloadException) {
//         _errorResult = ErrorResult(
//             errorMessage: 'Error when image downloaded !',
//             errorImage: 'assets/images/error.png');
//         userControllerUploadImageStates =
//             UserControllerUploadImageStates.UploadProfileImageErrorState;
//         notifyListeners();
//       });
//     } catch (uploadException) {
//       _errorResult = ErrorResult(
//           errorMessage: 'Error when image uploaded !',
//           errorImage: 'assets/images/error.png');
//       userControllerUploadImageStates =
//           UserControllerUploadImageStates.UploadProfileImageErrorState;
//       notifyListeners();
//     }
//     _profileImage = null;
//     notifyListeners();
//   }
//
//   Future<void> uploadCoverImage({
//     @required String name,
//     @required String phone,
//     @required String bio,
//   }) async {
//     userControllerUploadImageStates =
//         UserControllerUploadImageStates.UploadCoverImageLoadingState;
//     notifyListeners();
//     try {
//       final reference = FirebaseHelper.storageHelper
//           .ref()
//           .child('users/${Uri.file(_coverImage.path).pathSegments.last}');
//       await reference.putFile(_coverImage);
//       await reference.getDownloadURL().then((value) async {
//         await updateData(
//           name: name,
//           phone: phone,
//           bio: bio,
//           newCoverImageUrl: value,
//         );
//         userControllerUploadImageStates =
//             UserControllerUploadImageStates.UploadCoverImageSuccessState;
//         notifyListeners();
//       }).catchError((downloadException) {
//         _errorResult = ErrorResult(
//             errorMessage: 'Error when image downloaded !',
//             errorImage: 'assets/images/error.png');
//         userControllerUploadImageStates =
//             UserControllerUploadImageStates.UploadCoverImageErrorState;
//         notifyListeners();
//       });
//     } catch (uploadException) {
//       _errorResult = ErrorResult(
//           errorMessage: 'Error when image uploaded !',
//           errorImage: 'assets/images/error.png');
//       userControllerUploadImageStates =
//           UserControllerUploadImageStates.UploadCoverImageErrorState;
//       notifyListeners();
//     }
//     _coverImage = null;
//     notifyListeners();
//   }
//
//   UserControllerUpdateDataStates userControllerUpdateDataStates =
//       UserControllerUpdateDataStates.InitialState;
//
//   Future<void> updateData(
//       {@required String name,
//       @required String phone,
//       @required String bio,
//       String newCoverImageUrl,
//       String newProfileImageUrl}) async {
//     userControllerUpdateDataStates =
//         UserControllerUpdateDataStates.LoadingState;
//     notifyListeners();
//     UserModel userModel = UserModel(
//       uid: _userProfileData.uid,
//       email: _userProfileData.email,
//       name: name,
//       phone: phone,
//       bio: bio,
//       profileImageUrl: newProfileImageUrl ?? _userProfileData.profileImageUrl,
//       coverImageUrl: newCoverImageUrl ?? _userProfileData.coverImageUrl,
//     );
//     // UserModel userModel = UserModel(
//     //   uid: uid,
//     //   email: email,
//     //   name: name,
//     //   phone: phone,
//     //   bio: bio,
//     //   profileImageUrl: newProfileImageUrl ?? profileImageUrl,
//     //   coverImageUrl: newCoverImageUrl ?? coverImageUrl,
//     // );
//     await FirebaseHelper.firestoreHelper
//         .collection(usersCollection)
//         .doc(_currentUid)
//         .update(userModel.toJson())
//         .then((value) {
//       getUserProfileData();
//       userControllerUpdateDataStates =
//           UserControllerUpdateDataStates.LoadedState;
//     }).catchError((error) {
//       _errorResult = ErrorResult(
//           errorMessage: 'Something went wrong !',
//           errorImage: 'assets/images/error.png');
//       userControllerUpdateDataStates =
//           UserControllerUpdateDataStates.ErrorState;
//       notifyListeners();
//     });
//   }
//
// // updateProfileData({
// //   @required String name,
// //   @required String phone,
// //   @required String bio,
// // }) async {
// //   if (_profileImage != null && _coverImage != null) {
// //     uploadProfileImage(
// //       name: name,
// //       phone: phone,
// //       bio: bio,
// //     );
// //     uploadCoverImage(
// //       name: name,
// //       phone: phone,
// //       bio: bio,
// //     );
// //   } else if (_profileImage != null) {
// //     uploadProfileImage(
// //       name: name,
// //       phone: phone,
// //       bio: bio,
// //     );
// //   } else if (_coverImage != null) {
// //     uploadCoverImage(
// //       name: name,
// //       phone: phone,
// //       bio: bio,
// //     );
// //   } else {
// //     updateData(
// //       name: name,
// //       phone: phone,
// //       bio: bio,
// //     );
// //   }
// // }
//
//   ///TODO ANY THING HEREs
//
// }
