import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:social_app/constants/colors_constants.dart';
import 'package:social_app/constants/firestore_constants.dart';
import 'package:social_app/controller/comments_controller.dart';
import 'package:social_app/controller/comments_number_controller.dart';
import 'package:social_app/controller/posts_controller.dart';
import 'package:social_app/controller/user_profile_controller.dart';
import 'package:social_app/helper/firebase_helper.dart';
import 'package:social_app/helper/user_id_helper.dart';
import 'package:social_app/model/user_model.dart';
import 'package:social_app/states/posts_controller_states.dart';
import 'package:social_app/states/user_profile_controller_states.dart';
import 'package:social_app/view/comments_view/comments_view.dart';
import '../../icon_broken.dart';
import '../app_components.dart';
import 'feeds_view_components.dart';

//TODO SOME THING WITH
// class FeedsView extends StatelessWidget {
//   static const String id = 'FeedsView';
//
//   @override
//   Widget build(BuildContext context) {
//     return Consumer<UserController>(
//       builder: (context, provider, child) {
//         if (provider.userControllerGetPostsStates ==
//             UserControllerGetPostsStates.InitialState) {
//           provider.getUserProfileData();
//           Provider.of<EditProfileController>(context).getCurrentUserProfileData();
//           provider.getPosts();
//           return buildCircularLoadingWidget();
//         } else if (provider.userControllerGetPostsStates ==
//             UserControllerGetPostsStates.LoadingState) {
//           return buildCircularLoadingWidget();
//         } else if (provider.userControllerGetPostsStates ==
//             UserControllerGetPostsStates.LoadedState) {
//           return SingleChildScrollView(
//             physics: const BouncingScrollPhysics(),
//             child: Column(
//               children: [
//                 Card(
//                   elevation: 5.0,
//                   margin: const EdgeInsets.only(
//                       top: 0.0, left: 8.0, right: 8.0, bottom: 8.0),
//                   clipBehavior: Clip.antiAliasWithSaveLayer,
//                   child: Stack(
//                     alignment: AlignmentDirectional.bottomEnd,
//                     children: [
//                       BuildCachedNetworkImage(
//                         url: testFirst,
//                       ),
//                       Padding(
//                         padding: const EdgeInsets.all(8.0),
//                         child: Text(
//                           'Communicat with friends',
//                           style: Theme.of(context)
//                               .textTheme
//                               .bodyText2
//                               .copyWith(color: whiteColor),
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//                 ListView.separated(
//                   shrinkWrap: true,
//                   physics: const NeverScrollableScrollPhysics(),
//                   itemCount: provider.posts.length,
//                   itemBuilder: (_, index) {
//                     return BuildPostItem(
//                       image: Provider.of<EditProfileController>(context).userProfileData.profileImageUrl,
//                       // currentUser: provider.currentUserProfileData,
//                       post: provider.posts[index],
//                     );
//                   },
//                   separatorBuilder: (_, index) {
//                     return const SizedBox(
//                       height: 10.0,
//                     );
//                   },
//                 ),
//               ],
//             ),
//           );
//         } else {
//           return BuildErrorResultWidget(
//             errorImage: provider.errorResult.errorImage,
//             errorMessage: provider.errorResult.errorMessage,
//           );
//         }
//       },
//     );
//   }
// }

class FeedsView extends StatelessWidget {
  static const String id = 'FeedsView';

