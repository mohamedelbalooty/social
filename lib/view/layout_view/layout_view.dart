import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:social_app/icon_broken.dart';
import 'package:social_app/provider/bottom_nav_bar_provider.dart';
import 'package:social_app/states/bottom_nav_bar_states.dart';
import 'package:social_app/view/chats_view/chats_view.dart';
import 'package:social_app/view/home_view/home_view.dart';
import 'package:social_app/view/new_post_view/new_post_view.dart';
import 'package:social_app/view/settings_view/settings_view.dart';
import 'package:social_app/view/users/users_view.dart';
import '../app_components.dart';
import 'layout_view_components.dart';

class LayoutView extends StatelessWidget {
  static const String id = 'LayoutView';

  final List<Widget> _layoutScreens = [
    FeedsView(),
    ChatsView(),
    NewPostView(),
    UsersView(),
    SettingsView(),
  ];

  final List<String> _screensTitles = [
    'Home',
    'Chats',
    'New Post',
    'Users',
    'Settings'
  ];

  @override
  Widget build(BuildContext context) {
    return Consumer<BottomNavBarProvider>(
      builder: (context, provider, child) {
        return Scaffold(
          appBar: AppBar(
            title: Text(_screensTitles[provider.selectedNavBarScreenIndex]),
            actions: [
              BuildDefaultIconButton(
                icon: Icon(IconBroken.Search),
                onClick: () {},
              ),
              BuildDefaultIconButton(
                icon: Icon(IconBroken.Notification),
                onClick: () {},
              ),
            ],
          ),
          body: _layoutScreens[provider.selectedNavBarScreenIndex],
          bottomNavigationBar: BuildBottomNavBar(
            currentIndex: provider.selectedNavBarScreenIndex,
            onClick: (int selectedValue) {
              provider.changeSelectedNavBarScreenIndex(selectedValue);
              if(provider.bottomNavBarStates == BottomNavBarStates.NewPostState){
                namedNavigateTo(context, NewPostView.id);
              }
            },
          ),
        );
      },
    );
  }
}
