import 'package:flutter/material.dart' hide Colors;
import 'package:moniepoint_flutter/core/bottom_sheet.dart';
import 'package:moniepoint_flutter/core/colors.dart';
import 'package:moniepoint_flutter/core/network/resource.dart';
import 'package:moniepoint_flutter/core/styles.dart';
import 'package:moniepoint_flutter/core/utils/biometric_helper.dart';
import 'package:moniepoint_flutter/core/utils/dialog_util.dart';
import 'package:moniepoint_flutter/core/utils/preference_util.dart';
import 'package:moniepoint_flutter/core/viewmodels/finger_print_alert_view_model.dart';
import 'package:provider/provider.dart';

class FingerPrintAlertDialog extends StatefulWidget {
  FingerPrintAlertDialog();

  @override
  State<StatefulWidget> createState() {
    return _FingerPrintAlertDialog();
  }
}

class _FingerPrintAlertDialog extends State<FingerPrintAlertDialog> {
  bool hasError = false;
  bool _isLoading = false;
  bool _hasError = false;

  BiometricHelper? biometricHelper;

  @override
  void initState() {
    biometricHelper = BiometricHelper.getInstance();
    super.initState();
  }

  void _subscribeUiToSetFingerPrint() async {
    final viewModel = Provider.of<FingerPrintAlertViewModel>(context, listen: false);

    Function? subscription;
    await biometricHelper?.getBiometricType();
    subscription = biometricHelper?.authenticate(authType: "SetUp", authenticationCallback: (fingerprintKey, message) {
      if (fingerprintKey != null) {
        viewModel.setFingerprint(fingerprintKey).listen(_handleFingerprintResponse);
        subscription?.call();
      } else {
        print(message);
      }
    });
  }

  void _handleFingerprintResponse(Resource<bool> event) async {
    if (event is Loading) {
      setState(() { _isLoading = true; });
    } else if (event is Success) {
      PreferenceUtil.setAuthFingerprintUsername();
      PreferenceUtil.setFingerPrintEnabled(true);
      setState(() {_isLoading = false;});
      Navigator.of(context).pop(event.data);
    } else if (event is Error<bool>) {
      PreferenceUtil.setFingerPrintEnabled(false);
      await BiometricHelper.getInstance().deleteFingerPrintPassword();
      setState(() { _isLoading = false; _hasError = true; });
      showError(context, message: event.message);
    }
  }

  @override
  Widget build(BuildContext context) {
    return BottomSheets.makeAppBottomSheet(
        curveBackgroundColor: Colors.white,
        centerImageBackgroundColor: Colors.primaryColor.withOpacity(0.1),
        contentBackgroundColor: Colors.white,
        centerImageRes: 'res/drawables/ic_finger_print.svg',
        centerImageColor: Colors.primaryColor,
        centerImageWidth: 40,
        centerImageHeight: 40,
        content: FutureBuilder(
          future: biometricHelper?.getBiometricType(),
          builder: (mContext, AsyncSnapshot<BiometricType> snapshot) {
            if(!snapshot.hasData) return Text("Initializing");

            final type = snapshot.data;

            final titleMessage = (type == BiometricType.FINGER_PRINT)
                ? "Login with Fingerprint"
                : "Login with Face ID";

            final infoMessage = (type == BiometricType.FINGER_PRINT)
                ? "Enable fingerprint login on your device?"
                : "Enable Face ID login on your device?";

            return Wrap(
              children: [
                Container(
                  child: Column(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(height: 22),
                      Center(
                        child: Text(titleMessage,
                            style: TextStyle(
                                fontSize: 22,
                                fontWeight: FontWeight.w600,
                                color: Colors.colorPrimaryDark
                            )
                        ),
                      ),
                      SizedBox(height: 36),
                      Visibility(
                          visible: _isLoading,
                          child: SizedBox(
                            width: 30,
                            height: 30,
                            child: CircularProgressIndicator(
                              strokeWidth: 3,
                              valueColor: AlwaysStoppedAnimation(Colors.darkBlue),
                              backgroundColor: Colors.deepGrey.withOpacity(0.5),
                            ),
                          )),
                      SizedBox(height: _isLoading ? 12 : 0),
                      Text(
                          _isLoading
                              ? 'Setting up...'
                              : infoMessage,
                          style: TextStyle(
                              fontSize: 15, color: Colors.colorPrimaryDark)),
                      SizedBox(height: 40),
                      Padding(
                        padding: EdgeInsets.only(left: 16, right: 16),
                        child: Styles.statefulButton2(
                            isValid: !_isLoading,
                            elevation: 0.2,
                            isLoading: _isLoading,
                            onClick: () => _subscribeUiToSetFingerPrint(),
                            text: _hasError ? 'Retry' : 'Continue'
                        ),
                      ),
                      SizedBox(height: 32),
                    ],
                  ),
                )
              ],
            );
          },
        )
    );
  }
}
