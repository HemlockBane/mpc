import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:moniepoint_flutter/app/login/model/data/user.dart';
import 'package:moniepoint_flutter/core/login_mode.dart';
import 'package:moniepoint_flutter/core/models/user_instance.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PreferenceUtil {
  static const String LOGGED_IN_USER_KEY = "logged_in_user";
  static const String LOGGED_IN_USER_NAME = "logged_in_user_name";
  static const String HIDE_ACCOUNT_BAL = "hide_account_balance";
  static const String SYSTEM_CONFIG = "system-configuration";
  static const String USSD_CONFIG = "ussd-configuration";
  static const String LIVELINESS_CONFIG = "liveliness-configuration";
  static const String FINGER_PRINT_ENABLED = "is_finger_print_enabled";
  static const String FINGER_PRINT_USERNAME = "finger_print_username";
  static const String FINGER_PRINT_REQUEST_COUNTER = "finger_request_counter";
  static const String LOGIN_MODE = "login_mode";
  static SharedPreferences? _preferences;

  static initAsync() async  {
    _preferences = await SharedPreferences.getInstance();
  }

  PreferenceUtil.init() {
    SharedPreferences.getInstance().then((value) {
      print("Initialized Preference");
      _preferences = value;
    });
  }

  static void saveLoggedInUser(User user) {
    String userJson = jsonEncode(user);
    _preferences?.setString(LOGGED_IN_USER_KEY, userJson);
  }

  static void deleteLoggedInUser()  {
    _preferences?.remove(LOGGED_IN_USER_KEY);
    // UserInstance().setAccountStatus(null);
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

  static void setLoginMode(LoginMode loginMode) {
    _preferences?.setString(LOGIN_MODE, describeEnum(loginMode));
  }

  static LoginMode getLoginMode()  {
    String? loginMode = _preferences?.getString(LOGIN_MODE);
    return (loginMode != null) ? LoginMode.values.firstWhere((element) => describeEnum(element) == loginMode) : LoginMode.FULL_ACCESS;
  }

  static void saveData(String key, Object? object) {
    String data = jsonEncode(object);
    _preferences?.setString("$key", data);
  }

  static dynamic getData(String key) {
    String? data = _preferences?.getString("$key");
    try {
      return jsonDecode(data ?? "{}");
    } catch(e) {
      return null;
    }
  }

  static void saveDataForLoggedInUser(String appendKey, Object? object) {
    final username = getSavedUsername();
    saveData("$username-$appendKey", object);
  }

  static dynamic getDataForLoggedInUser(String appendKey) {
    final username = getSavedUsername();
    return getData("$username-$appendKey");
  }

  static void saveValueForLoggedInUser<T>(String appendKey, T value) {
    final username = getSavedUsername();

    if(T.toString() == "bool") {
      _preferences?.setBool("$username-$appendKey", value as bool);
      return;
    }
    _preferences?.setString("$username-$appendKey", "$value");
  }

  static T? getValue<T>(String appendKey) {
    if(T.toString() == "bool") return _preferences?.getBool("$appendKey") as T?;
    String? data = _preferences?.getString("$appendKey");
    return data as T?;
  }

  static void saveValue<T>(String appendKey, T value) {
    if(T.toString() == "bool") {
      _preferences?.setBool("$appendKey", value as bool);
      return;
    }
    _preferences?.setString("$appendKey", "$value");
  }

  static T? getValueForLoggedInUser<T>(String appendKey) {
    final username = getSavedUsername();
    if(T.toString() == "bool") return _preferences?.getBool("$username-$appendKey") as T?;
    String? data = _preferences?.getString("$username-$appendKey");
    return data as T?;
  }

  static void clearOutFingerPrintSession() {
    final username = getSavedUsername();
    _preferences?.remove(FINGER_PRINT_USERNAME);
    setFingerPrintEnabled(false);
    _preferences?.remove("$username-$FINGER_PRINT_ENABLED");
    _preferences?.remove("$username-$FINGER_PRINT_REQUEST_COUNTER");
  }

  static void setAuthFingerprintUsername() {
    final username = getSavedUsername();
    if(username == null) return;
    _preferences?.setString(FINGER_PRINT_USERNAME, username);
  }

  static String? getAuthFingerprintUsername() {
    return _preferences?.getString(FINGER_PRINT_USERNAME);
  }

  static void setFingerPrintEnabled(bool isEnabled) {
    final username = getSavedUsername();
    _preferences?.setBool("$username-$FINGER_PRINT_ENABLED", isEnabled);
  }

  static bool getFingerPrintEnabled() {
    final username = getSavedUsername();
    return _preferences?.getBool("$username-$FINGER_PRINT_ENABLED") ?? false;
  }

  static void setFingerprintRequestCounter(int numOfRequest) {
    final username = getSavedUsername();
    _preferences?.setInt("$username-$FINGER_PRINT_REQUEST_COUNTER", numOfRequest);
  }

  static int getFingerprintRequestCounter() {
    final username = getSavedUsername();
    return _preferences?.getInt("$username-$FINGER_PRINT_REQUEST_COUNTER") ?? 0;
  }

  //ios only
  static void setFingerprintPassword(String? password) {
    if(password == null) {
      _preferences?.remove("ios-finger-print-password");
      return;
    }
    _preferences?.setString("ios-finger-print-password", password);
  }

  //ios only
  static String? getFingerprintPassword() {
    return _preferences?.getString("ios-finger-print-password");
  }

  static bool isAccountBalanceHidden(String accountNumber) {
    return getValueForLoggedInUser("$accountNumber-$HIDE_ACCOUNT_BAL") ?? false;
  }

  static void addTaskToIosQueue() {

  }
}
