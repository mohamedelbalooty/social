import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:social_app/constants/colors_constants.dart';
import 'package:social_app/controller/user_profile_controller.dart';
import 'package:social_app/icon_broken.dart';
import 'package:social_app/model/user_model.dart';
import 'package:social_app/states/user_profile_controller_states.dart';
import 'package:social_app/view/edit_profile_view/edit_profile_view.dart';
import '../app_components.dart';
import 'settings_view_components.dart';

class SettingsView extends StatelessWidget {
  static const String id = 'SettingsView';

  @override
  Widget build(BuildContext context) {
    final UserProfileController _userProfileController =
        Provider.of<UserProfileController>(context, listen: false);
    final UserModel _userProfileData =
        context.select<UserProfileController, UserModel>(
            (value) => value.userProfileData);
    if (_userProfileController.userProfileControllerGetUserProfileDataStates ==
        UserProfileControllerGetUserProfileDataStates.LoadedState) {
      return SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          child: Column(
            children: [
              BuildProfileCoverImages(
                coverImage: _userProfileData.coverImageUrl,
                profileImage: NetworkImage(_userProfileData.profileImageUrl),
              ),
              minimumVerticalDistance(),
              Text(
                _userProfileData.name,
                style: Theme.of(context).textTheme.bodyText1,
              ),
              Text(
                _userProfileData.bio,
                textAlign: TextAlign.center,
                style:
                    Theme.of(context).textTheme.caption.copyWith(height: 1.4),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 15.0, bottom: 5.0),
                child: Row(
                  children: [
                    ProfileDetailsButton(
                      details: '100',
                      title: 'Posts',
                      onClick: () {},
                    ),
                    ProfileDetailsButton(
                      details: '125',
                      title: 'Photos',
                      onClick: () {},
                    ),
                    ProfileDetailsButton(
                      details: '200',
                      title: 'Followers',
                      onClick: () {},
                    ),
                    ProfileDetailsButton(
                      details: '1000',
                      title: 'Followings',
                      onClick: () {},
                    ),
                  ],
                ),
              ),
              Row(
                children: [
                  Expanded(
                    child: BuildDefaultOutlinedButton(
                      height: 35.0,
                      buttonWidget: Text(
                        'Add Photos',
                        style: TextStyle(color: mainColor),
                      ),
                      onClick: () {},
                    ),
                  ),
                  const SizedBox(
                    width: 10.0,
                  ),
                  BuildDefaultOutlinedButton(
                    height: 35.0,
                    width: 70.0,
                    buttonWidget: Icon(IconBroken.Edit,
                        color: _userProfileController
                                    .userProfileControllerGetUserProfileDataStates ==
                                UserProfileControllerGetUserProfileDataStates
                                    .ErrorState
                            ? greyColor
                            : mainColor),
                    onClick: _userProfileController
                                .userProfileControllerGetUserProfileDataStates ==
                            UserProfileControllerGetUserProfileDataStates
                                .ErrorState
                        ? () {}
                        : () {
                            namedNavigateTo(context, EditProfileView.id,
                                arguments: _userProfileData);
                          },
                  ),
                ],
              ),
            ],
          ),
        ),
      );
    } else {
      return BuildErrorResultWidget(
        errorImage: _userProfileController.errorResult.errorImage,
        errorMessage: _userProfileController.errorResult.errorMessage,
      );
    }
    // return Consumer<UserController>(
    //   builder: (context, provider, child) {
    //     if (provider.userControllerGetUserProfileDataStates ==
    //         UserControllerGetUserProfileDataStates.InitialState) {
    //       provider.getUserProfileData();
    //       return Material(child: buildCircularLoadingWidget());
    //     } else if (provider.userControllerGetUserProfileDataStates ==
    //         UserControllerGetUserProfileDataStates.LoadingState) {
    //       return Material(child: buildCircularLoadingWidget());
    //     } else if (provider.userControllerGetUserProfileDataStates ==
    //         UserControllerGetUserProfileDataStates.LoadedState) {
    //       return SingleChildScrollView(
    //         child: Padding(
    //           padding: const EdgeInsets.symmetric(horizontal: 8.0),
    //           child: Column(
    //             children: [
    //               BuildProfileCoverImages(
    //                 coverImage: provider.currentUserProfileData.coverImageUrl,
    //                 profileImage: NetworkImage(
    //                     provider.currentUserProfileData.profileImageUrl),
    //               ),
    //               minimumVerticalDistance(),
    //               Text(
    //                 provider.currentUserProfileData.name,
    //                 style: Theme.of(context).textTheme.bodyText1,
    //               ),
    //               Text(
    //                 provider.currentUserProfileData.bio,
    //                 textAlign: TextAlign.center,
    //                 style: Theme.of(context)
    //                     .textTheme
    //                     .caption
    //                     .copyWith(height: 1.4),
    //               ),
    //               Padding(
    //                 padding: const EdgeInsets.only(top: 15.0, bottom: 5.0),
    //                 child: Row(
    //                   children: [
    //                     ProfileDetailsButton(
    //                       details: '100',
    //                       title: 'Posts',
    //                       onClick: () {},
    //                     ),
    //                     ProfileDetailsButton(
    //                       details: '125',
    //                       title: 'Photos',
    //                       onClick: () {},
    //                     ),
    //                     ProfileDetailsButton(
    //                       details: '200',
    //                       title: 'Followers',
    //                       onClick: () {},
    //                     ),
    //                     ProfileDetailsButton(
    //                       details: '1000',
    //                       title: 'Followings',
    //                       onClick: () {},
    //                     ),
    //                   ],
    //                 ),
    //               ),
    //               Row(
    //                 children: [
    //                   Expanded(
    //                     child: BuildDefaultOutlinedButton(
    //                       height: 35.0,
    //                       buttonWidget: Text(
    //                         'Add Photos',
    //                         style: TextStyle(color: mainColor),
    //                       ),
    //                       onClick: () {},
    //                     ),
    //                   ),
    //                   const SizedBox(
    //                     width: 10.0,
    //                   ),
    //                   BuildDefaultOutlinedButton(
    //                     height: 35.0,
    //                     width: 70.0,
    //                     buttonWidget: Icon(IconBroken.Edit,
    //                         color:
    //                             provider.userControllerGetUserProfileDataStates ==
    //                                     UserControllerGetUserProfileDataStates
    //                                         .ErrorState
    //                                 ? greyColor
    //                                 : mainColor),
    //                     onClick: provider
    //                                 .userControllerGetUserProfileDataStates ==
    //                             UserControllerGetUserProfileDataStates
    //                                 .ErrorState
    //                         ? () {}
    //                         : () {
    //                             namedNavigateTo(context, EditProfileView.id,
    //                                 arguments: provider.currentUserProfileData);
    //                           },
    //                   ),
    //                 ],
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
    // );
  }
}
