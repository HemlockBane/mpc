import 'package:flutter/material.dart' hide Colors;
import 'package:flutter_svg/svg.dart';
import 'package:moniepoint_flutter/core/styles.dart';
import 'package:moniepoint_flutter/core/views/transaction_error_page.dart';

import '../../main.dart';
import '../views/bottom_sheet.dart';
import '../colors.dart';

Future<dynamic> showError(BuildContext context,
    {String title = "Oops! Something went wrong", String? message,
    VoidCallback? onPrimaryClick,
    String primaryButtonText = "Try Again",
    String? secondaryButtonText,
      bool useTextButton = false,
      bool displayDismissButton = false,
    VoidCallback? onSecondaryClick}) {
  return navigatorKey.currentState!.push(MaterialPageRoute(builder: (mContext) {
    return TransactionErrorPage(
      title: title,
      message: message ?? "",
      primaryButtonText: primaryButtonText,
      secondaryButtonText: secondaryButtonText ?? "Dismiss",
      onTryAgain: onPrimaryClick,
      onDismiss: onSecondaryClick,
      displayDismissButton: secondaryButtonText != null || displayDismissButton == true,
    );
  }));
  // return showModalBottomSheet(
  //     context: context,
  //     isScrollControlled: true,
  //     backgroundColor: Colors.transparent,
  //     builder: (mContext) {
  //       return BottomSheets.displayErrorModal(context,
  //           title: title,
  //           message: message,
  //           useTextButton: useTextButton,
  //           primaryButtonText: primaryButtonText,
  //           onPrimaryClick: onPrimaryClick,
  //           secondaryButtonText: secondaryButtonText,
  //           onSecondaryClick: onSecondaryClick);
  //     });
}

Future<dynamic> showSuccess(BuildContext context,
    {String? message,
      String title = "Oops",
      VoidCallback? onPrimaryClick,
      String primaryButtonText = "Continue",
      String? secondaryButtonText,
      bool useText = true,
      bool isDismissible = true,
      VoidCallback? onSecondaryClick}) {
  return showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      isDismissible: isDismissible,
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

Future<dynamic> showComingSoon(BuildContext context, {String title = "Coming Soon"}) {
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
              Text(title,
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


Future<dynamic> showConfirmation(BuildContext context, {String title = "Confirmation", required String primaryButtonText, required Widget content, VoidCallback? onPrimaryClick, Color? primaryButtonColor = Colors.primaryColor, EdgeInsets? contentPadding, double? height}) {

  final dialogRadius = Radius.circular(8);

  return showModalBottomSheet(
    isScrollControlled: true,
    context: context,
    backgroundColor: Colors.transparent,
    builder: (context) {
      return BottomSheets.makeAppBottomSheet2(
        height: height ?? 400,
        dialogIcon: SvgPicture.asset(
          'res/drawables/ic_info.svg',
          color: Colors.solidYellow,
          width: 40,
          height: 40,
        ),
        centerImageBackgroundColor: Colors.solidYellow.withOpacity(0.1),
        centerBackgroundPadding: 15,
        content: Wrap(
          children: [
            Container(
              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
              child: Column(
                children: [
                  Text(title,
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.textColorBlack)),
                  SizedBox(height: 16),
                  Container(
                    width: double.infinity,
                    padding: contentPadding ?? EdgeInsets.symmetric(vertical: 24, horizontal: 24),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.only(topRight: dialogRadius, topLeft: dialogRadius),
                      color: Color(0xffF5F6F7)
                    ),
                    child: content,
                  ),
                  SizedBox(height: 24),
                  SizedBox(
                    width: double.infinity,
                    child: Styles.appButton(
                      elevation: 0.5,
                      onClick: onPrimaryClick ?? () => Navigator.of(context).pop(),
                      text: primaryButtonText,
                      buttonStyle: Styles.primaryButtonStyle.copyWith(
                        backgroundColor: MaterialStateProperty.all(primaryButtonColor),
                        textStyle: MaterialStateProperty.all(TextStyle(
                          fontSize: 16,
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                          fontFamily: Styles.defaultFont)),
                        foregroundColor:
                        MaterialStateProperty.all(Colors.white)))),
                  SizedBox(height: 32)
                ],
              ),
            ),
          ],
        ),
      );
    });
}
