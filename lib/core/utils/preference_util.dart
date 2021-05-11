import 'dart:convert';

import 'package:moniepoint_flutter/app/login/model/data/user.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PreferenceUtil {
  static const String LOGGED_IN_USER_KEY = "logged_in_user";
  static const String LOGGED_IN_USER_NAME = "logged_in_user_name";
  static SharedPreferences? _preferences;

  PreferenceUtil.init() {
    SharedPreferences.getInstance().then((value) {
      _preferences = value;
    });
  }

  static void saveLoggedInUser(User user) {
    String userJson = jsonEncode(user);
    _preferences?.setString(LOGGED_IN_USER_KEY, userJson);
  }

  static void deleteLoggedInUser()  {
    _preferences?.remove(LOGGED_IN_USER_KEY);
  }

  static User? getLoggedInUser()  {
    String? userJson = _preferences?.getString(LOGGED_IN_USER_KEY);
    if(userJson == null) return null;
    User loggedInUser = User.fromJson(jsonDecode(userJson));
    return loggedInUser;
  }

  static void saveUsername(String username) {
    _preferences?.setString(LOGGED_IN_USER_NAME, username);
  }

  static String? getSavedUsername()  {
    String? savedUsername = _preferences?.getString(LOGGED_IN_USER_NAME);
    return savedUsername;
  }
}
