import 'package:flutter/material.dart' hide Colors;
import 'package:moniepoint_flutter/core/bottom_sheet.dart';
import 'package:moniepoint_flutter/core/colors.dart';
import 'package:moniepoint_flutter/core/models/user_instance.dart';
import 'package:moniepoint_flutter/core/styles.dart';
import 'package:moniepoint_flutter/core/tuple.dart';
import 'package:moniepoint_flutter/core/utils/text_utils.dart';
import 'package:moniepoint_flutter/core/utils/currency_util.dart';

class PndInstructionDialog extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    final accountStatus = UserInstance().accountStatus;

    final recordedCumulative = accountStatus?.postNoDebitInfo?.recordedSingleCredit?.formatCurrency ?? "0";
    final recordedSingle = accountStatus?.postNoDebitInfo?.recordedSingleCredit?.formatCurrency ?? "0";
    final maxCumulative = "Max cumulative balance exceeded $recordedCumulative / ${accountStatus?.postNoDebitInfo?.permittedCumulativeBalance?.formatCurrency ?? "0"}";
    final maxSingle = "Max single credit amount exceeded $recordedSingle / ${accountStatus?.postNoDebitInfo?.permittedSingleCredit?.formatCurrency ?? "0"}";

    return BottomSheets.makeAppBottomSheet(
        curveBackgroundColor: Colors.white,
        centerImageBackgroundColor: Colors.red.withOpacity(0.1),
        contentBackgroundColor: Colors.white,
        centerImageRes: 'res/drawables/ic_password_lock.svg',
        centerImageColor: Colors.red,
        content: Wrap(
          children: [
            Container(
              padding: EdgeInsets.only(left: 16, right: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  SizedBox(height: 20,),
                  Padding(
                      padding: EdgeInsets.symmetric(horizontal: 24),
                      child: Text(
                        'A post-no-debit instruction has been placed on your account due to the following violations:',
                        textAlign: TextAlign.start,
                        style: TextStyle(color: Colors.black),
                      ),
                  ),
                  SizedBox(height: 24,),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 24, vertical: 0),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("1."),
                        SizedBox(width: 4,),
                        Flexible(
                            child: Text(maxCumulative,
                                style: TextStyle(
                                    color: Colors.black,
                                    fontFamily: Styles.defaultFont,
                                    fontFamilyFallback: ["Roboto"]
                                )).colorText({recordedCumulative: Tuple(Colors.red, null)}, bold: false, underline: false)
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 24,),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 24, vertical: 0),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("2."),
                        SizedBox(width: 4,),
                        Flexible(
                            child: Text(maxSingle,
                                style: TextStyle(
                                    color: Colors.black,
                                    fontFamily: Styles.defaultFont,
                                    fontFamilyFallback: ["Roboto"]
                                ))
                                .colorText({recordedSingle: Tuple(Colors.red, null)}, bold: false, underline: false)
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 40,),
                  SizedBox(
                    width: double.infinity,
                    child: Styles.appButton(
                        elevation: 0,
                        onClick: () => Navigator.of(context).pop(),
                        text: "Dismiss",
                        buttonStyle: Styles.primaryButtonStyle.copyWith(
                          backgroundColor: MaterialStateProperty.all(Colors.primaryColor.withOpacity(0.1)),
                          foregroundColor: MaterialStateProperty.all(Colors.primaryColor),
                          textStyle: MaterialStateProperty.all(TextStyle(
                              fontSize: 16,
                              color: Colors.white,
                              fontWeight: FontWeight.w600,
                              fontFamily: Styles.defaultFont
                          ))
                        )
                    ),
                  ),
                  SizedBox(height: 26,),
                ],
              ),
            )
          ],
        )
    );
  }

}