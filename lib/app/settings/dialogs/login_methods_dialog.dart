import 'package:flutter/material.dart' hide Colors;
import 'package:flutter_svg/svg.dart';
import 'package:moniepoint_flutter/core/bottom_sheet.dart';
import 'package:moniepoint_flutter/core/colors.dart';
import 'package:moniepoint_flutter/core/tuple.dart';
import 'package:moniepoint_flutter/core/utils/biometric_helper.dart';
import 'package:moniepoint_flutter/core/utils/preference_util.dart';

class LoginMethodsDialog extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _LoginMethodDialog();
}

class _LoginMethodDialog extends State<LoginMethodsDialog> {

  BiometricType? _biometricType;
  bool _isFingerprintAvailable = false;
  bool _isFingerprintSetup = false;

  void _onFingerprintSwitched(bool value) async {
    if(!_isFingerprintAvailable) return;
    final biometricHelper = BiometricHelper.getInstance();
    final fingerprintPassword = await biometricHelper.getFingerprintPassword();
    if(value && fingerprintPassword == null) {
      Navigator.of(context).pop(true);
    } else {
      setState(() {
        PreferenceUtil.setFingerPrintEnabled(value);
      });
    }
  }

  void _initializeState() async {
    final biometricHelper = BiometricHelper.getInstance();
    _biometricType = await biometricHelper.getBiometricType();
    final fingerprintPassword = await biometricHelper.getFingerprintPassword();
    _isFingerprintAvailable = _biometricType != BiometricType.NONE;
    _isFingerprintSetup = fingerprintPassword != null;
    Future.delayed(Duration(milliseconds: 100), () => setState(() {}));
  }

  @override
  void initState() {
    _initializeState();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final biometricTitle = (_biometricType == BiometricType.FINGER_PRINT)
        ? "Use Fingerprint"
        : (_biometricType == BiometricType.FACE_ID)
            ? "Use Face ID"
            : "Use Fingerprint/FaceID";

    return BottomSheets.makeAppBottomSheet(
        curveBackgroundColor: Colors.white,
        centerImageBackgroundColor: Colors.primaryColor.withOpacity(0.1),
        contentBackgroundColor: Colors.white,
        centerImageRes: 'res/drawables/ic_password_lock.svg',
        centerImageHeight: 18,
        centerImageWidth: 18,
        centerBackgroundHeight: 74,
        centerBackgroundWidth: 74,
        centerBackgroundPadding: 18,
        content: SafeArea(child: Wrap(children: [
          Container(
            child: Column(
              children: [
                SizedBox(
                  height: 16,
                ),
                Center(
                  child: Text('Login Methods',
                      style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.w600,
                          color: Colors.colorPrimaryDark)),
                ),
                SizedBox(height: 24),
                SwitchListTile(
                  secondary: Container(
                    height: 60,
                    width: 60,
                    padding: EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      color: Colors.deepGrey.withOpacity(0.1),
                      shape: BoxShape.circle,
                    ),
                    child: Center(
                      child: SvgPicture.asset(
                        'res/drawables/ic_password_lock.svg',
                        color: Color(0XFF9DA1AB),
                        width: 40,
                        height: 40,
                      ),
                    ),
                  ),
                  value: true,
                  onChanged: (v) {},
                  title: Text('Use Password', style: TextStyle(fontSize: 18, color: Colors.textColorMainBlack),),
                  subtitle: Text('Enabled by default', style: TextStyle(fontSize: 14, color: Colors.textColorMainBlack.withOpacity(0.3)),),
                  activeTrackColor: Colors.grey.withOpacity(0.5),
                  inactiveTrackColor: Colors.grey.withOpacity(0.5),
                  inactiveThumbColor: Colors.grey.withOpacity(0.5),
                  activeColor: Colors.deepGrey,
                ),
                Padding(
                  padding: EdgeInsets.only(left: 24, right:24, top: 8, bottom: 14),
                  child: Divider(height: 1, color: Colors.grey.withOpacity(0.2),),
                ),
                SwitchListTile(
                  secondary: Container(
                    height: 60,
                    width: 60,
                    padding: EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      color: Colors.primaryColor.withOpacity(0.1),
                      shape: BoxShape.circle,
                    ),
                    child: Center(
                      child: SvgPicture.asset(
                        'res/drawables/ic_finger_print.svg',
                        color: Colors.primaryColor,
                        width: 40,
                        height: 40,
                      ),
                    ),
                  ),
                  value: !_isFingerprintAvailable ? false : PreferenceUtil.getFingerPrintEnabled(),
                  onChanged: _onFingerprintSwitched,
                  title: Text(biometricTitle, style: TextStyle(fontSize: 18, color: Colors.textColorMainBlack),),
                  subtitle: (!_isFingerprintAvailable || !_isFingerprintSetup)
                      ? Text(!_isFingerprintAvailable ? 'Device not supported' : 'Fingerprint not setup', style: TextStyle(fontSize: 14, color: Colors.textColorMainBlack.withOpacity(0.3)),)
                      : null,
                  activeTrackColor: Colors.solidOrange.withOpacity(0.5),
                  inactiveTrackColor: Colors.grey.withOpacity(0.5),
                  inactiveThumbColor: Colors.white.withOpacity(0.5),
                  activeColor: Colors.solidOrange,
                ),
                SizedBox(height: 64,)
              ],
            ),
          )
        ])));
  }
}
