import 'package:flutter/material.dart' hide Colors;
import 'package:flutter_svg/svg.dart';

import '../bottom_sheet.dart';
import '../colors.dart';

Future<dynamic> showError(BuildContext context,
    {String title = "Oops! Something went wrong", String? message,
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
        return BottomSheets.displayErrorModal(context,
            title: title,
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
        return BottomSheets.displaySuccessModal(context,
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

Future<dynamic> showInfo(BuildContext context,
    {String? message,
      String title = "Oops",
      VoidCallback? onPrimaryClick,
      String primaryButtonText = "Continue",
      String? secondaryButtonText,
      VoidCallback? onSecondaryClick}) {
  return showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (mContext) {
        return BottomSheets.displayInfoDialog(context,
            title: title,
            message: message,
            primaryButtonText: primaryButtonText,
            onPrimaryClick: onPrimaryClick,
            secondaryButtonText: secondaryButtonText,
            onSecondaryClick: onSecondaryClick
        );
      });
}

Future<dynamic> showComingSoon(BuildContext context) {
  return showModalBottomSheet(
      isScrollControlled: true,
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return BottomSheets.makeAppBottomSheet2(
          height: 300,
          dialogIcon: SvgPicture.asset(
            'res/drawables/ic_info.svg',
            color: Colors.primaryColor,
            width: 40,
            height: 40,
          ),
          centerImageBackgroundColor: Colors.primaryColor.withOpacity(0.1),
          centerBackgroundPadding: 15,
          content: Column(
            children: [
              SizedBox(height: 20),
              Text('Coming Soon',
                  style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.textColorBlack)),
              SizedBox(height: 16),
              Container(
                width: double.infinity,
                padding: EdgeInsets.symmetric(horizontal: 75),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(8)),
                ),
                child: Text(
                    "This feature is currently in development. "
                        "Not to worry, you’ll be using it sooner than you think. ",
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.normal,
                        color: Colors.darkBlue),
                    textAlign: TextAlign.center),
              ),
              SizedBox(height: 24),
              TextButton(
                child: Text(
                  'Dismiss',
                  style: TextStyle(color: Colors.primaryColor, fontSize: 16),
                ),
                onPressed: () => Navigator.pop(context),
              ),
              SizedBox(height: 32)
            ],
          ),
        );
      });
}
