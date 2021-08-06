import 'dart:ui';

import 'package:chewie/chewie.dart';
import 'package:flutter/material.dart' hide Colors, ScrollView;
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_swipecards/flutter_swipecards.dart';
import 'package:moniepoint_flutter/app/login/model/data/login_prompt.dart';
import 'package:moniepoint_flutter/core/colors.dart';
import 'package:moniepoint_flutter/core/styles.dart';
import 'package:moniepoint_flutter/core/utils/call_utils.dart';
import 'package:video_player/video_player.dart';
import 'package:moniepoint_flutter/core/views/scroll_view.dart';

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

  static Widget displayErrorModal2(BuildContext context,
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
                        maxLines: 4,
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
                      onPressed: onPrimaryClick,
                    ),
                  SizedBox(height: secondaryButtonText != null ? 32 : 0),
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

  static Widget displayErrorModal(BuildContext context,
      {String title = "Oops",
      String? message = "",
      VoidCallback? onClick,
      String buttonText = "Continue"}) {
    return makeAppBottomSheet(
        curveBackgroundColor: Colors.modalRed,
        centerImageBackgroundColor: Colors.white,
        contentBackgroundColor: Colors.modalRed,
        centerImageRes: 'res/drawables/ic_modal_error.svg',
        content: Wrap(
          children: [
            Container(
              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
              child: Column(
                children: [
                  Text(title,
                      style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.w600,
                          color: Colors.white)),
                  SizedBox(height: 16),
                  Container(
                    width: double.infinity,
                    padding: EdgeInsets.symmetric(horizontal: 24, vertical: 24),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(8)),
                        color: Colors.darkRed),
                    child: Text(message ?? "",
                        maxLines: 4,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.normal,
                            color: Colors.white),
                        textAlign: TextAlign.center),
                  ),
                  SizedBox(height: 21),
                  SizedBox(
                      width: double.infinity,
                      child: Styles.appButton(
                          elevation: 0.5,
                          onClick: onClick ?? () => Navigator.of(context).pop(),
                          text: buttonText,
                          buttonStyle: Styles.whiteButtonStyle.copyWith(
                              textStyle: MaterialStateProperty.all(TextStyle(
                                  fontSize: 18,
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontFamily: Styles.defaultFont)),
                              foregroundColor:
                                  MaterialStateProperty.all(Colors.modalRed)))),
                  SizedBox(height: 64)
                ],
              ),
            )
          ],
        ));
  }

  static Widget displaySuccessModal(BuildContext context,
      {String title = "Oops", String? message = "", VoidCallback? onClick}) {
    return makeAppBottomSheet(
        curveBackgroundColor: Colors.solidGreen,
        centerImageBackgroundColor: Colors.white,
        contentBackgroundColor: Colors.solidGreen,
        centerImageRes: 'res/drawables/success_modal_check.svg',
        content: Wrap(
          children: [
            Container(
              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
              child: Column(
                children: [
                  Text(title,
                      style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.w600,
                          color: Colors.white)),
                  SizedBox(height: 16),
                  Container(
                    width: double.infinity,
                    padding: EdgeInsets.symmetric(horizontal: 24, vertical: 24),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(8)),
                        color: Colors.solidDarkGreen),
                    child: Text(message ?? "",
                        maxLines: 3,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.normal,
                            color: Colors.white),
                        textAlign: TextAlign.center),
                  ),
                  SizedBox(height: 21),
                  SizedBox(
                      width: double.infinity,
                      child: Styles.appButton(
                          onClick: onClick ?? () => Navigator.of(context).pop(),
                          text: 'Continue',
                          buttonStyle: Styles.whiteButtonStyle.copyWith(
                              textStyle: MaterialStateProperty.all(TextStyle(
                                  fontSize: 18,
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontFamily: Styles.defaultFont)),
                              foregroundColor: MaterialStateProperty.all(
                                  Colors.solidGreen)))),
                  SizedBox(height: 64)
                ],
              ),
            )
          ],
        ));
  }

  static Widget displaySuccessModal2(BuildContext context,
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
                      onPressed: onPrimaryClick,
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
                  // SizedBox(height: secondaryButtonText != null ? 32 : 0),
                  // Visibility(
                  //     visible: secondaryButtonText != null,
                  //     child: TextButton(
                  //         onPressed: onSecondaryClick ?? () => Navigator.of(context).pop(),
                  //         child: Text(secondaryButtonText ?? "",
                  //             style: TextStyle(color: Colors.primaryColor, fontSize: 14, fontWeight: FontWeight.bold)
                  //         )
                  //     )),
                  SizedBox(height: 32),
                ],
              ),
            )
          ],
        ));
  }

  static Widget displayWarningDialog(
      String title, String description, VoidCallback onContinue,
      {String buttonText = "Continue"}) {
    return BottomSheets.makeAppBottomSheet(
        curveBackgroundColor: Colors.solidYellow,
        centerImageBackgroundColor: Colors.white,
        contentBackgroundColor: Colors.solidYellow,
        centerImageRes: 'res/drawables/ic_warning.svg',
        content: Wrap(
          children: [
            Container(
              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
              child: Column(
                children: [
                  Text(title,
                      style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.white)),
                  SizedBox(height: 16),
                  Container(
                    width: double.infinity,
                    padding: EdgeInsets.symmetric(horizontal: 24, vertical: 24),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(8)),
                        color: Colors.solidDarkYellow),
                    child: Text(description,
                        maxLines: 3,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.normal,
                            color: Colors.white),
                        textAlign: TextAlign.center),
                  ),
                  SizedBox(height: 21),
                  SizedBox(
                      width: double.infinity,
                      child: Styles.appButton(
                          elevation: 0.5,
                          onClick: onContinue,
                          text: buttonText,
                          buttonStyle: Styles.whiteButtonStyle.copyWith(
                              foregroundColor: MaterialStateProperty.all(
                                  Colors.solidYellow)))),
                  SizedBox(height: 64)
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
                                  fontWeight: FontWeight.normal)))),
                  SizedBox(height: 16),
                ],
              ),
            )
          ],
        ));
  }

  static Widget displayLoginPrompt(BuildContext context,
      {required LoginPrompt? prompt, required CardController cardController}) {
    VoidCallback? onPrimaryClick;
    String primaryButtonText = "Continue";
    String? secondaryButtonText = "Dismiss";
    VoidCallback? onSecondaryClick = () => cardController.triggerUp();
    bool showButton = false;

    late Color color;
    final successColor = Colors.solidGreen;
    final infoColor = Colors.primaryColor;
    final errorColor = Colors.modalRed;
    final headerState = prompt?.header?.headerState ?? "INFO";
    switch (headerState) {
      case "ERROR":
        color = errorColor;
        break;
      case "SUCCESS":
        color = successColor;
        break;
      case "INFO":
        color = infoColor;
        break;
    }

    bool hasImageOrVideo = prompt?.hasImageOrVideo ?? false;

    if (prompt != null &&
        prompt.navigationList != null &&
        prompt.navigationList!.isNotEmpty) {
      final list = prompt.navigationList!;
      final length = list.length;

      if (length == 1) {
        showButton = true;
        primaryButtonText = list[0].title ?? "";
        final dest = list[0].destination ?? "";
        bool isUrl = Uri.tryParse(dest)?.isAbsolute ?? false;
        onPrimaryClick = () {
          cardController.triggerUp();
          if (isUrl) {
            openUrl(dest);
          }

          // Handle screen navigation
        };
      }
      if (length > 1) {
        showButton = true;
        primaryButtonText = list[0].title ?? "";
        var dest = list[0].destination ?? "";
        bool isUrl = Uri.tryParse(dest)?.isAbsolute ?? false;
        onPrimaryClick = () {
          cardController.triggerUp();

          if (isUrl) {
            openUrl(dest);
          }
        };

        secondaryButtonText = list[1].title ?? "";
        dest = list[1].destination ?? "";
        isUrl = Uri.tryParse(dest)?.isAbsolute ?? false;
        onSecondaryClick = () {
          cardController.triggerUp();
          if (isUrl) {
            openUrl(dest);
          }
        };
      }
    }

    late double? height;
    if (!hasImageOrVideo && !showButton) height = 300;
    if (hasImageOrVideo && !showButton) height = 330;
    if (hasImageOrVideo && showButton) height = 450;
    // print(height);

    String headerSvg = "res/drawables/ic_circular_check_mark.svg";

    return makeAppBottomSheet2(
      curveBackgroundColor: Colors.white,
      centerImageBackgroundColor: color.withOpacity(0.1),
      contentBackgroundColor: Colors.white,
      centerBackgroundPadding: 13,
      dialogIcon: SvgPicture.asset(
        headerSvg,
        color: color,
        width: 40,
        height: 40,
      ),
      content: ScrollView(
        maxHeight: height,
        child: Container(
          padding: EdgeInsets.fromLTRB(24, 24, 24, 24),
          child: Column(
            children: [
              Text(prompt?.title ?? '',
                  style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: Colors.textColorBlack)),
              SizedBox(height: 24),
              if (hasImageOrVideo)
                Flexible(child: _buildDisplayContent(prompt)),
              if (hasImageOrVideo) SizedBox(height: 24),
              Container(
                width: double.infinity,
                padding: EdgeInsets.symmetric(horizontal: 24, vertical: 24),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(8)),
                    color: color.withOpacity(0.1)),
                child: Text(
                  prompt?.message ?? "",
                  maxLines: 4,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.normal,
                      color: Colors.textColorBlack),
                  textAlign: TextAlign.center,
                ),
              ),
              SizedBox(height: 24),
              if (showButton)
                SizedBox(
                  width: double.infinity,
                  child: Styles.appButton(
                    elevation: 0.5,
                    onClick:
                        onPrimaryClick ?? () => Navigator.of(context).pop(),
                    text: primaryButtonText,
                  ),
                ),
              if (showButton) SizedBox(height: 18),
              TextButton(
                child: Text(
                  secondaryButtonText,
                  style: TextStyle(color: Colors.primaryColor, fontSize: 16),
                ),
                onPressed: onSecondaryClick,
              ),
              SizedBox(height: 10)
            ],
          ),
        ),
      ),
    );
  }

  static Widget _buildDisplayContent(LoginPrompt? prompt) {
    Widget widget = Container();
    if (prompt != null &&
        prompt.videoLink != null &&
        prompt.videoLink!.isNotEmpty) {
      widget = Container(
        width: double.infinity,
        decoration:
            BoxDecoration(borderRadius: BorderRadius.all(Radius.circular(8))),
        child: VideoScreen(
          key: UniqueKey(),
          controller: VideoPlayerController.network(prompt.videoLink!),
        ),
      );
    } else if (prompt?.displayImage != null) {
      widget = Container(
        height: 150,
        width: double.infinity,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.all(
            Radius.circular(8),
          ),
        ),
        child: (prompt != null &&
                prompt.displayImage != null &&
                prompt.displayImage!.isPng)
            ? FadeInImage.assetNetwork(
                placeholder: "res/drawables/progress_bar_lottie.json",
                image: prompt.displayImage!.uuidRef!,
                fit: BoxFit.cover,
              )
            : SvgPicture.asset("res/drawables/ic_circular_check_mark.svg"),
      );
    }

    return widget;
  }
}

enum PromptColor { info, success, error }

class VideoScreen extends StatefulWidget {
  VideoScreen({required Key key, required this.controller}) : super(key: key);

  final VideoPlayerController controller;
  @override
  _VideoScreenState createState() => _VideoScreenState();
}

class _VideoScreenState extends State<VideoScreen> {
  late ChewieController _chewieController;

  @override
  void initState() {
    super.initState();
    _chewieController = ChewieController(
        videoPlayerController: widget.controller,
        autoPlay: false,
        autoInitialize: true,
        aspectRatio: 20 / 9);
  }

  @override
  void dispose() {
    widget.controller.dispose();
    _chewieController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      child: ConstrainedBox(
        constraints: BoxConstraints(maxHeight: 150, minWidth: double.infinity),
        child: Chewie(
          controller: _chewieController,
        ),
      ),
    );
  }
}
