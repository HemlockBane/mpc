import 'package:flutter/material.dart' hide ScrollView,Colors;
import 'package:flutter/services.dart';
import 'package:moniepoint_flutter/app/onboarding/viewmodel/onboarding_view_model.dart';
import 'package:moniepoint_flutter/app/onboarding/views/signup_account_view.dart';
import 'package:moniepoint_flutter/core/colors.dart';
import 'package:moniepoint_flutter/core/custom_fonts.dart';
import 'package:moniepoint_flutter/core/network/resource.dart';
import 'package:moniepoint_flutter/core/styles.dart';
import 'package:moniepoint_flutter/core/tuple.dart';
import 'package:moniepoint_flutter/core/utils/dialog_util.dart';
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

  TextEditingController? _phoneNumberController;

  void _subscribeUiToPhoneNumberValidation() {
    final viewModel = Provider.of<OnBoardingViewModel>(context, listen: false);
    viewModel.sendOtpToDevice().listen((event) {
      if(event is Loading) setState(() => _isLoading = true);
      if (event is Error<bool>) {
        setState(() => _isLoading = false);
        showError(
            widget._scaffoldKey.currentContext ?? context,
            message: event.message
        );
      }
      if(event is Success<bool>) {
        setState(() => _isLoading = false);
        Navigator.of(context).pushNamed(SignUpAccountScreen.ONBOARDING_PHONE_NUMBER_VERIFICATION);
      }
    });
  }
  void _fetchNationalities()  {
    final viewModel = Provider.of<OnBoardingViewModel>(context, listen: false);
    if(viewModel.nationalities.isEmpty) viewModel.fetchCountries().listen((event) { });
  }

  @override
  void initState() {
    _phoneNumberController = TextEditingController();
    super.initState();
    _fetchNationalities();
  }

  @override
  Widget build(BuildContext context) {
    final viewModel = Provider.of<OnBoardingViewModel>(context, listen: false);
    final bottom = MediaQuery.of(context).viewPadding.bottom;
    return ScrollView(
        maxHeight: MediaQuery.of(context).size.height - (70 + bottom),//subtract the vertical padding
        child: Container(
            padding: EdgeInsets.symmetric(vertical: 32, horizontal: 20),
            color: Colors.white,
            child: Column(
              children: [
                Expanded(
                    child: Center(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            'Welcome to Moniepoint',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.textColorBlack,
                              fontSize: 24,
                            ),
                            textAlign: TextAlign.start,
                          ),
                          SizedBox(height: 12),
                          Text(
                              'Enter your phone number to get started',
                              style: TextStyle(
                                  fontWeight: FontWeight.normal,
                                  color: Colors.textColorBlack,
                                  fontSize: 14)
                          ),
                          SizedBox(height: 46),
                          StreamBuilder(
                              stream: viewModel.accountForm.phoneNumberStream,
                              builder: (context, snapshot) {
                                return Styles.appEditText(
                                    hint: 'Phone Number',
                                    controller: _phoneNumberController,
                                    inputFormats: [FilteringTextInputFormatter.digitsOnly],
                                    inputType: TextInputType.number,
                                    onChanged: viewModel.accountForm.onPhoneNumberChanged,
                                    errorText: snapshot.hasError ? snapshot.error.toString() : null,
                                    startIcon: Icon(CustomFont.call, color: Colors.textFieldIcon.withOpacity(0.2), size: 24),
                                    animateHint: true,
                                    maxLength: 11
                                );
                              }),
                          SizedBox(height: 100),
                        ],
                      ),
                    )
                ),
                Styles.statefulButton(
                    elevation: 0,
                    stream: viewModel.accountForm.isMobileNumberValid,
                    onClick: _subscribeUiToPhoneNumberValidation,
                    text: 'Next',
                    isLoading: _isLoading
                ),
                SizedBox(height: 40),
                Center(
                    child: Text(
                        'Already have a profile? Login',
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
