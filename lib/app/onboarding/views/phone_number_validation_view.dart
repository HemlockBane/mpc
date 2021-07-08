import 'package:flutter/material.dart' hide ScrollView,Colors;
import 'package:flutter/services.dart';
import 'package:moniepoint_flutter/app/onboarding/viewmodel/onboarding_view_model.dart';
import 'package:moniepoint_flutter/app/onboarding/views/new/new_account_view.dart';
import 'package:moniepoint_flutter/core/colors.dart';
import 'package:moniepoint_flutter/core/custom_fonts.dart';
import 'package:moniepoint_flutter/core/styles.dart';
import 'package:moniepoint_flutter/core/tuple.dart';
import 'package:moniepoint_flutter/core/views/scroll_view.dart';
import 'package:provider/provider.dart';
import 'package:moniepoint_flutter/core/utils/text_utils.dart';

class PhoneNumberValidationScreen extends StatefulWidget {

  late final GlobalKey<ScaffoldState> _scaffoldKey;

  PhoneNumberValidationScreen(this._scaffoldKey);

  @override
  State<StatefulWidget> createState() => _PhoneNumberValidationScreen();
}

class _PhoneNumberValidationScreen extends State<PhoneNumberValidationScreen> {

  bool _isLoading = false;

  void _subscribeUiToPhoneNumberValidation() {
    Provider.of<OnBoardingViewModel>(context, listen: false);
    //TODO validate phone number
    Navigator.of(context).pushNamed(NewAccountScreen.ONBOARDING_PHONE_NUMBER_VERIFICATION);
  }

  @override
  Widget build(BuildContext context) {
    final viewModel = Provider.of<OnBoardingViewModel>(context, listen: false);

    return ScrollView(
        child: Container(
            height: double.infinity,
            width: double.infinity,
            padding: EdgeInsets.only(left: 16, right: 16, top: 41, bottom: 44),
            color: Colors.backgroundWhite,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  'Enter Phone Number',
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    color: Colors.colorPrimaryDark,
                    fontSize: 24,
                  ),
                  textAlign: TextAlign.start,
                ),
                SizedBox(height: 30),
                StreamBuilder(
                    stream: viewModel.accountForm.phoneNumberStream,
                    builder: (context, snapshot) {
                      return Styles.appEditText(
                          hint: 'Phone Number',
                          inputFormats: [FilteringTextInputFormatter.digitsOnly],
                          onChanged: viewModel.accountForm.onPhoneNumberChanged,
                          errorText: snapshot.hasError ? snapshot.error.toString() : null,
                          startIcon: Icon(CustomFont.call, color: Colors.colorFaded, size: 18),
                          animateHint: true,
                          maxLength: 13
                      );
                    }),
                Spacer(),
                SizedBox(height: 24),
                Styles.statefulButton(
                    elevation: 0,
                    stream: viewModel.accountForm.isMobileNumberValid,
                    onClick: _subscribeUiToPhoneNumberValidation,
                    text: 'Continue',
                    isLoading: _isLoading
                ),
                SizedBox(height: 32),
                Center(
                    child: Text('Already have a profile? Login',
                        style: TextStyle(color: Color(0XFF002331), fontFamily: Styles.defaultFont, fontSize: 16)
                    ).colorText({
                      "Login": Tuple(Colors.primaryColor, () => Navigator.of(widget._scaffoldKey.currentContext!).popAndPushNamed('/login'))
                    }, underline: false)
                ),
              ],
            )
        )
    );
  }
}
