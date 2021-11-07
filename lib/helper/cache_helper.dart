import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CacheHelper {
  static SharedPreferences preferences;

  static initializePreferences() async {
    preferences = await SharedPreferences.getInstance();
  }

  static Future<bool> setToken(
      {@required String tokenKey, @required String tokenValue}) async {
    print('set token');
    return await preferences.setString(tokenKey, tokenValue);
  }

  static String getToken(String tokenKey) {
    return preferences.getString(tokenKey);
  }
}
