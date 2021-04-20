import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart' hide Colors;
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:moniepoint_flutter/app/onboarding/viewmodel/onboarding_view_model.dart';
import 'package:moniepoint_flutter/app/securityquestion/model/data/security_question.dart';
import 'package:moniepoint_flutter/core/colors.dart';
import 'package:moniepoint_flutter/core/custom_fonts.dart';
import 'package:moniepoint_flutter/core/network/resource.dart';
import 'package:moniepoint_flutter/core/strings.dart';
import 'package:moniepoint_flutter/core/styles.dart';
import 'package:moniepoint_flutter/core/tuple.dart';
import 'package:moniepoint_flutter/core/views/pin_entry.dart';
import 'package:provider/provider.dart';
import 'package:moniepoint_flutter/core/utils/text_utils.dart';
import 'package:moniepoint_flutter/core/bottom_sheet.dart';


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
            final message = (_isNewAccount) ?"Account Created Successfully" : "Profile Created Successfully";
            return BottomSheets.displaySuccessModal(context, title:"Success", message: message);
          });
    }else if(resource is Error<T>) {
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

  void _showTermsAndConditionModal() {
    showModalBottomSheet(
        context: _scaffoldKey.currentContext ?? context,
        isScrollControlled: false,
        backgroundColor: Colors.transparent,
        builder: (context) {
          return BottomSheets.makeAppBottomSheet(
            centerImageRes: 'res/drawables/ic_terms_and_condition.svg',
            content: Stack(
              children: [
                Positioned(
                    top: 20,
                    right: 0,
                    left: 0,
                    child: Text('Terms & Conditions',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.darkBlue,
                    )
                )),
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
                        child: Text(Strings.terms_and_condition),
                      ),
                    )
                ),
                Positioned(
                    bottom: 32,
                    right: 16,
                    left: 16,
                    child: Divider(
                      height: 4,
                      color: Colors.colorFaded,
                    )
                ),
              ],
            )
          );
        });
  }

  Widget _buildTermsLayout() {
    final txt =
        'By signing up you agree to our Terms & Conditions and Privacy Policy.';
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 24, vertical: 14),
      decoration: BoxDecoration(
          color: Colors.primaryColor.withOpacity(0.1),
          borderRadius: BorderRadius.circular(8)),
      child: Text(
          txt,
          style: TextStyle(color: Colors.darkBlue, fontFamily: Styles.defaultFont, fontSize: 16)
      ).colorText({
        "Terms & Conditions": Tuple(Colors.darkBlue, _showTermsAndConditionModal),
        "Privacy Policy": Tuple(Colors.darkBlue, _showTermsAndConditionModal),
      }, bold: false),
    );
  }

  /// Returns each security drop down button
  Widget buildDropDownItem(
      int questionNumber,
      List<SecurityQuestion> items,
      AsyncSnapshot<SecurityQuestion> snapShot) {

    final viewModel = Provider.of<OnBoardingViewModel>(context, listen: false);

    return InputDecorator(
        decoration: InputDecoration(
          border: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.colorFaded),
            borderRadius: BorderRadius.circular(2)
          ),
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.colorFaded)
          ),
          contentPadding: EdgeInsets.only(left: 16, right: 21, top: 5, bottom: 5),
        ),
        child: DropdownButton(
            underline: Container(),
            icon: Icon(CustomFont.dropDown, color: Colors.primaryColor, size: 6),
            isExpanded: true,
            value: snapShot.data,
            onChanged: (v) => viewModel.profileForm.onSecurityQuestionChange(questionNumber, v as SecurityQuestion),
            style: const TextStyle(color: Colors.darkBlue, fontFamily: Styles.defaultFont, fontSize: 14),
            items: items.map((SecurityQuestion securityQuestion) {
              return DropdownMenuItem(
                  value: securityQuestion,
                  child: Text(securityQuestion.question)
              );
            }).toList()),
    );
  }

  /// Builds layout that holds all security questions
  Widget getSecurityQuestionLayout(BuildContext context, List<SecurityQuestion> items) {
    final viewModel = Provider.of<OnBoardingViewModel>(context, listen: false);
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
          initialData: (items.isNotEmpty) ? items.first : null,
          stream: viewModel.profileForm.questionOneStream,
          builder: (context, AsyncSnapshot<SecurityQuestion> snapShot) {
            return buildDropDownItem(1, items, snapShot);
          }),
      SizedBox(height: 16),
      StreamBuilder(
          stream: viewModel.profileForm.answerOneStream,
          builder: (context, snapshot) {
            return Styles.appEditText(
              hint: 'Answer 1',
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
          initialData: (items.isNotEmpty && items.length > 1) ? items[1] : null,
          stream: viewModel.profileForm.questionTwoStream,
          builder: (context, AsyncSnapshot<SecurityQuestion> snapShot) {
            return buildDropDownItem(2, items, snapShot);
          }),
      SizedBox(height: 16),
      StreamBuilder(
          stream: viewModel.profileForm.answerTwoStream,
          builder: (context, snapshot) {
            return Styles.appEditText(
              hint: 'Answer 2',
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
          initialData: (items.isNotEmpty && items.length > 2) ? items[2] : null,
          stream: viewModel.profileForm.questionThreeStream,
          builder: (context, AsyncSnapshot<SecurityQuestion> snapShot) {
            return buildDropDownItem(3, items, snapShot);
          }),
      SizedBox(height: 16),
      StreamBuilder(
          stream: viewModel.profileForm.answerThreeStream,
          builder: (context, snapshot) {
            return Styles.appEditText(
              hint: 'Answer 3',
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
            fontWeight: FontWeight.bold,
            color: Colors.darkBlue,
            fontSize: 21,
          ),
          textAlign: TextAlign.start,
        ),
        SizedBox(height: 30),
        StreamBuilder(
            stream: viewModel.profileForm.usernameStream,
            builder: (context, snapshot) {
              return Styles.appEditText(
                  hint: 'Enter Username',
                  animateHint: true,
                  onChanged: viewModel.profileForm.onUsernameChanged,
                  errorText: snapshot.hasError ? snapshot.error.toString() : null,
                  startIcon: Icon(CustomFont.username_icon, color: Colors.colorFaded),
                  drawablePadding: 8);
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
                  drawablePadding: 4,
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
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18, color: Colors.darkBlue),
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
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 22, color: Colors.darkBlue),
        ),
        SizedBox(height: 16),
        StreamBuilder(
            stream: viewModel.getSecurityQuestions(),
            builder: (context, AsyncSnapshot<Resource<List<SecurityQuestion>>> snapshot) {
              if(snapshot.hasData && snapshot.data is Success) {
                return getSecurityQuestionLayout(context, snapshot.data!.data!);
              }
              return Column();
            }),
        _buildTermsLayout(),
        SizedBox(height: 44),
        Spacer(),
        StreamBuilder(
          stream: viewModel.profileForm.isValid,
          initialData: false,
          builder: (context, AsyncSnapshot<bool> snapshot) {
            return Stack(
              children: [
                SizedBox(
                  width: double.infinity,
                  child: Styles.appButton(
                      onClick: (snapshot.hasData && snapshot.data == true) && !_isLoading
                          ? () => subscribeUiToOnBoard()
                          : null,
                      text: 'Continue'
                  ),
                ),
                Positioned(
                    right: 16,
                    top: 16,
                    bottom: 16,
                    child: _isLoading
                        ? SpinKitThreeBounce(size: 20.0, color: Colors.white.withOpacity(0.5))
                        : SizedBox()
                )
              ],
            );
          },
        ),
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
