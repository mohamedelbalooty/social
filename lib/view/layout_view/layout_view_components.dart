import 'package:flutter/material.dart';
import 'package:social_app/constants/colors_constants.dart';
import '../../icon_broken.dart';

class BuildBottomNavBar extends StatelessWidget {
  final int currentIndex;
  final Function onClick;

  const BuildBottomNavBar(
      {@required this.currentIndex, @required this.onClick});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        border: Border(
            top: BorderSide(
          color: greyColor,
          width: 1.5,
        )),
      ),
      child: BottomNavigationBar(
        key: UniqueKey(),
        currentIndex: currentIndex,
        onTap: onClick,
        fixedColor: mainColor,
        unselectedFontSize: 12.0,
        iconSize: 24.0,
        items: [
          _buildBottomNavigationBarItem(
            icon: Icon(IconBroken.Home),
            label: 'Home',
          ),
          _buildBottomNavigationBarItem(
            icon: Icon(IconBroken.Chat),
            label: 'Chat',
          ),
          _buildBottomNavigationBarItem(
            icon: Icon(IconBroken.Paper_Download),
            label: 'Post',
          ),
          _buildBottomNavigationBarItem(
            icon: Icon(IconBroken.User1),
            label: 'Users',
          ),
          _buildBottomNavigationBarItem(
            icon: Icon(IconBroken.Setting),
            label: 'Settings',
          ),
        ],
      ),
    );
  }

  BottomNavigationBarItem _buildBottomNavigationBarItem(
      {@required Icon icon, @required String label}) {
    return BottomNavigationBarItem(
      icon: icon,
      label: label,
    );
  }
}
