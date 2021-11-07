import 'package:flutter/material.dart';
import '../app_components.dart';

class ProfileDetailsButton extends StatelessWidget {
  final String details, title;
  final Function onClick;

  const ProfileDetailsButton({@required this.details, @required this.title, @required this.onClick});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: InkWell(
        onTap: onClick,
        child: Column(
          children: [
            Text(
              details,
              style: Theme.of(context)
                  .textTheme
                  .bodyText1
                  .copyWith(fontSize: 16.0, height: 1.2),
            ),
            Text(
              title,
              style: Theme.of(context).textTheme.caption,
            ),
          ],
        ),
      ),
    );
  }
}


class BuildProfileCoverImages extends StatelessWidget {
  final String coverImage;
  final ImageProvider profileImage;
  const BuildProfileCoverImages({@required this.coverImage, @required this.profileImage});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 220.0,
      width: double.infinity,
      child: Stack(
        alignment: Alignment.bottomCenter,
        children: [
          // Align(
          //   alignment: Alignment.topCenter,
          //   child: Container(
          //     height: 130.0,
          //     width: double.infinity,
          //     decoration: BoxDecoration(
          //       borderRadius: const BorderRadius.only(
          //         topLeft: Radius.circular(4.0),
          //         topRight: Radius.circular(4.0),
          //       ),
          //       image: DecorationImage(
          //         image: NetworkImage(coverImage),
          //         fit: BoxFit.cover,
          //       ),
          //     ),
          //   ),
          // ),
          Align(
            alignment: Alignment.topCenter,
            child: ClipRRect(
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(4.0),
                topRight: Radius.circular(4.0),
              ),
              child: BuildCachedNetworkImage(
                url: coverImage,
              ),
            ),
          ),
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
                image: profileImage,
                imageRadius: 0.0,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
