import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';

class FirebaseHelper {
  static FirebaseAuth authHelper = FirebaseAuth.instance;
  static FirebaseFirestore firestoreHelper = FirebaseFirestore.instance;
  static FirebaseStorage storageHelper = FirebaseStorage.instance;
}
