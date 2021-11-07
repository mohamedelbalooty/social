import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:social_app/constants/colors_constants.dart';
import 'package:social_app/constants/firestore_constants.dart';
import 'package:social_app/controller/user_profile_controller.dart';
import 'package:social_app/helper/firebase_helper.dart';
import 'package:social_app/model/comment_model.dart';
import 'package:social_app/model/user_model.dart';
import 'package:social_app/controller/comment_controller.dart';
import 'package:social_app/states/comment_controller_states.dart';
import 'package:social_app/view/feeds_view/feeds_view_components.dart';
import '../app_components.dart';

class CommentsView extends StatefulWidget {
  static const String id = 'CommentsView';

  @override
  _CommentsViewState createState() => _CommentsViewState();
}

class _CommentsViewState extends State<CommentsView> {
  final TextEditingController _commentController = TextEditingController();

  @override
  void dispose() {
    _commentController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    print('CommentsView');
    Map<String, dynamic> receptors = ModalRoute.of(context).settings.arguments;
    final UserModel _userProfileData =
        context.select<UserProfileController, UserModel>(
            (value) => value.userProfileData);
    CommentController provider = Provider.of<CommentController>(context, listen: false);
    List<CommentModel> comments = [];
    return Scaffold(
      body: SafeArea(
        child: Container(
          height: MediaQuery.of(context).size.height - 23.0,
          width: double.infinity,
          color: whiteColor,
          child: Column(
            children: [
              BuildLikesNumberWidget(
                likesNumber: receptors['likesNumber'],
              ),
              // if (provider.commentControllerCreateCommentOnPost ==
              //     CommentControllerCreateCommentOnPost.LoadingState)
              //   Padding(
              //     padding: const EdgeInsets.symmetric(horizontal: 10.0),
              //     child: buildLinearLoadingWidget(),
              //   ),
              StreamBuilder<QuerySnapshot>(
                key: UniqueKey(),
                stream: FirebaseHelper.firestoreHelper
                    .collection(postsCollection)
                    .doc(receptors['postId'])
                    .collection(commentsCollection).orderBy('date', descending: true)
                    .snapshots(),
                // stream: provider.commentss(receptors['postId']),
                builder: (BuildContext context, snapshot) {
                  print('StreamBuilder');
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return buildCircularLoadingWidget();
                  }else if(snapshot.connectionState == ConnectionState.done) {
                    if(snapshot.hasData){
                      for (var doc in snapshot.data.docs) {
                        var data = doc.data();
                        comments.add(CommentModel.fromJson(data));
                      }
                      return Expanded(
                        child: Padding(
                          padding: const EdgeInsets.only(top: 5.0),
                          child: ListView.separated(
                            itemCount: comments.length,
                            itemBuilder: (_, index) {
                              return BuildCommentItem(
                                uName: comments[index].uName,
                                uImage: comments[index].uImage,
                                commentText: comments[index].commentText,
                                commentImage: comments[index].commentImage,
                                date: comments[index].date.toString(),
                              );
                            },
                            separatorBuilder: (_, index) =>
                            const SizedBox(height: 2.0),
                          ),
                        ),
                      );
                    }else{
                      return Text('error');
                    }
                  }else{
                    return Text('error22');
                  }
                },
              ),
              // Expanded(
              //   child: Padding(
              //     padding: const EdgeInsets.only(top: 5.0),
              //     child: ListView.separated(
              //       itemCount: 10,
              //       itemBuilder: (_, index) {
              //         return BuildCommentItem(
              //           uName: provider.comments[index].uName,
              //           uImage: provider.comments[index].uImage,
              //           commentText: provider.comments[index].commentText,
              //           date: provider.comments[index].date,
              //         );
              //       },
              //       separatorBuilder: (_, index) =>
              //       const SizedBox(height: 2.0),
              //     ),
              //   ),
              // ),
              const Expanded(
                child: SizedBox(),
                flex: 0,
              ),
              Consumer<CommentController>(
                builder: (context, provider, child) {
                  print('CommentController consumer');
                  return BuildWriteContentWidget(
                    contentController: _commentController,
                    pickContentImage: () async {
                      await provider.pickCommentImage();
                      if (provider.commentControllerPickCommentImage ==
                          CommentControllerPickCommentImage
                              .CommentImagePickedErrorState) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          buildDefaultSnackBar(
                            context,
                            key: UniqueKey(),
                            contentText: provider.errorMessage,
                          ),
                        );
                      }
                    },
                    sendContent: () {
                      if (provider.commentImage != null) {
                        provider.uploadCommentImage(
                            postDocId: receptors['postId'],
                            uName: _userProfileData.name,
                            uImage: _userProfileData.profileImageUrl,
                            commentText: _commentController.text,
                            date: Timestamp.now());
                        if (provider
                                .commentControllerUploadCommentImageStates ==
                            CommentControllerUploadCommentImageStates
                                .UploadCommentImageErrorState) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            buildDefaultSnackBar(
                              context,
                              key: UniqueKey(),
                              contentText: provider.errorMessage,
                            ),
                          );
                        }
                      } else {
                        provider.createCommentOnPost(
                          postDocId: receptors['postId'],
                          uName: _userProfileData.name,
                          uImage: _userProfileData.profileImageUrl,
                          commentText: _commentController.text,
                          date: Timestamp.now(),
                        );
                        if (provider.commentControllerCreateCommentOnPost ==
                            CommentControllerCreateCommentOnPost.ErrorState) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            buildDefaultSnackBar(
                              context,
                              key: UniqueKey(),
                              contentText: provider.errorMessage,
                            ),
                          );
                        }
                      }

                      ///UNFOCUS
                      // FocusScope.of(context).unfocus();
                    },
                  );
                },
              ),
            ],
          ),
        ),
      ),

      // body: Consumer<CommentController>(
      //   builder: (context, provider, child) {
      //     if (provider.commentControllerGetComments ==
      //         CommentControllerGetComments.InitialState) {
      //       provider.getComments(postDocId: receptors['postId']);
      //       return buildCircularLoadingWidget();
      //     } else if (provider.commentControllerGetComments ==
      //         CommentControllerGetComments.LoadingState) {
      //       return buildCircularLoadingWidget();
      //     } else if (provider.commentControllerGetComments ==
      //         CommentControllerGetComments.LoadedState) {
      //       return SafeArea(
      //         child: Container(
      //           height: MediaQuery.of(context).size.height - 23.0,
      //           width: double.infinity,
      //           color: whiteColor,
      //           child: Column(
      //             children: [
      //               BuildLikesNumberWidget(
      //                 likesNumber: receptors['likesNumber'],
      //               ),
      //               if (provider.commentControllerCreateCommentOnPost ==
      //                   CommentControllerCreateCommentOnPost.LoadingState)
      //                 Padding(
      //                   padding: const EdgeInsets.symmetric(horizontal: 10.0),
      //                   child: buildLinearLoadingWidget(),
      //                 ),
      //               Expanded(
      //                 child: Padding(
      //                   padding: const EdgeInsets.only(top: 5.0),
      //                   child: ListView.separated(
      //                     itemCount: 10,
      //                     itemBuilder: (_, index) {
      //                       return BuildCommentItem(
      //                         uName: provider.comments[index].uName,
      //                         uImage: provider.comments[index].uImage,
      //                         commentText: provider.comments[index].commentText,
      //                         date: provider.comments[index].date,
      //                       );
      //                     },
      //                     separatorBuilder: (_, index) =>
      //                         const SizedBox(height: 2.0),
      //                   ),
      //                 ),
      //               ),
      //               const Expanded(
      //                 child: SizedBox(),
      //                 flex: 0,
      //               ),
      //               BuildWriteContentWidget(
      //                 contentController: _commentController,
      //                 pickContentImage: () async {
      //                   await provider.pickCommentImage();
      //                   if (provider.commentControllerPickCommentImage ==
      //                       CommentControllerPickCommentImage
      //                           .CommentImagePickedErrorState) {
      //                     ScaffoldMessenger.of(context).showSnackBar(
      //                       buildDefaultSnackBar(
      //                         context,
      //                         key: UniqueKey(),
      //                         contentText: provider.errorMessage,
      //                       ),
      //                     );
      //                   }
      //                 },
      //                 sendContent: () {
      //                   if (provider.commentImage != null) {
      //                     provider.uploadCommentImage(
      //                         postDocId: receptors['postId'],
      //                         uName: _userProfileData.name,
      //                         uImage: _userProfileData.profileImageUrl,
      //                         commentText: _commentController.text,
      //                         date: DateTime.now().toString());
      //                     if (provider
      //                             .commentControllerUploadCommentImageStates ==
      //                         CommentControllerUploadCommentImageStates
      //                             .UploadCommentImageErrorState) {
      //                       ScaffoldMessenger.of(context).showSnackBar(
      //                         buildDefaultSnackBar(
      //                           context,
      //                           key: UniqueKey(),
      //                           contentText: provider.errorMessage,
      //                         ),
      //                       );
      //                     }
      //                   } else {
      //                     provider.createCommentOnPost(
      //                       postDocId: receptors['postId'],
      //                       uName: _userProfileData.name,
      //                       uImage: _userProfileData.profileImageUrl,
      //                       commentText: _commentController.text,
      //                       date: DateTime.now().toString(),
      //                     );
      //                     if (provider.commentControllerCreateCommentOnPost ==
      //                         CommentControllerCreateCommentOnPost.ErrorState) {
      //                       ScaffoldMessenger.of(context).showSnackBar(
      //                         buildDefaultSnackBar(
      //                           context,
      //                           key: UniqueKey(),
      //                           contentText: provider.errorMessage,
      //                         ),
      //                       );
      //                     }
      //                   }
      //
      //                   ///UNFOCUS
      //                   FocusScope.of(context).unfocus();
      //                 },
      //               ),
      //             ],
      //           ),
      //         ),
      //       );
      //     } else {
      //       return BuildErrorResultWidget(
      //         errorImage: provider.errorResult.errorImage,
      //         errorMessage: provider.errorResult.errorMessage,
      //       );
      //     }
      //   },
      // ),
    );
  }
}
