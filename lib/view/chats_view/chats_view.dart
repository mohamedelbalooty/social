import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:social_app/controller/chat_controller.dart';
import 'package:social_app/states/chats_controller_states.dart';
import 'package:social_app/view/app_components.dart';
import 'package:social_app/view/messages_view/messages_view.dart';
import 'chat_view_components.dart';

class ChatsView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<ChatsController>(
      builder: (context, provider, child) {
        if (provider.chatsControllerGetUsersStates ==
            ChatsControllerGetUsersStates.InitialState) {
          provider.getUsers();
          return buildCircularLoadingWidget();
        } else if (provider.chatsControllerGetUsersStates ==
            ChatsControllerGetUsersStates.LoadingState) {
          return buildCircularLoadingWidget();
        } else if (provider.chatsControllerGetUsersStates ==
            ChatsControllerGetUsersStates.LoadedState) {
          if (provider.users.length != 0) {
            return ListView.separated(
              physics: const BouncingScrollPhysics(),
              itemCount: provider.users.length,
              itemBuilder: (_, index) {
                return BuildUserChatItem(
                  uName: provider.users[index].name,
                  uImage: provider.users[index].profileImageUrl,
                  onClick: () {
                    materialNavigateTo(
                      context,
                      MessagesView(
                        receiverUser: provider.users[index],
                      ),
                    );
                  },
                );
              },
              separatorBuilder: (_, index) => Padding(
                padding: const EdgeInsets.only(
                    left: 20.0, right: 20.0, bottom: 10.0),
                child: buildDefaultDivider(),
              ),
            );
          } else {
            return BuildEmptyListWidget(
              title: 'No users available yet.',
            );
          }
        } else {
          return BuildErrorResultWidget(
            errorImage: provider.errorResult.errorImage,
            errorMessage: provider.errorResult.errorMessage,
          );
        }
      },
    );
  }
}
