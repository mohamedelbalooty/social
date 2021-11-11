import 'package:flutter/material.dart';
import 'package:social_app/constants/colors_constants.dart';
import 'package:social_app/view/feeds_view/feeds_view_components.dart';
import '../../icon_broken.dart';
import '../app_components.dart';

class BuildLikesNumberWidget extends StatelessWidget {
  final int likesNumber;

  const BuildLikesNumberWidget({@required this.likesNumber});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 40.0,
      width: double.infinity,
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
          const Spacer(),
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
    return Row(
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
              width: (MediaQuery.of(context).size.width) / 2,
              padding:
                  const EdgeInsets.symmetric(horizontal: 10.0, vertical: 5.0),
              decoration: BoxDecoration(
                color: mainColor.withOpacity(0.4),
                borderRadius: BorderRadius.only(
                  topRight: Radius.circular(8.0),
                  topLeft: Radius.circular(8.0),
                  bottomRight: Radius.circular(8.0),
                  bottomLeft:
                      commentText != '' ? Radius.zero : Radius.circular(8.0),
                ),
              ),
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
                  if (commentText != '') mediumVerticalDistance(),
                  if (commentText != '')
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
            if (commentImage != '')
              const SizedBox(
                height: 2.0,
              ),
            if (commentImage != '')
              ClipRRect(
                borderRadius: const BorderRadius.only(
                  topRight: Radius.circular(8.0),
                  topLeft: Radius.circular(8.0),
                  bottomRight: Radius.circular(8.0),
                ),
                child: BuildCachedNetworkImage(
                  height: 120.0,
                  width: (MediaQuery.of(context).size.width) / 2,
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
    );
  }
}
