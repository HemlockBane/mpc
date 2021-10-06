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
import 'package:moniepoint_flutter/core/utils/currency_util.dart';

class AccountRestrictionScreen extends StatelessWidget {

  AccountRestrictionScreen({required this.userAccountId});

  final int userAccountId;

  @override
  Widget build(BuildContext context) {
    final userAccount = UserInstance().getUserAccount(userAccountId);

    //If for any weird reason the userAccount is null lets return back
    if (userAccount == null) {
      Future.delayed(Duration.zero, () => Navigator.of(context).pop());
      return Container();
    }

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
                      color: Colors.red.withOpacity(0.1),
                      icon: Container(
                        padding: EdgeInsets.all(6),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.red
                        ),
                        child: SvgPicture.asset("res/drawables/ic_danger_white.svg"),
                      )
                  ),
                  SizedBox(height: 15,),
                  Text(
                      "Account Restricted",
                      style: TextStyle(
                        fontSize: 32,
                        fontWeight: FontWeight.bold,
                        color: Colors.textColorBlack
                      ),
                  ),
                  SizedBox(height: 8),
                  Text(
                    "Your account has been placed on a No-Debit restriction due "
                        "to a violation of one of your account rules.",
                    style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.normal,
                        color: Colors.textColorBlack
                    ),
                  ),
                  SizedBox(height: 12,),
                  _AccountRestrictedRulesView(userAccount: userAccount,),
                  SizedBox(height: 38),
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
                    "You would need to upgrade your account by providing more information."
                        " Please provide the following:",
                    style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.normal,
                        color: Colors.textColorBlack
                    ),
                  ),
                  SizedBox(height: 15),
                  AccountStatusRequirementView(userAccount: userAccount),
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
                  SizedBox(
                    width: double.infinity,
                    child: Styles.appButton(
                        elevation: 0.3,
                        onClick: () => Navigator.of(context).popAndPushNamed(Routes.ACCOUNT_UPDATE),
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

///_AccountRestrictedRulesView
///
///
///
///
///
class _AccountRestrictedRulesView  extends StatelessWidget {

  _AccountRestrictedRulesView({required this.userAccount});

  final UserAccount userAccount;

  @override
  Widget build(BuildContext context) {

    final accountStatus = userAccount.accountStatus;
    final isPostNoDebit = accountStatus?.postNoDebit;

    if(isPostNoDebit == null || isPostNoDebit == false) return SizedBox();

    final postNoDebitInfo = accountStatus?.postNoDebitInfo;
    final cumulativeBalance =  postNoDebitInfo?.recordedCumulativeBalance?.formatCurrency ?? "0";
    final maxCumulativeBalance =  postNoDebitInfo?.permittedCumulativeBalance?.formatCurrency ?? "0";

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(height: 19),
        Text(
            "Your Account’s Rules",
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w600,
              color: Colors.textColorBlack
            ),
        ),
        SizedBox(height: 10),
        Container(
          padding: EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(width: 0.7, color: Color(0XFF0357EE).withOpacity(0.1)),
            boxShadow: [
              BoxShadow(
                color: Color(0XFF0E4FB1).withOpacity(0.12),
                offset: Offset(0,1),
                blurRadius: 2
              )
            ]
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: EdgeInsets.symmetric(vertical: 6, horizontal: 4),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(4),
                  color: Colors.primaryColor.withOpacity(0.1)
                ),
                child: Text(
                    accountStatus?.schemeCode?.name.toUpperCase() ?? "",//TODO change
                    style: TextStyle(
                      color: Colors.solidDarkBlue,
                      fontSize: 10,
                      fontWeight: FontWeight.w500
                    ),
                ),
              ),
              SizedBox(height: 9),
              Text(
                "Current Balance",
                style: TextStyle(
                    color: Colors.solidDarkBlue.withOpacity(0.5),
                    fontSize: 12,
                    fontWeight: FontWeight.w300
                ),
              ),
              Text(
                cumulativeBalance,
                style: TextStyle(
                  color: Colors.red,
                  fontSize: 22,
                  fontWeight: FontWeight.bold
                ),
              ),
              SizedBox(height: 8),
              Row(
                children: [
                  Text(
                    "Balance Limit",
                    style: TextStyle(
                      color: Colors.solidDarkBlue.withOpacity(0.5),
                      fontSize: 12,
                      fontWeight: FontWeight.w300,
                    ),
                  ),
                  SizedBox(width: 4),
                  Text(
                    maxCumulativeBalance,
                    style: TextStyle(
                      color: Color(0XFF282828),
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                    ),
                  )
                ],
              ),
            ],
          ),
        )
      ],
    );
  }
}