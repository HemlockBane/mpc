import 'package:flutter/material.dart' hide Colors;
import 'package:flutter_svg/svg.dart';
import 'package:moniepoint_flutter/app/login/views/biometric_login_screen.dart';
import 'package:moniepoint_flutter/core/network/resource.dart';
import 'package:moniepoint_flutter/core/network/response_observer.dart';
import 'package:moniepoint_flutter/core/routes.dart';
import 'package:moniepoint_flutter/core/utils/dialog_util.dart';
import 'package:moniepoint_flutter/core/viewmodels/finger_print_alert_view_model.dart';
import 'package:moniepoint_flutter/core/colors.dart';
import 'package:moniepoint_flutter/core/utils/biometric_helper.dart';
import 'package:moniepoint_flutter/core/utils/preference_util.dart';
import 'package:moniepoint_flutter/core/views/sessioned_widget.dart';
import 'package:moniepoint_flutter/main.dart';
import 'package:provider/provider.dart';

///
///@author Paul Okeke
///
class LoginMethodsDialog extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _LoginMethodDialog();
}

class _LoginMethodDialog extends State<LoginMethodsDialog> {

  late final LoginMethodViewModel _viewModel;
  BiometricType? _biometricType;
  bool _isFingerprintAvailable = false;
  bool _isFingerprintSetup = false;

  void _onFingerprintSwitched(bool value) async {
    if(!_isFingerprintAvailable) return;
    final biometricHelper = BiometricHelper.getInstance();
    final fingerprintPassword = await biometricHelper.getFingerprintPassword();

    if(value && fingerprintPassword == null) {
      _navigateToBiometricScreen();
    } else {
      setState(() {
        PreferenceUtil.setFingerPrintEnabled(value);
      });
    }
  }

  void _navigateToBiometricScreen(){
    final responseObserver = LoginMethodResponseObserver(
        context: context, biometricType: _biometricType
    );

    String biometricTypeText = "";
    if (_biometricType == BiometricType.FINGER_PRINT) {
      biometricTypeText = "Fingerprint";
    } else if (_biometricType == BiometricType.FACE_ID) {
      biometricTypeText = "Face ID";
    }

    Navigator.of(context).push(
        MaterialPageRoute(
            builder: (_) => ChangeNotifierProvider.value(
              value: _viewModel,
              child: BiometricLoginScreen(
                responseObserver: responseObserver,
                pageDescription: "Enable $biometricTypeText\nLogin",
                pageActionText: "Setup",
                fingerPrintAction: (key, _) {
                  _viewModel.setFingerprint(key).listen(responseObserver.observe);
                },
                authType: BiometricHelper.SetUpAuthType,
              ),
            )
        )
    ).then((value) {
      if (value != null && value is bool) {
        showSuccess(
            context,
            title: "$biometricTypeText setup",
            message: "$biometricTypeText Setup successfully"
        );
      }
    });
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
    _viewModel = Provider.of<LoginMethodViewModel>(context, listen: false);
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

    return Scaffold(
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
                    "Login Methods",
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
                Expanded(child: Container(
                  width: double.infinity,
                  height: double.infinity,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(topLeft: Radius.circular(30), topRight: Radius.circular(30)),
                  ),
                  child: Column(
                    children: [
                      SizedBox(height: 30),
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
                ))
              ],
            ),
          ),
      ),
    );
  }
}

class LoginMethodResponseObserver extends ResponseObserver<Resource<bool>> {

  LoginMethodResponseObserver(
      {required BuildContext context, required this.biometricType})
      : super(context: context);

  final BiometricType? biometricType;

  @override
  void observe(Resource<bool> event) async {
    if (event is Loading) {
      this.updateResponseState(ResponseState.LOADING);
    } else if (event is Success) {
      PreferenceUtil.setAuthFingerprintUsername();
      PreferenceUtil.setFingerPrintEnabled(true);
      this.updateResponseState(ResponseState.SUCCESS);
      navigatorKey.currentState?.pop(event.data);
    } else if (event is Error<bool>) {
      PreferenceUtil.setFingerPrintEnabled(false);
      await BiometricHelper.getInstance().deleteFingerPrintPassword();
      this.updateResponseState(ResponseState.ERROR);

      final actionTitle = (biometricType == BiometricType.FINGER_PRINT)
          ? "Fingerprint Setup Failed!"
          : "Face ID Setup Failed!";

      showError(
          navigatorKey.currentContext!,
          title: actionTitle,
          message: event.message,
          onPrimaryClick: () {
            Navigator.of(context).popUntil((route) {
              return route.settings.name == Routes.SETTINGS_CHANGE_LOGIN_METHOD;
            });
          }
      );
    }
  }
}
