import 'package:flutter/material.dart';

import '../bottom_sheet.dart';

Future<dynamic> showError(BuildContext context,
    {String? message,
    VoidCallback? onPrimaryClick,
    String primaryButtonText = "Continue",
    String? secondaryButtonText,
      bool useTextButton = false,
    VoidCallback? onSecondaryClick}) {
  return showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (mContext) {
        return BottomSheets.displayErrorModal2(context,
            message: message,
            useTextButton: useTextButton,
            primaryButtonText: primaryButtonText,
            onPrimaryClick: onPrimaryClick,
            secondaryButtonText: secondaryButtonText,
            onSecondaryClick: onSecondaryClick);
      });
}

Future<dynamic> showSuccess(BuildContext context,
    {String? message,
      String title = "Oops",
      VoidCallback? onPrimaryClick,
      String primaryButtonText = "Continue",
      String? secondaryButtonText,
      bool useText = true,
      VoidCallback? onSecondaryClick}) {
  return showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (mContext) {
        return BottomSheets.displaySuccessModal2(context,
            title: title,
            message: message,
            useText: useText,
            primaryButtonText: primaryButtonText,
            onPrimaryClick: onPrimaryClick,
            secondaryButtonText: secondaryButtonText,
            onSecondaryClick: onSecondaryClick
        );
      });
}
