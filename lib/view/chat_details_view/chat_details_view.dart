import 'package:cloud_firestore/cloud_firestore.dart';
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
    UserModel senderData = context.select<UserProfileController, UserModel>(
        (value) => value.userProfileData);
    return Scaffold(
      appBar: buildChatDetailsViewAppBar(context,
          uImage: receiverUser.profileImageUrl,
          uName: receiverUser.name, onPop: () {
        Provider.of<NewMessageController>(context, listen: false)
            .removePickedImage();
      }),
      body: Builder(
        builder: (context) {
          Provider.of<MessagesController>(context, listen: false).getMessages(
              senderId: senderData.uid, receiverId: receiverUser.uid);
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10.0),
            child: Consumer<NewMessageController>(
              builder: (context, newMessageControllerProvider, child) {
                return Stack(
                  alignment: Alignment.bottomCenter,
                  children: [
                    Column(
                      children: [
                        Consumer<MessagesController>(
                          builder:
                              (context, messagesControllerProvider, child) {
                            return ConditionalBuilder(
                              condition:
                                  messagesControllerProvider.messages.length >
                                      0,
                              builder: (_) => Expanded(
                                child: ListView.separated(
                                  physics: const BouncingScrollPhysics(),
                                  reverse: true,
                                  itemCount: messagesControllerProvider
                                      .messages.length,
                                  itemBuilder: (_, index) {
                                    if (senderData.uid ==
                                        messagesControllerProvider
                                            .messages[index].senderId)
                                      return _senderMessageBubble(context,
                                          message: messagesControllerProvider
                                              .messages[index],
                                          senderUser: senderData);
                                    return _receiverMessageBubble(
                                        message: messagesControllerProvider
                                            .messages[index],
                                        receiverUser: receiverUser);
                                  },
                                  separatorBuilder: (_, index) =>
                                      mediumVerticalDistance(),
                                ),
                              ),
                              fallback: (_) => Expanded(
                                child: SingleChildScrollView(
                                  child: Column(
                                    children: [
                                      SizedBox(
                                        height:
                                            MediaQuery.of(context).size.height *
                                                0.2,
                                      ),
                                      BuildEmptyListWidget(
                                        title: 'No messages available yet.',
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                        minimumVerticalDistance(),
                        Expanded(
                          flex: 0,
                          child: BuildWriteContentWidget(
                            contentController: _chatController,
                            contentImage: newMessageControllerProvider.messageImage,
                            pickContentImage: () async {
                              await newMessageControllerProvider
                                  .pickMessageImage();
                              if (newMessageControllerProvider
                                      .newMessageControllerPickMessageImageStates ==
                                  NewMessageControllerPickMessageImageStates
                                      .MessageImagePickedErrorState) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  buildDefaultSnackBar(
                                    context,
                                    key: UniqueKey(),
                                    contentText: newMessageControllerProvider
                                        .errorMessage,
                                  ),
                                );
                              }
                            },
                            sendContent: () async {
                              if (newMessageControllerProvider.messageImage !=
                                  null) {
                                await newMessageControllerProvider
                                    .uploadMessageImage(
                                  senderId: senderData.uid,
                                  receiverId: receiverUser.uid,
                                  messageText: _chatController.text,
                                  messageDateTime: DateTime.now().toString(),
                                  messageTime: Timestamp.now(),
                                );
                              } else {
                                await newMessageControllerProvider.sendMessage(
                                  senderId: senderData.uid,
                                  receiverId: receiverUser.uid,
                                  messageText: _chatController.text,
                                  messageImage: '',
                                  messageDateTime: DateTime.now().toString(),
                                  messageTime: Timestamp.now(),
                                );
                              }
                              if (newMessageControllerProvider
                                      .newMessageControllerSendMessageStates ==
                                  NewMessageControllerSendMessageStates
                                      .SendMessageErrorState) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  buildDefaultSnackBar(
                                    context,
                                    key: UniqueKey(),
                                    contentText: newMessageControllerProvider
                                        .errorMessage,
                                  ),
                                );
                              }
                              _chatController.clear();
                            },
                          ),
                        ),
                      ],
                    ),
                    if (newMessageControllerProvider.messageImage != null)
                      Container(
                        width: MediaQuery.of(context).size.width,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.end,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Stack(
                              alignment: AlignmentDirectional.topEnd,
                              children: [
                                ClipRRect(
                                  borderRadius: const BorderRadius.all(
                                    Radius.circular(8.0),
                                  ),
                                  child: Image.file(
                                    newMessageControllerProvider.messageImage,
                                    height: 120.0,
                                    width: 130.0,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                                BuildDefaultCircleIconButton(
                                  icon: Icons.close,
                                  onClick: () {
                                    newMessageControllerProvider
                                        .removePickedImage();
                                  },
                                ),
                              ],
                            ),
                            if (newMessageControllerProvider
                                    .newMessageControllerSendMessageStates ==
                                NewMessageControllerSendMessageStates
                                    .SendImageMessageLoadingState)
                              const SizedBox(
                                height: 2,
                              ),
                            if (newMessageControllerProvider
                                    .newMessageControllerSendMessageStates ==
                                NewMessageControllerSendMessageStates
                                    .SendImageMessageLoadingState)
                              buildLinearLoadingWidget(),
                            const SizedBox(
                              height: 51.0,
                            ),
                            // minimumVerticalDistance(),
                          ],
                        ),
                      ),
                  ],
                );
              },
            ),
          );
        },
      ),

      ///
      // body: StreamBuilder<QuerySnapshot>(
      //   stream: FirebaseHelper.firestoreHelper
      //       .collection(usersCollection)
      //       .doc(senderData.uid)
      //       .collection(chatsCollection)
      //       .doc(receiverUser.uid)
      //       .collection(messagesCollection)
      //       .orderBy('messageTime', descending: true)
      //       .snapshots(),
      //   builder: (context, snapshot){
      //     if(snapshot.connectionState == ConnectionState.waiting){
      //       return buildCircularLoadingWidget();
      //     }else{
      //       List<MessageModel> messages = [];
      //       for (var doc in snapshot.data.docs) {
      //         var data = doc.data();
      //         messages.add(MessageModel.fromJson(data));
      //       }
      //       return Padding(
      //         padding: const EdgeInsets.symmetric(horizontal: 10.0),
      //         child: Column(
      //           children: [
      //             ConditionalBuilder(
      //               condition: messages.length > 0,
      //               builder: (_) => Expanded(
      //                 child: ListView.separated(
      //                   physics: const BouncingScrollPhysics(),
      //                   reverse: true,
      //                   itemCount: messages.length,
      //                   itemBuilder: (_, index) {
      //                     // List<MessageModel> messages = context.select<
      //                     //     MessagesController,
      //                     //     List<MessageModel>>((value) => value.messages);
      //                     return senderMessageBubble(
      //                         messages[index],
      //                         senderData.uid ==
      //                             messages[index].senderId);
      //                     // if (senderData.uid ==
      //                     //     provider.messages[index].senderId)
      //                     //   return _senderMessageBubble(
      //                     //       message: provider.messages[index],
      //                     //       senderUser: senderData);
      //                     // return _receiverMessageBubble(
      //                     //     message: provider.messages[index],
      //                     //     receiverUser: receiverUser);
      //                     // if (senderData.uid ==
      //                     //     provider.messages[index].senderId)
      //                     // return receiverMessageBubble(provider.messages[index]);
      //                     // return senderMessageBubble(provider.messages[index]);
      //                   },
      //                   separatorBuilder: (_, index) =>
      //                       minimumVerticalDistance(),
      //                 ),
      //               ),
      //               fallback: (_) => Expanded(
      //                 child: SingleChildScrollView(
      //                   child: Column(
      //                     children: [
      //                       SizedBox(
      //                         height:
      //                         MediaQuery.of(context).size.height * 0.2,
      //                       ),
      //                       BuildEmptyListWidget(
      //                         title: 'No messages available yet.',
      //                       ),
      //                     ],
      //                   ),
      //                 ),
      //               ),
      //             ),
      //             // if (provider.messages.length == 0) Spacer(),
      //             minimumVerticalDistance(),
      //             Consumer<NewMessageController>(
      //               builder: (context, provider, child) {
      //                 return Expanded(
      //                   flex: 0,
      //                   child: BuildWriteContentWidget(
      //                     contentImage: provider.messageImage,
      //                     contentController: _chatController,
      //                     pickContentImage: () async {
      //                       await provider.pickMessageImage();
      //                       if (provider
      //                           .newMessageControllerPickMessageImageStates ==
      //                           NewMessageControllerPickMessageImageStates
      //                               .MessageImagePickedErrorState) {
      //                         ScaffoldMessenger.of(context).showSnackBar(
      //                           buildDefaultSnackBar(
      //                             context,
      //                             key: UniqueKey(),
      //                             contentText: provider.errorMessage,
      //                           ),
      //                         );
      //                       }
      //                     },
      //                     sendContent: () async {
      //                       if (provider.messageImage != null) {
      //                         await provider.uploadMessageImage(
      //                           senderId: senderData.uid,
      //                           receiverId: receiverUser.uid,
      //                           messageText: _chatController.text,
      //                           // messageTime: DateTime.now().toString(),
      //                           messageTime: Timestamp.now()
      //                         );
      //                       } else {
      //                         await provider.sendMessage(
      //                           senderId: senderData.uid,
      //                           receiverId: receiverUser.uid,
      //                           messageText: _chatController.text,
      //                           messageImage: '',
      //                           // messageTime: DateTime.now().toString(),
      //                           messageTime: Timestamp.now(),
      //                         );
      //                       }
      //                       if (provider
      //                           .newMessageControllerSendMessageStates ==
      //                           NewMessageControllerSendMessageStates
      //                               .SendMessageErrorState) {
      //                         ScaffoldMessenger.of(context).showSnackBar(
      //                           buildDefaultSnackBar(
      //                             context,
      //                             key: UniqueKey(),
      //                             contentText: provider.errorMessage,
      //                           ),
      //                         );
      //                       }
      //                       _chatController.clear();
      //                     },
      //                   ),
      //                 );
      //               },
      //             ),
      //           ],
      //         ),
      //       );
      //     }
      //   },
      // ),
      ///
    );
  }

  Widget _senderMessageBubble(context,
          {@required MessageModel message, @required UserModel senderUser}) =>
      GestureDetector(
        onLongPressStart: (details) {
          double dx = details.globalPosition.dx;
          double dy = details.globalPosition.dy;
          double dx2 = MediaQuery.of(context).size.width - dx;
          double dy2 = MediaQuery.of(context).size.width - dy;
          showMenu(
              context: context,
              position: RelativeRect.fromLTRB(dx, dy, dx2, dy2),
              shape: const OutlineInputBorder(
                borderRadius: BorderRadius.all(
                  Radius.circular(8.0),
                ),
              ),
              // color: Colors.transparent,
              // elevation: 0.0,
              items: [
                PopupMenuItem(
                  child: Text('Hello'),
                ),
                PopupMenuItem(child: Text('Ok')),
              ]);
        },
        child: BuildMessageBubble(
          isSender: true,
          color: mainColor.withOpacity(0.2),
          bubbleDirection: AlignmentDirectional.centerEnd,
          bubbleRowMainAxisDirection: MainAxisAlignment.end,
          bubbleColumnCrossAxisDirection: CrossAxisAlignment.end,
          bubbleRadiusSender: Radius.zero,
          bubbleRadiusReceiver: Radius.circular(8.0),
          messageText: message.messageText,
          messageImage: message.messageImage,
          userImage: senderUser.profileImageUrl,
        ),
      );

  BuildMessageBubble _receiverMessageBubble(
          {@required MessageModel message, @required UserModel receiverUser}) =>
      BuildMessageBubble(
        isSender: false,
        color: greyColor.withOpacity(0.5),
        bubbleDirection: AlignmentDirectional.centerStart,
        bubbleRowMainAxisDirection: MainAxisAlignment.start,
        bubbleColumnCrossAxisDirection: CrossAxisAlignment.start,
        bubbleRadiusSender: Radius.circular(8.0),
        bubbleRadiusReceiver: Radius.zero,
        messageText: message.messageText,
        messageImage: message.messageImage,
        userImage: receiverUser.profileImageUrl,
      );
}
