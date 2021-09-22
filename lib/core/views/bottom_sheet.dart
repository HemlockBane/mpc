import 'dart:ui';

import 'package:flutter/material.dart' hide Colors, ScrollView;
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_swipecards/flutter_swipecards.dart';
import 'package:moniepoint_flutter/app/airtime/viewmodels/service_provider_view_model.dart';
import 'package:moniepoint_flutter/app/login/model/data/login_prompt.dart';
import 'package:moniepoint_flutter/core/colors.dart';
import 'package:moniepoint_flutter/core/styles.dart';

import '../login_prompt.dart';

class BottomSheets {
  static Widget makeAppBottomSheet(
      {double? height,
      Color curveBackgroundColor = Colors.white,
      Color centerImageBackgroundColor = Colors.primaryColor,
      Color contentBackgroundColor = Colors.white,
      String centerImageRes = 'res/drawables/ic_key.svg',
      double paddingLeft = 0,
      double paddingRight = 0,
      double paddingBottom = 0,
      double centerImageWidth = 33,
      double centerImageHeight = 33,
      double? centerBackgroundHeight,
      double? centerBackgroundWidth,
      double centerBackgroundPadding = 20,
      Widget? content,
      Color? centerImageColor}) {
    return Container(
        height: height,
        child: Stack(
          children: [
            Positioned(
              child: SvgPicture.asset(
                'res/drawables/ic_white_curve.svg',
                color: curveBackgroundColor,
              ),
              left: 0,
              right: 0,
            ),
            Container(
              width: double.infinity,
              margin: EdgeInsets.only(top: 42.5),
              padding: EdgeInsets.only(
                  top: 43,
                  left: paddingLeft,
                  right: paddingRight,
                  bottom: paddingBottom),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(16),
                      topRight: Radius.circular(16)),
                  color: contentBackgroundColor),
              child: content,
            ),
            Positioned(
              child: Container(
                width: centerBackgroundWidth,
                height: centerBackgroundHeight,
                decoration: BoxDecoration(
                  color: centerImageBackgroundColor,
                  shape: BoxShape.circle,
                ),
                child: SvgPicture.asset(centerImageRes,
                    width: centerImageWidth,
                    height: centerImageHeight,
                    color: centerImageColor),
                padding: EdgeInsets.all(centerBackgroundPadding),
                margin: EdgeInsets.only(top: 10),
              ),
              left: 0,
              right: 0,
            ),
          ],
        ));
  }

  static Widget makeAppBottomSheet2({
    double? height,
    Color curveBackgroundColor = Colors.white,
    Color centerImageBackgroundColor = Colors.primaryColor,
    Color contentBackgroundColor = Colors.white,
    Widget? dialogIcon,
    double paddingLeft = 0,
    double paddingRight = 0,
    double paddingBottom = 0,
    double? centerBackgroundHeight,
    double? centerBackgroundWidth,
    double centerBackgroundPadding = 20,
    Widget? content,
  }) {
    return Container(
        height: height,
        child: Stack(
          children: [
            Positioned(
              child: SvgPicture.asset(
                'res/drawables/ic_white_curve.svg',
                color: curveBackgroundColor,
              ),
              left: 0,
              right: 0,
            ),
            Container(
              width: double.infinity,
              margin: EdgeInsets.only(top: 42.5),
              padding: EdgeInsets.only(
                  top: 30,
                  left: paddingLeft,
                  right: paddingRight,
                  bottom: paddingBottom),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(16),
                      topRight: Radius.circular(16),
                      bottomLeft: Radius.circular(16),
                      bottomRight: Radius.circular(16)),
                  color: contentBackgroundColor),
              child: content,
            ),
            Positioned(
              child: Container(
                width: centerBackgroundWidth,
                height: centerBackgroundHeight,
                decoration: BoxDecoration(
                  color: centerImageBackgroundColor,
                  shape: BoxShape.circle,
                ),
                child: dialogIcon,
                padding: EdgeInsets.all(centerBackgroundPadding),
                margin: EdgeInsets.only(top: 10),
              ),
              left: 0,
              right: 0,
            ),
          ],
        ));
  }

  static Widget displayErrorModal(BuildContext context,
      {String title = "Oops! Something went wrong",
      String? message = "",
      VoidCallback? onPrimaryClick,
      String primaryButtonText = "Continue",
      String? secondaryButtonText,
      VoidCallback? onSecondaryClick,
      bool useTextButton = false}) {
    return makeAppBottomSheet2(
        curveBackgroundColor: Colors.white,
        centerImageBackgroundColor: Colors.red.withOpacity(0.1),
        contentBackgroundColor: Colors.white,
        centerBackgroundPadding: 12,
        dialogIcon: SvgPicture.asset(
          'res/drawables/ic_info.svg',
          color: Colors.red,
          width: 40,
          height: 40,
        ),
        content: Wrap(
          children: [
            Container(
              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
              child: Column(
                children: [
                  Text(title,
                      style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: Colors.textColorBlack)),
                  SizedBox(height: 16),
                  Container(
                    width: double.infinity,
                    padding: EdgeInsets.symmetric(horizontal: 24, vertical: 24),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(8)),
                        color: Colors.red.withOpacity(0.1)),
                    child: Text(message ?? "",
                        maxLines: 6,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.normal,
                            color: Colors.textColorBlack),
                        textAlign: TextAlign.center),
                  ),
                  SizedBox(height: 21),
                  if (!useTextButton)
                    SizedBox(
                        width: double.infinity,
                        child: Styles.appButton(
                          elevation: 0.2,
                          onClick: onPrimaryClick ??
                              () => Navigator.of(context).pop(),
                          text: primaryButtonText,
                        )),
                  if (useTextButton)
                    TextButton(
                      child: Text(
                        primaryButtonText,
                        style:
                            TextStyle(color: Colors.primaryColor, fontSize: 16),
                      ),
                      onPressed: onPrimaryClick ?? () => Navigator.of(context).pop(),
                    ),
                  SizedBox(height: secondaryButtonText != null ? 26 : 0),
                  Visibility(
                      visible: secondaryButtonText != null,
                      child: TextButton(
                          onPressed: onSecondaryClick ??
                              () => Navigator.of(context).pop(),
                          child: Text(secondaryButtonText ?? "",
                              style: TextStyle(
                                  color: Colors.primaryColor,
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold)))),
                  SizedBox(height: 32),
                ],
              ),
            )
          ],
        ));
  }

  static Widget displaySuccessModal(BuildContext context,
      {String title = "Oops",
      String? message = "",
      VoidCallback? onPrimaryClick,
      String primaryButtonText = "Continue",
      String? secondaryButtonText,
      VoidCallback? onSecondaryClick,
      bool useText = false}) {
    return makeAppBottomSheet2(
        curveBackgroundColor: Colors.white,
        centerImageBackgroundColor: Colors.solidGreen.withOpacity(0.1),
        contentBackgroundColor: Colors.white,
        centerBackgroundPadding: 13,
        dialogIcon: SvgPicture.asset(
          'res/drawables/ic_circular_check_mark.svg',
          color: Colors.solidGreen,
          width: 40,
          height: 40,
        ),
        content: Wrap(
          children: [
            Container(
              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
              child: Column(
                children: [
                  Text(title,
                      style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: Colors.textColorBlack)),
                  SizedBox(height: 16),
                  Container(
                    width: double.infinity,
                    padding: EdgeInsets.symmetric(horizontal: 24, vertical: 24),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(8)),
                        color: Colors.solidGreen.withOpacity(0.1)),
                    child: Text(message ?? "",
                        maxLines: 4,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.normal,
                            color: Colors.textColorBlack),
                        textAlign: TextAlign.center),
                  ),
                  SizedBox(height: 21),
                  if (useText)
                    TextButton(
                      child: Text(
                        primaryButtonText,
                        style:
                            TextStyle(color: Colors.primaryColor, fontSize: 16),
                      ),
                      onPressed: onPrimaryClick ?? () => Navigator.of(context).pop(),
                    ),
                  if (!useText)
                    SizedBox(
                        width: double.infinity,
                        child: Styles.appButton(
                          elevation: 0.5,
                          onClick: onPrimaryClick ??
                              () => Navigator.of(context).pop(),
                          text: primaryButtonText,
                        )),
                  SizedBox(height: 32),
                ],
              ),
            )
          ],
        ));
  }

  static Widget displayInfoDialog(BuildContext context,
      {String title = "Oops",
      String? message = "",
      VoidCallback? onPrimaryClick,
      String primaryButtonText = "Continue",
      String? secondaryButtonText,
      VoidCallback? onSecondaryClick}) {
    return makeAppBottomSheet2(
        curveBackgroundColor: Colors.white,
        centerImageBackgroundColor: Colors.primaryColor.withOpacity(0.1),
        contentBackgroundColor: Colors.white,
        centerBackgroundPadding: 12,
        dialogIcon: SvgPicture.asset(
          'res/drawables/ic_info_italic.svg',
          color: Colors.primaryColor,
          width: 40,
          height: 40,
        ),
        content: Wrap(
          children: [
            Container(
              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Column(
                children: [
                  SizedBox(
                    height: 7,
                  ),
                  Text(title,
                      style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: Colors.textColorBlack)),
                  SizedBox(height: 16),
                  Container(
                    width: double.infinity,
                    padding: EdgeInsets.symmetric(horizontal: 24, vertical: 24),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(8)),
                        color: Colors.primaryColor.withOpacity(0.1)),
                    child: Text(message ?? "",
                        maxLines: 5,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.normal,
                            color: Colors.textColorBlack),
                        textAlign: TextAlign.center),
                  ),
                  SizedBox(height: 24),
                  SizedBox(
                      width: double.infinity,
                      child: Styles.appButton(
                          elevation: 0.5,
                          onClick: onPrimaryClick ??
                              () => Navigator.of(context).pop(),
                          text: primaryButtonText,
                          buttonStyle: Styles.primaryButtonStyle.copyWith(
                              textStyle: MaterialStateProperty.all(TextStyle(
                                  fontSize: 16,
                                  color: Colors.white,
                                  fontWeight: FontWeight.w600,
                                  fontFamily: Styles.defaultFont)),
                              foregroundColor:
                                  MaterialStateProperty.all(Colors.white)))),
                  SizedBox(height: secondaryButtonText != null ? 32 : 0),
                  Visibility(
                      visible: secondaryButtonText != null,
                      child: TextButton(
                          onPressed: onSecondaryClick ??
                              () => Navigator.of(context).pop(),
                          child: Text(secondaryButtonText ?? "",
                              style: TextStyle(
                                  color: Colors.primaryColor,
                                  fontSize: 16,
                                  fontWeight: FontWeight.normal
                              )
                          )
                      )
                  ),
                  SizedBox(height: 32),
                ],
              ),
            )
          ],
        ));
  }

  static Widget displayLoginPrompt(BuildContext context,
      {required LoginPrompt? prompt,
      required CardController cardController,
      required ServiceProviderViewModel serviceProviderViewModel}) {
    return LoginPromptBottomSheet(prompt: prompt, cardController: cardController, serviceProviderViewModel: serviceProviderViewModel);
  }

}


