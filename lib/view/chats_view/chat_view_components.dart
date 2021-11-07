import 'package:flutter/material.dart';
import 'package:social_app/constants/colors_constants.dart';
import '../app_components.dart';

class BuildUserChatItem extends StatelessWidget {
  final String uImage, uName;
  final Function onClick;

  const BuildUserChatItem(
      {@required this.uName, @required this.uImage, @required this.onClick});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 20.0, right: 20.0, bottom: 10.0),
      child: InkWell(
        onTap: onClick,
        splashColor: mainColor.withOpacity(0.1),
        highlightColor: mainColor.withOpacity(0.2),
        child: Row(
          children: [
            BuildUserCircleImage(
              image: NetworkImage(uImage),
              imageRadius: 22.0,
            ),
            const SizedBox(
              width: 15.0,
            ),
            Text(
              uName,
              style: Theme.of(context)
                  .textTheme
                  .bodyText2
                  .copyWith(height: 1.4),
            ),
          ],
        ),
      ),
    );
  }
}
