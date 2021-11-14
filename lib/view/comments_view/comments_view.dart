import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:conditional_builder/conditional_builder.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:social_app/constants/colors_constants.dart';
import 'package:social_app/controller/comments_controller.dart';
import 'package:social_app/controller/likes_number_controller.dart';
import 'package:social_app/controller/user_profile_controller.dart';
import 'package:social_app/model/user_model.dart';
import 'package:social_app/controller/new_comment_controller.dart';
import 'package:social_app/states/comments_controller_stats.dart';
import 'package:social_app/states/new_comment_controller_states.dart';
import '../app_components.dart';
import '../likes_view/likes_view.dart';
import 'comments_view_components.dart';

class CommentsView extends StatefulWidget {
  final String postDocId;

  const CommentsView({@required this.postDocId});

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
    final UserModel _userProfileData =
        context.select<UserProfileController, UserModel>(
            (value) => value.userProfileData);
    final LikesNumberController _likesNumberController =
        Provider.of<LikesNumberController>(context);
    return Scaffold(
      body: Builder(
        builder: (context) {
          Provider.of<CommentsController>(context, listen: false)
              .getComments(postDocId: widget.postDocId);
          return SafeArea(
            child: Container(
              height: double.infinity,
              width: double.infinity,
              color: whiteColor,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10.0),
                child: Consumer<NewCommentController>(
                  builder: (context, newCommentControllerProvider, child) {
                    return Stack(
                      alignment: Alignment.bottomCenter,
                      children: [
                        Column(
                          children: [
                            BuildLikesNumberWidget(
                              likesStream: _likesNumberController
                                  .getLikesNumber(postDocId: widget.postDocId),
                              onClickedToViewLikes: () {
                                materialNavigateTo(
                                    context,
                                    LikesView(
                                      postDocId: widget.postDocId,
                                    ));
                              },
                            ),
                            Consumer<CommentsController>(
                              builder:
                                  (context, commentsControllerProvider, child) {
                                if (commentsControllerProvider
                                        .commentsControllerStates ==
                                    CommentsControllerStates
                                        .CommentsControllerGetCommentsErrorState) {
                                  return Expanded(
                                    child: SingleChildScrollView(
                                      child: Column(
                                        children: [
                                          SizedBox(
                                            height: MediaQuery.of(context)
                                                    .size
                                                    .height *
                                                0.2,
                                          ),
                                          BuildEmptyListWidget(
                                            title: commentsControllerProvider
                                                .errorResult.errorMessage,
                                          ),
                                        ],
                                      ),
                                    ),
                                  );
                                } else {
                                  return ConditionalBuilder(
                                    condition: commentsControllerProvider
                                            .comments.length >
                                        0,
                                    builder: (context) => Expanded(
                                      child: ListView.separated(
                                        itemCount: commentsControllerProvider
                                            .comments.length,
                                        itemBuilder: (_, index) {
                                          return Padding(
                                            padding: index == 0
                                                ? const EdgeInsets.only(
                                                    top: 5.0)
                                                : EdgeInsets.zero,
                                            child: BuildCommentItem(
                                              uName: commentsControllerProvider
                                                  .comments[index].uName,
                                              uImage: commentsControllerProvider
                                                  .comments[index].uImage,
                                              commentText:
                                                  commentsControllerProvider
                                                      .comments[index]
                                                      .commentText,
                                              date: '12/11/2021',
                                              commentImage:
                                                  commentsControllerProvider
                                                      .comments[index]
                                                      .commentImage,
                                            ),
                                          );
                                        },
                                        separatorBuilder: (_, index) =>
                                            minimumVerticalDistance(),
                                      ),
                                    ),
                                    fallback: (_) => Expanded(
                                      child: SingleChildScrollView(
                                        child: Column(
                                          children: [
                                            SizedBox(
                                              height: MediaQuery.of(context)
                                                      .size
                                                      .height *
                                                  0.2,
                                            ),
                                            BuildEmptyListWidget(
                                              title:
                                                  'No comments available yet.',
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  );
                                }
                              },
                            ),
                            Expanded(
                              flex: 0,
                              child: BuildWriteContentWidget(
                                contentController: _commentController,
                                contentImage:
                                    newCommentControllerProvider.commentImage,
                                pickContentImage: () async {
                                  await newCommentControllerProvider
                                      .pickCommentImage();
                                  if (newCommentControllerProvider
                                          .newCommentControllerPickCommentImage ==
                                      NewCommentControllerPickCommentImage
                                          .CommentImagePickedErrorState) {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      buildDefaultSnackBar(
                                        context,
                                        key: UniqueKey(),
                                        contentText:
                                            newCommentControllerProvider
                                                .errorMessage,
                                      ),
                                    );
                                  }
                                },
                                sendContent: () {
                                  if (newCommentControllerProvider
                                          .commentImage !=
                                      null) {
                                    newCommentControllerProvider
                                        .uploadCommentImage(
                                            postDocId: widget.postDocId,
                                            uName: _userProfileData.name,
                                            uImage: _userProfileData
                                                .profileImageUrl,
                                            commentText:
                                                _commentController.text,
                                            commentDateTime:
                                                DateTime.now().toString(),
                                            commentTime: Timestamp.now());
                                    if (newCommentControllerProvider
                                            .newCommentControllerCreateComment ==
                                        NewCommentControllerCreateComment
                                            .ErrorState) {
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(
                                        buildDefaultSnackBar(
                                          context,
                                          key: UniqueKey(),
                                          contentText:
                                              newCommentControllerProvider
                                                  .errorMessage,
                                        ),
                                      );
                                    }
                                  } else {
                                    newCommentControllerProvider
                                        .createCommentOnPost(
                                      postDocId: widget.postDocId,
                                      uName: _userProfileData.name,
                                      uImage: _userProfileData.profileImageUrl,
                                      commentText: _commentController.text,
                                      commentDateTime:
                                          DateTime.now().toString(),
                                      commentTime: Timestamp.now(),
                                    );
                                    if (newCommentControllerProvider
                                            .newCommentControllerCreateComment ==
                                        NewCommentControllerCreateComment
                                            .ErrorState) {
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(
                                        buildDefaultSnackBar(
                                          context,
                                          key: UniqueKey(),
                                          contentText:
                                              newCommentControllerProvider
                                                  .errorMessage,
                                        ),
                                      );
                                    }
                                  }
                                  _commentController.clear();
                                },
                              ),
                            ),
                          ],
                        ),
                        if (newCommentControllerProvider.commentImage != null)
                          Container(
                            width: MediaQuery.of(context).size.width,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.end,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Stack(
                                  alignment: AlignmentDirectional.topEnd,
                                  children: [
                                    ClipRRect(
                                      borderRadius: const BorderRadius.all(
                                        Radius.circular(8.0),
                                      ),
                                      child: Image.file(
                                        newCommentControllerProvider
                                            .commentImage,
                                        height: 120.0,
                                        width: 130.0,
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                    BuildDefaultCircleIconButton(
                                      icon: Icons.close,
                                      onClick: () {
                                        newCommentControllerProvider
                                            .removePickedImage();
                                      },
                                    ),
                                  ],
                                ),
                                if (newCommentControllerProvider
                                        .newCommentControllerCreateComment ==
                                    NewCommentControllerCreateComment
                                        .LoadingState)
                                  const SizedBox(
                                    height: 2,
                                  ),
                                if (newCommentControllerProvider
                                        .newCommentControllerCreateComment ==
                                    NewCommentControllerCreateComment
                                        .LoadingState)
                                  buildLinearLoadingWidget(),
                                const SizedBox(
                                  height: 51.0,
                                ),
                              ],
                            ),
                          ),
                      ],
                    );
                  },
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
