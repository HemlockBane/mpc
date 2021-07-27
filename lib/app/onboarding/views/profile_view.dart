import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart' hide Colors;
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:moniepoint_flutter/app/cards/views/error_layout_view.dart';
import 'package:moniepoint_flutter/app/onboarding/viewmodel/onboarding_view_model.dart';
import 'package:moniepoint_flutter/app/onboarding/views/security_question_shimmer.dart';
import 'package:moniepoint_flutter/app/securityquestion/model/data/security_question.dart';
import 'package:moniepoint_flutter/core/colors.dart';
import 'package:moniepoint_flutter/core/custom_fonts.dart';
import 'package:moniepoint_flutter/core/network/network_bound_resource.dart';
import 'package:moniepoint_flutter/core/network/resource.dart';
import 'package:moniepoint_flutter/core/routes.dart';
import 'package:moniepoint_flutter/core/strings.dart';
import 'package:moniepoint_flutter/core/styles.dart';
import 'package:moniepoint_flutter/core/tuple.dart';
import 'package:moniepoint_flutter/core/utils/call_utils.dart';
import 'package:moniepoint_flutter/core/views/pin_entry.dart';
import 'package:provider/provider.dart';
import 'package:moniepoint_flutter/core/utils/text_utils.dart';
import 'package:moniepoint_flutter/core/bottom_sheet.dart';
import '../username_validation_state.dart';

class ProfileScreen extends StatefulWidget {
  late final GlobalKey<ScaffoldState> _scaffoldKey;

  ProfileScreen(this._scaffoldKey);

  @override
  State<StatefulWidget> createState() {
    return _ProfileScreenState(this._scaffoldKey);
  }
}

class _ProfileScreenState extends State<ProfileScreen> {

  late final GlobalKey<ScaffoldState> _scaffoldKey;
  bool _isPasswordVisible  = false;
  bool _isLoading = false;
  bool _isNewAccount = false;

  Stream<Resource<List<SecurityQuestion>>>? _securityQuestionStream;

  _ProfileScreenState(this._scaffoldKey);
  
  Widget getPasswordToggleIcon(BuildContext context) {
    return IconButton(
        icon: Icon(this._isPasswordVisible ? Icons.visibility : Icons.visibility_off, color: Colors.colorFaded),
        onPressed: () {
          setState(() {
            this._isPasswordVisible = !_isPasswordVisible;
          });
        }
    );
  }

  void handleCreationResponse<T>(Resource<T> resource) {
    if(resource is Success<T>){
      setState(() => _isLoading = false);
      showModalBottomSheet(
          context: _scaffoldKey.currentContext ?? context,
          isScrollControlled: true,
          backgroundColor: Colors.transparent,
          builder: (context) {
            final message = (_isNewAccount) ? "Account Created Successfully" : "Profile Created Successfully";
            return BottomSheets.displaySuccessModal(context, title:"Success", message: message, onClick: (){
              Navigator.pushNamedAndRemoveUntil(context, Routes.LOGIN, (route) => false);
            });
          });
    } else if(resource is Error<T>) {
      showModalBottomSheet(
          context: _scaffoldKey.currentContext ?? context,
          isScrollControlled: true,
          backgroundColor: Colors.transparent,
          builder: (context) {
            return BottomSheets.displayErrorModal(context, message: resource.message);
          });
      setState(() => _isLoading = false);
    }
    else if (resource is Loading){
      setState(() => _isLoading = true);
    }
  }

  void subscribeUiToOnBoard() {
    final viewModel = Provider.of<OnBoardingViewModel>(context, listen: false);
    if (viewModel.isNewAccount) {
      _isNewAccount = true;
      viewModel.createAccount().listen(handleCreationResponse);
    } else {
      _isNewAccount = false;
      viewModel.createUser().listen(handleCreationResponse);
    }
  }

