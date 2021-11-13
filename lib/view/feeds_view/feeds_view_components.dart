import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:social_app/constants/colors_constants.dart';
import 'package:social_app/constants/firestore_constants.dart';
import 'package:social_app/helper/firebase_helper.dart';
import 'package:social_app/helper/user_id_helper.dart';
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
  final String postDocId;
  final String image;
  final PostModel post;
  final Function addLike, deleteLike, commentOnPost;
  final Stream likeStream, commentStream;

  const BuildPostItem(
      {@required this.postDocId,
      @required this.post,
      @required this.image,
      @required this.addLike,
      @required this.deleteLike,
      @required this.commentOnPost,
      @required this.likeStream,
      @required this.commentStream});

  @override
  Widget build(BuildContext context) {
    print('BuildPostItem');
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
                          minimumHorizontalDistance(),
                          const Icon(
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
                    const Icon(
                      IconBroken.Heart,
                      color: Colors.red,
                      size: 18.0,
                    ),
                    minimumHorizontalDistance(),
                    StreamBuilder(
                      stream: likeStream,
                      builder: (context, snapshot) {
                        print('likeStream');
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return Text(
                            'Loading...',
                            style: Theme.of(context).textTheme.caption,
                          );
                        } else {
                          if (snapshot.hasData) {
                            return Text(
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
                    const Icon(
                      IconBroken.Chat,
                      size: 18.0,
                      color: Colors.amber,
                    ),
                    minimumHorizontalDistance(),
                    StreamBuilder(
                      stream: commentStream,
                      builder: (context, snapshot) {
                        print('commentStream');
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return Text(
                            'Loading...',
                            style: Theme.of(context).textTheme.caption,
                          );
                        } else {
                          if (snapshot.hasData) {
                            return Text(
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
                const Spacer(),
                StreamBuilder<DocumentSnapshot>(
                  stream: FirebaseHelper.firestoreHelper
                      .collection(postsCollection)
                      .doc(postDocId)
                      .collection(likesCollection)
                      .doc(UserIdHelper.currentUid)
                      .snapshots(),
                  builder: (context, docSnapshot) {
                    if (!docSnapshot.hasData) {
                      return Icon(
                        IconBroken.Heart,
                        color: greyColor,
                        size: 18.0,
                      );
                    }
                    if (docSnapshot.data.exists) {
                      return BuildReactButton(
                        icon: Icons.favorite,
                        iconColor: Colors.red,
                        iconSize: 20.0,
                        onClick: () async {
                          await addLikes(true, postDocId);
                        },
                      );
                    } else {
                      return BuildReactButton(
                        icon: Icons.favorite_border,
                        iconColor: greyColor,
                        onClick: () async{
                           await addLikes(false, postDocId);
                        },
                      );
                    }
                  },
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

// Future<void> like(postDocId) async{
//   await FirebaseHelper.firestoreHelper
//       .collection(postsCollection)
//       .doc(postDocId)
//       .collection(likesCollection)
//       .doc(UserIdHelper.currentUid)
//       .set({
//     'liked': true,
//   });
// }
//
//  unLike(postDocId)  {
//    FirebaseHelper.firestoreHelper
//       .collection(postsCollection)
//       .doc(postDocId)
//       .collection(likesCollection)
//       .doc(UserIdHelper.currentUid).delete();
// }


Future<void> addLikes(bool liked, postDocId) async {
  liked = !liked;
  if (liked) {
   await FirebaseHelper.firestoreHelper
        .collection(postsCollection)
        .doc(postDocId)
        .collection(likesCollection)
        .doc(UserIdHelper.currentUid).set({
      'liked': true,
    });
  } else {
    await FirebaseHelper.firestoreHelper
        .collection(postsCollection)
        .doc(postDocId)
        .collection(likesCollection)
        .doc(UserIdHelper.currentUid).delete();
  }
}
