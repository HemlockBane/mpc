import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart' hide Colors;
import 'package:flutter/services.dart';
import 'package:moniepoint_flutter/app/onboarding/model/data/bvn_validation_request.dart';
import 'package:moniepoint_flutter/app/onboarding/viewmodel/onboarding_view_model.dart';
import 'package:moniepoint_flutter/app/onboarding/views/new/new_account_view.dart';
import 'package:moniepoint_flutter/core/bottom_sheet.dart';
import 'package:moniepoint_flutter/core/colors.dart';
import 'package:moniepoint_flutter/core/custom_fonts.dart';
import 'package:moniepoint_flutter/core/models/gender.dart';
import 'package:moniepoint_flutter/core/network/resource.dart';
import 'package:moniepoint_flutter/core/styles.dart';
import 'package:moniepoint_flutter/core/tuple.dart';
import 'package:moniepoint_flutter/core/utils/call_utils.dart';
import 'package:moniepoint_flutter/core/utils/text_utils.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';

class BVNValidationScreen extends StatefulWidget {
  /// We are simply using this key to reference our parent context
  late final GlobalKey<ScaffoldState> _scaffoldKey;

  BVNValidationScreen(this._scaffoldKey);

  @override
  State<StatefulWidget> createState() {
    return _BVNValidationScreenState(_scaffoldKey);
  }
}

class _BVNValidationScreenState extends State<BVNValidationScreen> {
  late final GlobalKey<ScaffoldState> _scaffoldKey;
  final _dummyFocus = FocusNode();

  final TextEditingController _genderController = TextEditingController();
  final TextEditingController _dateOfBirthController = TextEditingController();
  bool _isLoading = false;

  _BVNValidationScreenState(this._scaffoldKey);

  void _onDateOfBirthChanged() {
    final viewModel = Provider.of<OnBoardingViewModel>(context, listen: false);
    final dateOfBirth = _dateOfBirthController.text;
    viewModel.accountForm.onDateOfBirthChanged(dateOfBirth);
  }

  @override
  void initState() {
    _dateOfBirthController.addListener(_onDateOfBirthChanged);
    super.initState();
  }

  void displayDatePicker(BuildContext context) async {
    final selectedDate = await showDatePicker(
        builder: (BuildContext context, Widget? child) {
          return Theme(
            data: ThemeData.from(colorScheme: ColorScheme.light(primary: Colors.primaryColor)),
            child: child!
          );
          },
        // locale: Locale("en-GB"),
        helpText: 'Select Date of Birth',
        context: this.context,
        initialDate: DateTime(1980, 1, 1).add(Duration(days: 1)),
        firstDate: DateTime(1900, 1, 1).add(Duration(days: 1)),
        lastDate: DateTime.now().subtract(Duration(days: 365 * 2))
    );

    if(selectedDate != null ) {
      _dateOfBirthController.text = DateFormat('yyyy-MM-dd').format(selectedDate);
    }
  }

  void subscribeToBVNValidation(BuildContext context) {
    //since we are coming from the dialog lets pop
    Provider.of<OnBoardingViewModel>(context, listen: false)
        .validateBVN()
        .listen((event) {
          if(event is Loading) setState(() => _isLoading = true);
          if (event is Error<BVNValidationRequest>) {
            setState(() => _isLoading = false);
            showModalBottomSheet(
                context: _scaffoldKey.currentContext ?? context,
                isScrollControlled: true,
                backgroundColor: Colors.transparent,
                builder: (context) {
                  return BottomSheets.displayErrorModal(context, message: event.message);
                });
          }
          if(event is Success<BVNValidationRequest>) {
            setState(() => _isLoading = false);
            Navigator.of(context).pushNamed(NewAccountScreen.OTP_SCREEN);
          }
    });
    //startValidation
  }

  @override
  void dispose() {
    _genderController.dispose();
    _dummyFocus.dispose();
    super.dispose();
  }

