import 'package:flutter/material.dart' hide Colors, ScrollView;
import 'package:flutter/services.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:moniepoint_flutter/app/login/viewmodels/recovery_view_model.dart';
import 'package:moniepoint_flutter/app/login/views/recovery/recovery_controller_screen.dart';
import 'package:moniepoint_flutter/app/usermanagement/model/data/recovery_response.dart';
import 'package:moniepoint_flutter/core/bottom_sheet.dart';
import 'package:moniepoint_flutter/core/colors.dart';
import 'package:moniepoint_flutter/core/custom_fonts.dart';
import 'package:moniepoint_flutter/core/network/resource.dart';
import 'package:moniepoint_flutter/core/styles.dart';
import 'package:moniepoint_flutter/core/views/scroll_view.dart';
import 'package:provider/provider.dart';

class RecoverPasswordScreen extends StatefulWidget {

  late final GlobalKey<ScaffoldState> _scaffoldKey;

  RecoverPasswordScreen(this._scaffoldKey);

  @override
  State<StatefulWidget> createState() {
    return _RecoverPasswordScreen();
  }

}

class _RecoverPasswordScreen extends State<RecoverPasswordScreen> {
  bool _isLoading = false;

  void _subscribeUiToPasswordRecovery() {
    final viewModel = Provider.of<RecoveryViewModel>(context, listen: false);
    viewModel.initiateRecovery().listen((event) {
      if(event is Loading) setState(() => _isLoading = true);
      if (event is Error<RecoveryResponse>) {
        setState(() => _isLoading = false);
        showModalBottomSheet(
            context: widget._scaffoldKey.currentContext ?? context,
            isScrollControlled: true,
            backgroundColor: Colors.transparent,
            builder: (context) {
              return BottomSheets.displayErrorModal(context, message: event.message);
            });
      }
      if(event is Success<RecoveryResponse>) {
        setState(() => _isLoading = false);
        Navigator.of(context).pushNamed("security_question");
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final viewModel = Provider.of<RecoveryViewModel>(context, listen: false);
    viewModel.setRecoveryMode(RecoveryMode.PASSWORD_RECOVERY);

    return SingleChildScrollView(
      physics: NeverScrollableScrollPhysics(),
      child: ConstrainedBox(
        constraints: BoxConstraints(
          minHeight: MediaQuery.of(context).size.height,
          minWidth: MediaQuery.of(context).size.width
        ),
        child: IntrinsicHeight(
          child:  Container(
            padding: EdgeInsets.symmetric(vertical: 32, horizontal: 16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Flexible(
                    fit: FlexFit.loose,
                    child: Center(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            'Recover Password',
                            textAlign: TextAlign.start,
                            style: TextStyle(
                                color: Colors.colorPrimaryDark,
                                fontSize: 25,
                                fontWeight: FontWeight.bold),
                          ),
                          SizedBox(height: 8),
                          Text(
                              'Please enter the account number and username linked to your account. ',
                              textAlign: TextAlign.start,
                              style: TextStyle(
                                  color: Colors.textColorBlack,
                                  fontSize: 15,
                                  fontWeight: FontWeight.normal)),
                          SizedBox(height: 44),
                          StreamBuilder(
                            stream: viewModel.passwordRecoveryForm.accountNumberStream,
                            builder: (context, snapshot) {
                              return Styles.appEditText(
                                  hint: 'Account Number',
                                  inputFormats: [
                                    LengthLimitingTextInputFormatter(10),
                                    FilteringTextInputFormatter.digitsOnly
                                  ],
                                  animateHint: true,
                                  onChanged: viewModel.passwordRecoveryForm.onAccountNumberChanged,
                                  errorText: snapshot.hasError
                                      ? snapshot.error.toString()
                                      : null,
                                  startIcon: Icon(CustomFont.bankIcon, color: Colors.colorFaded)
                              );
                            },
                          ),
                          SizedBox(height: 16),
                          StreamBuilder(
                            stream: viewModel.passwordRecoveryForm.usernameStream,
                            builder: (context, snapshot) {
                              return Styles.appEditText(
                                  hint: 'Username',
                                  inputFormats: [LengthLimitingTextInputFormatter(11)],
                                  animateHint: true,
                                  onChanged: viewModel.passwordRecoveryForm.onUsernameChanged,
                                  errorText: snapshot.hasError
                                      ? snapshot.error.toString()
                                      : null,
                                  startIcon: Icon(CustomFont.username_icon, color: Colors.colorFaded)
                              );
                            },
                          ),
                          SizedBox(height: 100),
                        ],
                      ),
                    )),
                Styles.statefulButton(
                    elevation: 0,
                    stream: viewModel.passwordRecoveryForm.isValid,
                    onClick: _subscribeUiToPasswordRecovery,
                    text: 'Submit',
                    isLoading: _isLoading
                ),
                SizedBox(height: 16)
              ],
            ),
          ),
        ),
      ),
    );
  }

}