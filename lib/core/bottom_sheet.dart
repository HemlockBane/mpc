import 'package:flutter/material.dart' hide Colors;
import 'package:flutter_svg/flutter_svg.dart';
import 'package:moniepoint_flutter/core/colors.dart';
import 'package:moniepoint_flutter/core/styles.dart';

class BottomSheets {
  static Widget makeAppBottomSheet(
      {double? height,
      Color curveBackgroundColor = Colors.white,
      Color centerImageBackgroundColor = Colors.primaryColor,
      Color contentBackgroundColor = Colors.white,
      String centerImageRes = 'res/drawables/ic_key.svg',
      Widget? content}) {
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
              padding: EdgeInsets.only(top: 43),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(16),
                      topRight: Radius.circular(16)),
                  color: contentBackgroundColor),
              child: content,
            ),
            Positioned(
              child: Container(
                decoration: BoxDecoration(
                  color: centerImageBackgroundColor,
                  shape: BoxShape.circle,
                ),
                child: SvgPicture.asset(centerImageRes, width: 33, height: 33),
                padding: EdgeInsets.all(20),
                margin: EdgeInsets.only(top: 10),
              ),
              left: 0,
              right: 0,
            ),
          ],
        ));
  }

  static Widget displayErrorModal(BuildContext context,
      {String title = "Oops", String? message = "", VoidCallback? onClick}) {
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
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.white)),
                  SizedBox(height: 16),
                  Container(
                    width: double.infinity,
                    padding: EdgeInsets.symmetric(horizontal: 24, vertical: 24),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(8)),
                        color: Colors.darkRed),
                    child: Text(message ?? "",
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
                          onClick:
                          onClick ?? () => Navigator.of(context).pop(),
                          text: 'Continue',
                          buttonStyle: Styles.whiteButtonStyle.copyWith(
                              foregroundColor: MaterialStateProperty.all(
                                  Colors.modalRed)))),
                  SizedBox(height: 64)
                ],
              ),
            )
          ],
        )
    );
  }
}