  @override
  Widget build(BuildContext context) {
    final UserProfileController _userProfileController =
        Provider.of<UserProfileController>(context, listen: false);
    final UserModel _userProfileData =
        context.select<UserProfileController, UserModel>(
            (value) => value.userProfileData);
    return Consumer<PostsController>(
      builder: (context, provider, child) {
        if (provider.postsControllerGetPostsStates ==
            PostsControllerGetPostsStates.InitialState) {
          _userProfileController.getUserProfileData();
          provider.getPosts();
          return buildCircularLoadingWidget();
        } else if (provider.postsControllerGetPostsStates ==
            PostsControllerGetPostsStates.LoadingState) {
          return buildCircularLoadingWidget();
        } else if (provider.postsControllerGetPostsStates ==
                PostsControllerGetPostsStates.LoadedState &&
            _userProfileController
                    .userProfileControllerGetUserProfileDataStates ==
                UserProfileControllerGetUserProfileDataStates.LoadedState) {
          return SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: Column(
              children: [
                Card(
                  elevation: 5.0,
                  margin: const EdgeInsets.only(
                      top: 0.0, left: 8.0, right: 8.0, bottom: 8.0),
                  clipBehavior: Clip.antiAliasWithSaveLayer,
                  child: Stack(
                    alignment: AlignmentDirectional.bottomEnd,
                    children: [
                      const BuildCachedNetworkImage(
                        url: testFirst,
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          'Communicat with friends',
                          style: Theme.of(context)
                              .textTheme
                              .bodyText2
                              .copyWith(color: whiteColor),
                        ),
                      ),
                    ],
                  ),
                ),
                ListView.separated(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: provider.posts.length,
                  itemBuilder: (_, index) {

                    // return Card(
                    //   elevation: 5.0,
                    //   margin: const EdgeInsets.symmetric(horizontal: 8.0),
                    //   clipBehavior: Clip.antiAliasWithSaveLayer,
                    //   child: Padding(
                    //     padding: const EdgeInsets.symmetric(
                    //         horizontal: 10.0, vertical: 5.0),
                    //     child: Column(
                    //       crossAxisAlignment: CrossAxisAlignment.start,
                    //       children: [
                    //         Row(
                    //           children: [
                    //             BuildUserCircleImage(
                    //               image: NetworkImage(
                    //                   provider.posts[index].uImage),
                    //               imageRadius: 20.0,
                    //             ),
                    //             const SizedBox(
                    //               width: 15.0,
                    //             ),
                    //             Expanded(
                    //               child: Column(
                    //                 crossAxisAlignment:
                    //                     CrossAxisAlignment.start,
                    //                 children: [
                    //                   Row(
                    //                     crossAxisAlignment:
                    //                         CrossAxisAlignment.end,
                    //                     children: [
                    //                       Text(
                    //                         provider.posts[index].uName,
                    //                         style: Theme.of(context)
                    //                             .textTheme
                    //                             .bodyText2
                    //                             .copyWith(height: 1.4),
                    //                       ),
                    //                       const SizedBox(
                    //                         width: 4.0,
                    //                       ),
                    //                       Icon(
                    //                         Icons.check_circle,
                    //                         color: Colors.blueAccent,
                    //                         size: 15.0,
                    //                       ),
                    //                     ],
                    //                   ),
                    //                   Text(
                    //                     provider.posts[index].datetime,
                    //                     style: Theme.of(context)
                    //                         .textTheme
                    //                         .caption
                    //                         .copyWith(
                    //                           height: 1.4,
                    //                         ),
                    //                   ),
                    //                 ],
                    //               ),
                    //             ),
                    //             SizedBox(),
                    //             InkWell(
                    //               child: const Icon(
                    //                 IconBroken.More_Circle,
                    //                 size: 22.0,
                    //                 color: Colors.grey,
                    //               ),
                    //               onTap: () {},
                    //             ),
                    //           ],
                    //         ),
                    //         buildDefaultDivider(height: 20.0),
                    //         Text(
                    //           provider.posts[index].postText,
                    //           style: Theme.of(context).textTheme.subtitle1,
                    //           textAlign: TextAlign.justify,
                    //         ),
                    //         minimumVerticalDistance(),
                    //         if (provider.posts[index].postImage != '')
                    //           ClipRRect(
                    //             borderRadius: const BorderRadius.all(
                    //               Radius.circular(4.0),
                    //             ),
                    //             child: BuildCachedNetworkImage(
                    //               url: provider.posts[index].postImage,
                    //               height: 150.0,
                    //             ),
                    //           ),
                    //         if (provider.posts[index].postImage != '')
                    //           minimumVerticalDistance(),
                    //         Row(
                    //           mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    //           children: [
                    //             Row(
                    //               children: [
                    //                 const Icon(
                    //                   IconBroken.Heart,
                    //                   color: Colors.red,
                    //                   size: 18.0,
                    //                 ),
                    //                 minimumHorizontalDistance(),
                    //                 Text(
                    //                   '5',
                    //                   style:
                    //                       Theme.of(context).textTheme.caption,
                    //                 ),
                    //               ],
                    //             ),
                    //             Row(
                    //               children: [
                    //                 const Icon(
                    //                   IconBroken.Chat,
                    //                   size: 18.0,
                    //                   color: Colors.amber,
                    //                 ),
                    //                 minimumHorizontalDistance(),
                    //                 Builder(
                    //                   builder: (context) {
                    //                     Provider.of<CommentsController>(context, listen: false).getComments(postDocId: provider.postsId[index]);
                    //                     return Consumer<CommentsController>(
                    //                       builder: (context, provider, child) {
                    //                         return Text(
                    //                           provider.comments.length.toString(),
                    //                           style: Theme.of(context)
                    //                               .textTheme
                    //                               .caption,
                    //                         );
                    //                       },
                    //                     );
                    //                   },
                    //                 ),
                    //               ],
                    //             ),
                    //           ],
                    //         ),
                    //         buildDefaultDivider(height: 15.0),
                    //         minimumVerticalDistance(),
                    //         Row(
                    //           crossAxisAlignment: CrossAxisAlignment.center,
                    //           children: [
                    //             BuildUserCircleImage(
                    //               image: NetworkImage(
                    //                   _userProfileData.profileImageUrl ??
                    //                       errorImage),
                    //               imageRadius: 15.0,
                    //             ),
                    //             minimumHorizontalDistance(),
                    //             InkWell(
                    //               child: Text(
                    //                 'write a comment....',
                    //                 style: Theme.of(context).textTheme.caption,
                    //               ),
                    //               onTap: () {
                    //                 namedNavigateTo(context, CommentsView.id,
                    //                     arguments: {
                    //                       // 'likesNumber': provider.likes[index],
                    //                       'likesNumber': 5,
                    //                       'postId': provider.postsId[index],
                    //                     });
                    //               },
                    //             ),
                    //             const Expanded(child: SizedBox()),
                    //             BuildReactButton(
                    //               icon: IconBroken.Heart,
                    //               iconColor: Colors.red,
                    //               onClick: () {},
                    //             ),
                    //             minimumHorizontalDistance(),
                    //             Text(
                    //               'Like',
                    //               style: Theme.of(context).textTheme.caption,
                    //             ),
                    //           ],
                    //         ),
                    //       ],
                    //     ),
                    //   ),
                    // );

                    ///
                    return BuildPostItem(
                      postDocId: provider.postsId[index],
                      image: _userProfileData.profileImageUrl,
                      post: provider.posts[index],
                      likeStream: FirebaseHelper.firestoreHelper
                          .collection(postsCollection)
                          .doc(provider.postsId[index])
                          .collection(likesCollection)
                          .snapshots(),
                      commentStream: FirebaseHelper.firestoreHelper
                        .collection(postsCollection)
                        .doc(provider.postsId[index])
                        .collection(commentsCollection)
                        .snapshots(),
                          // provider.getLikes(postDocId: provider.postsId[index]),
                      // addLike: () async {
                      //   await provider.likePost(
                      //       postDocId: provider.postsId[index]);
                      //   if (provider.postsControllerLikePostStates ==
                      //       PostsControllerLikePostStates.ErrorState) {
                      //     showToast(context, provider.errorMessage);
                      //   }
                      // },
                      addLike: (){
                        addLikes(true, provider.postsId[index]);
                      },
                      deleteLike: (){
                        addLikes(false, provider.postsId[index]);
                      },
                      commentOnPost: () {
                        namedNavigateTo(context, CommentsView.id, arguments: {
                          // 'likesNumber': provider.likes[index],
                          'likesNumber': 5,
                          'postId': provider.postsId[index],
                        });

                        ///
                        // await showModalBottomSheet(
                        //   isScrollControlled: true,
                        //   context: context,
                        //   builder: (_) {
                        //     return Container(
                        //       height:
                        //           MediaQuery.of(context).size.height - 23.0,
                        //       width: double.infinity,
                        //       color: whiteColor,
                        //       child: Column(
                        //         children: [
                        //           BuildLikesNumberWidget(
                        //             likesNumber: provider.likes[index],
                        //           ),
                        //           if(provider.postsControllerCreateCommentOnPost ==
                        //               PostsControllerCreateCommentOnPost.LoadingState)
                        //           Padding(
                        //             padding: const EdgeInsets.symmetric(horizontal: 10.0),
                        //             child: buildLinearLoadingWidget(),
                        //           ),
                        //           BuildListOfComments(
                        //             uName: 'Mohamed Gamal',
                        //             uImage: testFirst,
                        //             commentText:
                        //                 'Mohamed is fresh graduated',
                        //             date: '1/11/2021',
                        //           ),
                        //           const Expanded(
                        //             child: SizedBox(),
                        //             flex: 0,
                        //           ),
                        //           BuildCommentWidget(
                        //             commentController: _commentController,
                        //             pickCommentImage: () {
                        //               provider.pickCommentImage();
                        //               if (provider
                        //                       .postsControllerPickCommentImage ==
                        //                   PostsControllerPickCommentImage
                        //                       .CommentImagePickedErrorState) {
                        //                 ScaffoldMessenger.of(context)
                        //                     .showSnackBar(
                        //                   buildDefaultSnackBar(
                        //                     context,
                        //                     key: UniqueKey(),
                        //                     contentText:
                        //                         provider.errorMessage,
                        //                   ),
                        //                 );
                        //               }
                        //             },
                        //             commentOnPost: () {
                        //               if (provider.commentImage != null) {
                        //                 provider.uploadCommentImage(
                        //                     postDocId:
                        //                         provider.postsId[index],
                        //                     uName: _userProfileData.name,
                        //                     uImage: _userProfileData
                        //                         .profileImageUrl,
                        //                     commentText:
                        //                         _commentController.text,
                        //                     date: DateTime.now());
                        //                 if (provider
                        //                         .postsControllerUploadImageStates ==
                        //                     PostsControllerUploadImageStates
                        //                         .UploadCommentImageErrorState) {
                        //                   ScaffoldMessenger.of(context)
                        //                       .showSnackBar(
                        //                     buildDefaultSnackBar(
                        //                       context,
                        //                       key: UniqueKey(),
                        //                       contentText:
                        //                           provider.errorMessage,
                        //                     ),
                        //                   );
                        //                 }
                        //               } else {
                        //                 provider.createCommentOnPost(
                        //                   postDocId:
                        //                       provider.postsId[index],
                        //                   uName: _userProfileData.name,
                        //                   uImage: _userProfileData
                        //                       .profileImageUrl,
                        //                   commentText:
                        //                       _commentController.text,
                        //                   date: DateTime.now(),
                        //                 );
                        //                 if (provider
                        //                         .postsControllerCreateCommentOnPost ==
                        //                     PostsControllerCreateCommentOnPost
                        //                         .ErrorState) {
                        //                   ScaffoldMessenger.of(context)
                        //                       .showSnackBar(
                        //                     buildDefaultSnackBar(
                        //                       context,
                        //                       key: UniqueKey(),
                        //                       contentText:
                        //                           provider.errorMessage,
                        //                     ),
                        //                   );
                        //                 }
                        //               }
                        //             },
                        //           ),
                        //         ],
                        //       ),
                        //     );
                        //   },
                        // );
                        ///
                      },
                    );
                    ///
                  },
                  separatorBuilder: (_, index) {
                    return mediumVerticalDistance();
                  },
                ),
              ],
            ),
          );
        } else {
          return BuildErrorResultWidget(
            errorImage: provider.errorResult.errorImage,
            errorMessage: provider.errorResult.errorMessage,
          );
        }
      },
    );
  }
  void addLikes(bool liked, postDocId){
    liked = !liked;
    if(liked){
      var ref = FirebaseHelper.firestoreHelper
          .collection(postsCollection)
          .doc(postDocId)
          .collection(likesCollection)
          .doc(UserIdHelper.currentUid);
      ref.set({
        'liked': true,
      });
    }else{
      var ref = FirebaseHelper.firestoreHelper
          .collection(postsCollection)
          .doc(postDocId)
          .collection(likesCollection)
          .doc(UserIdHelper.currentUid);
      ref.delete();
    }
  }
}

