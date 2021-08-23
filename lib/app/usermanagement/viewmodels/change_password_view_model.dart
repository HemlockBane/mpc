import 'dart:async';

import 'package:get_it/get_it.dart';
import 'package:moniepoint_flutter/app/usermanagement/model/data/change_password_request_body.dart';
import 'package:moniepoint_flutter/app/usermanagement/model/usermanagement_service_delegate.dart';
import 'package:moniepoint_flutter/core/network/resource.dart';
import 'package:moniepoint_flutter/core/validators.dart';
import 'package:moniepoint_flutter/core/viewmodels/base_view_model.dart';
import 'package:rxdart/rxdart.dart';

class ChangePasswordViewModel extends BaseViewModel with Validators {

  late final UserManagementServiceDelegate _delegate;
  final ChangePasswordRequestBody _requestBody = ChangePasswordRequestBody();

  late final Stream<bool> _isValid;
  Stream<bool> get isValid => _isValid;

  StreamController<String> _oldPasswordController = StreamController.broadcast();
  Stream<String?> get oldPasswordStream => _oldPasswordController.stream;

  StreamController<String> _newPasswordController = StreamController.broadcast();
  Stream<String?> get newPasswordStream => _newPasswordController.stream;

  ChangePasswordViewModel({UserManagementServiceDelegate? delegate}){
    this._delegate = delegate ?? GetIt.I<UserManagementServiceDelegate>();

    this._isValid = Rx.combineLatest([oldPasswordStream, newPasswordStream], (values) {
      return _isOldPasswordValid(displayError: false)
          && _isNewPasswordValid(displayError: false);
    }).asBroadcastStream();
  }

  void onOldPasswordChanged(String? oldPassword) {
    _requestBody.oldPassword = oldPassword;
    _oldPasswordController.sink.add(oldPassword ?? "");
    _isOldPasswordValid(displayError: true);
  }

  bool _isOldPasswordValid({bool displayError = false}) {
    final isValid = _requestBody.oldPassword != null && _requestBody.oldPassword?.isNotEmpty == true;
    if (isValid) return true;
    if (displayError && !isValid) _oldPasswordController.sink.addError("Your previous password is required.");
    return false;
  }

  void onNewPasswordChanged(String? oldPassword) {
    _requestBody.newPassword = oldPassword;
    _newPasswordController.sink.add(oldPassword ?? "");
    _isNewPasswordValid(displayError: true);
  }

  bool _isNewPasswordValid({bool displayError = false}) {
    final validator = validatePasswordWithMessage(_requestBody.newPassword);
    if (validator.first) return true;
    if (displayError && !validator.first) _newPasswordController.sink.addError(validator.second?.first ?? "");
    return false;
  }

  Stream<Resource<bool>> changePassword() => _delegate.changePassword(_requestBody);

  @override
  void dispose() {
    _oldPasswordController.close();
    _newPasswordController.close();
    super.dispose();
  }
}