  void displayDateOfBirthDialog(BuildContext mContext) {
    FocusScope.of(context).requestFocus(_dummyFocus);
    final viewModel = Provider.of<OnBoardingViewModel>(mContext, listen: false);
    _dateOfBirthController.text = "";

    showModalBottomSheet(
        context: _scaffoldKey.currentContext ?? mContext,
        isScrollControlled: true,
        backgroundColor: Colors.transparent,
        builder: (context) {
          return BottomSheets.makeAppBottomSheet(
              centerImageBackgroundColor: Colors.primaryColor.withOpacity(0.1),
              centerImageRes: 'res/drawables/ic_calendar.svg',
              content: Wrap(
                children: [
                  Container(
                    width: double.infinity,
                    padding: EdgeInsets.only(left: 16, right: 16, top: 30, bottom: 16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Text('Date of Birth',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                fontSize: 22,
                                fontWeight: FontWeight.bold,
                                color: Colors.darkBlue)),
                        SizedBox(height: 12),
                        Text(
                            'Please provide the date of birth for the supplied BVN',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.normal,
                                color: Colors.deepGrey)),
                        SizedBox(height: 24),
                        Styles.appEditText(
                            controller: _dateOfBirthController,
                            hint: 'Enter Date of Birth',
                            startIcon: Icon(
                              CustomFont.calendar,
                              color: Colors.colorFaded,
                            ),
                            enabled: false,
                            onClick: () => displayDatePicker(mContext)),
                        SizedBox(height: 45),
                        StreamBuilder(
                            stream: viewModel.accountForm.dobStream,
                            builder: (_, AsyncSnapshot<bool> snapshot) {
                              return Styles.appButton(
                                  onClick: (!snapshot.hasData || snapshot.data == false)
                                      ? null
                                      : () {
                                          Navigator.pop(context);
                                          subscribeToBVNValidation(mContext);
                                        },
                                  text: 'Continue'
                              );
                            }),
                        SizedBox(height: 42),
                      ],
                    ),
                  )
                ],
              ));
        });
  }

  Widget _buildMain(BuildContext context) {
    final viewModel = Provider.of<OnBoardingViewModel>(context, listen: false);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text('Sign Up to Moniepoint',
            style: TextStyle(
                fontWeight: FontWeight.w600,
                color: Colors.colorPrimaryDark,
                fontSize: 24
            ),
            textAlign: TextAlign.start),
        SizedBox(height: 6),
        Text('Enter your details to get started.',
            style: TextStyle(
                fontWeight: FontWeight.normal,
                color: Colors.textColorBlack,
                fontSize: 14)),
        SizedBox(height: 45),
        Container(
          padding: EdgeInsets.symmetric(horizontal: 15, vertical: 8),
          decoration: BoxDecoration(
              shape: BoxShape.rectangle,
              color: Colors.primaryColor.withOpacity(0.2),
              borderRadius: BorderRadius.circular(4)),
          child: Center(
            child: Text(
                'Dial *565*0# on your registered mobile number to get your \nBVN!',
                textAlign: TextAlign.center,
                style: TextStyle(
                    fontFamily: Styles.defaultFont,
                    color: Color(0XFF0B3275),
                    fontWeight: FontWeight.w400,
                    fontSize: 12
                ))
                .colorText({'*565*0#': Tuple(Colors.primaryColor, () => openUrl("tel:${Uri.encodeComponent("*565*0#")}"))}, underline: false),
          ),
        ),
        SizedBox(height: 20),
        StreamBuilder(
            stream: viewModel.accountForm.bvnStream,
            builder: (context, snapshot) {
          return Styles.appEditText(
              errorText: snapshot.hasError ? snapshot.error.toString() : null,
              hint: 'BVN',
              inputFormats: [FilteringTextInputFormatter.digitsOnly],
              onChanged: viewModel.accountForm.onBVNChanged,
              startIcon: Icon(CustomFont.bankIcon, color: Colors.colorFaded, size: 22),
              animateHint: true,
              maxLength: 11
          );
        }),
        SizedBox(height: 16),
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
        SizedBox(height: 16),
        StreamBuilder(
          stream: viewModel.accountForm.emailStream,
            builder: (context, snapshot) {
          return Styles.appEditText(
            errorText: snapshot.hasError ? snapshot.error.toString() : null,
            onChanged: viewModel.accountForm.onEmailChanged,
            hint: 'Email Address',
            startIcon: Icon(CustomFont.email, color: Colors.colorFaded, size: 16),
            animateHint: true,
          );
        }),
        SizedBox(height: 16),
        StreamBuilder(
            stream: viewModel.accountForm.genderStream,
            builder: (BuildContext context, snapshot) {
          return Styles.appEditText(
              controller: _genderController,
              hint: 'Gender',
              errorText: snapshot.hasError ? snapshot.error.toString() : null,
              startIcon: Icon(CustomFont.gender, color: Colors.colorFaded, size: 22),
              endIcon: Icon(CustomFont.dropDown, color: Colors.primaryColor, size: 6),
              animateHint: true,
              enabled: false,
              onClick: () => showDialog(context: context, builder: (BuildContext mContext) {
                return SimpleDialog(
                  title: const Text('Select your Gender'),
                  children: Gender.values.map<Widget>((e) => SimpleDialogOption(
                    child: Text(describeEnum(e)),
                    onPressed: () {
                      _genderController.text = describeEnum(e);
                      FocusManager.instance.primaryFocus?.unfocus();
                      Navigator.pop(mContext);
                      viewModel.accountForm.onGenderChanged(describeEnum(e));
                    }
                  )).toList(),
                );
              })
          );
        }),
        Spacer(),
        SizedBox(height: 24),
        Styles.statefulButton(
            elevation: 0,
            stream: viewModel.accountForm.isValid,
            onClick: () => displayDateOfBirthDialog(context),
            text: 'Continue',
            isLoading: _isLoading
        ),
        SizedBox(height: 32),
        Center(
          child: Text('Already have a profile? Login',
              style: TextStyle(color: Color(0XFF002331), fontFamily: Styles.defaultFont, fontSize: 16)
          ).colorText({
            "Login": Tuple(Colors.primaryColor, () => Navigator.of(_scaffoldKey.currentContext!).popAndPushNamed('/login'))
          }, underline: false)
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(child: Scaffold(
        resizeToAvoidBottomInset: false,
        body: LayoutBuilder(builder: (BuildContext context, BoxConstraints constraints) {
          return SingleChildScrollView(
            child: ConstrainedBox(
              constraints: BoxConstraints(minHeight: constraints.maxHeight),
              child: IntrinsicHeight(
                child: Container(
                    color: Colors.backgroundWhite,
                    padding: EdgeInsets.only(
                        left: 16, right: 16, top: 41, bottom: 44*2
                    ),
                    child: _buildMain(context)
                ),
              ),
            ),
          );
        })));
  }
}
