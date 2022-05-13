import 'dart:io';

import 'package:flutter/material.dart' hide Colors;
import 'package:flutter_svg/svg.dart';
import 'package:moniepoint_flutter/core/colors.dart';
import 'package:moniepoint_flutter/core/network/resource.dart';
import 'package:moniepoint_flutter/core/network/response_observer.dart';
import 'package:moniepoint_flutter/core/routes.dart';
import 'package:moniepoint_flutter/core/utils/biometric_helper.dart';
import 'package:moniepoint_flutter/core/utils/preference_util.dart';

///
///@author Paul Okeke
///
class BiometricLoginScreen extends StatefulWidget {

  BiometricLoginScreen({
    required this.responseObserver,
    required this.fingerPrintAction,
    this.pageDescription = "",
    this.pageActionText = "",
    this.authType = BiometricHelper.LoginAuthType
  });

  final ResponseObserver<Resource<dynamic>> responseObserver;
  final Function(String key, String password) fingerPrintAction;
  final String pageDescription;
  final String pageActionText;
  final String authType;

  @override
  State<StatefulWidget> createState() => _BiometricLoginScreenState();

}

class _BiometricLoginScreenState extends State<BiometricLoginScreen> {

  BiometricHelper? _biometricHelper;

  void _responseStateListener(ResponseState? state) {
    if(mounted) setState(() {});
  }

  @override
  void initState() {
    _biometricHelper = BiometricHelper.getInstance();
    super.initState();
    widget.responseObserver.addStateListener(_responseStateListener);
    WidgetsBinding.instance?.addPostFrameCallback((timeStamp) {
      _startAuthProcess();
    });
  }

  void _startAuthProcess() async {
    final biometricType = await _biometricHelper?.getBiometricType();
    if (biometricType == BiometricType.NONE) {
      //TODO
      return;
    }
    if(widget.authType == BiometricHelper.LoginAuthType) {
      _startFingerPrintLoginProcess();
    } else if (widget.authType == BiometricHelper.SetUpAuthType) {
      _authenticate();
    }
  }

  void _startFingerPrintLoginProcess() async {
    final hasFingerPrint = (await _biometricHelper?.getFingerprintPassword()) != null;
    if (PreferenceUtil.getFingerPrintEnabled() && hasFingerPrint) {
      _authenticate();
    }
  }

  void _authenticate() async {
    await _biometricHelper?.getBiometricType();
    Function? subscription;
    subscription = _biometricHelper?.authenticate(authType: widget.authType, authenticationCallback: (key, msg) {
      if (key != null) {
        widget.fingerPrintAction(key, PreferenceUtil.getAuthFingerprintUsername() ?? "");
        subscription?.call();
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text("An Error occurred authenticating with biometrics"))
        );
      }
    });
  }

  Widget biometricStateWidget() {
    if (widget.responseObserver.responseState != ResponseState.LOADING) {
      return Platform.isAndroid
          ? SvgPicture.asset('res/drawables/ic_finger_print.svg')
          : SvgPicture.asset(
              'res/drawables/ic_face.svg',
              color: Colors.primaryColor,
              height: 54.8,
              width: 54.8,
            );
    }
    return SizedBox(
      width: 35,
      height: 35,
      child: CircularProgressIndicator(
        valueColor: AlwaysStoppedAnimation(Colors.primaryColor),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0XFF002E82),
      body: Container(
        decoration: BoxDecoration(
            // color: Colors.primaryColor,
            image: DecorationImage(
                fit: BoxFit.cover,
                image: AssetImage("res/drawables/ic_app_new_bg.png")
            )
        ),
        padding: EdgeInsets.only(left: 20, right: 20,top: 80, bottom: 80),
        child: Container(
          width: double.infinity,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20)
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              SizedBox(height: 96,),
              SvgPicture.asset(
                "res/drawables/ic_moniepoint_cube_2.svg",
                color: Colors.primaryColor,
                width: 60,
                height: 60,
              ),
              SizedBox(height: 20,),
              Text(
                widget.pageDescription,
                textAlign: TextAlign.center,
                style: TextStyle(
                    fontSize: 24,
                    color: Colors.solidDarkBlue,
                    fontWeight: FontWeight.w700
                ),
              ),
              Spacer(),
              Text(
                widget.pageActionText,
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                  color: Colors.textColorBlack
                ),
              ),
              SizedBox(height: 23,),
              Container(
                padding: EdgeInsets.only(top: 20, bottom: 20, right: 20, left: 20),
                decoration: BoxDecoration(
                  color: Colors.primaryColor.withOpacity(0.13),
                  borderRadius: BorderRadius.circular(21)
                ),
                child: biometricStateWidget()
              ),
              SizedBox(height: 46),
              Container(
                width: double.infinity,
                padding: EdgeInsets.only(top: 14, bottom: 14),
                decoration: BoxDecoration(
                  border: Border(top: BorderSide(color: Colors.primaryColor.withOpacity(0.1), width: 0.8))
                ),
                child: TextButton(
                    onPressed: () => Navigator.of(context).popAndPushNamed(Routes.LOGIN),
                    child: Text(
                      "Use Password Instead",
                      style: TextStyle(
                        color: Colors.primaryColor
                      ),
                    )
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    widget.responseObserver.removeStateListener(_responseStateListener);
    super.dispose();
  }

}