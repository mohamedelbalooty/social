import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:social_app/constants/colors_constants.dart';
import 'package:social_app/controller/new_post_controller.dart';
import 'package:social_app/controller/user_profile_controller.dart';
import 'package:social_app/icon_broken.dart';
import 'package:social_app/model/user_model.dart';
import 'package:social_app/states/new_post_controller_states.dart';
import 'package:social_app/states/user_profile_controller_states.dart';
import '../app_components.dart';

class NewPostView extends StatefulWidget {
  static const String id = 'NewPostView';

  @override
  _NewPostViewState createState() => _NewPostViewState();
}

class _NewPostViewState extends State<NewPostView> {
  final TextEditingController _postController = TextEditingController();

  @override
  void dispose() {
    _postController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final UserProfileController _userProfileController =
        Provider.of<UserProfileController>(context, listen: false);
    final UserModel _userProfileData =
        context.select<UserProfileController, UserModel>(
            (value) => value.userProfileData);
    if (_userProfileController.userProfileControllerGetUserProfileDataStates ==
        UserProfileControllerGetUserProfileDataStates.LoadedState) {
      return Consumer<NewPostController>(
        builder: (context, provider, child) {
          return Scaffold(
            appBar: buildDefaultAppBar(
              title: 'Create Post',
              leading: BuildDefaultIconButton(
                icon: const Icon(IconBroken.Arrow___Left),
                onClick: () {
                  provider.removePickedImage();
                  Navigator.pop(context);
                },
              ),
              actions: [
                BuildDefaultTextButton(
                  title: 'Post'.toUpperCase(),
                  buttonColor: mainColor,
                  textSize: 14.0,
                  onClick: () {
                    if (provider.postImage != null) {
                      provider
                          .uploadPostImage(
                              uid: _userProfileData.uid,
                              uName: _userProfileData.name,
                              uImage: _userProfileData.profileImageUrl,
                              postText: _postController.text,
                              datetime: DateTime.now().toString())
                          .then(
                            (value) =>
                                ScaffoldMessenger.of(context).showSnackBar(
                              buildDefaultSnackBar(
                                context,
                                key: UniqueKey(),
                                contentText: 'Post created.',
                              ),
                            ),
                          );
                      if (provider.newPostControllerCreatePostStates ==
                          NewPostControllerCreatePostStates.ErrorState) {
                        ScaffoldMessenger.of(context)
                            .showSnackBar(buildDefaultSnackBar(
                          context,
                          key: UniqueKey(),
                          contentText: provider.errorResult.errorMessage,
                        ));
                      }
                    } else if (_postController.text != '') {
                      provider
                          .createNewPost(
                              uid: _userProfileData.uid,
                              uName: _userProfileData.name,
                              uImage: _userProfileData.profileImageUrl,
                              postText: _postController.text,
                              datetime: DateTime.now().toString())
                          .then((value) =>
                              ScaffoldMessenger.of(context).showSnackBar(
                                buildDefaultSnackBar(
                                  context,
                                  key: UniqueKey(),
                                  contentText: 'Post created.',
                                ),
                              ));
                      if (provider.newPostControllerCreatePostStates ==
                          NewPostControllerCreatePostStates.ErrorState) {
                        ScaffoldMessenger.of(context)
                            .showSnackBar(buildDefaultSnackBar(
                          context,
                          key: UniqueKey(),
                          contentText: provider.errorResult.errorMessage,
                        ));
                      }
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        buildDefaultSnackBar(
                          context,
                          key: UniqueKey(),
                          contentText: 'No post created yet !',
                        ),
                      );
                    }
                  },
                ),
              ],
            ),
            body: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: Column(
                children: [
                  if (provider.newPostControllerCreatePostStates ==
                      NewPostControllerCreatePostStates.LoadingState)
                    buildLinearLoadingWidget(),
                  if (provider.newPostControllerCreatePostStates ==
                      NewPostControllerCreatePostStates.LoadingState)
                    minimumVerticalDistance(),
                  Row(
                    children: [
                      BuildUserCircleImage(
                        image: NetworkImage(_userProfileData.profileImageUrl),
                        imageRadius: 20.0,
                      ),
                      const SizedBox(
                        width: 15.0,
                      ),
                      Expanded(
                        child: Text(
                          _userProfileData.name,
                          style: TextStyle(
                            height: 1.4,
                          ),
                        ),
                      ),
                    ],
                  ),
                  minimumVerticalDistance(),
                  BuildDefaultUnderlineBorderTextFormField(
                    key: UniqueKey(),
                    controller: _postController,
                    hint: 'What\'s on your mind...',
                  ),
                  minimumVerticalDistance(),
                  if (provider.postImage != null)
                    Stack(
                      alignment: AlignmentDirectional.topEnd,
                      children: [
                        Container(
                          height: 130.0,
                          width: double.infinity,
                          decoration: BoxDecoration(
                            borderRadius: const BorderRadius.all(
                              Radius.circular(8.0),
                            ),
                            image: DecorationImage(
                              image: FileImage(provider.postImage),
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                        BuildDefaultCircleIconButton(
                          icon: Icons.close,
                          onClick: () {
                            provider.removePickedImage();
                          },
                        ),
                      ],
                    ),
                  const Spacer(),
                  Row(
                    children: [
                      Expanded(
                        child: TextButton(
                          style: ButtonStyle(
                            overlayColor: MaterialStateColor.resolveWith(
                                (states) => mainColor.withOpacity(0.1)),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                IconBroken.Image,
                                color: mainColor,
                                size: 20.0,
                              ),
                              minimumHorizontalDistance(),
                              Text(
                                'add photo',
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyText1
                                    .copyWith(color: mainColor),
                              ),
                            ],
                          ),
                          onPressed: () async {
                            await provider.pickPostImage();
                            if (provider.newPostControllerPickPostImageStates ==
                                NewPostControllerPickPostImageStates
                                    .PostImagePickedErrorState) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                buildDefaultSnackBar(
                                  context,
                                  key: UniqueKey(),
                                  contentText:
                                      provider.errorResult.errorMessage,
                                ),
                              );
                            }
                          },
                        ),
                      ),
                      Expanded(
                        child: BuildDefaultTextButton(
                          title: '# tags',
                          buttonColor: mainColor,
                          onClick: () {},
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          );
        },
      );
    } else {
      return Material(
        child: BuildErrorResultWidget(
          errorImage: _userProfileController.errorResult.errorImage,
          errorMessage: _userProfileController.errorResult.errorMessage,
        ),
      );
    }
  }
}
