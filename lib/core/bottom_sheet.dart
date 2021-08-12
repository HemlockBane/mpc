import 'dart:convert';
import 'dart:ui';

import 'package:chewie/chewie.dart';
import 'package:flutter/material.dart' hide Colors, ScrollView;
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_swipecards/flutter_swipecards.dart';
import 'package:lottie/lottie.dart';
import 'package:moniepoint_flutter/app/airtime/viewmodels/service_provider_view_model.dart';
import 'package:moniepoint_flutter/app/login/model/data/login_prompt.dart';
import 'package:moniepoint_flutter/core/colors.dart';
import 'package:moniepoint_flutter/core/models/file_result.dart';
import 'package:moniepoint_flutter/core/network/resource.dart';
import 'package:moniepoint_flutter/core/styles.dart';
import 'package:moniepoint_flutter/core/utils/call_utils.dart';
import 'package:provider/provider.dart';
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
                      onPressed: onPrimaryClick ?? () => Navigator.of(context).pop(),
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
      {required LoginPrompt? prompt,
      required CardController cardController,
      required ServiceProviderViewModel serviceProviderViewModel}) {
    VoidCallback? onPrimaryClick;
    String primaryButtonText = "Continue";
    String? secondaryButtonText = "Dismiss";
    VoidCallback? onSecondaryClick = () => cardController.triggerUp();
    bool showButton = false;

    late Color color;
    final successColor = Colors.solidGreen;
    final infoColor = Colors.primaryColor;
    final errorColor = Colors.modalRed;
    final headerState = prompt?.header?.headerState ?? "NEUTRAL";
    switch (headerState) {
      case "ERROR":
        color = errorColor;
        break;
      case "SUCCESS":
        color = successColor;
        break;
      case "NEUTRAL":
        color = infoColor;
        break;
    }

    bool hasImageOrVideo = prompt?.hasImageOrVideo ?? false;

    if (prompt != null &&
        prompt.navigationList != null &&
        prompt.navigationList!.isNotEmpty) {
      final list = prompt.navigationList!;
      // final length = list.length;
      final length = 0;

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

    late double? height = 300;
    if (!hasImageOrVideo && !showButton) height = 300;
    if (hasImageOrVideo && !showButton) height = 330;
    if (hasImageOrVideo && showButton) height = 450;
    // print(height);

    return makeAppBottomSheet2(
      curveBackgroundColor: Colors.white,
      centerImageBackgroundColor: color.withOpacity(0.1),
      contentBackgroundColor: Colors.white,
      centerBackgroundPadding: 13,
      dialogIcon: SvgPicture.string(
        string2,
        color: color,
        width: 40,
        height: 40,
      ),
      content: ConstrainedBox(
        constraints: BoxConstraints(minHeight: 400, maxHeight: 450),
        child: ListView(
          shrinkWrap: true,
          children: [
            Container(
              padding: EdgeInsets.fromLTRB(24, 24, 24, 0),
              child: Column(
                children: [
                  Text(
                    prompt?.title ?? '',
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: Colors.textColorBlack,
                    ),
                  ),
                  SizedBox(height: 24),
                  if (hasImageOrVideo)
                    _buildDisplayContent(prompt, serviceProviderViewModel),
                  if (hasImageOrVideo) SizedBox(height: 24),
                  Container(
                    width: double.infinity,
                    padding: EdgeInsets.symmetric(horizontal: 15, vertical: 15),
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
                      style:
                          TextStyle(color: Colors.primaryColor, fontSize: 16),
                    ),
                    onPressed: onSecondaryClick,
                  ),
                  SizedBox(height: 10)
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  static Widget _buildDisplayContent(
      LoginPrompt? prompt, ServiceProviderViewModel serviceProviderViewModel) {
    Widget widget = Container();
    if (prompt != null &&
        prompt.videoLink != null &&
        prompt.videoLink!.isNotEmpty) {
      widget = Container(
        child: ClipRRect(
          borderRadius: BorderRadius.all(Radius.circular(8)),
          child: VideoScreen(
            key: UniqueKey(),
            controller: VideoPlayerController.network(prompt.videoLink!),
          ),
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
                prompt.displayImage!.isPng) // TODO: Remove "isPng". Check for SVG, then lottie, then image is fallback
            ? ImageWidget(
                uuidRef: prompt.displayImage!.uuidRef,
                serviceProviderViewModel: serviceProviderViewModel,
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
        aspectRatio: 20 / 9,
        placeholder: Lottie.asset(
          "res/drawables/progress_bar_lottie.json",
          height: 30,
          width: 30,
          fit: BoxFit.contain,
        ),
        errorBuilder: (context, message) => Container());
  }

  @override
  void dispose() {
    widget.controller.dispose();
    _chewieController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.all(Radius.circular(8)),
      child: ConstrainedBox(
        constraints: BoxConstraints(maxHeight: 150, minWidth: double.infinity),
        child: Chewie(
          controller: _chewieController,
        ),
      ),
    );
  }
}

class ImageWidget extends StatefulWidget {
  ImageWidget({required this.uuidRef, required this.serviceProviderViewModel});

  final String? uuidRef;
  final ServiceProviderViewModel serviceProviderViewModel;

  @override
  _ImageWidgetState createState() => _ImageWidgetState();
}

class _ImageWidgetState extends State<ImageWidget> {
  Stream<Resource<FileResult>>? _fileResultStream;
  Widget? _itemImage;

  @override
  void initState() {
    _fetchServiceProviderLogo();
    super.initState();
  }

  void _fetchServiceProviderLogo() {
    _fileResultStream =
        widget.serviceProviderViewModel.getFile(widget.uuidRef ?? "");
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: (widget.uuidRef != null) ? _fileResultStream : null,
      builder: (mContext, AsyncSnapshot<Resource<FileResult>> snapShot) {
        if (!snapShot.hasData ||
            snapShot.data == null ||
            (snapShot.data is Error && _itemImage == null)) return Container();

        final base64 = snapShot.data?.data;
        final base64String = base64?.base64String;

        if ((base64 == null ||
                base64String == null ||
                base64String.isEmpty == true) &&
            _itemImage == null) {
          return Container();
        }

        if (_itemImage == null) {
          _itemImage = ConstrainedBox(
            constraints:
                BoxConstraints(maxHeight: 150, minWidth: double.infinity),
            child: Image.memory(base64Decode(base64String!),
                fit: BoxFit.contain,
                color: Colors.black, errorBuilder: (_, _i, _j) {
              return Container();
            }),
          );
        }

        return _itemImage!;
      },
    );
  }
}

final string =
    '''<svg width="27" height="27" viewBox="0 0 27 27" fill="none" xmlns="http://www.w3.org/2000/svg">
    <path opacity="0.1" fill-rule="evenodd" clip-rule="evenodd"
        d="M13.5 27C20.9558 27 27 20.9558 27 13.5C27 6.04416 20.9558 0 13.5 0C6.04416 0 0 6.04416 0 13.5C0 20.9558 6.04416 27 13.5 27Z"
        fill="#0B3275" />
    <path
        d="M20.8693 18.1305C20.9504 18.0225 20.9959 17.8921 20.9997 17.7572C21.0035 17.6223 20.9654 17.4895 20.8905 17.3772C19.963 15.983 18.5484 14.9853 16.9238 14.5794L16.5977 14.4979C16.4884 14.4705 16.3739 14.4719 16.2653 14.5019C16.1568 14.5319 16.0578 14.5895 15.9781 14.6691L15.1042 15.5381C14.936 15.6999 14.7116 15.7903 14.4781 15.7903C14.2447 15.7903 14.0203 15.6999 13.8521 15.5381L11.4603 13.1479C11.295 12.9815 11.2022 12.7564 11.2022 12.5219C11.2022 12.2873 11.295 12.0622 11.4603 11.8958L12.3309 11.0268C12.4113 10.9466 12.4694 10.8468 12.4995 10.7373C12.5295 10.6278 12.5304 10.5123 12.5021 10.4023L12.4206 10.0762C12.0147 8.4516 11.017 7.03698 9.62279 6.10946C9.51047 6.03462 9.37771 5.99646 9.24279 6.00026C9.10788 6.00405 8.97747 6.04962 8.86954 6.13066L8.54346 6.37522C7.75552 6.96916 7.11584 7.73752 6.67457 8.62007C6.23329 9.50262 6.00241 10.4754 6.00002 11.4621C5.99793 12.2975 6.16141 13.1249 6.48099 13.8968C6.80057 14.6686 7.26993 15.3694 7.86195 15.9588L11.0412 19.1381C11.6306 19.7301 12.3314 20.1994 13.1032 20.519C13.8751 20.8386 14.7025 21.0021 15.5379 21C16.5247 20.9978 17.4975 20.7671 18.3801 20.3258C19.2627 19.8845 20.031 19.2447 20.6248 18.4565L20.8693 18.1305ZM15.5379 19.6957C14.8739 19.6977 14.216 19.5679 13.6026 19.3138C12.9891 19.0596 12.4321 18.6862 11.9641 18.2152L8.78476 15.0359C8.31375 14.5679 7.94036 14.0109 7.68623 13.3974C7.43211 12.784 7.3023 12.1261 7.30435 11.4621C7.30616 10.6915 7.48325 9.9314 7.82221 9.23935C8.16117 8.5473 8.65313 7.94143 9.26084 7.46759C10.1872 8.20408 10.8473 9.22323 11.1407 10.3697L10.5391 10.973C10.1289 11.3841 9.89852 11.9411 9.89852 12.5219C9.89852 13.1026 10.1289 13.6596 10.5391 14.0707L12.9309 16.4609C13.3476 16.8603 13.9025 17.0833 14.4798 17.0833C15.057 17.0833 15.6119 16.8603 16.0287 16.4609L16.6384 15.8528C17.7828 16.1495 18.799 16.8119 19.5324 17.7392C19.0586 18.3469 18.4527 18.8388 17.7607 19.1778C17.0686 19.5168 16.3085 19.6938 15.5379 19.6957Z"
        fill="#0361F0" />
    <path
        d="M14.6689 12.3311C14.7295 12.3917 14.8014 12.4398 14.8806 12.4726C14.9597 12.5054 15.0446 12.5223 15.1303 12.5223C15.216 12.5223 15.3009 12.5054 15.38 12.4726C15.4592 12.4398 15.5311 12.3917 15.5917 12.3311L19.0433 8.87948V10.5653C19.0433 10.7383 19.112 10.9042 19.2343 11.0265C19.3566 11.1488 19.5225 11.2175 19.6954 11.2175C19.8684 11.2175 20.0343 11.1488 20.1566 11.0265C20.2789 10.9042 20.3476 10.7383 20.3476 10.5653V7.30451C20.3476 7.13154 20.2789 6.96566 20.1566 6.84336C20.0343 6.72105 19.8684 6.65234 19.6954 6.65234H16.4346C16.2617 6.65234 16.0958 6.72105 15.9735 6.84336C15.8512 6.96566 15.7825 7.13154 15.7825 7.30451C15.7825 7.47747 15.8512 7.64335 15.9735 7.76566C16.0958 7.88796 16.2617 7.95667 16.4346 7.95667H18.1205L14.6689 11.4082C14.6083 11.4688 14.5602 11.5407 14.5273 11.6199C14.4945 11.6991 14.4776 11.7839 14.4776 11.8696C14.4776 11.9554 14.4945 12.0402 14.5273 12.1194C14.5602 12.1986 14.6083 12.2705 14.6689 12.3311Z"
        fill="#0361F0" />
</svg>''';

final string2 =
    '''<svg width="21" height="22" viewBox="0 0 21 25" fill="none" xmlns="http://www.w3.org/2000/svg">
<path d="M14 12.5C13.337 12.5 12.7011 12.2366 12.2322 11.7678C11.7634 11.2989 11.5 10.663 11.5 10C11.5 9.33696 11.7634 8.70107 12.2322 8.23223C12.7011 7.76339 13.337 7.5 14 7.5C14.663 7.5 15.2989 7.76339 15.7678 8.23223C16.2366 8.70107 16.5 9.33696 16.5 10C16.5 10.3283 16.4353 10.6534 16.3097 10.9567C16.1841 11.26 15.9999 11.5356 15.7678 11.7678C15.5356 11.9999 15.26 12.1841 14.9567 12.3097C14.6534 12.4353 14.3283 12.5 14 12.5ZM14 3C12.1435 3 10.363 3.7375 9.05025 5.05025C7.7375 6.36301 7 8.14348 7 10C7 15.25 14 23 14 23C14 23 21 15.25 21 10C21 8.14348 20.2625 6.36301 18.9497 5.05025C17.637 3.7375 15.8565 3 14 3Z" fill="#0361F0"/>
<path d="M9 22L8.44342 22.5027L9 23.1189L9.55658 22.5027L9 22ZM9 22C9.55658 22.5027 9.55669 22.5026 9.55682 22.5024L9.55723 22.502L9.55852 22.5006L9.56299 22.4956L9.57937 22.4773C9.58598 22.4699 9.59401 22.4609 9.60339 22.4503C9.61409 22.4383 9.62656 22.4242 9.64073 22.4082C9.69393 22.348 9.77116 22.2598 9.86899 22.1463C10.0646 21.9192 10.3428 21.5903 10.6761 21.1797C11.342 20.3592 12.2311 19.2082 13.1217 17.8882C14.0109 16.5704 14.9108 15.0704 15.5907 13.5527C16.2662 12.0449 16.75 10.4643 16.75 9C16.75 6.94457 15.9335 4.97333 14.4801 3.51992C13.0267 2.06652 11.0554 1.25 9 1.25C6.94457 1.25 4.97333 2.06652 3.51992 3.51992C2.06652 4.97333 1.25 6.94457 1.25 9C1.25 10.4643 1.7338 12.0449 2.4093 13.5527C3.0892 15.0704 3.98912 16.5704 4.87828 17.8882C5.76888 19.2082 6.65799 20.3592 7.32391 21.1797C7.65719 21.5903 7.9354 21.9192 8.13101 22.1463C8.22884 22.2598 8.30607 22.348 8.35927 22.4082C8.38587 22.4383 8.40647 22.4615 8.42063 22.4773L8.43701 22.4956L8.44148 22.5006L8.44277 22.502L8.44318 22.5024C8.44331 22.5026 8.44342 22.5027 9 22ZM9 10.75C8.53587 10.75 8.09075 10.5656 7.76256 10.2374C7.43437 9.90925 7.25 9.46413 7.25 9C7.25 8.53587 7.43437 8.09075 7.76256 7.76256C8.09075 7.43437 8.53587 7.25 9 7.25C9.46413 7.25 9.90925 7.43437 10.2374 7.76256C10.5656 8.09075 10.75 8.53587 10.75 9C10.75 9.22981 10.7047 9.45738 10.6168 9.6697C10.5288 9.88202 10.3999 10.0749 10.2374 10.2374C10.0749 10.3999 9.88202 10.5288 9.6697 10.6168C9.45738 10.7047 9.22981 10.75 9 10.75Z" fill="#0361F0" stroke="#F9FBFD" stroke-width="1.5"/>
<circle cx="9" cy="9" r="2" fill="#F9FBFD"/>
</svg>
''';
