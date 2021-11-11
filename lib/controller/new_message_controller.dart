import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:social_app/constants/firestore_constants.dart';
import 'package:social_app/helper/firebase_helper.dart';
import 'package:social_app/helper/image_picker_helper.dart';
import 'package:social_app/model/message_model.dart';
import 'package:social_app/states/new_message_controller_states.dart';

class NewMessageController extends ChangeNotifier {
  NewMessageControllerSendMessageStates newMessageControllerSendMessageStates;
  NewMessageControllerPickMessageImageStates
      newMessageControllerPickMessageImageStates;

  String get errorMessage => _errorMessage;
  String _errorMessage;

  File get messageImage => _messageImage;
  File _messageImage;

  Future<void> pickMessageImage() async {
    var _pickedFile = await ImagePickerHelper.picker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 80,
    );
    if (_pickedFile != null) {
      _messageImage = File(_pickedFile.path);
      newMessageControllerPickMessageImageStates =
          NewMessageControllerPickMessageImageStates
              .MessageImagePickedSuccessState;
    } else {
      _errorMessage = 'An error occurred while taking the photo !';
      newMessageControllerPickMessageImageStates =
          NewMessageControllerPickMessageImageStates
              .MessageImagePickedErrorState;
    }
    notifyListeners();
  }

  void removePickedImage() {
    _messageImage = null;
    notifyListeners();
  }

  Future<void> uploadMessageImage(
      {@required String senderId,
      @required String receiverId,
      @required String messageText,
      @required String messageDateTime,
      @required Timestamp messageTime}) async {
    newMessageControllerSendMessageStates =
        NewMessageControllerSendMessageStates.SendImageMessageLoadingState;
    notifyListeners();
    try {
      final reference = FirebaseHelper.storageHelper
          .ref()
          .child('users/${Uri.file(_messageImage.path).pathSegments.last}');
      await reference.putFile(_messageImage);
      await reference.getDownloadURL().then((value) async {
        await sendMessage(
            senderId: senderId,
            receiverId: receiverId,
            messageText: messageText,
            messageImage: value,
            messageDateTime: messageDateTime,
            messageTime: messageTime);
        newMessageControllerSendMessageStates =
            NewMessageControllerSendMessageStates.SendMessageSuccessState;
        notifyListeners();
      }).catchError((downloadException) {
        _errorMessage = 'Error when image downloaded !';
        newMessageControllerSendMessageStates =
            NewMessageControllerSendMessageStates.SendMessageErrorState;
        notifyListeners();
      });
    } catch (uploadException) {
      _errorMessage = 'Error when image uploaded !';
      newMessageControllerSendMessageStates =
          NewMessageControllerSendMessageStates.SendMessageErrorState;
      notifyListeners();
    }
    _messageImage = null;
    notifyListeners();
  }

  Future<void> sendMessage(
      {@required String senderId,
      @required String receiverId,
      @required String messageText,
      @required String messageImage,
      @required String messageDateTime,
      @required Timestamp messageTime}) async {
    MessageModel message = MessageModel(
        senderId: senderId,
        receiverId: receiverId,
        messageText: messageText,
        messageImage: messageImage,
        messageDateTime: messageDateTime,
        messageTime: messageTime);
    try {
      await FirebaseHelper.firestoreHelper
          .collection(usersCollection)
          .doc(senderId)
          .collection(chatsCollection)
          .doc(receiverId)
          .collection(messagesCollection)
          .add(message.toJson());
      await FirebaseHelper.firestoreHelper
          .collection(usersCollection)
          .doc(receiverId)
          .collection(chatsCollection)
          .doc(senderId)
          .collection(messagesCollection)
          .add(message.toJson());
      newMessageControllerSendMessageStates =
          NewMessageControllerSendMessageStates.SendMessageSuccessState;
    } catch (error) {
      newMessageControllerSendMessageStates =
          NewMessageControllerSendMessageStates.SendMessageErrorState;
    }
    notifyListeners();
  }
}
