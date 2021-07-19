import 'package:flutter/material.dart' hide Colors, ScrollView;
import 'package:flutter/services.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:moniepoint_flutter/app/liveliness/liveliness_verification.dart';
import 'package:moniepoint_flutter/app/onboarding/viewmodel/onboarding_view_model.dart';
import 'package:moniepoint_flutter/app/validation/model/data/onboarding_liveliness_validation_response.dart';
import 'package:moniepoint_flutter/app/validation/model/data/validate_phone_otp_response.dart';
import 'package:moniepoint_flutter/core/bottom_sheet.dart';
import 'package:moniepoint_flutter/core/colors.dart';
import 'package:moniepoint_flutter/core/custom_fonts.dart';
import 'package:moniepoint_flutter/core/network/resource.dart';
import 'package:moniepoint_flutter/core/routes.dart';
import 'package:moniepoint_flutter/core/styles.dart';
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

  _EnterBVNScreen(this._scaffoldKey);


  @override
  void initState() {
    
    super.initState();
  }

  void _subscribeUiToOtpValidation(BuildContext context) async {
    final viewModel = Provider.of<OnBoardingViewModel>(context, listen: false);
    final validationResponse = await Navigator.of(widget._scaffoldKey.currentContext ?? context)
       .pushNamed(Routes.LIVELINESS_DETECTION, arguments: {
         "verificationFor": LivelinessVerificationFor.ON_BOARDING,
          "bvn" : viewModel.accountForm.account.bvn,
          "phoneNumberValidationKey": viewModel.phoneNumberValidationKey
       });

    if(validationResponse!= null && validationResponse is OnboardingLivelinessValidationResponse){

      if(validationResponse.phoneMismatchError != null) {
        _showGenericError(validationResponse.phoneMismatchError?.message);
        return;
      }

      if(validationResponse.bvnMismatchError != null) {
        _showGenericError(validationResponse.bvnMismatchError?.message);
        return;
      }

      if(validationResponse.mobileProfileExist == true) {
        showModalBottomSheet(
            backgroundColor: Colors.transparent,
            context: context,
            builder: (mContext) {
              return BottomSheets.displayInfoDialog(
                  context, title: "We've found you",
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
        return;
      }

      //If everything is successful then we need to decide our next route
      final onboardingType = validationResponse.setupType?.type;
      if(onboardingType == OnBoardingType.ACCOUNT_DOES_NOT_EXIST){
        //We navigate to account info
      }else {
        //We navigate to profile info

      }
    }
  }

  void _showGenericError(String? message) {
    showModalBottomSheet(
        backgroundColor: Colors.transparent,
        context: context,
        builder: (mContext) {
          return BottomSheets.displayErrorModal(context, message: message, onClick: (){
            Navigator.of(context).pop();
          }, buttonText: "Try Again");
        }
    );
  }

  String getUSSD() {
    return "*5573*80#";
  }

  @override
  Widget build(BuildContext context) {
    final viewModel = Provider.of<OnBoardingViewModel>(context, listen: false);

    return ScrollView(
      maxHeight: MediaQuery.of(context).size.height - 64,//subtract the vertical padding
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 32, horizontal: 20),
        color: Colors.backgroundWhite,
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
                              inputFormats: [FilteringTextInputFormatter.digitsOnly],
                              onChanged: viewModel.accountForm.onBVNChanged,
                              startIcon: Icon(CustomFont.numberInput, color: Colors.textFieldIcon.withOpacity(0.2), size: 22),
                              animateHint: true,
                              maxLength: 11
                          );
                        }),
                    SizedBox(height: 20),
                    OtpUssdInfoView(
                      "Onboarding Phone Number Validation OTP Mobile",
                      defaultCode: "*5573*70#",
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
                onClick: () => _subscribeUiToOtpValidation(context),
                text: 'Next',
                isLoading: false,
            ),
          ],
        ),
      ),
    );
  }
}