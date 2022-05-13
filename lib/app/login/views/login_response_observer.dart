import 'package:flutter/material.dart';
import 'package:moniepoint_flutter/app/login/model/data/user.dart';
import 'package:moniepoint_flutter/app/login/viewmodels/login_view_model.dart';
import 'package:moniepoint_flutter/app/login/views/recovery/recovery_controller_screen.dart';
import 'package:moniepoint_flutter/core/login_mode.dart';
import 'package:moniepoint_flutter/core/network/resource.dart';
import 'package:moniepoint_flutter/core/network/response_observer.dart';
import 'package:moniepoint_flutter/core/routes.dart';
import 'package:moniepoint_flutter/core/utils/call_utils.dart';
import 'package:moniepoint_flutter/core/utils/dialog_util.dart';
import 'package:moniepoint_flutter/core/utils/preference_util.dart';
import 'package:moniepoint_flutter/core/views/bottom_sheet.dart';

class LoginResponseObserver extends ResponseObserver<Resource<User>>{

  LoginResponseObserver({
    required BuildContext context,
    this.passwordController,
    required this.viewModel,
    this.setState
  }): super(context: context);

  final LoginViewModel viewModel;
  final TextEditingController? passwordController;
  final Function()? setState;

  void observe(Resource<User> event) {
    if (event is Loading) {
      viewModel.isLoggingIn = true;
      updateResponseState(ResponseState.LOADING);
    }
    if (event is Error<User>) {
      viewModel.isLoggingIn = false;
      setState?.call();
      passwordController?.clear();
      updateResponseState(ResponseState.ERROR);

      if (event.message?.contains("version") == true) {
        showInfo(
            context,
            title: "Update Moniepoint App",
            message: event.message ?? "",
            primaryButtonText: "Upgrade App",
            onPrimaryClick: () {
              Navigator.of(context).pop();
              openUrl(viewModel.getApplicationPlayStoreUrl());
            }
        );
      } else {
        showError(
            context,
            title: "Login Failed!",
            message: event.message ?? "",
            displayDismissButton: false
        );
      }
    }
    if (event is Success<User>) {
      viewModel.isLoggingIn = false;
      passwordController?.clear();
      updateResponseState(ResponseState.SUCCESS);
      PreferenceUtil.setLoginMode(LoginMode.FULL_ACCESS);
      PreferenceUtil.saveLoggedInUser(event.data!);
      PreferenceUtil.saveUsername(event.data?.username ?? "");
      checkSecurityFlags(event.data!);
    }
  }

  void checkSecurityFlags(User user) async {
    if (user.registerDevice == true) {
      viewModel.isLoggingIn = false;
      setState?.call();
      showModalBottomSheet(
          context: context,
          backgroundColor: Colors.transparent,
          builder: (b) => BottomSheets.displayInfoDialog(context,
              message: "Your login was successful, but this device is not recognized.",
              title: "Device not recognized",
              primaryButtonText: "Register Device",
              secondaryButtonText: "Dismiss",
              onPrimaryClick: () async {
                Navigator.of(context).popAndPushNamed(Routes.ACCOUNT_RECOVERY,
                    arguments: RecoveryMode.DEVICE);
              })
      );
    } else {
      await Navigator.pushReplacementNamed(context, Routes.DASHBOARD);
    }
  }


}