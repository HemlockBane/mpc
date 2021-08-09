import 'package:moniepoint_flutter/core/tuple.dart';

mixin Validators {
  ///Validates the password and append the error message
  /// if the password is valid Tuple.second is empty
  Tuple<bool, List<String>?> validatePasswordWithMessage(String? password) {
    List<String>? passwordErrors = [];
    bool isValid = false;

    if (password == null || password.isEmpty) {
      passwordErrors.add("Enter a valid password");
    }
    if (password != null && password.length < 8) {
      passwordErrors.add("Password must be at least 8 characters");
    }
    if (password != null && !RegExp(r".*[!@$%^&*()_+=\-\[\]{};':.<>\\/?`~].*").hasMatch(password)) {
      passwordErrors.add("Password must have at least one special character");
    }
    if (password != null &&  !RegExp(r".*[A-Z].*").hasMatch(password)) {
      passwordErrors.add("Password must have at least one UPPERCASE character");
    }
    if (password != null &&  !RegExp(r".*[0-9].*").hasMatch(password)) {
      passwordErrors.add("Password must have at least one number");
    }
    if(password != null && passwordErrors.isEmpty) {
      isValid = true;
      passwordErrors = null;
    }
    return Tuple(isValid, passwordErrors);
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
    final reg = RegExp("^(\\+234[7-9]|234[7-9]|08|09|07)\\d{9}\$");
    return reg.hasMatch(text.replaceAll(RegExp("\\s"), "").trim());
  }

  bool isEmailValid(String? text) {
    if(text == null) return false;
    return RegExp(r"^[a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,253}[a-zA-Z0-9])?(?:\.[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,253}[a-zA-Z0-9])?)*$").hasMatch(text);
  }
}