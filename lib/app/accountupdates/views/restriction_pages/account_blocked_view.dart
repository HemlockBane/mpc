import 'dart:ui';

import 'package:flutter/material.dart' hide Colors, ScrollView;
import 'package:flutter_svg/flutter_svg.dart';
import 'package:moniepoint_flutter/app/accountupdates/views/restriction_pages/account_status_page_icon.dart';
import 'package:moniepoint_flutter/app/login/views/support_contact_view.dart';
import 'package:moniepoint_flutter/core/colors.dart';
import 'package:moniepoint_flutter/core/styles.dart';
import 'package:moniepoint_flutter/core/utils/dialog_util.dart';
import 'package:moniepoint_flutter/core/viewmodels/system_configuration_view_model.dart';
import 'package:moniepoint_flutter/core/views/scroll_view.dart';
import 'package:moniepoint_flutter/core/views/sessioned_widget.dart';
import 'package:provider/provider.dart';

class AccountBlockedView extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    final viewModel = Provider.of<SystemConfigurationViewModel>(context, listen: false);
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
                        padding: EdgeInsets.all(10),
                        decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.red
                        ),
                        child: SvgPicture.asset("res/drawables/ic_account_blocked.svg",width: 16, height: 19,),
                      )
                  ),
                  SizedBox(height: 15,),
                  Text(
                      "Account Blocked",
                      style: TextStyle(
                        fontSize: 32,
                        fontWeight: FontWeight.bold,
                        color: Colors.textColorBlack
                      ),
                  ),
                  SizedBox(height: 8,),
                  Text(
                    "You blocked your account on the 12th of January 2021 at 12:33 AM.",
                    style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.normal,
                        color: Colors.textColorBlack
                    ),
                  ),
                  SizedBox(height: 50,),
                  Text(
                    "Account Block Reason",
                    style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                        color: Colors.textColorBlack
                    ),
                  ),
                  SizedBox(height: 8,),
                  Text(
                    "Because I said so :|",
                    style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.normal,
                        color: Colors.textColorBlack
                    ),
                  ),
                  SizedBox(height: 50),
                  Text(
                    "How do I fix this?",
                    style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                        color: Colors.textColorBlack
                    ),
                  ),
                  SizedBox(height: 6,),
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
                  SupportContactView(systemConfigStream: viewModel.getSystemConfigurations(forceRemote: false)),
                  SizedBox(height: 39),
                  Spacer(),
                  SizedBox(
                    width: double.infinity,
                    child: Styles.appButton(
                        elevation: 0.3,
                        onClick: () => showComingSoon(context, title: "Currently Unavailable"),
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