  @override
  void initState() {
    final viewModel = Provider.of<OnBoardingViewModel>(context, listen: false);
    _securityQuestionStream = viewModel.getSecurityQuestions();
    super.initState();
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
                          ))),
                  Positioned(
                      top: 66,
                      right: 16,
                      left: 16,
                      child: Divider(
                        height: 4,
                        color: Colors.colorFaded,
                      )),
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
    final txt = 'By signing up you agree to our Terms & Conditions and Privacy Policy.';
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 24, vertical: 14),
      decoration: BoxDecoration(
          color: Colors.primaryColor.withOpacity(0.1),
          borderRadius: BorderRadius.circular(8)),
      child: Text(
          txt,
          style: TextStyle(color: Colors.textColorPrimary, fontFamily: Styles.defaultFont, fontSize: 18)
      ).colorText({
        "Terms & Conditions": Tuple(Colors.textColorPrimary, () => _showTermsAndConditionModal("Terms & Conditions", Strings.terms_and_condition)),
        "Privacy Policy": Tuple(Colors.textColorPrimary, () => _showTermsAndConditionModal("Privacy Policy", Strings.privacy_policy)),
      }, bold: true, boldType: 1),
    );
  }

  /// Builds layout that holds all security questions
  Widget getSecurityQuestionLayout(BuildContext context, List<SecurityQuestion> items) {
    final viewModel = Provider.of<OnBoardingViewModel>(context, listen: false);
    final itemStyle = TextStyle(fontWeight: FontWeight.w600, color: Colors.deepGrey);
    final selectedItemStyle = TextStyle(fontWeight: FontWeight.w600, color: Colors.deepGrey, backgroundColor: Colors.grey);
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Text(
        'Security Question 1',
        style: TextStyle(
            fontWeight: FontWeight.normal,
            fontSize: 13,
            color: Colors.textColorBlack),
      ),
      SizedBox(height: 8),
      StreamBuilder(
          initialData: null,
          stream: viewModel.profileForm.questionOneStream,
          builder: (context, AsyncSnapshot<SecurityQuestion?> snapShot) {
            return Styles.buildDropDown(viewModel.profileForm.securityQuestionOneList, snapShot, (item, index) {
              viewModel.profileForm.onSecurityQuestionChange(1, item as SecurityQuestion);
            }, itemStyle: itemStyle, hint: "Security Question 1");
          }),
      SizedBox(height: 16),
      StreamBuilder(
          stream: viewModel.profileForm.answerOneStream,
          builder: (context, snapshot) {
            return Styles.appEditText(
              hint: 'Answer 1',
              fontSize: 13,
              onChanged: (v) => viewModel.profileForm.onAnswerChanged(1, v),
              errorText: snapshot.hasError ? snapshot.error.toString() : null,
            );
          }),
      SizedBox(height: 40),
      Text(
        'Security Question 2',
        style: TextStyle(
            fontWeight: FontWeight.normal,
            fontSize: 13,
            color: Colors.textColorBlack),
      ),
      SizedBox(height: 8),
      StreamBuilder(
          initialData: null,
          stream: viewModel.profileForm.questionTwoStream,
          builder: (context, AsyncSnapshot<SecurityQuestion?> snapShot) {
            return Styles.buildDropDown(viewModel.profileForm.securityQuestionTwoList, snapShot, (item, index) {
              viewModel.profileForm.onSecurityQuestionChange(2, item as SecurityQuestion);
            }, itemStyle: itemStyle, hint: "Security Question 2");
          }),
      SizedBox(height: 16),
      StreamBuilder(
          stream: viewModel.profileForm.answerTwoStream,
          builder: (context, snapshot) {
            return Styles.appEditText(
              hint: 'Answer 2',
              fontSize: 13,
              onChanged: (v) => viewModel.profileForm.onAnswerChanged(2, v),
              errorText: snapshot.hasError ? snapshot.error.toString() : null,
            );
          }),
      SizedBox(height: 40),
      Text(
        'Security Question 3',
        style: TextStyle(
            fontWeight: FontWeight.normal,
            fontSize: 13,
            color: Colors.textColorBlack),
      ),
      SizedBox(height: 8),
      StreamBuilder(
          initialData: null,
          stream: viewModel.profileForm.questionThreeStream,
          builder: (context, AsyncSnapshot<SecurityQuestion?> snapShot) {
            return Styles.buildDropDown(viewModel.profileForm.securityQuestionThreeList, snapShot, (item, index) {
              viewModel.profileForm.onSecurityQuestionChange(3, item as SecurityQuestion);
            }, itemStyle: itemStyle, hint: "Security Question 3");
          }),
      SizedBox(height: 16),
      StreamBuilder(
          stream: viewModel.profileForm.answerThreeStream,
          builder: (context, snapshot) {
            return Styles.appEditText(
              hint: 'Answer 3',
              fontSize: 13,
              onChanged: (v) => viewModel.profileForm.onAnswerChanged(3, v),
              errorText: snapshot.hasError ? snapshot.error.toString() : null,
            );
          }),
      SizedBox(height: 32),
    ]);
  }

  Widget _buildMain(BuildContext context) {
    final viewModel = Provider.of<OnBoardingViewModel>(context, listen: false);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      mainAxisSize: MainAxisSize.max,
      children: [
        Text(
          'Create Your Profile',
          style: TextStyle(
            fontWeight: FontWeight.w600,
            color: Colors.colorPrimaryDark,
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
                      hint: 'Enter Username',
                      animateHint: true,
                      endIcon: validationStatus == UsernameValidationStatus.VALIDATING
                          ? Padding(
                              padding: EdgeInsets.only(right: 16),
                              child: SizedBox(
                                width: 20,
                                child: SpinKitThreeBounce(size: 20.0, color: Colors.primaryColor.withOpacity(0.8)),),
                            )
                          : null,
                      onChanged: (v) {
                        viewModel.profileForm.onUsernameChanged(v);
                      },
                      errorText: snapshot.hasError ? snapshot.error.toString() : null,
                      startIcon: Icon(CustomFont.username_icon, color: Colors.colorFaded),
                      drawablePadding: EdgeInsets.only(left: 8, right: 8),
                    ),
                    onFocusChange: (hasFocus) {
                      final username = viewModel.profileForm.profile.username;
                      if (!hasFocus && username != null && username.isNotEmpty)
                        viewModel.checkUsername(username).listen((event) {});
                    },
                  ),
                  Visibility(
                      visible: validationStatus != null && validationStatus == UsernameValidationStatus.AVAILABLE,
                      child: Padding(
                        padding:EdgeInsets.only(left: 16, top: 3),
                        child: Text(
                          'Username is available',
                          style: TextStyle(color: Colors.solidGreen, fontSize: 12),
                        ),
                      )
                  ),
                ],
              );
            }),
        SizedBox(height: 16),
        StreamBuilder(
            stream: viewModel.profileForm.passwordStream,
            builder: (context, snapshot) {
              return Styles.appEditText(
                  hint: 'Password',
                  onChanged: viewModel.profileForm.onPasswordChanged,
                  errorText: snapshot.hasError ? snapshot.error.toString() : null,
                  animateHint: true,
                  drawablePadding: EdgeInsets.only(left: 4, right: 4),
                  startIcon: Icon(CustomFont.password, color: Colors.colorFaded),
                  endIcon: getPasswordToggleIcon(context),
                  isPassword: !_isPasswordVisible
              );
            }),
        SizedBox(height: 37),
        Container(
          margin: EdgeInsets.only(left: 44, right: 44),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                ' Setup Mobile Transaction PIN',
                style: TextStyle(fontWeight: FontWeight.w600, fontSize: 18, color: Colors.colorPrimaryDark),
              ),
              SizedBox(height: 16),
              StreamBuilder(
                stream: viewModel.profileForm.pinInputStream,
                  builder: (_, __) {
                return PinEntry(onChange: viewModel.profileForm.onPinChanged);
              })
            ],
          ),
        ),
        SizedBox(height: 46),
        Text(
            'Security Questions',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 22, color: Colors.colorPrimaryDark),
        ),
        SizedBox(height: 16),
        StreamBuilder(
            stream: _securityQuestionStream,
            builder: (context, AsyncSnapshot<Resource<List<SecurityQuestion>>> snapshot) {
              final responseData = (snapshot.hasData) ? snapshot.data : null;
              if(responseData is Success) {
                print(viewModel.profileForm.securityQuestionOneList);
                return getSecurityQuestionLayout(context, snapshot.data!.data!);
              }
              //loading state
              if(responseData == null || snapshot.data is Loading) {
                return SecurityQuestionShimmer();
              }
              if(responseData is Error<List<SecurityQuestion>>) {
                final errMessage = formatError(responseData.message, "security questions");
                return ErrorLayoutView(errMessage.first, errMessage.second, (){
                  _securityQuestionStream = viewModel.getSecurityQuestions();
                  setState(() {});
                });
              }
              return Container();
            }),
        _buildTermsLayout(),
        SizedBox(height: 44),
        Spacer(),
        Styles.statefulButton(
            stream: viewModel.profileForm.isValid,
            onClick: () => subscribeUiToOnBoard(),
            text: "Continue",
            isLoading: _isLoading
        )
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomInset: false,
        body: LayoutBuilder(
            builder: (BuildContext context, BoxConstraints constraints) {
          return SingleChildScrollView(
            child: ConstrainedBox(
              constraints: BoxConstraints(minHeight: constraints.maxHeight),
              child: IntrinsicHeight(
                child: Container(
                    color: Colors.backgroundWhite,
                    padding: EdgeInsets.only(left: 16, right: 16, top: 41, bottom: 42),
                    child: _buildMain(context)),
              ),
            ),
          );
        }));
  }

}
