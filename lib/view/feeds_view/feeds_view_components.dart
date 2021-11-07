import 'package:flutter/material.dart';
import 'package:social_app/constants/colors_constants.dart';
import 'package:social_app/constants/firestore_constants.dart';
import 'package:social_app/model/post_model.dart';
import '../../icon_broken.dart';
import '../app_components.dart';

class BuildReactButton extends StatelessWidget {
  final IconData icon;
  final Color iconColor;
  final double iconSize;
  final Function onClick;

  const BuildReactButton(
      {@required this.icon,
      @required this.iconColor,
      @required this.onClick,
      this.iconSize = 18.0});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onClick,
      child: Icon(
        icon,
        size: iconSize,
        color: iconColor,
      ),
      highlightColor: iconColor.withOpacity(0.3),
      splashColor: iconColor.withOpacity(0.2),
    );
  }
}

class BuildPostItem extends StatelessWidget {
  final String image;
  final PostModel post;
  final Function onLikePost, commentOnPost;
  final int likes;
  final Stream stream;

  const BuildPostItem(
      {@required this.post,
      @required this.image,
      @required this.onLikePost,
      @required this.likes,
      @required this.commentOnPost,
      @required this.stream});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 5.0,
      margin: const EdgeInsets.symmetric(horizontal: 8.0),
      clipBehavior: Clip.antiAliasWithSaveLayer,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 5.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                BuildUserCircleImage(
                  image: NetworkImage(post.uImage),
                  imageRadius: 20.0,
                ),
                const SizedBox(
                  width: 15.0,
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text(
                            post.uName,
                            style: Theme.of(context)
                                .textTheme
                                .bodyText2
                                .copyWith(height: 1.4),
                          ),
                          const SizedBox(
                            width: 4.0,
                          ),
                          Icon(
                            Icons.check_circle,
                            color: Colors.blueAccent,
                            size: 15.0,
                          ),
                        ],
                      ),
                      Text(
                        post.datetime,
                        style: Theme.of(context).textTheme.caption.copyWith(
                              height: 1.4,
                            ),
                      ),
                    ],
                  ),
                ),
                SizedBox(),
                InkWell(
                  child: const Icon(
                    IconBroken.More_Circle,
                    size: 22.0,
                    color: Colors.grey,
                  ),
                  onTap: () {},
                ),
              ],
            ),
            buildDefaultDivider(height: 20.0),
            Text(
              post.postText,
              style: Theme.of(context).textTheme.subtitle1,
              textAlign: TextAlign.justify,
            ),
            minimumVerticalDistance(),
            if (post.postImage != '')
              ClipRRect(
                borderRadius: const BorderRadius.all(
                  Radius.circular(4.0),
                ),
                child: BuildCachedNetworkImage(
                  url: post.postImage,
                  height: 150.0,
                ),
              ),
            if (post.postImage != '') minimumVerticalDistance(),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    // Icon(IconBroken.Heart, color: Colors.red, size: 18.0,),
                    BuildReactButton(
                      icon: IconBroken.Heart,
                      iconColor: Colors.red,
                      onClick: () {},
                    ),
                    minimumHorizontalDistance(),
                    StreamBuilder(
                      stream: stream,
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return buildCircularLoadingWidget();
                        } else {
                          if (snapshot.hasData) {
                            return Text(
                              // '$likes',
                              '${snapshot.data.docs.length}',
                              style: Theme.of(context).textTheme.caption,
                            );
                          } else {
                            return Text(
                              'Error!',
                              style: Theme.of(context).textTheme.caption,
                            );
                          }
                        }
                      },
                    ),
                  ],
                ),
                Row(
                  children: [
                    BuildReactButton(
                      icon: IconBroken.Chat,
                      iconColor: Colors.amber,
                      onClick: () {},
                    ),
                    minimumHorizontalDistance(),
                    Text(
                      '150 comment',
                      style: Theme.of(context).textTheme.caption,
                    ),
                  ],
                ),
              ],
            ),
            buildDefaultDivider(height: 15.0),
            minimumVerticalDistance(),
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                BuildUserCircleImage(
                  image: NetworkImage(image ?? errorImage),
                  imageRadius: 15.0,
                ),
                minimumHorizontalDistance(),
                InkWell(
                  child: Text(
                    'write a comment....',
                    style: Theme.of(context).textTheme.caption,
                  ),
                  onTap: commentOnPost,
                ),
                const Expanded(child: SizedBox()),
                BuildReactButton(
                  icon: IconBroken.Heart,
                  iconColor: Colors.red,
                  onClick: onLikePost,
                ),
                minimumHorizontalDistance(),
                Text(
                  'Like',
                  style: Theme.of(context).textTheme.caption,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}




class BuildLikesNumberWidget extends StatelessWidget {
  final int likesNumber;

