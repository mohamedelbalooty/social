import 'package:conditional_builder/conditional_builder.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:social_app/constants/colors_constants.dart';
import 'package:social_app/controller/messages_controller.dart';
import 'package:social_app/controller/new_message_controller.dart';
import 'package:social_app/controller/user_profile_controller.dart';
import 'package:social_app/model/message_model.dart';
import 'package:social_app/model/user_model.dart';
import 'package:social_app/states/new_message_controller_states.dart';
import 'package:social_app/view/app_components.dart';
import 'chat_details_view_components.dart';

class ChatDetailsView extends StatelessWidget {
  static const String id = 'ChatDetailsView';
  final UserModel receiverUser;

  ChatDetailsView({@required this.receiverUser});

  final TextEditingController _chatController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    String senderId = context.select<UserProfileController, String>(
        (value) => value.userProfileData.uid);
    return Scaffold(
      appBar: buildChatDetailsViewAppBar(
        context,
        uImage: receiverUser.profileImageUrl,
        uName: receiverUser.name,
      ),
      body: Builder(
        builder: (context) {
          Provider.of<MessagesController>(context, listen: false)
              .getMessages(senderId: senderId, receiverId: receiverUser.uid);
          return Consumer<MessagesController>(
            builder: (context, provider, child) {
              print('build MessagesController consumer');
              return ConditionalBuilder(
                condition: provider.messages.length > 0,
                builder: (_) => Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20.0),
                  child: Column(
                    children: [
                      Expanded(
                        child: ListView.separated(
                          physics: const BouncingScrollPhysics(),
                          reverse: true,
                          itemCount: provider.messages.length,
                          itemBuilder: (_, index) {
                            if (senderId == provider.messages[index].senderId) {
                              return _senderMessageBubble(
                                  message: provider.messages[index]);
                            }
                            return _receiverMessageBubble(
                                message: provider.messages[index]);
                          },
                          separatorBuilder: (_, index) =>
                              minimumVerticalDistance(),
                        ),
                      ),
                      minimumVerticalDistance(),
                      Consumer<NewMessageController>(
                        builder: (context, provider, child) {
                          print('build NewMessageController consumer');
                          return BuildWriteContentWidget(
                            contentController: _chatController,
                            pickContentImage: () async {
                              await provider.pickMessageImage();
                              if (provider
                                      .newMessageControllerPickMessageImageStates ==
                                  NewMessageControllerPickMessageImageStates
                                      .MessageImagePickedErrorState) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  buildDefaultSnackBar(
                                    context,
                                    key: UniqueKey(),
                                    contentText: provider.errorMessage,
                                  ),
                                );
                              }
                            },
                            sendContent: () async {
                              if (provider.messageImage != null) {
                                await provider.uploadMessageImage(
                                  senderId: senderId,
                                  receiverId: receiverUser.uid,
                                  messageText: _chatController.text,
                                  messageTime: DateTime.now().toString(),
                                );
                              } else {
                                await provider.sendMessage(
                                  senderId: senderId,
                                  receiverId: receiverUser.uid,
                                  messageText: _chatController.text,
                                  messageImage: '',
                                  messageTime: DateTime.now().toString(),
                                );
                              }
                              if (provider
                                      .newMessageControllerSendMessageStates ==
                                  NewMessageControllerSendMessageStates
                                      .SendMessageErrorState) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  buildDefaultSnackBar(
                                    context,
                                    key: UniqueKey(),
                                    contentText: provider.errorMessage,
                                  ),
                                );
                              }
                              _chatController.clear();
                            },
                          );
                        },
                      ),
                    ],
                  ),
                ),
                fallback: (_) => BuildEmptyListWidget(
                  title: 'No users available yet.',
                ),
              );
            },
          );
        },
      ),
    );
  }

  BuildMessageBubble _senderMessageBubble({@required MessageModel message}) =>
      BuildMessageBubble(
        color: mainColor.withOpacity(0.2),
        messageText: message.messageText,
        bubbleDirection: AlignmentDirectional.centerEnd,
        bubbleAxisDirection: CrossAxisAlignment.end,
        bubbleRadiusSender: Radius.zero,
        bubbleRadiusReceiver: Radius.circular(8.0),
        messageImage: message.messageImage,
      );

  BuildMessageBubble _receiverMessageBubble({@required MessageModel message}) =>
      BuildMessageBubble(
        color: greyColor.withOpacity(0.5),
        messageText: message.messageText,
        bubbleDirection: AlignmentDirectional.centerStart,
        bubbleAxisDirection: CrossAxisAlignment.start,
        bubbleRadiusSender: Radius.circular(8.0),
        bubbleRadiusReceiver: Radius.zero,
        messageImage: message.messageImage,
      );
}
