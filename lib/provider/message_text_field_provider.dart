import 'package:flutter/material.dart';

class MessageTextFieldProvider extends ChangeNotifier{
  String textFieldContent = '';
  void onChangeTextContent(String value){
    textFieldContent = value;
    notifyListeners();
  }
}