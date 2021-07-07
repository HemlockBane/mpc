
import 'package:flutter/material.dart' hide Colors;
import 'package:flutter_svg/flutter_svg.dart';
import 'package:moniepoint_flutter/app/settings/dialogs/change_password_dialog.dart';
import 'package:moniepoint_flutter/app/settings/dialogs/change_pin_dialog.dart';
import 'package:moniepoint_flutter/app/settings/dialogs/login_methods_dialog.dart';
import 'package:moniepoint_flutter/app/usermanagement/viewmodels/change_password_view_model.dart';
import 'package:moniepoint_flutter/app/usermanagement/viewmodels/change_pin_view_model.dart';
import 'package:moniepoint_flutter/core/bottom_sheet.dart';
import 'package:moniepoint_flutter/core/colors.dart';
import 'package:moniepoint_flutter/core/config/build_config.dart';
import 'package:moniepoint_flutter/core/network/resource.dart';
import 'package:moniepoint_flutter/core/routes.dart';
import 'package:moniepoint_flutter/core/styles.dart';
import 'package:moniepoint_flutter/core/utils/preference_util.dart';
import 'package:moniepoint_flutter/core/viewmodels/finger_print_alert_view_model.dart';
import 'package:moniepoint_flutter/core/views/finger_print_alert_dialog.dart';
import 'package:moniepoint_flutter/core/views/sessioned_widget.dart';
import 'package:provider/provider.dart';

class SettingsScreen extends StatefulWidget {

  @override
  State<StatefulWidget> createState() => _SettingsScreen();

}

class _SettingsScreen extends State<SettingsScreen> {

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey();

  void _onChangePassword() async {
    dynamic result = await showModalBottomSheet(
        isScrollControlled: true,
        backgroundColor: Colors.transparent,
        context: _scaffoldKey.currentContext ?? context,
        builder: (context) => ChangeNotifierProvider(
          create:(_) => ChangePasswordViewModel(),
          child: ChangePasswordDialog(),
        )
    );
    if(result is Error<bool>) {
      showModalBottomSheet(
          backgroundColor: Colors.transparent,
          context: _scaffoldKey.currentContext ?? context,
          builder: (context) => BottomSheets.displayErrorModal(context, title: "Oops", message: result.message));
    } else if(result is bool && result == true) {
      _displaySuccessMessage("Password Changed", "Password was updated successfully");
    }
  }

  void _onChangePin() async {
    dynamic result = await showModalBottomSheet(
        isScrollControlled: true,
        backgroundColor: Colors.transparent,
        context: _scaffoldKey.currentContext ?? context,
        builder: (context) => ChangeNotifierProvider(
          create:(_) => ChangePinViewModel(),
          child: ChangePinDialog(),
        )
    );
    if(result is Error<bool>) {
      showModalBottomSheet(
          backgroundColor: Colors.transparent,
          context: _scaffoldKey.currentContext ?? context,
          builder: (context) => BottomSheets.displayErrorModal(context, title: "Oops", message: result.message));
    } else if(result is bool && result == true) {
      _displaySuccessMessage("Pin Changed", "Transaction PIN was updated successfully");
    }
  }

  void _openLoginMethods() async {
    dynamic result = await showModalBottomSheet(
        isScrollControlled: true,
        backgroundColor: Colors.transparent,
        context: _scaffoldKey.currentContext ?? context,
        builder: (mContext) => LoginMethodsDialog()
    );

    if(result is bool && result){
      final fingerprintResult = await showModalBottomSheet(
          isScrollControlled: true,
          backgroundColor: Colors.transparent,
          context: _scaffoldKey.currentContext ?? context,
          builder: (mContext) => ChangeNotifierProvider(
              create: (_) => FingerPrintAlertViewModel(),
              child: FingerPrintAlertDialog(),
          )
      );
      if (fingerprintResult != null && fingerprintResult is bool) {
        showModalBottomSheet(
            backgroundColor: Colors.transparent,
            context: context,
            builder: (mContext) => BottomSheets.displaySuccessModal(
                mContext,
                title: "Fingerprint setup",
                message: "Fingerprint Setup successfully"
            )
        );
      }
    }
  }

  void _displaySuccessMessage(String title, String message) {
    showModalBottomSheet(
        context: _scaffoldKey.currentContext ?? context,
        isScrollControlled: true,
        backgroundColor: Colors.transparent,
        builder: (mContext) => BottomSheets.displaySuccessModal(
            _scaffoldKey.currentContext ?? mContext,
            title: title,
            message: message,
            onClick: () => Navigator.of(_scaffoldKey.currentContext ?? context).pop()
        )
    );
  }

