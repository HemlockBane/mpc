import 'package:flutter/material.dart' hide Colors;
import 'package:flutter_svg/svg.dart';
import 'package:moniepoint_flutter/core/views/bottom_sheet.dart';
import 'package:moniepoint_flutter/core/colors.dart';
import 'package:moniepoint_flutter/core/styles.dart';
import 'package:moniepoint_flutter/core/tuple.dart';
import 'package:moniepoint_flutter/core/extensions/text_utils.dart';

class UnlinkCardWarningDialog extends StatelessWidget {
  final String cardPan;
  final String accountNumber;

  UnlinkCardWarningDialog({required this.cardPan, required this.accountNumber});

  String _getMessage() {
    return "This action will unlink your current card $cardPan on your account $accountNumber."
        " The current card will become unusable.\n\nWould you like to continue?";
  }

  @override
  Widget build(BuildContext context) {
    return BottomSheets.makeAppBottomSheet2(
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
                  Text("Warning...",
                      style: TextStyle(
                          fontSize: 21,
                          fontWeight: FontWeight.bold,
                          color: Colors.black)),
                  SizedBox(height: 16),
                  Container(
                    width: double.infinity,
                    padding: EdgeInsets.symmetric(horizontal: 24, vertical: 24),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(8)),
                        color: Colors.red.withOpacity(0.1)),
                    child: Text(_getMessage(),
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.normal,
                            color: Colors.textColorBlack),
                    ).colorText({
                      "$cardPan" :  Tuple(Colors.textColorBlack, null),
                      "$accountNumber" :  Tuple(Colors.textColorBlack, null)
                    }, underline: false),
                  ),
                  SizedBox(height: 12),
                  SizedBox(
                    width: double.infinity,
                    child: Styles.appButton(
                        elevation: 0.2,
                        buttonStyle: Styles.redButtonStyle2,
                        onClick: () => Navigator.of(context).pop(true),
                        text: "Go ahead, Unlink the card"
                    ),
                  ),
                  SizedBox(height: 29),
                  TextButton(
                    child: Text(
                      "Cancel",
                      style: TextStyle(color: Colors.primaryColor, fontSize: 15, fontWeight: FontWeight.w500),
                    ),
                    onPressed: () => Navigator.of(context).pop(false),
                  ),
                  SizedBox(height: 42),
                ],
              ),
            )
          ],
        ));
  }
}
