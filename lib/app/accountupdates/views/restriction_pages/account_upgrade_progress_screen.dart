import 'dart:ui';

import 'package:flutter/material.dart' hide Colors, ScrollView;
import 'package:flutter_svg/flutter_svg.dart';
import 'package:moniepoint_flutter/app/accountupdates/views/restriction_pages/account_status_page_icon.dart';
import 'package:moniepoint_flutter/app/accountupdates/views/restriction_pages/account_status_requirement_view.dart';
import 'package:moniepoint_flutter/core/colors.dart';
import 'package:moniepoint_flutter/core/models/user_instance.dart';
import 'package:moniepoint_flutter/core/styles.dart';
import 'package:moniepoint_flutter/core/views/scroll_view.dart';
import 'package:moniepoint_flutter/core/views/sessioned_widget.dart';

class AccountUpgradeProgressScreen extends StatelessWidget {

  AccountUpgradeProgressScreen({required this.userAccountId});

  final int userAccountId;

  @override
  Widget build(BuildContext context) {
    final userAccount = UserInstance().getUserAccount(userAccountId);
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
                    color: Colors.solidGreen.withOpacity(0.1),
                    icon: Container(
                      padding: EdgeInsets.all(6),
                      decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.solidGreen
                      ),
                      child: SvgPicture.asset("res/drawables/ic_account_upgrade_progress.svg",),
                    )
                ),
                SizedBox(height: 15,),
                Text(
                  "Account Upgrade\nIn Progress...",
                  style: TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                      color: Colors.textColorBlack
                  ),
                ),
                SizedBox(height: 8,),
                Text(
                  "Please give us some time to verify your documents.",
                  style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.normal,
                      color: Colors.textColorBlack
                  ),
                ),
                SizedBox(height: 50),
                AccountStatusRequirementView(
                  userAccount: userAccount,
                  requirementMode: AccountRequirementMode.IN_PROGRESS,
                ),
                SizedBox(height: 39),
                Spacer(),
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