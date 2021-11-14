import 'package:conditional_builder/conditional_builder.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:social_app/constants/colors_constants.dart';
import 'package:social_app/controller/likes_controller.dart';
import 'package:social_app/states/likes_controller_states.dart';
import '../../icon_broken.dart';
import '../app_components.dart';

class LikesView extends StatelessWidget {
  final String postDocId;

  const LikesView({@required this.postDocId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: buildDefaultAppBar(
        title: 'People who reacted',
        leading: BuildDefaultIconButton(
          icon: const Icon(IconBroken.Arrow___Left),
          onClick: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Builder(
        builder: (context) {
          Provider.of<LikesController>(context, listen: false)
              .getLikes(postDocId: postDocId);
          return Consumer<LikesController>(
            builder: (context, likesControllerProvider, child) {
              if (likesControllerProvider.likesControllerStates ==
                  LikesControllerStates.LikesControllerGetLikesErrorState) {
                return BuildEmptyListWidget(
                  title: likesControllerProvider.errorResult.errorMessage,
                );
              } else {
                return ConditionalBuilder(
                  condition: likesControllerProvider.likes.length > 0,
                  builder: (context) => ListView.separated(
                    itemCount: likesControllerProvider.likes.length,
                    itemBuilder: (context, index) {
                      return Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Stack(
                              alignment: AlignmentDirectional.bottomEnd,
                              children: [
                                BuildUserCircleImage(
                                  imageRadius: 25.0,
                                  image: NetworkImage(likesControllerProvider
                                      .likes[index].uImage),
                                ),
                                PositionedDirectional(
                                  bottom: 2.0,
                                  child: Container(
                                    height: 20.0,
                                    width: 20.0,
                                    decoration: BoxDecoration(
                                      color: Theme.of(context)
                                          .scaffoldBackgroundColor,
                                      shape: BoxShape.circle,
                                      border: Border.all(color: mainColor),
                                    ),
                                    child: const Center(
                                      child: Icon(
                                        IconBroken.Heart,
                                        color: mainColor,
                                        size: 15.0,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(
                              width: 15.0,
                            ),
                            Text(
                              likesControllerProvider.likes[index].uName,
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyText2
                                  .copyWith(height: 1.4),
                            ),
                          ],
                        ),
                      );
                    },
                    separatorBuilder: (_, index) => mediumVerticalDistance(),
                  ),
                  fallback: (_) => BuildEmptyListWidget(
                    title: 'No likes available yet.',
                  ),
                );
              }
            },
          );
        },
      ),
    );
  }
}
