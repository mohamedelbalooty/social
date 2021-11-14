// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';
// import 'package:social_app/constants/colors_constants.dart';
// import 'package:social_app/controller/user_controller.dart';
// import 'package:social_app/controller/edit_profile_controller.dart';
// import 'package:social_app/model/user_model.dart';
// import 'package:social_app/states/edit_profile_controller_states.dart';
// import '../../icon_broken.dart';
// import '../app_components.dart';
//
// class EditProfileView extends StatefulWidget {
//   static const String id = 'EditProfileView';
//
//   @override
//   _EditProfileViewState createState() => _EditProfileViewState();
// }
//
// class _EditProfileViewState extends State<EditProfileView> {
//   final TextEditingController _nameController = TextEditingController();
//
//   final TextEditingController _bioController = TextEditingController();
//
//   final TextEditingController _phoneController = TextEditingController();
//
//   @override
//   void dispose() {
//     _nameController.dispose();
//     _bioController.dispose();
//     _phoneController.dispose();
//     super.dispose();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     UserModel currentUser = ModalRoute.of(context).settings.arguments;
//     return Scaffold(
//       appBar: buildDefaultAppBar(
//         title: 'Edit Profile',
//         leading: BuildDefaultIconButton(
//           icon: const Icon(IconBroken.Arrow___Left_2),
//           onClick: () {
//             Navigator.pop(context);
//           },
//         ),
//         titleSpacing: 0.0,
//         actions: [
//           Consumer<EditProfileController>(
//             builder: (context, provider, child) {
//               return BuildDefaultTextButton(
//                 title: 'update'.toUpperCase(),
//                 buttonColor: mainColor,
//                 textSize: 14.0,
//                 onClick: () {
//                   // provider.updateProfileData(
//                   //     uid: currentUser.uid,
//                   //     email: currentUser.email,
//                   //     name: _nameController.text,
//                   //     bio: _bioController.text,
//                   //     phone: _phoneController.text,
//                   //     profileImageUrl: currentUser.profileImageUrl,
//                   //     coverImageUrl: currentUser.coverImageUrl,
//                   //     getPostCurrentUserData:
//                   //         Provider.of<UserController>(context, listen: false)
//                   //             .getUserProfileData());
//                   provider.updateData(
//                       uid: currentUser.uid,
//                       email: currentUser.email,
//                       name: _nameController.text,
//                       bio: _bioController.text,
//                       phone: _phoneController.text,
//                       profileImageUrl: currentUser.profileImageUrl,
//                       coverImageUrl: currentUser.coverImageUrl,
//                       getPostCurrentUserData:
//                           Provider.of<UserController>(context, listen: false)
//                               .getUserProfileData());
//                   if (provider.userProfileControllerUpdateDataStates ==
//                       UserProfileControllerUpdateDataStates.ErrorState) {
//                     ScaffoldMessenger.of(context).showSnackBar(
//                       buildDefaultSnackBar(
//                         context,
//                         key: UniqueKey(),
//                         contentText: provider.errorResult.errorMessage,
//                       ),
//                     );
//                   }
//                 },
//               );
//             },
//           ),
//         ],
//       ),
//       body: Consumer<EditProfileController>(
//         builder: (context, provider, child) {
//           _nameController.text = currentUser.name;
//           _bioController.text = currentUser.bio;
//           _phoneController.text = currentUser.phone;
//           return SingleChildScrollView(
//             child: Padding(
//               padding: const EdgeInsets.symmetric(horizontal: 8.0),
//               child: Column(
//                 children: [
//                   if (provider.userProfileControllerUpdateDataStates ==
//                       UserProfileControllerUpdateDataStates.LoadingState)
//                     buildLinearLoadingWidget(),
//                   if (provider.userProfileControllerUpdateDataStates ==
//                       UserProfileControllerUpdateDataStates.LoadingState)
//                     minimumVerticalDistance(),
//                   Container(
//                     height: 175.0,
//                     width: double.infinity,
//                     child: Stack(
//                       alignment: Alignment.bottomCenter,
//                       children: [
//                         Align(
//                           alignment: Alignment.topCenter,
//                           child: Stack(
//                             alignment: AlignmentDirectional.topEnd,
//                             children: [
//                               Container(
//                                 height: 130.0,
//                                 width: double.infinity,
//                                 decoration: BoxDecoration(
//                                   borderRadius: const BorderRadius.only(
//                                     topLeft: Radius.circular(4.0),
//                                     topRight: Radius.circular(4.0),
//                                   ),
//                                   image: DecorationImage(
//                                     image: provider.coverImage == null
//                                         ? NetworkImage(
//                                             currentUser.coverImageUrl)
//                                         : FileImage(provider.coverImage),
//                                     fit: BoxFit.cover,
//                                   ),
//                                 ),
//                               ),
//                               BuildDefaultCircleIconButton(
//                                 icon: IconBroken.Image,
//                                 onClick: () async {
//                                   await provider.pickCoverImage();
//                                   if (provider
//                                           .userProfileControllerImageStates ==
//                                       UserProfileControllerPickedImageStates
//                                           .CoverImagePickedErrorState) {
//                                     ScaffoldMessenger.of(context).showSnackBar(
//                                       buildDefaultSnackBar(
//                                         context,
//                                         key: UniqueKey(),
//                                         contentText:
//                                             provider.errorResult.errorMessage,
//                                       ),
//                                     );
//                                   }
//                                 },
//                               ),
//                             ],
//                           ),
//                         ),
//                         Stack(
//                           alignment: AlignmentDirectional.bottomEnd,
//                           children: [
//                             Container(
//                               height: 110.0,
//                               width: 110.0,
//                               decoration: BoxDecoration(
//                                 color:
//                                     Theme.of(context).scaffoldBackgroundColor,
//                                 shape: BoxShape.circle,
//                               ),
//                               child: Padding(
//                                 padding: const EdgeInsets.all(4.0),
//                                 child: BuildUserCircleImage(
//                                   image: provider.profileImage == null
//                                       ? NetworkImage(
//                                           currentUser.profileImageUrl)
//                                       : FileImage(provider.profileImage),
//                                   imageRadius: 0.0,
//                                 ),
//                               ),
//                             ),
//                             BuildDefaultCircleIconButton(
//                               icon: IconBroken.Image,
//                               onClick: () async {
//                                 await provider.pickProfileImage();
//                                 if (provider.userProfileControllerImageStates ==
//                                     UserProfileControllerPickedImageStates
//                                         .ProfileImagePickedErrorState) {
//                                   ScaffoldMessenger.of(context).showSnackBar(
//                                     buildDefaultSnackBar(
//                                       context,
//                                       key: UniqueKey(),
//                                       contentText:
//                                           provider.errorResult.errorMessage,
//                                     ),
//                                   );
//                                 }
//                               },
//                             ),
//                           ],
//                         ),
//                       ],
//                     ),
//                   ),
//                   constDistance(),
//                   if (provider.coverImage != null ||
//                       provider.profileImage != null)
//                     Row(
//                       textBaseline: TextBaseline.alphabetic,
//                       children: [
//                         if (provider.coverImage != null)
//                           Expanded(
//                             child: Column(
//                               children: [
//                                 BuildDefaultButton(
//                                   height: 45.0,
//                                   buttonName: 'Upload Cover',
//                                   buttonNameColor: lightMainColor,
//                                   onClick: () {
//                                     provider.uploadCoverImage(
//                                       profileImageUrl: currentUser.profileImageUrl,
//                                         uid: currentUser.uid,
//                                         email: currentUser.email,
//                                         name: _nameController.text,
//                                         phone: _phoneController.text,
//                                         bio: _bioController.text,
//                                         getPostCurrentUserData:
//                                             Provider.of<UserController>(context,
//                                                     listen: false)
//                                                 .getUserProfileData());
//                                     if (provider
//                                             .userProfileControllerUploadImageStates ==
//                                         UserProfileControllerUploadImageStates
//                                             .UploadCoverImageErrorState) {
//                                       ScaffoldMessenger.of(context)
//                                           .showSnackBar(
//                                         buildDefaultSnackBar(
//                                           context,
//                                           key: UniqueKey(),
//                                           contentText:
//                                               provider.errorResult.errorMessage,
//                                         ),
//                                       );
//                                     }
//                                   },
//                                 ),
//                                 if (provider
//                                         .userProfileControllerUploadImageStates ==
//                                     UserProfileControllerUploadImageStates
//                                         .UploadCoverImageLoadingState)
//                                   minimumVerticalDistance(),
//                                 if (provider
//                                         .userProfileControllerUploadImageStates ==
//                                     UserProfileControllerUploadImageStates
//                                         .UploadCoverImageLoadingState)
//                                   buildLinearLoadingWidget(),
//                               ],
//                             ),
//                           ),
//                         if (provider.coverImage != null &&
//                             provider.profileImage != null)
//                           mediumHorizontalDistance(),
//                         if (provider.profileImage != null)
//                           Expanded(
//                             child: Column(
//                               mainAxisAlignment: MainAxisAlignment.start,
//                               children: [
//                                 BuildDefaultButton(
//                                   height: 45.0,
//                                   buttonName: 'Upload Profile',
//                                   buttonNameColor: lightMainColor,
//                                   onClick: () {
//                                     provider.uploadProfileImage(
//                                       coverImageUrl: currentUser.coverImageUrl,
//                                         uid: currentUser.uid,
//                                         email: currentUser.email,
//                                         name: _nameController.text,
//                                         phone: _phoneController.text,
//                                         bio: _bioController.text,
//                                         getPostCurrentUserData:
//                                             Provider.of<UserController>(context,
//                                                     listen: false)
//                                                 .getUserProfileData());
//                                     if (provider
//                                             .userProfileControllerUploadImageStates ==
//                                         UserProfileControllerUploadImageStates
//                                             .UploadProfileImageErrorState) {
//                                       ScaffoldMessenger.of(context)
//                                           .showSnackBar(
//                                         buildDefaultSnackBar(
//                                           context,
//                                           key: UniqueKey(),
//                                           contentText:
//                                               provider.errorResult.errorMessage,
//                                         ),
//                                       );
//                                     }
//                                   },
//                                 ),
//                                 if (provider
//                                         .userProfileControllerUploadImageStates ==
//                                     UserProfileControllerUploadImageStates
//                                         .UploadProfileImageLoadingState)
//                                   minimumVerticalDistance(),
//                                 if (provider
//                                         .userProfileControllerUploadImageStates ==
//                                     UserProfileControllerUploadImageStates
//                                         .UploadProfileImageLoadingState)
//                                   buildLinearLoadingWidget(),
//                               ],
//                             ),
//                           ),
//                       ],
//                     ),
//                   if (provider.coverImage != null ||
//                       provider.profileImage != null)
//                     mediumVerticalDistance(),
//                   BuildDefaultOutlineBorderTextFormField(
//                     key: UniqueKey(),
//                     controller: _nameController,
//                     label: 'Name',
//                     prefixIcon: IconBroken.User,
//                     validate: (String value) {
//                       if (value.isEmpty) {
//                         return 'Please enter your name !';
//                       }
//                       return null;
//                     },
//                   ),
//                   minimumVerticalDistance(),
//                   minimumVerticalDistance(),
//                   BuildDefaultOutlineBorderTextFormField(
//                     key: UniqueKey(),
//                     controller: _bioController,
//                     label: 'Bio',
//                     prefixIcon: IconBroken.Info_Circle,
//                     validate: (String value) {
//                       if (value.isEmpty) {
//                         return 'Please enter your bio !';
//                       }
//                       return null;
//                     },
//                   ),
//                   minimumVerticalDistance(),
//                   minimumVerticalDistance(),
//                   BuildDefaultOutlineBorderTextFormField(
//                     key: UniqueKey(),
//                     controller: _phoneController,
//                     label: 'Phone',
//                     prefixIcon: IconBroken.Call,
//                     validate: (String value) {
//                       if (value.isEmpty) {
//                         return 'Please enter your phone number !';
//                       }
//                       return null;
//                     },
//                   ),
//                 ],
//               ),
//             ),
//           );
//
//           ///
//           // if (provider.userProfileControllerGetDataStates ==
//           //     UserProfileControllerGetDataStates.InitialState) {
//           //   // provider.getCurrentUserProfileData();
//           //   return buildCircularLoadingWidget();
//           // } else if (provider.userProfileControllerGetDataStates ==
//           //     UserProfileControllerGetDataStates.LoadingState) {
//           //   return buildCircularLoadingWidget();
//           // } else if (provider.userProfileControllerGetDataStates ==
//           //     UserProfileControllerGetDataStates.LoadedState) {
//           //   // _nameController.text = provider.userProfileData.name;
//           //   // _bioController.text = provider.userProfileData.bio;
//           //   // _phoneController.text = provider.userProfileData.phone;
//           //   _nameController.text = currentUser.name;
//           //   _bioController.text = currentUser.bio;
//           //   _phoneController.text = currentUser.phone;
//           //   return SingleChildScrollView(
//           //     child: Padding(
//           //       padding: const EdgeInsets.symmetric(horizontal: 8.0),
//           //       child: Column(
//           //         children: [
//           //           if (provider.userProfileControllerUpdateDataStates ==
//           //               UserProfileControllerUpdateDataStates.LoadingState)
//           //             buildLinearLoadingWidget(),
//           //           if (provider.userProfileControllerUpdateDataStates ==
//           //               UserProfileControllerUpdateDataStates.LoadingState)
//           //             minimumVerticalDistance(),
//           //           Container(
//           //             height: 175.0,
//           //             width: double.infinity,
//           //             child: Stack(
//           //               alignment: Alignment.bottomCenter,
//           //               children: [
//           //                 Align(
//           //                   alignment: Alignment.topCenter,
//           //                   child: Stack(
//           //                     alignment: AlignmentDirectional.topEnd,
//           //                     children: [
//           //                       Container(
//           //                         height: 130.0,
//           //                         width: double.infinity,
//           //                         decoration: BoxDecoration(
//           //                           borderRadius: const BorderRadius.only(
//           //                             topLeft: Radius.circular(4.0),
//           //                             topRight: Radius.circular(4.0),
//           //                           ),
//           //                           image: DecorationImage(
//           //                             image: provider.coverImage == null
//           //                                 ? NetworkImage(currentUser.coverImageUrl)
//           //                                 : FileImage(provider.coverImage),
//           //                             fit: BoxFit.cover,
//           //                           ),
//           //                         ),
//           //                       ),
//           //                       BuildDefaultCircleIconButton(
//           //                         icon: IconBroken.Image,
//           //                         onClick: () async {
//           //                           await provider.pickCoverImage();
//           //                           if (provider
//           //                                   .userProfileControllerImageStates ==
//           //                               UserProfileControllerPickedImageStates
//           //                                   .CoverImagePickedErrorState) {
//           //                             ScaffoldMessenger.of(context)
//           //                                 .showSnackBar(
//           //                               buildDefaultSnackBar(
//           //                                 context,
//           //                                 key: UniqueKey(),
//           //                                 contentText:
//           //                                     provider.errorResult.errorMessage,
//           //                               ),
//           //                             );
//           //                           }
//           //                         },
//           //                       ),
//           //                     ],
//           //                   ),
//           //                 ),
//           //                 Stack(
//           //                   alignment: AlignmentDirectional.bottomEnd,
//           //                   children: [
//           //                     Container(
//           //                       height: 110.0,
//           //                       width: 110.0,
//           //                       decoration: BoxDecoration(
//           //                         color:
//           //                             Theme.of(context).scaffoldBackgroundColor,
//           //                         shape: BoxShape.circle,
//           //                       ),
//           //                       child: Padding(
//           //                         padding: const EdgeInsets.all(4.0),
//           //                         child: BuildUserCircleImage(
//           //                           image: provider.profileImage == null
//           //                               ? NetworkImage(currentUser.profileImageUrl)
//           //                               : FileImage(provider.profileImage),
//           //                           imageRadius: 0.0,
//           //                         ),
//           //                       ),
//           //                     ),
//           //                     BuildDefaultCircleIconButton(
//           //                       icon: IconBroken.Image,
//           //                       onClick: () async {
//           //                         await provider.pickProfileImage();
//           //                         if (provider
//           //                                 .userProfileControllerImageStates ==
//           //                             UserProfileControllerPickedImageStates
//           //                                 .ProfileImagePickedErrorState) {
//           //                           ScaffoldMessenger.of(context).showSnackBar(
//           //                             buildDefaultSnackBar(
//           //                               context,
//           //                               key: UniqueKey(),
//           //                               contentText:
//           //                                   provider.errorResult.errorMessage,
//           //                             ),
//           //                           );
//           //                         }
//           //                       },
//           //                     ),
//           //                   ],
//           //                 ),
//           //               ],
//           //             ),
//           //           ),
//           //           constDistance(),
//           //           if (provider.coverImage != null ||
//           //               provider.profileImage != null)
//           //             Row(
//           //               textBaseline: TextBaseline.alphabetic,
//           //               children: [
//           //                 if (provider.coverImage != null)
//           //                   Expanded(
//           //                     child: Column(
//           //                       children: [
//           //                         BuildDefaultButton(
//           //                           height: 45.0,
//           //                           buttonName: 'Upload Cover',
//           //                           buttonNameColor: lightMainColor,
//           //                           onClick: () {
//           //                             provider.uploadCoverImage(
//           //                                 name: _nameController.text,
//           //                                 phone: _phoneController.text,
//           //                                 bio: _bioController.text);
//           //                             if (provider
//           //                                     .userProfileControllerUploadImageStates ==
//           //                                 UserProfileControllerUploadImageStates
//           //                                     .UploadCoverImageErrorState) {
//           //                               ScaffoldMessenger.of(context)
//           //                                   .showSnackBar(
//           //                                 buildDefaultSnackBar(
//           //                                   context,
//           //                                   key: UniqueKey(),
//           //                                   contentText: provider
//           //                                       .errorResult.errorMessage,
//           //                                 ),
//           //                               );
//           //                             }
//           //                           },
//           //                         ),
//           //                         if (provider
//           //                                 .userProfileControllerUploadImageStates ==
//           //                             UserProfileControllerUploadImageStates
//           //                                 .UploadCoverImageLoadingState)
//           //                           minimumVerticalDistance(),
//           //                         if (provider
//           //                                 .userProfileControllerUploadImageStates ==
//           //                             UserProfileControllerUploadImageStates
//           //                                 .UploadCoverImageLoadingState)
//           //                           buildLinearLoadingWidget(),
//           //                       ],
//           //                     ),
//           //                   ),
//           //                 if (provider.coverImage != null &&
//           //                     provider.profileImage != null)
//           //                   mediumHorizontalDistance(),
//           //                 if (provider.profileImage != null)
//           //                   Expanded(
//           //                     child: Column(
//           //                       mainAxisAlignment: MainAxisAlignment.start,
//           //                       children: [
//           //                         BuildDefaultButton(
//           //                           height: 45.0,
//           //                           buttonName: 'Upload Profile',
//           //                           buttonNameColor: lightMainColor,
//           //                           onClick: () {
//           //                             provider.uploadProfileImage(
//           //                                 name: _nameController.text,
//           //                                 phone: _phoneController.text,
//           //                                 bio: _bioController.text);
//           //                             if (provider
//           //                                     .userProfileControllerUploadImageStates ==
//           //                                 UserProfileControllerUploadImageStates
//           //                                     .UploadProfileImageErrorState) {
//           //                               ScaffoldMessenger.of(context)
//           //                                   .showSnackBar(
//           //                                 buildDefaultSnackBar(
//           //                                   context,
//           //                                   key: UniqueKey(),
//           //                                   contentText: provider
//           //                                       .errorResult.errorMessage,
//           //                                 ),
//           //                               );
//           //                             }
//           //                           },
//           //                         ),
//           //                         if (provider
//           //                                 .userProfileControllerUploadImageStates ==
//           //                             UserProfileControllerUploadImageStates
//           //                                 .UploadProfileImageLoadingState)
//           //                           minimumVerticalDistance(),
//           //                         if (provider
//           //                                 .userProfileControllerUploadImageStates ==
//           //                             UserProfileControllerUploadImageStates
//           //                                 .UploadProfileImageLoadingState)
//           //                           buildLinearLoadingWidget(),
//           //                       ],
//           //                     ),
//           //                   ),
//           //               ],
//           //             ),
//           //           if (provider.coverImage != null ||
//           //               provider.profileImage != null)
//           //             mediumVerticalDistance(),
//           //           BuildDefaultOutlineBorderTextFormField(
//           //             key: UniqueKey(),
//           //             controller: _nameController,
//           //             label: 'Name',
//           //             prefixIcon: IconBroken.User,
//           //             validate: (String value) {
//           //               if (value.isEmpty) {
//           //                 return 'Please enter your name !';
//           //               }
//           //               return null;
//           //             },
//           //           ),
//           //           minimumVerticalDistance(),
//           //           minimumVerticalDistance(),
//           //           BuildDefaultOutlineBorderTextFormField(
//           //             key: UniqueKey(),
//           //             controller: _bioController,
//           //             label: 'Bio',
//           //             prefixIcon: IconBroken.Info_Circle,
//           //             validate: (String value) {
//           //               if (value.isEmpty) {
//           //                 return 'Please enter your bio !';
//           //               }
//           //               return null;
//           //             },
//           //           ),
//           //           minimumVerticalDistance(),
//           //           minimumVerticalDistance(),
//           //           BuildDefaultOutlineBorderTextFormField(
//           //             key: UniqueKey(),
//           //             controller: _phoneController,
//           //             label: 'Phone',
//           //             prefixIcon: IconBroken.Call,
//           //             validate: (String value) {
//           //               if (value.isEmpty) {
//           //                 return 'Please enter your phone number !';
//           //               }
//           //               return null;
//           //             },
//           //           ),
//           //         ],
//           //       ),
//           //     ),
//           //   );
//           // } else {
//           //   return BuildErrorResultWidget(
//           //     errorImage: provider.errorResult.errorImage,
//           //     errorMessage: provider.errorResult.errorMessage,
//           //   );
//           // }
//           ///
//         },
//       ),
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:social_app/constants/colors_constants.dart';
import 'package:social_app/controller/edit_profile_controller.dart';
import 'package:social_app/controller/user_profile_controller.dart';
import 'package:social_app/model/user_model.dart';
import 'package:social_app/states/edit_profile_controller_states.dart';
import '../../icon_broken.dart';
import '../app_components.dart';

