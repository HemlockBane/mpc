import 'package:moniepoint_flutter/core/tuple.dart';

mixin Validators {
  ///Validates the password and append the error message
  /// if the password is valid Tuple.second is empty
  Tuple<bool, String?> validatePasswordWithMessage(String? password) {
    String? passwordError;
    bool isValid = false;

    if (password == null || password.isEmpty) {
      passwordError = "Enter a valid password";
    } else if (password.length < 8) {
      passwordError = "Password must be at least 8 characters";
    }
    else if (!RegExp(r".*[!@$%^&*()_+=\-\[\]{};':.<>\\/?`~].*").hasMatch(password)) {
      passwordError = "Password must have at least one special character";
    }
    else if (!RegExp(r".*[A-Z].*").hasMatch(password)) {
      passwordError = "Password must have at least one UPPERCASE character";
    } else if (!RegExp(r".*[0-9].*").hasMatch(password)) {
      passwordError = "Password must have at least one number";
    } else {
      isValid = true;
      passwordError = null;
    }
    return Tuple(isValid, passwordError);
  }

  bool isBVNValid(String? text) {
    if(text == null) return false;
    if(text.isEmpty || text.length < 11) return false;
    return true;
  }

  bool isAccountNumberValid(String? text) {
    if(text == null) return false;
    if(text.isEmpty || text.length < 10) return false;
    return true;
  }

  bool isPhoneNumberValid(String? text) {
    if(text == null) return false;
    if (text.length < 10) return false;
    final code = text.substring(0, 4);
    if(code.contains("+234") && text.length >= 14){
      return true;
    }
    else if(code.contains("234") && text.length >= 13){
      return true;
    }
    else if(!code.contains("234") && text.length == 11) {
      return true;
    }
    return false;
  }

  bool isEmailValid(String? text) {
    if(text == null) return false;
    return RegExp(r"^[a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,253}[a-zA-Z0-9])?(?:\.[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,253}[a-zA-Z0-9])?)*$").hasMatch(text);
  }
}