// class BuildCommentsBottomSheet extends StatefulWidget {
//   final int likesNumber;
//   final String uName, uImage, commentText, date;
//   final TextEditingController commentController;
//   final Function commentOnPost;
//
//   const BuildCommentsBottomSheet(
//       {@required this.likesNumber,
//       @required this.uName,
//       @required this.uImage,
//       @required this.commentText,
//       @required this.date,
//       @required this.commentController,
//       this.commentOnPost});
//
//   @override
//   _BuildCommentsBottomSheetState createState() =>
//       _BuildCommentsBottomSheetState();
// }
//
// class _BuildCommentsBottomSheetState extends State<BuildCommentsBottomSheet> {
//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       height: MediaQuery.of(context).size.height - 23.0,
//       width: double.infinity,
//       // color: Color(0xFF2B2B2B),
//       color: whiteColor,
//       child: Column(
//         children: [
//           Container(
//             height: 40.0,
//             width: double.infinity,
//             margin: EdgeInsets.symmetric(horizontal: 10.0),
//             decoration: const BoxDecoration(
//               border: Border(
//                 bottom: BorderSide(
//                   color: greyColor,
//                   width: 1.0,
//                 ),
//               ),
//             ),
//             child: Row(
//               crossAxisAlignment: CrossAxisAlignment.center,
//               children: [
//                 Icon(
//                   IconBroken.Heart,
//                   color: mainColor,
//                   size: 20.0,
//                 ),
//                 minimumHorizontalDistance(),
//                 Text(
//                   '${widget.likesNumber}',
//                   style: Theme.of(context).textTheme.caption,
//                 ),
//                 const Expanded(child: SizedBox()),
//                 BuildReactButton(
//                   icon: Icons.arrow_forward_ios_sharp,
//                   iconColor: blackColor,
//                   onClick: () {},
//                 ),
//               ],
//             ),
//           ),
//           Expanded(
//             child: Padding(
//               padding: const EdgeInsets.only(top: 5.0),
//               child: ListView.separated(
//                 itemCount: 10,
//                 itemBuilder: (_, index) {
//                   return BuildCommentItem(
//                     uName: widget.uName,
//                     uImage: widget.uImage,
//                     date: widget.date,
//                     commentText: widget.commentText,
//                   );
//                 },
//                 separatorBuilder: (_, index) => buildCommentVerticalDistance(),
//               ),
//             ),
//           ),
//           const Expanded(
//             child: SizedBox(),
//             flex: 0,
//           ),
//           Column(
//             mainAxisAlignment: MainAxisAlignment.start,
//             children: [
//               buildCustomDivider(height: 0.0),
//               Padding(
//                 padding:
//                     const EdgeInsets.symmetric(vertical: 5.0, horizontal: 10.0),
//                 child: Row(
//                   children: [
//                     InkWell(
//                       child: Container(
//                         height: 40.0,
//                         width: 40.0,
//                         decoration: BoxDecoration(
//                           color: mainColor.withOpacity(0.4),
//                           borderRadius: const BorderRadius.all(
//                             Radius.circular(8.0),
//                           ),
//                         ),
//                         child: const Center(
//                           child: Icon(
//                             IconBroken.Image,
//                             size: 22.0,
//                             color: mainColor,
//                           ),
//                         ),
//                       ),
//                       onTap: () {},
//                     ),
//                     mediumHorizontalDistance(),
//                     Expanded(
//                       child: BuildCommentTextField(
//                         key: UniqueKey(),
//                         controller: widget.commentController,
//                         onChange: (String value) {
//                           setState(() {
//                             widget.commentController.text = value;
//                           });
//                         },
//                         icon: InkWell(
//                           onTap: widget.commentController.text == ''
//                               ? () {}
//                               : () {
//                                   print(widget.commentController.text);
//                                 },
//                           child: Icon(
//                             IconBroken.Send,
//                             size: 22.0,
//                             color: widget.commentController.text == ''
//                                 ? Colors.grey.shade600
//                                 : mainColor,
//                           ),
//                         ),
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//             ],
//           ),
//         ],
//       ),
//     );
//   }
//
//   SizedBox buildCommentVerticalDistance() => const SizedBox(
//         height: 2.0,
//       );
// }

// return BuildCommentsBottomSheet(
//   likesNumber: provider.likes[index],
//   uName: 'Mohamed Gamal',
//   uImage: testFirst,
//   commentText: 'Mohamed is fresh graduated',
//   date: '1/11/2021',
//   commentController: _commentController,
// );