class EditProfileView extends StatefulWidget {
  static const String id = 'EditProfileView';

  @override
  _EditProfileViewState createState() => _EditProfileViewState();
}

class _EditProfileViewState extends State<EditProfileView> {
  final TextEditingController _nameController = TextEditingController();

  final TextEditingController _bioController = TextEditingController();

  final TextEditingController _phoneController = TextEditingController();

  @override
  void dispose() {
    _nameController.dispose();
    _bioController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    UserModel currentUser = ModalRoute.of(context).settings.arguments;
    return Scaffold(
      appBar: buildDefaultAppBar(
        title: 'Edit Profile',
        leading: BuildDefaultIconButton(
          icon: const Icon(IconBroken.Arrow___Left),
          onClick: () {
            Navigator.pop(context);
          },
        ),
        actions: [
          Consumer<EditProfileController>(
            builder: (context, provider, child) {
              return BuildDefaultTextButton(
                title: 'update'.toUpperCase(),
                buttonColor: mainColor,
                textSize: 14.0,
                onClick: () {
                  provider
                      .updateData(
                          uid: currentUser.uid,
                          email: currentUser.email,
                          name: _nameController.text,
                          bio: _bioController.text,
                          phone: _phoneController.text,
                          profileImageUrl: currentUser.profileImageUrl,
                          coverImageUrl: currentUser.coverImageUrl)
                      .then((value) {
                    Provider.of<UserProfileController>(context, listen: false)
                        .getUserProfileData();
                    Navigator.pop(context);
                  });
                  if (provider.userProfileControllerUpdateDataStates ==
                      UserProfileControllerUpdateDataStates.ErrorState) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      buildDefaultSnackBar(
                        context,
                        key: UniqueKey(),
                        contentText: provider.errorResult.errorMessage,
                      ),
                    );
                  }
                },
              );
            },
          ),
        ],
      ),
      // body: Consumer<UserController>(
      //   builder: (context, provider, child) {
      //     _nameController.text = currentUser.name;
      //     _bioController.text = currentUser.bio;
      //     _phoneController.text = currentUser.phone;
      //     return SingleChildScrollView(
      //       child: Padding(
      //         padding: const EdgeInsets.symmetric(horizontal: 8.0),
      //         child: Column(
      //           children: [
      //             if (provider.userControllerUpdateDataStates ==
      //                 UserControllerUpdateDataStates.LoadingState)
      //               buildLinearLoadingWidget(),
      //             if (provider.userControllerUpdateDataStates ==
      //                 UserControllerUpdateDataStates.LoadingState)
      //               minimumVerticalDistance(),
      //             Container(
      //               height: 175.0,
      //               width: double.infinity,
      //               child: Stack(
      //                 alignment: Alignment.bottomCenter,
      //                 children: [
      //                   Align(
      //                     alignment: Alignment.topCenter,
      //                     child: Stack(
      //                       alignment: AlignmentDirectional.topEnd,
      //                       children: [
      //                         Container(
      //                           height: 130.0,
      //                           width: double.infinity,
      //                           decoration: BoxDecoration(
      //                             borderRadius: const BorderRadius.only(
      //                               topLeft: Radius.circular(4.0),
      //                               topRight: Radius.circular(4.0),
      //                             ),
      //                             image: DecorationImage(
      //                               image: provider.coverImage == null
      //                                   ? NetworkImage(
      //                                       currentUser.coverImageUrl)
      //                                   : FileImage(provider.coverImage),
      //                               fit: BoxFit.cover,
      //                             ),
      //                           ),
      //                         ),
      //                         BuildDefaultCircleIconButton(
      //                           icon: IconBroken.Image,
      //                           onClick: () async {
      //                             await provider.pickCoverImage();
      //                             if (provider
      //                                     .userControllerPickProfileImagesStates ==
      //                                 UserControllerPickProfileImagesStates
      //                                     .CoverImagePickedErrorState) {
      //                               ScaffoldMessenger.of(context).showSnackBar(
      //                                 buildDefaultSnackBar(
      //                                   context,
      //                                   key: UniqueKey(),
      //                                   contentText:
      //                                       provider.errorResult.errorMessage,
      //                                 ),
      //                               );
      //                             }
      //                           },
      //                         ),
      //                       ],
      //                     ),
      //                   ),
      //                   Stack(
      //                     alignment: AlignmentDirectional.bottomEnd,
      //                     children: [
      //                       Container(
      //                         height: 110.0,
      //                         width: 110.0,
      //                         decoration: BoxDecoration(
      //                           color:
      //                               Theme.of(context).scaffoldBackgroundColor,
      //                           shape: BoxShape.circle,
      //                         ),
      //                         child: Padding(
      //                           padding: const EdgeInsets.all(4.0),
      //                           child: BuildUserCircleImage(
      //                             image: provider.profileImage == null
      //                                 ? NetworkImage(
      //                                     currentUser.profileImageUrl)
      //                                 : FileImage(provider.profileImage),
      //                             imageRadius: 0.0,
      //                           ),
      //                         ),
      //                       ),
      //                       BuildDefaultCircleIconButton(
      //                         icon: IconBroken.Image,
      //                         onClick: () async {
      //                           await provider.pickProfileImage();
      //                           if (provider
      //                                   .userControllerPickProfileImagesStates ==
      //                               UserControllerPickProfileImagesStates
      //                                   .ProfileImagePickedErrorState) {
      //                             ScaffoldMessenger.of(context).showSnackBar(
      //                               buildDefaultSnackBar(
      //                                 context,
      //                                 key: UniqueKey(),
      //                                 contentText:
      //                                     provider.errorResult.errorMessage,
      //                               ),
      //                             );
      //                           }
      //                         },
      //                       ),
      //                     ],
      //                   ),
      //                 ],
      //               ),
      //             ),
      //             mediumVerticalDistance(),
      //             if (provider.coverImage != null ||
      //                 provider.profileImage != null)
      //               Row(
      //                 textBaseline: TextBaseline.alphabetic,
      //                 children: [
      //                   if (provider.coverImage != null)
      //                     Expanded(
      //                       child: Column(
      //                         children: [
      //                           BuildDefaultButton(
      //                             height: 45.0,
      //                             buttonName: 'Upload Cover',
      //                             buttonNameColor: lightMainColor,
      //                             onClick: () {
      //                               provider.uploadCoverImage(
      //                                 name: _nameController.text,
      //                                 phone: _phoneController.text,
      //                                 bio: _bioController.text,
      //                               );
      //                               if (provider
      //                                       .userControllerUploadImageStates ==
      //                                   UserControllerUploadImageStates
      //                                       .UploadCoverImageErrorState) {
      //                                 ScaffoldMessenger.of(context)
      //                                     .showSnackBar(
      //                                   buildDefaultSnackBar(
      //                                     context,
      //                                     key: UniqueKey(),
      //                                     contentText:
      //                                         provider.errorResult.errorMessage,
      //                                   ),
      //                                 );
      //                               }
      //                             },
      //                           ),
      //                           if (provider
      //                               .userControllerUploadImageStates ==
      //                               UserControllerUploadImageStates
      //                                   .UploadCoverImageLoadingState)
      //                             minimumVerticalDistance(),
      //                           if (provider
      //                               .userControllerUploadImageStates ==
      //                               UserControllerUploadImageStates
      //                                   .UploadCoverImageLoadingState)
      //                             buildLinearLoadingWidget(),
      //                         ],
      //                       ),
      //                     ),
      //                   if (provider.coverImage != null &&
      //                       provider.profileImage != null)
      //                     mediumHorizontalDistance(),
      //                   if (provider.profileImage != null)
      //                     Expanded(
      //                       child: Column(
      //                         mainAxisAlignment: MainAxisAlignment.start,
      //                         children: [
      //                           BuildDefaultButton(
      //                             height: 45.0,
      //                             buttonName: 'Upload Profile',
      //                             buttonNameColor: lightMainColor,
      //                             onClick: () {
      //                               provider.uploadProfileImage(
      //                                 name: _nameController.text,
      //                                 phone: _phoneController.text,
      //                                 bio: _bioController.text,
      //                               ).then((value) {
      //                                 Provider.of<CounterApp1>(context, listen: false).change();
      //                               });
      //                               if (provider
      //                                       .userControllerUploadImageStates ==
      //                                   UserControllerUploadImageStates
      //                                       .UploadProfileImageErrorState) {
      //                                 ScaffoldMessenger.of(context)
      //                                     .showSnackBar(
      //                                   buildDefaultSnackBar(
      //                                     context,
      //                                     key: UniqueKey(),
      //                                     contentText:
      //                                         provider.errorResult.errorMessage,
      //                                   ),
      //                                 );
      //                               }
      //                             },
      //                           ),
      //                           if (provider
      //                               .userControllerUploadImageStates ==
      //                               UserControllerUploadImageStates
      //                                   .UploadProfileImageLoadingState)
      //                             minimumVerticalDistance(),
      //                           if (provider
      //                               .userControllerUploadImageStates ==
      //                               UserControllerUploadImageStates
      //                                   .UploadProfileImageLoadingState)
      //                             buildLinearLoadingWidget(),
      //                         ],
      //                       ),
      //                     ),
      //                 ],
      //               ),
      //             if (provider.coverImage != null ||
      //                 provider.profileImage != null)
      //               mediumVerticalDistance(),
      //             BuildDefaultOutlineBorderTextFormField(
      //               key: UniqueKey(),
      //               controller: _nameController,
      //               label: 'Name',
      //               prefixIcon: IconBroken.User,
      //               validate: (String value) {
      //                 if (value.isEmpty) {
      //                   return 'Please enter your name !';
      //                 }
      //                 return null;
      //               },
      //             ),
      //             minimumVerticalDistance(),
      //             minimumVerticalDistance(),
      //             BuildDefaultOutlineBorderTextFormField(
      //               key: UniqueKey(),
      //               controller: _bioController,
      //               label: 'Bio',
      //               prefixIcon: IconBroken.Info_Circle,
      //               validate: (String value) {
      //                 if (value.isEmpty) {
      //                   return 'Please enter your bio !';
      //                 }
      //                 return null;
      //               },
      //             ),
      //             minimumVerticalDistance(),
      //             minimumVerticalDistance(),
      //             BuildDefaultOutlineBorderTextFormField(
      //               key: UniqueKey(),
      //               controller: _phoneController,
      //               label: 'Phone',
      //               prefixIcon: IconBroken.Call,
      //               validate: (String value) {
      //                 if (value.isEmpty) {
      //                   return 'Please enter your phone number !';
      //                 }
      //                 return null;
      //               },
      //             ),
      //           ],
      //         ),
      //       ),
      //     );
      //   },
      // ),

