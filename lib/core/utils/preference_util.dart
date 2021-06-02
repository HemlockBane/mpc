import 'dart:convert';

import 'package:moniepoint_flutter/app/login/model/data/user.dart';
import 'package:moniepoint_flutter/core/models/user_instance.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PreferenceUtil {
  static const String LOGGED_IN_USER_KEY = "logged_in_user";
  static const String LOGGED_IN_USER_NAME = "logged_in_user_name";
  static const String HIDE_ACCOUNT_BAL = "hide_account_balance";
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
    UserInstance().getUser()?.withAccessToken(null);
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

  static void saveDataForLoggedInUser(String appendKey, Object? object) {
    final username = getSavedUsername();
    String data = jsonEncode(object);
    _preferences?.setString("$username-$appendKey", data);
  }

  static dynamic getDataForLoggedInUser<T>(String appendKey) {
    final username = getSavedUsername();
    String? data = _preferences?.getString("$username-$appendKey");
    return jsonDecode(data ?? "{}");
  }

  static void saveValueForLoggedInUser<T>(String appendKey, T value) {
    final username = getSavedUsername();

    if(T.toString() == "bool") {
      _preferences?.setBool("$username-$appendKey", value as bool);
      return;
    }
    _preferences?.setString("$username-$appendKey", "$value");
  }

  static T? getValueForLoggedInUser<T>(String appendKey) {
    final username = getSavedUsername();
    print(T.toString());
    if(T.toString() == "bool") return _preferences?.getBool("$username-$appendKey") as T?;
    String? data = _preferences?.getString("$username-$appendKey");
    return data as T?;
  }
}
