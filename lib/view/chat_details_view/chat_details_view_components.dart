import 'package:flutter/material.dart';
import '../../icon_broken.dart';
import '../app_components.dart';

AppBar buildChatDetailsViewAppBar(BuildContext context,
    {@required String uImage,
    @required String uName,
    @required Function onPop}) {
  return AppBar(
    elevation: 2.0,
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
      icon: const Icon(IconBroken.Arrow___Left),
      onClick: () {
        onPop();
        Navigator.pop(context);
      },
    ),
  );
}

class BuildMessageBubble extends StatelessWidget {
  final Color color;
  final String messageText, messageImage, userImage;
  final Radius bubbleRadiusSender, bubbleRadiusReceiver;
  final AlignmentGeometry bubbleDirection;
  final MainAxisAlignment bubbleRowMainAxisDirection;
  final CrossAxisAlignment bubbleColumnCrossAxisDirection;
  final bool isSender;

  const BuildMessageBubble({
    @required this.color,
    @required this.bubbleRadiusSender,
    @required this.bubbleRadiusReceiver,
    @required this.bubbleDirection,
    @required this.bubbleRowMainAxisDirection,
    @required this.bubbleColumnCrossAxisDirection,
    @required this.userImage,
    @required this.isSender,
    this.messageText,
    this.messageImage,
  });

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: bubbleDirection,
      child: Row(
        mainAxisAlignment: bubbleRowMainAxisDirection,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          if (!isSender)
            BuildUserCircleImage(
                image: NetworkImage(userImage), imageRadius: 10.0),
          if (!isSender) minimumHorizontalDistance(),
          Column(
            crossAxisAlignment: bubbleColumnCrossAxisDirection,
            children: [
              if (messageText != '')
                Container(
                  constraints: BoxConstraints(
                    maxWidth: MediaQuery.of(context).size.width / 2,
                  ),
                  padding: const EdgeInsets.all(10.0),
                  decoration: BoxDecoration(
                    color: color,
                    borderRadius: BorderRadiusDirectional.only(
                        topStart: Radius.circular(8.0),
                        topEnd: Radius.circular(8.0),
                        bottomEnd: bubbleRadiusSender,
                        bottomStart: bubbleRadiusReceiver),
                    // boxShadow: [
                    //   BoxShadow(
                    //     color: Colors.black12,
                    //     offset: Offset(0, 2),
                    //     blurRadius: 5.0,
                    //     spreadRadius: 1.0
                    //   ),
                    // ],
                  ),
                  child: Text(
                    messageText,
                    style: Theme.of(context).textTheme.subtitle1.copyWith(
                          fontSize: 12.0,
                          fontWeight: FontWeight.normal,
                        ),
                  ),
                ),
              if (messageImage != '' && messageText != '')
                minimumVerticalDistance(),
              if (messageImage != '')
                ClipRRect(
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(8.0),
                      topRight: Radius.circular(8.0),
                      bottomRight: bubbleRadiusSender,
                      bottomLeft: bubbleRadiusReceiver),
                  child: BuildCachedNetworkImage(
                    url: messageImage,
                    height: 110.0,
                    width: MediaQuery.of(context).size.width / 2,
                  ),
                ),
            ],
          ),
          if (isSender) minimumHorizontalDistance(),
          if (isSender)
            BuildUserCircleImage(
                image: NetworkImage(userImage), imageRadius: 10.0),
        ],
      ),
    );
  }
}