  @override
  Widget build(BuildContext context) {
    final bool isFingerPrintEnabled = PreferenceUtil.getFingerPrintEnabled();

    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: Colors.backgroundWhite,
      appBar: AppBar(
          centerTitle: false,
          titleSpacing: -12,
          iconTheme: IconThemeData(color: Colors.primaryColor),
          title: Text('Settings',
              textAlign: TextAlign.start,
              style: TextStyle(
                  color: Colors.darkBlue,
                  fontFamily: Styles.defaultFont,
                  fontSize: 17
              )
          ),
          backgroundColor: Colors.backgroundWhite,
          elevation: 0
      ),
      body: SessionedWidget(
          context: context,
          child: SingleChildScrollView(
            child: Column(
              children: [
                SizedBox(height: 16),
                ListTile(
                    title: Text('Login Methods',
                        style: TextStyle(
                            color: Colors.textColorMainBlack,
                            fontSize: 16,
                            fontWeight: FontWeight.normal)),
                    onTap: _openLoginMethods,
                    trailing:
                    SvgPicture.asset('res/drawables/ic_forward_anchor.svg'),
                    subtitle: Text('Password Enabled, Fingerprint ${(isFingerPrintEnabled) ? "Enabled" : "Disabled"}',
                        style: TextStyle(
                            color: Colors.deepGrey,
                            fontSize: 14,
                            fontWeight: FontWeight.normal))),
                Padding(
                  padding: EdgeInsets.only(left: 16, right: 16),
                  child: Divider(
                    height: 1,
                    color: Colors.dashboardDivider.withOpacity(0.2),
                  ),
                ),
                ListTile(
                  contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 7),
                  title: Text('Change Password',
                      style: TextStyle(
                          color: Colors.textColorMainBlack,
                          fontSize: 16,
                          fontWeight: FontWeight.normal)),
                  onTap: _onChangePassword,
                  trailing: SvgPicture.asset('res/drawables/ic_forward_anchor.svg'),
                ),
                Padding(
                  padding: EdgeInsets.only(left: 16, right: 16),
                  child: Divider(
                    height: 1,
                    color: Colors.dashboardDivider.withOpacity(0.2),
                  ),
                ),
                ListTile(
                  contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 7),
                  title: Text('Change Transaction PIN',
                      style: TextStyle(
                          color: Colors.textColorMainBlack,
                          fontSize: 16,
                          fontWeight: FontWeight.normal)),
                  onTap: _onChangePin,
                  trailing: SvgPicture.asset('res/drawables/ic_forward_anchor.svg'),
                ),
                Padding(
                  padding: EdgeInsets.only(left: 16, right: 16),
                  child: Divider(
                    height: 1,
                    color: Colors.dashboardDivider.withOpacity(0.2),
                  ),
                ),
                ListTile(
                  contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 7),
                  title: Text('Manage Beneficiaries',
                      style: TextStyle(
                          color: Colors.textColorMainBlack,
                          fontSize: 16,
                          fontWeight: FontWeight.normal)),
                  onTap: () => Navigator.of(context).pushNamed(Routes.MANAGED_BENEFICIARIES),
                  trailing: SvgPicture.asset('res/drawables/ic_forward_anchor.svg'),
                ),
                Padding(
                  padding: EdgeInsets.only(left: 16, right: 16),
                  child: Divider(
                    height: 1,
                    color: Colors.dashboardDivider.withOpacity(0.2),
                  ),
                ),
                ListTile(
                  contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 7),
                  title: Text('Registered Devices',
                      style: TextStyle(
                          color: Colors.textColorMainBlack,
                          fontSize: 16,
                          fontWeight: FontWeight.normal)),
                  onTap: () => Navigator.of(context).pushNamed(Routes.REGISTERED_DEVICES),
                  trailing: SvgPicture.asset('res/drawables/ic_forward_anchor.svg'),
                ),
                Padding(
                  padding: EdgeInsets.only(left: 16, right: 16),
                  child: Divider(
                    height: 1,
                    color: Colors.dashboardDivider.withOpacity(0.2),
                  ),
                ),
                ListTile(
                    title: Text('App Version',
                        style: TextStyle(
                            color: Colors.textColorMainBlack,
                            fontSize: 16,
                            fontWeight: FontWeight.normal
                        )),
                    trailing: null,
                    subtitle: Text("v ${BuildConfig.APP_VERSION}",
                        style: TextStyle(
                            color: Colors.deepGrey,
                            fontSize: 14,
                            fontWeight: FontWeight.normal
                        )
                    )
                ),
              ],
            ),
          ),
      ),
    );
  }

}