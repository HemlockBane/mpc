import 'dart:ui';

import 'package:flutter/material.dart' hide Colors, ScrollView;
import 'package:flutter_svg/flutter_svg.dart';
import 'package:moniepoint_flutter/app/accountupdates/views/restriction_pages/account_status_page_icon.dart';
import 'package:moniepoint_flutter/app/accountupdates/views/restriction_pages/account_status_requirement_view.dart';
import 'package:moniepoint_flutter/core/colors.dart';
import 'package:moniepoint_flutter/core/models/user_instance.dart';
import 'package:moniepoint_flutter/core/routes.dart';
import 'package:moniepoint_flutter/core/styles.dart';
import 'package:moniepoint_flutter/core/views/scroll_view.dart';
import 'package:moniepoint_flutter/core/views/sessioned_widget.dart';

class AccountUpgradeInfoScreen extends StatelessWidget {

  AccountUpgradeInfoScreen({required this.userAccountId});

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
                      child: SvgPicture.asset("res/drawables/ic_upload.svg", color: Colors.white),
                    )
                ),
                SizedBox(height: 15,),
                Text(
                  "Upgrade Your\nAccount",
                  style: TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                      color: Colors.textColorBlack
                  ),
                ),
                SizedBox(height: 8,),
                Text(
                  "Upgrade your account to enjoy higher transaction limits and avoid regulatory issues.",
                  style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.normal,
                      color: Colors.textColorBlack
                  ),
                ),
                SizedBox(height: 50),
                Text(
                  "What do I need to begin?",
                  style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                      color: Colors.textColorBlack
                  ),
                ),
                SizedBox(height: 6),
                Text(
                  "You can upgrade your account by providing  the following:",
                  style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.normal,
                      color: Colors.textColorBlack
                  ),
                ),
                SizedBox(height: 16),
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