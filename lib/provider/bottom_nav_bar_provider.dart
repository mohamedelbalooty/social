import 'package:flutter/material.dart';
import 'package:social_app/states/bottom_nav_bar_states.dart';

class BottomNavBarProvider extends ChangeNotifier {
  BottomNavBarStates bottomNavBarStates = BottomNavBarStates.InitialState;

  int selectedNavBarScreenIndex = 0;

  void changeSelectedNavBarScreenIndex(int value) {
    if (value == 2) {
      bottomNavBarStates = BottomNavBarStates.NewPostState;
    }else{
      selectedNavBarScreenIndex = value;
      bottomNavBarStates = BottomNavBarStates.InitialState;
    }
    notifyListeners();
  }
}
