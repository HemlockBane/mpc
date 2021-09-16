
import 'dart:math';

import 'package:flutter/material.dart' hide Colors;
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';
import 'package:lottie/lottie.dart';
import 'package:moniepoint_flutter/app/accounts/model/data/account_update_flag.dart';
import 'package:moniepoint_flutter/app/accountupdates/views/account_update_form_view.dart';
import 'package:moniepoint_flutter/core/colors.dart';
import 'package:moniepoint_flutter/core/styles.dart';
import 'package:moniepoint_flutter/core/tuple.dart';
import 'package:moniepoint_flutter/core/extensions/text_utils.dart';

class DocumentVerificationScreen extends PagedForm {

  final AccountUpdateFlag? idVerificationFlag;
  final AccountUpdateFlag? addressVerificationFlag;

  DocumentVerificationScreen(this.idVerificationFlag, this.addressVerificationFlag);

  @override
  String getTitle() => "";

  @override
  State<StatefulWidget> createState() => _DocumentVerificationScreen();

  static String getMaxDocumentVerificationTime(AccountUpdateFlag? idVerificationFlag, AccountUpdateFlag? addressVerificationFlag) {
    final idVerificationTime = idVerificationFlag?.verificationEndTime;
    final addressVerificationTime = addressVerificationFlag?.verificationEndTime;

    if(idVerificationTime == null && addressVerificationTime == null ) return "";

    final idDateTime = DateTime.parse(idVerificationTime ?? addressVerificationTime ?? "");
    final addressDateTime = DateTime.parse(addressVerificationTime ?? idVerificationTime ?? "");

    final maxTime = max(idDateTime.millisecondsSinceEpoch, addressDateTime.millisecondsSinceEpoch);

    return DateFormat("d MMM yyyy").format(DateTime.fromMillisecondsSinceEpoch(maxTime));
  }
}

class _DocumentVerificationScreen extends State<DocumentVerificationScreen> {

  bool _documentIsInErrorState() {
    return widget.idVerificationFlag?.verificationStates != VerificationState.INPROGRESS
    && widget.addressVerificationFlag?.verificationStates != VerificationState.INPROGRESS;
  }
  
  String getVerificationTextWithTime() {
    String description = "We are verifying your documents.\n";

    String maxTime = DocumentVerificationScreen.getMaxDocumentVerificationTime(
        widget.idVerificationFlag, widget.addressVerificationFlag
    );

    return (maxTime.isNotEmpty)
        ? "${description}Expect verification on or before \n$maxTime."
        : "$description";
  }

  @override
  Widget build(BuildContext context) {
    final hasError = _documentIsInErrorState();
    final maxTime = DocumentVerificationScreen.getMaxDocumentVerificationTime(
        widget.idVerificationFlag, widget.addressVerificationFlag
    );
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Flexible(
          child: Text(
            (!hasError)
                ? "Document Verification\nIn Progress..."
                : "We Encountered a Problem \nConcluding your Verification",
            textAlign: TextAlign.center,
            style: TextStyle(
                color: (hasError)
                ? Colors.red
                : Colors.darkBlue, fontSize: 22, fontWeight: FontWeight.w600
            ),
          ),
        ),
        SizedBox(height: 12),
        Flexible(
          child: Text(
            (!hasError) ? getVerificationTextWithTime() : "Please contact bank support.",
            textAlign: TextAlign.center,
            style: TextStyle(
                color: Colors.textColorBlack,
                fontSize: 16,
                fontWeight: FontWeight.normal,
                fontFamily: Styles.defaultFont,
                height: 1.4
            ),
          ).colorText({maxTime: Tuple(Colors.darkBlue, null)}, underline: false),
        ),
        SizedBox(height: hasError ? 24 : 0,),
        hasError
            ? SvgPicture.asset("res/drawables/ic_warning.svg", width:70, height: 70,)
            : Lottie.asset('res/drawables/timer_lottie.json', repeat: true),
        SizedBox(height: hasError ? 80 : 0,),
      ],
    );
  }

}