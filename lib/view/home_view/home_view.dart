import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:social_app/constants/colors_constants.dart';
import 'package:social_app/controller/comments_number_controller.dart';
import 'package:social_app/controller/likes_number_controller.dart';
import 'package:social_app/controller/new_like_controller.dart';
import 'package:social_app/controller/posts_controller.dart';
import 'package:social_app/controller/user_profile_controller.dart';
import 'package:social_app/states/posts_controller_states.dart';
import 'package:social_app/states/user_profile_controller_states.dart';
import 'package:social_app/view/comments_view/comments_view.dart';
import '../app_components.dart';
import 'home_view_components.dart';

class FeedsView extends StatelessWidget {
  static const String id = 'FeedsView';

  @override
  Widget build(BuildContext context) {
    final UserProfileController _userProfileController =
        Provider.of<UserProfileController>(context, listen: false);
    final LikesNumberController _likesNumberController =
        Provider.of<LikesNumberController>(context);
    final CommentsNumberController _commentsNumberController =
        Provider.of<CommentsNumberController>(context);
    final NewLikeProvider _newLikeProvider =
        Provider.of<NewLikeProvider>(context, listen: false);
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
                  physics: const NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  itemCount: provider.posts.length,
                  itemBuilder: (_, index) {
                    return BuildPostItem(
                      postDocId: provider.postsId[index],
                      uImage: _userProfileController
                          .userProfileData.profileImageUrl,
                      post: provider.posts[index],
                      likesStream: _likesNumberController.getLikesNumber(
                          postDocId: provider.postsId[index]),
                      commentStream:
                          _commentsNumberController.getCommentsNumber(
                              postDocId: provider.postsId[index]),
                      likeButtonStream: _newLikeProvider.likeButtonStream(
                          postDocId: provider.postsId[index]),
                      addLike: () async {
                        await _newLikeProvider.addLikes(
                            true, provider.postsId[index],
                            uName: _userProfileController.userProfileData.name,
                            uImage: _userProfileController
                                .userProfileData.profileImageUrl,
                            isLiked: true);
                      },
                      deleteLike: () async {
                        await _newLikeProvider.addLikes(
                            false, provider.postsId[index],
                            uName: _userProfileController.userProfileData.name,
                            uImage: _userProfileController
                                .userProfileData.profileImageUrl,
                            isLiked: true);
                      },
                      commentOnPost: () {
                        materialNavigateTo(
                          context,
                          CommentsView(
                            postDocId: provider.postsId[index],
                          ),
                        );
                      },
                    );
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
}
