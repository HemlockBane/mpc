import 'dart:io';

import 'package:flutter/material.dart' hide Colors, ScrollView;
import 'package:flutter/services.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:lottie/lottie.dart';
import 'package:moniepoint_flutter/app/onboarding/viewmodel/onboarding_view_model.dart';
import 'package:moniepoint_flutter/app/validation/model/data/onboarding_liveliness_validation_response.dart';
import 'package:moniepoint_flutter/core/colors.dart';
import 'package:moniepoint_flutter/core/network/resource.dart';
import 'package:moniepoint_flutter/core/routes.dart';
import 'package:moniepoint_flutter/core/strings.dart';
import 'package:moniepoint_flutter/core/styles.dart';
import 'package:moniepoint_flutter/core/tuple.dart';
import 'package:moniepoint_flutter/core/utils/call_utils.dart';
import 'package:moniepoint_flutter/core/utils/dialog_util.dart';
import 'package:moniepoint_flutter/core/utils/preference_util.dart';
import 'package:moniepoint_flutter/core/validators.dart';
import 'package:moniepoint_flutter/core/views/custom_check_box.dart';
import 'package:moniepoint_flutter/core/views/scroll_view.dart';
import 'package:moniepoint_flutter/core/views/valid_password_checker.dart';
import 'package:path/path.dart' hide context;
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import 'package:moniepoint_flutter/core/utils/text_utils.dart';
import 'package:moniepoint_flutter/core/bottom_sheet.dart';
import 'package:signature/signature.dart';
import '../username_validation_state.dart';

class ProfileScreen extends StatefulWidget {
  late final GlobalKey<ScaffoldState> _scaffoldKey;

  ProfileScreen(this._scaffoldKey);

  @override
  State<StatefulWidget> createState() {
    return _ProfileScreenState(this._scaffoldKey);
  }
}

class _ProfileScreenState extends State<ProfileScreen> with Validators{

  late final GlobalKey<ScaffoldState> _scaffoldKey;
  bool _isPasswordVisible  = false;
  bool _isPinVisible  = false;
  bool _isUssdVisible  = false;
  bool _isLoading = false;
  bool _isSignatureEnabled = false;
  bool _displayPasswordStrength = false;

  final SignatureController _signatureController = SignatureController(penStrokeWidth: 2, penColor: Colors.darkBlue);
  final TextEditingController _passwordController = TextEditingController();

  _ProfileScreenState(this._scaffoldKey);
  
  Widget getPasswordToggleIcon(BuildContext context) {
    return IconButton(
        icon: Icon(this._isPasswordVisible ? Icons.visibility : Icons.visibility_off, color: Color(0XFF999999)),
        onPressed: () {
          setState(() {
            this._isPasswordVisible = !_isPasswordVisible;
          });
        }
    );
  }

  Widget getPinToggleIcon(BuildContext context) {
    return IconButton(
        icon: Icon(this._isPinVisible ? Icons.visibility : Icons.visibility_off, color:  Color(0XFF999999)),
        onPressed: () {
          setState(() {
            this._isPinVisible = !_isPinVisible;
          });
        }
    );
  }

  Widget getUssdToggleIcon(BuildContext context) {
    return IconButton(
        icon: Icon(this._isUssdVisible ? Icons.visibility : Icons.visibility_off, color:  Color(0XFF999999)),
        onPressed: () {
          setState(() {
            this._isUssdVisible = !_isUssdVisible;
          });
        }
    );
  }

  void handleCreationResponse<T>(Resource<T> resource) async {
    final viewModel = Provider.of<OnBoardingViewModel>(context, listen: false);
    if(resource is Success<T>) {
      setState(() => _isLoading = false);

      final message = (viewModel.onBoardingType == OnBoardingType.ACCOUNT_DOES_NOT_EXIST)
          ? "Your account has been created successfully, login now with your credentials."
          : "Your profile has been created successfully, login now with your credentials.";
      await showSuccess(
          widget._scaffoldKey.currentContext ?? context,
          title: "Profile Created Successfully",
          message: message,
          useText: false,
          primaryButtonText: "Proceed to Login",
          onPrimaryClick: () {
            Navigator.of(context).pop(true);
            PreferenceUtil.saveUsername(viewModel.profileForm.profile.username ?? "");
            Navigator.pushNamedAndRemoveUntil(_scaffoldKey.currentContext!, Routes.LOGIN, (route) => false);
          }
      );
    } else if(resource is Error<T>) {
      setState(() => _isLoading = false);
      showError(
          widget._scaffoldKey.currentContext ?? context,
          message: resource.message,
          primaryButtonText: "Try Again?"
      );
    }
    else if (resource is Loading){
      setState(() => _isLoading = true);
    }
  }

