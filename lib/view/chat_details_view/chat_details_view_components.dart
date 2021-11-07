import 'package:flutter/material.dart';
import '../../icon_broken.dart';
import '../app_components.dart';

AppBar buildChatDetailsViewAppBar(
  BuildContext context, {
  @required String uImage,
  @required String uName,
}) {
  return AppBar(
    titleSpacing: 0.0,
    title: Row(
      children: [
        BuildUserCircleImage(
          image: NetworkImage(uImage),
          imageRadius: 15.0,
        ),
        mediumHorizontalDistance(),
        Text(
          uName,
          style: Theme.of(context).textTheme.subtitle1,
        ),
      ],
    ),
    leading: BuildDefaultIconButton(
      icon: const Icon(IconBroken.Arrow___Left_2),
      onClick: () {
        Navigator.pop(context);
      },
    ),
  );
}

class BuildChatBubble extends StatelessWidget {
  final Color color;
  final String chatText, chatImage;
  final Radius bubbleRadiusSender, bubbleRadiusReceiver;
  final AlignmentGeometry bubbleDirection;
  final CrossAxisAlignment bubbleAxisDirection;

  const BuildChatBubble({
    @required this.color,
    @required this.bubbleRadiusSender,
    @required this.bubbleRadiusReceiver,
    @required this.bubbleDirection,
    @required this.bubbleAxisDirection,
    this.chatText,
    this.chatImage,
  });

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: bubbleDirection,
      child: Column(
        crossAxisAlignment: bubbleAxisDirection,
        children: [
          if (chatText != null)
          Container(
            constraints: BoxConstraints(
              maxWidth: (MediaQuery.of(context).size.width / 2) - 40.0,
            ),
            padding:
                const EdgeInsets.all(10.0),
            decoration: BoxDecoration(
              color: color,
              borderRadius: BorderRadiusDirectional.only(
                  topStart: Radius.circular(8.0),
                  topEnd: Radius.circular(8.0),
                  bottomEnd: bubbleRadiusSender,
                  bottomStart: bubbleRadiusReceiver),
            ),
            child: Text(
              chatText,
              style: Theme.of(context).textTheme.subtitle1.copyWith(
                    fontSize: 12.0,
                    fontWeight: FontWeight.normal,
                  ),
            ),
          ),
          if (chatImage != null)
          minimumVerticalDistance(),
          if (chatImage != null)
            Container(
              height: 80.0,
              width: (MediaQuery.of(context).size.width / 2) - 40.0,
              decoration: BoxDecoration(
                color: color,
                borderRadius: BorderRadiusDirectional.only(
                    topStart: Radius.circular(8.0),
                    topEnd: Radius.circular(8.0),
                    bottomEnd: bubbleRadiusSender,
                    bottomStart: bubbleRadiusReceiver),
                image: DecorationImage(
                  image: NetworkImage(
                    chatImage,
                  ),
                  fit: BoxFit.cover,
                ),
              ),
            ),
        ],
      ),
    );
  }
}
