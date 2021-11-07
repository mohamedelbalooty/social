import 'firebase_helper.dart';

class UserIdHelper {
  static String currentUid = FirebaseHelper.authHelper.currentUser.uid;
}
