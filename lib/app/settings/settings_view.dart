
import 'package:flutter/material.dart' hide Colors;
import 'package:flutter_svg/flutter_svg.dart';
import 'package:moniepoint_flutter/core/colors.dart';
import 'package:moniepoint_flutter/core/config/build_config.dart';
import 'package:moniepoint_flutter/core/routes.dart';
import 'package:moniepoint_flutter/core/utils/preference_util.dart';
import 'package:moniepoint_flutter/core/views/sessioned_widget.dart';

///
///@author Paul Okeke
///
class SettingsScreen extends StatefulWidget {

  @override
  State<StatefulWidget> createState() => _SettingsScreen();

}

class _SettingsScreen extends State<SettingsScreen> {

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey();

  void _onChangePassword() async {
    Navigator.of(context).pushNamed(Routes.SETTINGS_CHANGE_PASSWORD);
  }

  void _onChangePin() async {
    Navigator.of(context).pushNamed(Routes.SETTINGS_CHANGE_PIN);
  }

  void _onResetPin() async {
    Navigator.of(context).pushNamed(Routes.SETTINGS_RESET_PIN);
  }

  void _openLoginMethods() async {
    Navigator.of(context).pushNamed(Routes.SETTINGS_CHANGE_LOGIN_METHOD);
  }

  Widget _listView() {
    final bool isFingerPrintEnabled = PreferenceUtil.getFingerPrintEnabled();
    return Container(
      width: double.infinity,
      height: double.infinity,
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(topLeft: Radius.circular(30), topRight: Radius.circular(30)),
      ),
      child: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(height: 16),
            ListTile(
                title: Text('Login Methods',
                    style: TextStyle(
                        color: Colors.textColorMainBlack,
                        fontSize: 16,
                        fontWeight: FontWeight.normal)
                ),
                onTap: _openLoginMethods,
                trailing:
                SvgPicture.asset('res/drawables/ic_forward_anchor.svg'),
                subtitle: Text('Password Enabled, Fingerprint ${(isFingerPrintEnabled) ? "Enabled" : "Disabled"}',
                    style: TextStyle(
                        color: Colors.deepGrey,
                        fontSize: 14,
                        fontWeight: FontWeight.normal)
                )
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
              title: Text('Reset Transaction PIN',
                  style: TextStyle(
                      color: Colors.textColorMainBlack,
                      fontSize: 16,
                      fontWeight: FontWeight.normal)),
              onTap: _onResetPin,
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
                      fontWeight: FontWeight.normal
                  )
              ),
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
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: Colors.white,
      extendBodyBehindAppBar: true,
      appBar: AppBar(
          centerTitle: false,
          titleSpacing: 0,
          iconTheme: IconThemeData(color: Colors.primaryColor),
          title: Text('Settings',
              textAlign: TextAlign.start,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w700,
                color: Colors.textColorBlack
              )
          ),
          backgroundColor: Colors.backgroundWhite.withOpacity(0.05),
          elevation: 0
      ),
      body: SessionedWidget(
          context: context,
          child: Container(
            padding: EdgeInsets.only(top: 120),
            decoration: BoxDecoration(
                color: Colors.backgroundWhite,
                image: DecorationImage(
                    fit: BoxFit.cover,
                    image: AssetImage("res/drawables/ic_app_new_bg.png")
                )
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: EdgeInsets.only(left: 16),
                  child: Text(
                    "Manage Settings",
                    style: TextStyle(
                      color: Colors.textColorBlack,
                      fontSize: 24,
                      fontWeight: FontWeight.w700
                    ),
                  ),
                ),
                SizedBox(height: 2),
                Padding(
                  padding: EdgeInsets.only(left: 16),
                  child: Text(
                    "Customize your Moniepoint experience",
                    style: TextStyle(
                      color: Colors.textColorBlack.withOpacity(0.5),
                      fontWeight: FontWeight.w500,
                      fontSize: 12,
                    ),
                  ),
                ),
                SizedBox(height: 21),
                Expanded(child: _listView())
              ],
            ),
          ),
      ),
    );
  }

}