  void subscribeUiToOnBoard() async {
    final viewModel = Provider.of<OnBoardingViewModel>(context, listen: false);
    if (await Permission.storage.request().isGranted) {
      final bytes = await _signatureController.toPngBytes();
      Directory dir = await getTemporaryDirectory();
      File signatureFile = File(join(dir.path, 'signature.png'));
      signatureFile.writeAsBytesSync(bytes!);

      viewModel.createAccount(signatureFile.path).listen(handleCreationResponse);
    }
  }

  void _defaultFn(bool undefined) {
    /*do nothing*/
  }

  @override
  void initState() {
    final viewModel = Provider.of<OnBoardingViewModel>(context, listen: false);
    super.initState();
    viewModel.profileForm.initForm(viewModel.onBoardingType);
    _signatureController.addListener(() {
      setState(() {});
      viewModel.profileForm.setHasSignature(_signatureController.isNotEmpty);
    });

    Future.delayed(Duration(milliseconds: 500), () {
      viewModel.profileForm.setHasSignature(false);
      viewModel.profileForm.onEnableUssd(true);
    });
  }

  void _showTermsAndConditionModal(String title, String content) {
    showModalBottomSheet(
        context: _scaffoldKey.currentContext ?? context,
        isScrollControlled: true,
        backgroundColor: Colors.transparent,
        builder: (context) {
          return BottomSheets.makeAppBottomSheet(
              centerImageBackgroundColor: Colors.primaryColor.withOpacity(0.1),
              centerImageRes: 'res/drawables/ic_terms_and_condition.svg',
              contentBackgroundColor: Colors.white,
              centerImageWidth: 45,
              centerImageHeight: 45,
              centerBackgroundPadding: 13,
              content: Stack(
                children: [
                  Positioned(
                      top: 20,
                      right: 0,
                      left: 0,
                      child: Text(title,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: Colors.textColorPrimary,
                          ))
                  ),
                  Positioned(
                      top: 66,
                      right: 16,
                      left: 16,
                      child: Divider(
                        height: 4,
                        color: Colors.colorFaded,
                      )
                  ),
                  Positioned(
                      top: 70,
                      bottom: 40,
                      right: 0.0,
                      left: 0.0,
                      child: SingleChildScrollView(
                        padding: EdgeInsets.symmetric(vertical: 16, horizontal: 16),
                        child: Container(
                          child: Html(
                              data: content,
                              onLinkTap: (String? url, RenderContext context, Map<String, String> attributes, _){
                                if(url != null) openUrl(url);
                              },
                          )//Text(Strings.terms_and_condition),
                        ),
                      )),
                  Positioned(
                      bottom: 32,
                      right: 16,
                      left: 16,
                      child: Divider(
                        height: 4,
                        color: Colors.colorFaded,
                      )),
                ],
              ));
        });
  }

  Widget _buildTermsLayout() {
    final txt = 'By signing up you agree to our\nTerms & Conditions and Privacy Policy.';
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12, vertical: 14),
      decoration: BoxDecoration(
          color: Colors.primaryColor.withOpacity(0.1),
          borderRadius: BorderRadius.circular(8)),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SvgPicture.asset('res/drawables/ic_info.svg'),
          SizedBox(width: 14),
          Expanded(
              child: Text(txt,
                      style: TextStyle(
                          color: Colors.textColorBlack,
                          fontFamily: Styles.defaultFont,
                          fontSize: 18)
              ).colorText({
                "Terms & Conditions": Tuple(Colors.primaryColor, () => _showTermsAndConditionModal("Terms & Conditions", Strings.terms_and_condition)),
                "Privacy Policy": Tuple(Colors.primaryColor, () => _showTermsAndConditionModal("Privacy Policy", Strings.privacy_policy)),
              }, bold: true, boldType: 1))
        ],
      ),
    );
  }

  Widget _signatureView() {
    return Stack(
      children: [
        Container(
          clipBehavior: Clip.antiAliasWithSaveLayer,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              border: _isSignatureEnabled == false ? null :Border.all(color: Colors.deepGrey.withOpacity(0.29), width: 1.0)),
          child: ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Signature(
                height: 200,
                controller: _signatureController,
                backgroundColor: Colors.white,
              )),
        ),
        Visibility(
          visible: _isSignatureEnabled == false,
          child: Container(
              height: 200,
              width: double.infinity,
              decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                      color: Colors.deepGrey.withOpacity(0.29), width: 1.0))),
        ),
        Visibility(
            visible: _isSignatureEnabled == false,
            child: Container(
              padding: EdgeInsets.only(top: 16, bottom: 16, right: 8, left: 8),
              width: double.infinity,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SvgPicture.asset('res/drawables/ic_signature.svg', color: Colors.colorFaded.withOpacity(0.1),),
                  SizedBox(height: 30,),
                  TextButton(
                      onPressed: () async {
                        setState(() {
                          _isSignatureEnabled = true;
                        });
                      },
                      child: Text('Tap to add your Signature',
                        style: TextStyle(color: Colors.primaryColor, fontWeight: FontWeight.w600),
                      )
                  )
                ],
              ),
            )
        ),
        Positioned(
            right: 16,
            top: 8,
            child: Opacity(
              opacity: _signatureController.isEmpty ? 0 : 1,
              child: TextButton(
                  child: Text('CLEAR',
                      style: TextStyle(fontWeight: FontWeight.w400, color: Colors.deepGrey, fontSize: 14)),
                  onPressed: () {
                    _signatureController.clear();
                  }),
            ))
      ],
    );
  }

  Widget? _getUsernameIconForValidationStatus(UsernameValidationStatus? status) {
    if(status == UsernameValidationStatus.VALIDATING) {
      return Padding(
        padding: EdgeInsets.only(right: 16),
        child: SizedBox(
          width: 20,
          child: Lottie.asset('res/drawables/progress_bar_lottie.json', width: 40, height: 40),
        ),
      );
    }
    if(status == UsernameValidationStatus.AVAILABLE) {
      return Padding(
          padding: EdgeInsets.only(right: 24),
          child: SizedBox(
            width: 16,
            height: 16,
            child: SvgPicture.asset(
              'res/drawables/ic_circular_check_mark.svg', color: Colors.solidGreen,
            ),
          ),
      );
    }
    return null;
  }

  Widget _buildMain(BuildContext context) {
    final viewModel = Provider.of<OnBoardingViewModel>(context, listen: false);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      mainAxisSize: MainAxisSize.max,
      children: [
        Text(
          'Create Profile',
          style: TextStyle(
            fontWeight: FontWeight.w600,
            color: Colors.textColorBlack,
            fontSize: 24,
          ),
          textAlign: TextAlign.start,
        ),
        SizedBox(height: 30),
        StreamBuilder(
            stream: viewModel.profileForm.usernameStream,
            builder: (context, AsyncSnapshot<Tuple<String, UsernameValidationState>> snapshot) {
              final validationStatus = (snapshot.hasData) ? snapshot.data?.second.status : null;
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Focus(
                    child: Styles.appEditText(
                      hint: 'Username',
                      animateHint: true,
                      endIcon: _getUsernameIconForValidationStatus(validationStatus),
                      onChanged: (v) {
                        viewModel.profileForm.onUsernameChanged(v);
                      },
                      errorText: snapshot.hasError ? snapshot.error.toString() : null,
                      drawablePadding: EdgeInsets.only(left: 8, right: 8),
                    ),
                    onFocusChange: (hasFocus) {
                      final username = viewModel.profileForm.profile.username;
                      if (!hasFocus && username != null && username.isNotEmpty)
                        viewModel.checkUsername(username).listen((event) {});
                    },
                  ),
                ],
              );
            }),
        SizedBox(height: viewModel.onBoardingType == OnBoardingType.ACCOUNT_DOES_NOT_EXIST ? 24 : 0),
        Visibility(
            visible: viewModel.onBoardingType == OnBoardingType.ACCOUNT_DOES_NOT_EXIST,
            child: StreamBuilder(
                stream: viewModel.profileForm.emailStream,
                builder: (context, snapshot) {
                  return Styles.appEditText(
                    hint: 'Email Address',
                    inputType: TextInputType.emailAddress,
                    onChanged: viewModel.profileForm.onEmailChanged,
                    errorText: snapshot.hasError ? snapshot.error.toString() : null,
                    animateHint: true,
                    drawablePadding: EdgeInsets.only(left: 4, right: 4),
                  );
                }
                ),
        ),
        SizedBox(height: 24),
        Focus(
            onFocusChange: (v) {
              _displayPasswordStrength = v;
              viewModel.profileForm.onPasswordChanged(_passwordController.text);
            },
            child: StreamBuilder(
                stream: viewModel.profileForm.passwordStream,
                builder: (context, AsyncSnapshot<String?> snapshot) {
                  return Column(
                    children: [
                      Styles.appEditText(
                          hint: 'Password',
                          controller: _passwordController,
                          onChanged: viewModel.profileForm.onPasswordChanged,
                          animateHint: true,
                          drawablePadding: EdgeInsets.only(left: 4, right: 4),
                          endIcon: getPasswordToggleIcon(context),
                          isPassword: !_isPasswordVisible
                      ),
                      if(_displayPasswordStrength) SizedBox(height: 24,),
                      if(_displayPasswordStrength) ValidPasswordChecker(_passwordController.text)
                    ],
                  );
                }
            )
        ),
        SizedBox(height: 24),
        StreamBuilder(
            stream: viewModel.profileForm.pinInputStream,
            builder: (context, snapshot) {
              return Styles.appEditText(
                  hint: 'Mobile App PIN',
                  onChanged: viewModel.profileForm.onPinChanged,
                  errorText: snapshot.hasError ? snapshot.error.toString() : null,
                  animateHint: true,
                  maxLength: 4,
                  inputType: TextInputType.number,
                  inputFormats: [FilteringTextInputFormatter.digitsOnly],
                  drawablePadding: EdgeInsets.only(left: 4, right: 4),
                  endIcon: getPinToggleIcon(context),
                  isPassword: !_isPinVisible
              );
            }),
        SizedBox(height: 24),
        Container(
          child: StreamBuilder(
              stream: viewModel.profileForm.enableUssdStream,
              builder: (mContext, AsyncSnapshot<bool> snapshot) {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Enable USSD banking',
                          style: TextStyle(fontWeight: FontWeight.w600, fontSize: 18, color: Colors.textColorBlack),
                        ),
                        CustomCheckBox(onSelect: (v) {
                          viewModel.profileForm.onEnableUssd(!viewModel.accountForm.account.createUssdPin);
                        }, isSelected: viewModel.accountForm.account.createUssdPin)
                      ],
                    ),
                    SizedBox(height: viewModel.accountForm.account.createUssdPin ? 4 : 0),
                    Visibility(
                      visible: viewModel.accountForm.account.createUssdPin,
                      child: Divider(color: Colors.dividerColor, height: 0.9,),
                    ),
                    SizedBox(height: viewModel.accountForm.account.createUssdPin ? 20 : 0),
                    Visibility(
                        visible: viewModel.accountForm.account.createUssdPin ,
                        child: StreamBuilder(
                            stream: viewModel.profileForm.ussdPinInputStream,
                            builder: (context, snapshot) {
                              return Styles.appEditText(
                                  hint: 'USSD PIN',
                                  maxLength: 4,
                                  inputType: TextInputType.number,
                                  inputFormats: [FilteringTextInputFormatter.digitsOnly],
                                  onChanged: viewModel.profileForm.onUssdPinChanged,
                                  errorText: snapshot.hasError ? snapshot.error.toString() : null,
                                  animateHint: true,
                                  drawablePadding: EdgeInsets.only(left: 4, right: 4),
                                  endIcon: getUssdToggleIcon(context),
                                  isPassword: !_isUssdVisible
                              );
                            })
                    )
                  ],
                );
              }
          ),
        ),
        SizedBox(height: 41),
        _signatureView(),
        SizedBox(height: 44),
        _buildTermsLayout(),
        SizedBox(height: 26),
        Spacer(),
        Styles.statefulButton(
            stream: viewModel.profileForm.isValid,
            onClick: () => subscribeUiToOnBoard(),
            text: "Complete Signup",
            isLoading: _isLoading
        )
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return ScrollView(
        maxHeight: MediaQuery.of(context).size.height - 64,//subtract the vertical padding
        child : Container(
            padding: EdgeInsets.symmetric(vertical: 32, horizontal: 20),
            color: Colors.white,
            child : _buildMain(context)
        )
    );
  }

  @override
  void dispose() {
    _passwordController.dispose();
    super.dispose();
  }

}