      body: Consumer<EditProfileController>(
        builder: (_, provider, child) {
          _nameController.text = currentUser.name;
          _bioController.text = currentUser.bio;
          _phoneController.text = currentUser.phone;
          return SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: Column(
                children: [
                  if (provider.userProfileControllerUpdateDataStates ==
                      UserProfileControllerUpdateDataStates.LoadingState)
                    buildLinearLoadingWidget(),
                  if (provider.userProfileControllerUpdateDataStates ==
                      UserProfileControllerUpdateDataStates.LoadingState)
                    minimumVerticalDistance(),
                  Container(
                    height: 220.0,
                    width: double.infinity,
                    child: Stack(
                      alignment: Alignment.bottomCenter,
                      children: [
                        Align(
                          alignment: Alignment.topCenter,
                          child: Stack(
                            alignment: AlignmentDirectional.topEnd,
                            children: [
                              Container(
                                height: 180.0,
                                width: double.infinity,
                                decoration: BoxDecoration(
                                  borderRadius: const BorderRadius.only(
                                    topLeft: Radius.circular(8.0),
                                    topRight: Radius.circular(8.0),
                                  ),
                                  image: DecorationImage(
                                    image: provider.coverImage == null
                                        ? NetworkImage(
                                            currentUser.coverImageUrl)
                                        : FileImage(provider.coverImage),
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                              BuildDefaultCircleIconButton(
                                icon: IconBroken.Image,
                                onClick: () async {
                                  await provider.pickCoverImage();
                                  if (provider
                                          .userProfileControllerImageStates ==
                                      UserProfileControllerPickedImageStates
                                          .CoverImagePickedErrorState) {
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
                            ],
                          ),
                        ),
                        Stack(
                          alignment: AlignmentDirectional.bottomEnd,
                          children: [
                            Container(
                              height: 150.0,
                              width: 150.0,
                              decoration: BoxDecoration(
                                color: Theme.of(context).scaffoldBackgroundColor,
                                shape: BoxShape.circle,
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(4.0),
                                child: BuildUserCircleImage(
                                  image: provider.profileImage == null
                                      ? NetworkImage(
                                          currentUser.profileImageUrl)
                                      : FileImage(provider.profileImage),
                                  imageRadius: 0.0,
                                ),
                              ),
                            ),
                            PositionedDirectional(
                              end: 5.0,
                              bottom: 10.0,
                              child: BuildDefaultCircleIconButton(
                                icon: IconBroken.Image,
                                onClick: () async {
                                  await provider.pickProfileImage();
                                  if (provider.userProfileControllerImageStates ==
                                      UserProfileControllerPickedImageStates
                                          .ProfileImagePickedErrorState) {
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
                          ],
                        ),
                      ],
                    ),
                  ),
                  mediumVerticalDistance(),
                  if (provider.coverImage != null ||
                      provider.profileImage != null)
                    Row(
                      textBaseline: TextBaseline.alphabetic,
                      children: [
                        if (provider.coverImage != null)
                          Expanded(
                            child: Column(
                              children: [
                                BuildDefaultButton(
                                  height: 45.0,
                                  buttonName: 'Upload Cover',
                                  buttonNameColor: lightMainColor,
                                  onClick: () {
                                    provider
                                        .uploadCoverImage(
                                            uid: currentUser.uid,
                                            email: currentUser.email,
                                            name: _nameController.text,
                                            phone: _phoneController.text,
                                            bio: _bioController.text,
                                            profileImageUrl:
                                                currentUser.profileImageUrl)
                                        .then((value) {
                                      Provider.of<UserProfileController>(
                                              context,
                                              listen: false)
                                          .getUserProfileData();
                                      Navigator.pop(context);
                                    });
                                    if (provider
                                            .userProfileControllerUploadImageStates ==
                                        UserProfileControllerUploadImageStates
                                            .UploadCoverImageErrorState) {
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(
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
                                if (provider
                                        .userProfileControllerUploadImageStates ==
                                    UserProfileControllerUploadImageStates
                                        .UploadCoverImageLoadingState)
                                  minimumVerticalDistance(),
                                if (provider
                                        .userProfileControllerUploadImageStates ==
                                    UserProfileControllerUploadImageStates
                                        .UploadCoverImageLoadingState)
                                  buildLinearLoadingWidget(),
                              ],
                            ),
                          ),
                        if (provider.coverImage != null &&
                            provider.profileImage != null)
                          mediumHorizontalDistance(),
                        if (provider.profileImage != null)
                          Expanded(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                BuildDefaultButton(
                                  height: 45.0,
                                  buttonName: 'Upload Profile',
                                  buttonNameColor: lightMainColor,
                                  onClick: () {
                                    provider
                                        .uploadProfileImage(
                                            uid: currentUser.uid,
                                            email: currentUser.email,
                                            name: _nameController.text,
                                            phone: _phoneController.text,
                                            coverImageUrl:
                                                currentUser.coverImageUrl,
                                            bio: _bioController.text)
                                        .then((value) {
                                      Provider.of<UserProfileController>(
                                              context,
                                              listen: false)
                                          .getUserProfileData();
                                      Navigator.pop(context);
                                    });
                                    if (provider
                                            .userProfileControllerUploadImageStates ==
                                        UserProfileControllerUploadImageStates
                                            .UploadProfileImageErrorState) {
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(
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
                                if (provider
                                        .userProfileControllerUploadImageStates ==
                                    UserProfileControllerUploadImageStates
                                        .UploadProfileImageLoadingState)
                                  minimumVerticalDistance(),
                                if (provider
                                        .userProfileControllerUploadImageStates ==
                                    UserProfileControllerUploadImageStates
                                        .UploadProfileImageLoadingState)
                                  buildLinearLoadingWidget(),
                              ],
                            ),
                          ),
                      ],
                    ),
                  if (provider.coverImage != null ||
                      provider.profileImage != null)
                    mediumVerticalDistance(),
                  BuildDefaultOutlineBorderTextFormField(
                    key: UniqueKey(),
                    controller: _nameController,
                    label: 'Name',
                    prefixIcon: IconBroken.User,
                    validate: (String value) {
                      if (value.isEmpty) {
                        return 'Please enter your name !';
                      }
                      return null;
                    },
                  ),
                  mediumVerticalDistance(),
                  BuildDefaultOutlineBorderTextFormField(
                    key: UniqueKey(),
                    controller: _bioController,
                    label: 'Bio',
                    prefixIcon: IconBroken.Info_Circle,
                    validate: (String value) {
                      if (value.isEmpty) {
                        return 'Please enter your bio !';
                      }
                      return null;
                    },
                  ),
                  mediumVerticalDistance(),
                  BuildDefaultOutlineBorderTextFormField(
                    key: UniqueKey(),
                    controller: _phoneController,
                    label: 'Phone',
                    prefixIcon: IconBroken.Call,
                    validate: (String value) {
                      if (value.isEmpty) {
                        return 'Please enter your phone number !';
                      }
                      return null;
                    },
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

///
// if (provider.userProfileControllerGetDataStates ==
//     UserProfileControllerGetDataStates.InitialState) {
//   // provider.getCurrentUserProfileData();
//   return buildCircularLoadingWidget();
// } else if (provider.userProfileControllerGetDataStates ==
//     UserProfileControllerGetDataStates.LoadingState) {
//   return buildCircularLoadingWidget();
// } else if (provider.userProfileControllerGetDataStates ==
//     UserProfileControllerGetDataStates.LoadedState) {
//   // _nameController.text = provider.userProfileData.name;
//   // _bioController.text = provider.userProfileData.bio;
//   // _phoneController.text = provider.userProfileData.phone;
//   _nameController.text = currentUser.name;
//   _bioController.text = currentUser.bio;
//   _phoneController.text = currentUser.phone;
//   return SingleChildScrollView(
//     child: Padding(
//       padding: const EdgeInsets.symmetric(horizontal: 8.0),
//       child: Column(
//         children: [
//           if (provider.userProfileControllerUpdateDataStates ==
//               UserProfileControllerUpdateDataStates.LoadingState)
//             buildLinearLoadingWidget(),
//           if (provider.userProfileControllerUpdateDataStates ==
//               UserProfileControllerUpdateDataStates.LoadingState)
//             minimumVerticalDistance(),
//           Container(
//             height: 175.0,
//             width: double.infinity,
//             child: Stack(
//               alignment: Alignment.bottomCenter,
//               children: [
//                 Align(
//                   alignment: Alignment.topCenter,
//                   child: Stack(
//                     alignment: AlignmentDirectional.topEnd,
//                     children: [
//                       Container(
//                         height: 130.0,
//                         width: double.infinity,
//                         decoration: BoxDecoration(
//                           borderRadius: const BorderRadius.only(
//                             topLeft: Radius.circular(4.0),
//                             topRight: Radius.circular(4.0),
//                           ),
//                           image: DecorationImage(
//                             image: provider.coverImage == null
//                                 ? NetworkImage(currentUser.coverImageUrl)
//                                 : FileImage(provider.coverImage),
//                             fit: BoxFit.cover,
//                           ),
//                         ),
//                       ),
//                       BuildDefaultCircleIconButton(
//                         icon: IconBroken.Image,
//                         onClick: () async {
//                           await provider.pickCoverImage();
//                           if (provider
//                                   .userProfileControllerImageStates ==
//                               UserProfileControllerPickedImageStates
//                                   .CoverImagePickedErrorState) {
//                             ScaffoldMessenger.of(context)
//                                 .showSnackBar(
//                               buildDefaultSnackBar(
//                                 context,
//                                 key: UniqueKey(),
//                                 contentText:
//                                     provider.errorResult.errorMessage,
//                               ),
//                             );
//                           }
//                         },
//                       ),
//                     ],
//                   ),
//                 ),
//                 Stack(
//                   alignment: AlignmentDirectional.bottomEnd,
//                   children: [
//                     Container(
//                       height: 110.0,
//                       width: 110.0,
//                       decoration: BoxDecoration(
//                         color:
//                             Theme.of(context).scaffoldBackgroundColor,
//                         shape: BoxShape.circle,
//                       ),
//                       child: Padding(
//                         padding: const EdgeInsets.all(4.0),
//                         child: BuildUserCircleImage(
//                           image: provider.profileImage == null
//                               ? NetworkImage(currentUser.profileImageUrl)
//                               : FileImage(provider.profileImage),
//                           imageRadius: 0.0,
//                         ),
//                       ),
//                     ),
//                     BuildDefaultCircleIconButton(
//                       icon: IconBroken.Image,
//                       onClick: () async {
//                         await provider.pickProfileImage();
//                         if (provider
//                                 .userProfileControllerImageStates ==
//                             UserProfileControllerPickedImageStates
//                                 .ProfileImagePickedErrorState) {
//                           ScaffoldMessenger.of(context).showSnackBar(
//                             buildDefaultSnackBar(
//                               context,
//                               key: UniqueKey(),
//                               contentText:
//                                   provider.errorResult.errorMessage,
//                             ),
//                           );
//                         }
//                       },
//                     ),
//                   ],
//                 ),
//               ],
//             ),
//           ),
//           constDistance(),
//           if (provider.coverImage != null ||
//               provider.profileImage != null)
//             Row(
//               textBaseline: TextBaseline.alphabetic,
//               children: [
//                 if (provider.coverImage != null)
//                   Expanded(
//                     child: Column(
//                       children: [
//                         BuildDefaultButton(
//                           height: 45.0,
//                           buttonName: 'Upload Cover',
//                           buttonNameColor: lightMainColor,
//                           onClick: () {
//                             provider.uploadCoverImage(
//                                 name: _nameController.text,
//                                 phone: _phoneController.text,
//                                 bio: _bioController.text);
//                             if (provider
//                                     .userProfileControllerUploadImageStates ==
//                                 UserProfileControllerUploadImageStates
//                                     .UploadCoverImageErrorState) {
//                               ScaffoldMessenger.of(context)
//                                   .showSnackBar(
//                                 buildDefaultSnackBar(
//                                   context,
//                                   key: UniqueKey(),
//                                   contentText: provider
//                                       .errorResult.errorMessage,
//                                 ),
//                               );
//                             }
//                           },
//                         ),
//                         if (provider
//                                 .userProfileControllerUploadImageStates ==
//                             UserProfileControllerUploadImageStates
//                                 .UploadCoverImageLoadingState)
//                           minimumVerticalDistance(),
//                         if (provider
//                                 .userProfileControllerUploadImageStates ==
//                             UserProfileControllerUploadImageStates
//                                 .UploadCoverImageLoadingState)
//                           buildLinearLoadingWidget(),
//                       ],
//                     ),
//                   ),
//                 if (provider.coverImage != null &&
//                     provider.profileImage != null)
//                   mediumHorizontalDistance(),
//                 if (provider.profileImage != null)
//                   Expanded(
//                     child: Column(
//                       mainAxisAlignment: MainAxisAlignment.start,
//                       children: [
//                         BuildDefaultButton(
//                           height: 45.0,
//                           buttonName: 'Upload Profile',
//                           buttonNameColor: lightMainColor,
//                           onClick: () {
//                             provider.uploadProfileImage(
//                                 name: _nameController.text,
//                                 phone: _phoneController.text,
//                                 bio: _bioController.text);
//                             if (provider
//                                     .userProfileControllerUploadImageStates ==
//                                 UserProfileControllerUploadImageStates
//                                     .UploadProfileImageErrorState) {
//                               ScaffoldMessenger.of(context)
//                                   .showSnackBar(
//                                 buildDefaultSnackBar(
//                                   context,
//                                   key: UniqueKey(),
//                                   contentText: provider
//                                       .errorResult.errorMessage,
//                                 ),
//                               );
//                             }
//                           },
//                         ),
//                         if (provider
//                                 .userProfileControllerUploadImageStates ==
//                             UserProfileControllerUploadImageStates
//                                 .UploadProfileImageLoadingState)
//                           minimumVerticalDistance(),
//                         if (provider
//                                 .userProfileControllerUploadImageStates ==
//                             UserProfileControllerUploadImageStates
//                                 .UploadProfileImageLoadingState)
//                           buildLinearLoadingWidget(),
//                       ],
//                     ),
//                   ),
//               ],
//             ),
//           if (provider.coverImage != null ||
//               provider.profileImage != null)
//             mediumVerticalDistance(),
//           BuildDefaultOutlineBorderTextFormField(
//             key: UniqueKey(),
//             controller: _nameController,
//             label: 'Name',
//             prefixIcon: IconBroken.User,
//             validate: (String value) {
//               if (value.isEmpty) {
//                 return 'Please enter your name !';
//               }
//               return null;
//             },
//           ),
//           minimumVerticalDistance(),
//           minimumVerticalDistance(),
//           BuildDefaultOutlineBorderTextFormField(
//             key: UniqueKey(),
//             controller: _bioController,
//             label: 'Bio',
//             prefixIcon: IconBroken.Info_Circle,
//             validate: (String value) {
//               if (value.isEmpty) {
//                 return 'Please enter your bio !';
//               }
//               return null;
//             },
//           ),
//           minimumVerticalDistance(),
//           minimumVerticalDistance(),
//           BuildDefaultOutlineBorderTextFormField(
//             key: UniqueKey(),
//             controller: _phoneController,
//             label: 'Phone',
//             prefixIcon: IconBroken.Call,
//             validate: (String value) {
//               if (value.isEmpty) {
//                 return 'Please enter your phone number !';
//               }
//               return null;
//             },
//           ),
//         ],
//       ),
//     ),
//   );
// } else {
//   return BuildErrorResultWidget(
//     errorImage: provider.errorResult.errorImage,
//     errorMessage: provider.errorResult.errorMessage,
//   );
// }
///