  const BuildLikesNumberWidget({@required this.likesNumber});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 40.0,
      width: double.infinity,
      margin: EdgeInsets.symmetric(horizontal: 10.0),
      decoration: const BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color: greyColor,
            width: 1.0,
          ),
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const Icon(
            IconBroken.Heart,
            color: mainColor,
            size: 20.0,
          ),
          minimumHorizontalDistance(),
          Text(
            '$likesNumber',
            style: Theme.of(context).textTheme.caption,
          ),
          const Expanded(child: SizedBox()),
          BuildReactButton(
            icon: Icons.arrow_forward_ios_sharp,
            iconColor: blackColor,
            onClick: () {},
          ),
        ],
      ),
    );
  }
}

class BuildCommentItem extends StatelessWidget {
  final String uName, uImage, commentText, commentImage, date;

  const BuildCommentItem({
    @required this.uName,
    @required this.uImage,
    @required this.commentText,
    @required this.commentImage,
    @required this.date,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          BuildUserCircleImage(
            image: NetworkImage(uImage),
            imageRadius: 20.0,
          ),
          mediumHorizontalDistance(),
          Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: (MediaQuery.of(context).size.width) - 70.0,
                decoration: BoxDecoration(
                  color: mainColor.withOpacity(0.4),
                  borderRadius: const BorderRadius.all(
                    Radius.circular(8.0),
                  ),
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 10.0, vertical: 5.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '$uName',
                        style: Theme.of(context)
                            .textTheme
                            .subtitle1
                            .copyWith(height: 1.4),
                      ),
                      mediumVerticalDistance(),
                      Text(
                        '$commentText',
                        style: Theme.of(context)
                            .textTheme
                            .subtitle1
                            .copyWith(fontSize: 11.0, height: 1.4),
                      ),
                    ],
                  ),
                ),
              ),
              if(commentImage != '')
                const SizedBox(height: 2.0,),
              if(commentImage != '')
              ClipRRect(
                borderRadius: const BorderRadius.all(
                  Radius.circular(8.0),
                ),
                child: BuildCachedNetworkImage(
                  height: 100.0,
                  width: (MediaQuery.of(context).size.width) - 70.0,
                  url: commentImage,
                ),
              ),
              Text(
                // '$date',
                '12/1/5',
                style: Theme.of(context)
                    .textTheme
                    .caption
                    .copyWith(fontSize: 11.0, fontWeight: FontWeight.normal),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

// class BuildListOfComments extends StatelessWidget {
//   final String uName, uImage, commentText, date;
//
//   const BuildListOfComments({
//     @required this.uName,
//     @required this.uImage,
//     @required this.commentText,
//     @required this.date,
//   });
//
//   @override
//   Widget build(BuildContext context) {
//     return Expanded(
//       child: Padding(
//         padding: const EdgeInsets.only(top: 5.0),
//         child: ListView.separated(
//           itemCount: 10,
//           itemBuilder: (_, index) {
//             return Padding(
//               padding: const EdgeInsets.symmetric(horizontal: 10.0),
//               child: Row(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   BuildUserCircleImage(
//                     image: NetworkImage(uImage),
//                     imageRadius: 20.0,
//                   ),
//                   mediumHorizontalDistance(),
//                   Column(
//                     mainAxisAlignment: MainAxisAlignment.start,
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       Container(
//                         width: (MediaQuery.of(context).size.width) - 70.0,
//                         decoration: BoxDecoration(
//                           color: mainColor.withOpacity(0.4),
//                           borderRadius: const BorderRadius.all(
//                             Radius.circular(8.0),
//                           ),
//                         ),
//                         child: Padding(
//                           padding: const EdgeInsets.symmetric(
//                               horizontal: 10.0, vertical: 5.0),
//                           child: Column(
//                             mainAxisAlignment: MainAxisAlignment.start,
//                             crossAxisAlignment: CrossAxisAlignment.start,
//                             children: [
//                               Text(
//                                 '$uName',
//                                 style: Theme.of(context)
//                                     .textTheme
//                                     .subtitle1
//                                     .copyWith(height: 1.4),
//                               ),
//                               mediumVerticalDistance(),
//                               Text(
//                                 '$commentText',
//                                 style: Theme.of(context)
//                                     .textTheme
//                                     .subtitle1
//                                     .copyWith(fontSize: 11.0, height: 1.4),
//                               ),
//                             ],
//                           ),
//                         ),
//                       ),
//                       ClipRRect(
//                         borderRadius: const BorderRadius.all(
//                           Radius.circular(8.0),
//                         ),
//                         child: BuildCachedNetworkImage(
//                           height: 100.0,
//                           width: (MediaQuery.of(context).size.width) - 70.0,
//                           url: testTwo,
//                         ),
//                       ),
//                       Text(
//                         '$date',
//                         style: Theme.of(context).textTheme.caption.copyWith(
//                             fontSize: 11.0, fontWeight: FontWeight.normal),
//                       ),
//                     ],
//                   ),
//                 ],
//               ),
//             );
//           },
//           separatorBuilder: (_, index) => const SizedBox(height: 2.0),
//         ),
//       ),
//     );
//   }
// }


