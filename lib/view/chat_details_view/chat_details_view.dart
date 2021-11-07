import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:social_app/constants/colors_constants.dart';
import 'package:social_app/model/user_model.dart';
import 'package:social_app/view/app_components.dart';
import 'chat_details_view_components.dart';

class ChatDetailsView extends StatelessWidget {
  static const String id = 'ChatDetailsView';
  final UserModel currentUser;
  ChatDetailsView({@required this.currentUser});

  final TextEditingController _chatController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: buildChatDetailsViewAppBar(
        context,
        uImage: currentUser.profileImageUrl,
        uName: currentUser.name,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0),
        child: Column(
          children: [
            // Container(
            //   constraints: BoxConstraints(
            //     maxWidth: MediaQuery.of(context).size.width / 2,
            //   ),
            //   padding:
            //       const EdgeInsets.symmetric(vertical: 5.0, horizontal: 10.0),
            //   decoration: BoxDecoration(
            //     color: greyColor,
            //     borderRadius: BorderRadiusDirectional.only(
            //       topStart: Radius.circular(8.0),
            //       topEnd: Radius.circular(8.0),
            //       bottomEnd: Radius.circular(8.0),
            //       bottomStart: Radius.zero,
            //     ),
            //   ),
            //   child: Text(
            //     'Hello world',
            //     style: Theme.of(context).textTheme.subtitle1.copyWith(
            //           fontSize: 12.0,
            //           fontWeight: FontWeight.normal,
            //         ),
            //   ),
            // ),
            BuildChatBubble(
              color: greyColor.withOpacity(0.5),
              chatText: 'Hello world',
              bubbleDirection: AlignmentDirectional.centerStart,
              bubbleAxisDirection: CrossAxisAlignment.start,
              bubbleRadiusSender: Radius.circular(8.0),
              bubbleRadiusReceiver: Radius.zero,
              // chatImage: testTwo,
            ),
            BuildChatBubble(
              color: mainColor.withOpacity(0.2),
              chatText: 'Hello Medo',
              bubbleDirection: AlignmentDirectional.centerEnd,
              bubbleAxisDirection: CrossAxisAlignment.end,
              bubbleRadiusSender: Radius.zero,
              bubbleRadiusReceiver: Radius.circular(8.0),
              chatImage: testTwo,
            ),
            Spacer(),
            BuildWriteContentWidget(
              contentController: _chatController,
              pickContentImage: (){},
              sendContent: (){},
            ),
          ],
        ),
      ),
    );
  }
}
