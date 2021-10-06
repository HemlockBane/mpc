import 'dart:ui';

import 'package:flutter/material.dart' hide Colors, ScrollView;
import 'package:flutter_svg/flutter_svg.dart';
import 'package:moniepoint_flutter/app/accountupdates/views/restriction_pages/account_status_page_icon.dart';
import 'package:moniepoint_flutter/app/accountupdates/views/restriction_pages/account_status_requirement_view.dart';
import 'package:moniepoint_flutter/app/customer/user_account.dart';
import 'package:moniepoint_flutter/core/colors.dart';
import 'package:moniepoint_flutter/core/models/user_instance.dart';
import 'package:moniepoint_flutter/core/routes.dart';
import 'package:moniepoint_flutter/core/styles.dart';
import 'package:moniepoint_flutter/core/views/scroll_view.dart';
import 'package:moniepoint_flutter/core/views/sessioned_widget.dart';

class AccountStatusRegularizeDocumentScreen extends StatelessWidget {

  AccountStatusRegularizeDocumentScreen({required this.userAccountId});

  final int userAccountId;

  String _requiredDocumentText(UserAccount? userAccount) {
    if(userAccount?.customer?.reUploadID == true
        && userAccount?.customer?.reUploadProofOfAddress == true) {
      return "ID and Proof Of Address";
    } else if(userAccount?.customer?.reUploadID == true) {
      return "ID";
    } else if(userAccount?.customer?.reUploadProofOfAddress == true){
      return "Proof of Address";
    }
    return "";
  }

  String _getInfoText(UserAccount? userAccount) {
    if(userAccount?.customer?.reUploadID == true
        && userAccount?.customer?.reUploadProofOfAddress == true) {
      return "some documents you uploaded";
    } else if(userAccount?.customer?.reUploadID == true) {
      return "your ID you uploaded";
    } else if(userAccount?.customer?.reUploadProofOfAddress == true) {
      return "the Proof of Address you uploaded";
    }
    return "";
  }

  @override
  Widget build(BuildContext context) {
    final userAccount = UserInstance().getUserAccount(userAccountId);
    final requiredDocuments = _requiredDocumentText(userAccount);
    final infoText = _getInfoText(userAccount);

    return SessionedWidget(
      context: context,
      child: Scaffold(
        backgroundColor: Colors.backgroundTwo,
        appBar: AppBar(
            centerTitle: false,
            titleSpacing: -12,
            iconTheme: IconThemeData(color: Colors.primaryColor),
            title: Text('Account Management',
                textAlign: TextAlign.start,
                style: TextStyle(
                    color: Colors.textColorBlack,
                    fontFamily: Styles.defaultFont,
                    fontSize: 14,
                    fontWeight: FontWeight.bold
                )
            ),
            backgroundColor: Colors.transparent,
            elevation: 0
        ),
        body: ScrollView(
          child: Container(
            padding: EdgeInsets.only(left: 20, right: 20, top: 10, bottom: 32),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                AccountStatusPageIcon(
                    color: Colors.primaryColor.withOpacity(0.1),
                    icon: Container(
                      padding: EdgeInsets.all(4),
                      decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.primaryColor
                      ),
                      child: SvgPicture.asset("res/drawables/ic_danger_white.svg"),
                    )
                ),
                SizedBox(height: 15,),
                Text(
                  "Regularize\nDocuments",
                  style: TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                      color: Colors.textColorBlack
                  ),
                ),
                SizedBox(height: 8),
                Text(
                  "We have discovered some problems with $infoText.",
                  style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.normal,
                      color: Colors.textColorBlack
                  ),
                ),
                SizedBox(height: 34),
                Text(
                  "How do I fix this?",
                  style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                      color: Colors.textColorBlack
                  ),
                ),
                SizedBox(height: 6),
                Text(
                  "You would need to re-upload the $requiredDocuments. Please provide the following:",
                  style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.normal,
                      color: Colors.textColorBlack
                  ),
                ),
                SizedBox(height: 15),
                AccountStatusRequirementView(
                  userAccount: userAccount,
                  requirementMode: AccountRequirementMode.REGULARIZE_DOCUMENT
                ),
                SizedBox(height: 21),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                        "*",
                        style: TextStyle(
                            color: Colors.colorFaded,
                            fontSize: 18,
                            fontWeight: FontWeight.bold
                        )
                    ),
                    SizedBox(width: 6,),
                    Flexible(
                        child: Text(
                            "All documents should be valid at the time of registration",
                            style: TextStyle(
                                color: Colors.darkBlue,
                                fontSize: 12,
                                fontWeight: FontWeight.normal
                            )
                        )
                    ),
                  ],
                ),
                SizedBox(height: 39),
                Spacer(),
                SizedBox(
                  width: double.infinity,
                  child: Styles.appButton(
                      elevation: 0.3,
                      onClick: () async {
                        await Navigator.of(context).pushNamed(Routes.ACCOUNT_UPDATE);
                        Navigator.of(context).pop();
                      },
                      text: "Get Started",
                      textStyle: TextStyle(
                          fontWeight: FontWeight.w500,
                          fontSize: 15,
                          color: Colors.white
                      )
                  ),
                ),
                SizedBox(height: 25),
                Center(
                    child: TextButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        child: Text(
                          "Dismiss",
                          style: TextStyle(
                              color: Colors.primaryColor,
                              fontSize: 14,
                              fontWeight: FontWeight.w600
                          ),
                        )
                    )
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

}
