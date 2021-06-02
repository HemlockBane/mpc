import 'dart:async';

import 'package:get_it/get_it.dart';
import 'package:moniepoint_flutter/app/usermanagement/model/data/change_password_request_body.dart';
import 'package:moniepoint_flutter/app/usermanagement/model/data/change_pin_request_body.dart';
import 'package:moniepoint_flutter/app/usermanagement/model/usermanagement_service_delegate.dart';
import 'package:moniepoint_flutter/core/network/resource.dart';
import 'package:moniepoint_flutter/core/validators.dart';
import 'package:moniepoint_flutter/core/viewmodels/base_view_model.dart';
import 'package:rxdart/rxdart.dart';

class ChangePinViewModel extends BaseViewModel with Validators {

  late final UserManagementServiceDelegate _delegate;
  final ChangePinRequestBody _requestBody = ChangePinRequestBody();

  late final Stream<bool> _isValid;
  Stream<bool> get isValid => _isValid;

  StreamController<String> _oldPinController = StreamController.broadcast();
  Stream<String?> get oldPinStream => _oldPinController.stream;

  StreamController<String> _newPinController = StreamController.broadcast();
  Stream<String?> get newPinStream => _newPinController.stream;

  ChangePinViewModel({UserManagementServiceDelegate? delegate}){
    this._delegate = delegate ?? GetIt.I<UserManagementServiceDelegate>();

    this._isValid = Rx.combineLatest([oldPinStream, newPinStream], (values) {
      return _isOldPinValid(displayError: false)
          && _isNewPinValid(displayError: false);
    }).asBroadcastStream();
  }

  void onOldPinChanged(String? oldPin) {
    _requestBody.oldPin = oldPin;
    _oldPinController.sink.add(oldPin ?? "");
    _isOldPinValid(displayError: true);
  }

  bool _isOldPinValid({bool displayError = false}) {
    final isValid = _requestBody.oldPin != null
        && _requestBody.oldPin?.isNotEmpty == true
        && _requestBody.oldPin?.length == 4;
    if (isValid) return true;
    if (displayError && !isValid) _oldPinController.sink.addError(
        (_requestBody.oldPin?.isEmpty == true )
            ? "Old PIN is required."
            : "Invalid Old PIN"
    );
    return false;
  }

  void onNewPinChanged(String? oldPin) {
    _requestBody.newPin = oldPin;
    _newPinController.sink.add(oldPin ?? "");
    _isNewPinValid(displayError: true);
  }

  bool _isNewPinValid({bool displayError = false}) {
    final isValid = _requestBody.newPin != null
        && _requestBody.newPin?.isNotEmpty == true
        && _requestBody.newPin?.length == 4;
    if (isValid) return true;
    if (displayError && !isValid) _newPinController.sink.addError(
        (_requestBody.newPin?.isEmpty == true )
            ? "New PIN is required."
            : "Invalid New PIN"
    );
    return false;
  }

  Stream<Resource<bool>> changePin() => _delegate.changePin(_requestBody);

  @override
  void dispose() {
    _oldPinController.close();
    _newPinController.close();
    super.dispose();
  }
}