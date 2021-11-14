import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:social_app/constants/colors_constants.dart';
import 'package:social_app/constants/firestore_constants.dart';
import 'package:social_app/model/post_model.dart';
import '../../icon_broken.dart';
import '../app_components.dart';

class BuildPostItem extends StatelessWidget {
  final String postDocId;
  final String uImage;
  final PostModel post;
  final Function commentOnPost, addLike, deleteLike;
  final Stream<QuerySnapshot> likesStream, commentStream;
  final Stream<DocumentSnapshot> likeButtonStream;

  const BuildPostItem(
      {@required this.postDocId,
      @required this.post,
      @required this.uImage,
      @required this.commentOnPost,
      @required this.addLike,
      @required this.deleteLike,
      @required this.likesStream,
      @required this.commentStream,
      @required this.likeButtonStream});

  @override
  Widget build(BuildContext context) {
    print('BuildPostItem');
    return Card(
      elevation: 8.0,
      margin: const EdgeInsets.symmetric(horizontal: 8.0),
      shape: const OutlineInputBorder(
        borderRadius: BorderRadius.all(
          Radius.circular(8.0),
        ),
        borderSide: const BorderSide(color: transparentColor),
      ),
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
                mediumHorizontalDistance(),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        post.uName,
                        style: Theme.of(context)
                            .textTheme
                            .bodyText2
                            .copyWith(height: 1.4),
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
                // SizedBox(),
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
            buildDefaultDivider(height: 10.0),
            if (post.postText != '')
              Text(
                post.postText,
                style: Theme.of(context).textTheme.subtitle1,
                textAlign: TextAlign.justify,
              ),
            if (post.postImage != '') minimumVerticalDistance(),
            if (post.postImage != '')
              ClipRRect(
                borderRadius: const BorderRadius.all(
                  Radius.circular(8.0),
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
                    StreamBuilder<QuerySnapshot>(
                      stream: likesStream,
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
                    StreamBuilder<QuerySnapshot>(
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
            buildDefaultDivider(height: 10.0),
            minimumVerticalDistance(),
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                BuildUserCircleImage(
                  image: NetworkImage(uImage ?? errorImage),
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
                  stream: likeButtonStream,
                  builder: (context, docSnapshot) {
                    print('like button stream');
                    if (!docSnapshot.hasData) {
                      return const Icon(
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
                        onClick: addLike,
                      );
                    } else {
                      return BuildReactButton(
                        icon: Icons.favorite_border,
                        iconColor: greyColor,
                        onClick: deleteLike,
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

// Future<void> _addLikes(bool liked) async {
//   // / LikeModel likeModel = LikeModel(
//   //   liked: true,
//   //   uName: uName,
//   //   uImage: uImage
//   // );
//   var ref = FirebaseHelper.firestoreHelper
//       .collection(postsCollection)
//       .doc(postDocId)
//       .collection(likesCollection)
//       .doc(UserIdHelper.currentUid);
//   liked = !liked;
//   if (liked) {
//     await ref.set({
//       'liked': true,
//     });
//   } else {
//     await ref.delete();
//   }
// }
}
