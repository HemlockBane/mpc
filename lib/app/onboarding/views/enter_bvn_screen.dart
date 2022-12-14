import 'package:flutter/material.dart' hide Colors, ScrollView;
import 'package:flutter/services.dart';
import 'package:moniepoint_flutter/app/liveliness/model/data/liveliness_verification_for.dart';
import 'package:moniepoint_flutter/app/onboarding/viewmodel/onboarding_view_model.dart';
import 'package:moniepoint_flutter/app/validation/model/data/onboarding_liveliness_validation_response.dart';
import 'package:moniepoint_flutter/core/views/bottom_sheet.dart';
import 'package:moniepoint_flutter/core/colors.dart';
import 'package:moniepoint_flutter/core/custom_fonts.dart';
import 'package:moniepoint_flutter/core/routes.dart';
import 'package:moniepoint_flutter/core/styles.dart';
import 'package:moniepoint_flutter/core/utils/dialog_util.dart';
import 'package:moniepoint_flutter/core/views/otp_ussd_info_view.dart';
import 'package:moniepoint_flutter/core/views/scroll_view.dart';
import 'package:provider/provider.dart';

import 'signup_account_view.dart';

class EnterBVNScreen extends StatefulWidget {
  late final GlobalKey<ScaffoldState> _scaffoldKey;

  EnterBVNScreen(this._scaffoldKey);

  @override
  State<StatefulWidget> createState() {
    return _EnterBVNScreen(_scaffoldKey);
  }

}

class _EnterBVNScreen extends State<EnterBVNScreen> {
  late final GlobalKey<ScaffoldState> _scaffoldKey;
  late final TextEditingController _bvnController;
  static const BVN_LENGTH = 11;

  _EnterBVNScreen(this._scaffoldKey);

  @override
  void initState() {
    _bvnController = TextEditingController();
    super.initState();
  }

  void _subscribeUiToLivelinessTest(BuildContext context) async {
    final viewModel = Provider.of<OnBoardingViewModel>(context, listen: false);

    final validationResponse = await Navigator.of(widget._scaffoldKey.currentContext ?? context)
       .pushNamed(Routes.LIVELINESS_DETECTION, arguments: {
         "verificationFor": LivelinessVerificationFor.ON_BOARDING,
          "bvn" : viewModel.accountForm.account.bvn,
          "phoneNumberValidationKey": viewModel.phoneNumberValidationKey
       });

    if(validationResponse != null && validationResponse is OnboardingLivelinessValidationResponse) {

      if(validationResponse.phoneMismatchError != null) {
        _showGenericError("Phone Number Mismatched!", validationResponse.phoneMismatchError?.message);
        return;
      }

      if(validationResponse.phoneNumberUniquenessError != null) {
        _showGenericError(
            "Phone Number already in use",
            validationResponse.phoneNumberUniquenessError?.message
        );
        return;
      }

      if(validationResponse.mobileProfileExist == true) {
        _showProfileExist();
        return;
      }

      //If everything is successful then we need to decide our next route
      final profileSetupType = validationResponse.setupType;

      viewModel.setOnboardingKey(validationResponse.onboardingKey ?? "");

      if(profileSetupType != null) {
        viewModel.setProfileSetupType(profileSetupType);
      }

      if(profileSetupType?.type == OnBoardingType.ACCOUNT_DOES_NOT_EXIST) {
        //We navigate to account info
        Navigator.of(context).pushNamed(SignUpAccountScreen.ACCOUNT_INFO);
      } else if(profileSetupType?.type == OnBoardingType.ACCOUNT_EXIST) {
        //We navigate to profile info
        Navigator.of(context).pushNamed(SignUpAccountScreen.PROFILE);
      } else {
        _showGenericError("Invalid Account Setup Type","Failed to determine account setup type");
      }
    }
  }

  void _showProfileExist() {
    showModalBottomSheet(
        backgroundColor: Colors.transparent,
        context: widget._scaffoldKey.currentContext ?? context,
        builder: (mContext) {
          return BottomSheets.displayInfoDialog(
              widget._scaffoldKey.currentContext ?? context,
              title: "We've found you",
              message: "The phone number and bvn supplied already has a profile",
              primaryButtonText: "Login with your Credentials",
              secondaryButtonText: "Recover Credentials",
              onPrimaryClick: () {
                Navigator.of(widget._scaffoldKey.currentContext ?? context)
                    .pushNamed(Routes.LOGIN);
              },
              onSecondaryClick: () {
                Navigator.of(widget._scaffoldKey.currentContext ?? context)
                    .pushNamed(Routes.LOGIN);
              }
          );
        }
    );
  }

  void _showGenericError(String title, String? message) {
    showError(
        widget._scaffoldKey.currentContext ?? context,
        message: message,
        title: title,
        primaryButtonText: "Try Again",
        onPrimaryClick: (){
          Navigator.of(widget._scaffoldKey.currentContext ?? context).pop();
        }
    );
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
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(
              child: Center(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      'Enter BVN',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.textColorBlack,
                        fontSize: 24,
                      ),
                      textAlign: TextAlign.start,
                    ),
                    SizedBox(height: 30),
                    StreamBuilder(
                        stream: viewModel.accountForm.bvnStream,
                        builder: (context, snapshot) {
                          return Styles.appEditText(
                              errorText: snapshot.hasError ? snapshot.error.toString() : null,
                              hint: 'Enter BVN',
                              controller: _bvnController,
                              textInputAction: TextInputAction.done,
                              inputType: TextInputType.number,
                              inputFormats: [FilteringTextInputFormatter.digitsOnly],
                              onChanged: viewModel.accountForm.onBVNChanged,
                              startIcon: Icon(CustomFont.numberInput, color: Colors.textFieldIcon.withOpacity(0.2), size: 22),
                              animateHint: true,
                              maxLength: BVN_LENGTH
                          );
                        }),
                    SizedBox(height: 20),
                    OtpUssdInfoView(
                      "None",
                      defaultCode: "*565*0#",
                      message: "Dial {} on your registered phone number to get your BVN",
                    ),
                    SizedBox(height: 100),
                  ],
                ),
              ),
            ),
            Styles.statefulButton(
                stream: viewModel.accountForm.isBankVerificationNumberValid,
                elevation: 0,
                onClick: () => _subscribeUiToLivelinessTest(context),
                text: 'Next',
                isLoading: false,
            ),
          ],
        ),
      ),
    );
  }
}