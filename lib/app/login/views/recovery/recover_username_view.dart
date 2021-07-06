import 'package:flutter/material.dart' hide ScrollView, Colors;
import 'package:flutter/services.dart';
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

class RecoverUsernameScreen extends StatefulWidget {

  late final GlobalKey<ScaffoldState> _scaffoldKey;

  RecoverUsernameScreen(this._scaffoldKey);

  @override
  State<StatefulWidget> createState() {
    return _RecoverUsernameScreen();
  }
}

class _RecoverUsernameScreen extends State<RecoverUsernameScreen> {
  bool _isLoading = false;

  void subscribeUiToUsernameRecovery() {
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
    viewModel.setRecoveryMode(RecoveryMode.USERNAME_RECOVERY);

    return ScrollView(
      maxHeight: MediaQuery.of(context).size.height,
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 32, horizontal: 16),
        child: Column(
          children: [
            Expanded(
                child: Center(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        'Recover Username',
                        textAlign: TextAlign.start,
                        style: TextStyle(
                            color: Colors.colorPrimaryDark,
                            fontSize: 25,
                            fontWeight: FontWeight.w600
                        ),
                      ),
                      SizedBox(height: 8),
                      Text(
                          'Please enter the account number and BVN linked to the forgotten username.',
                          textAlign: TextAlign.start,
                          style: TextStyle(
                              color: Colors.textColorBlack,
                              fontSize: 15,
                              fontWeight: FontWeight.normal)
                      ),
                      SizedBox(height: 44),
                      StreamBuilder(
                        stream: viewModel.userRecoveryForm.accountNumberStream,
                        builder: (context, snapshot) {
                          return Styles.appEditText(
                              hint: 'Account Number',
                              maxLength: 10,
                              inputFormats: [
                                FilteringTextInputFormatter.digitsOnly
                              ],
                              animateHint: true,
                              onChanged: viewModel.userRecoveryForm.onAccountNumberChanged,
                              errorText: snapshot.hasError
                                  ? snapshot.error.toString()
                                  : null,
                              startIcon: Icon(CustomFont.bankIcon,
                              color: Colors.colorFaded)
                          );
                    },
                  ),
                  SizedBox(height: 16),
                  StreamBuilder(
                    stream: viewModel.userRecoveryForm.bvnStream,
                    builder: (context, snapshot) {
                      return Styles.appEditText(
                          hint: 'BVN',
                          maxLength: 11,
                          inputFormats: [
                            FilteringTextInputFormatter.digitsOnly
                          ],
                          animateHint: true,
                          onChanged: viewModel.userRecoveryForm.onBVNChanged,
                          errorText: snapshot.hasError
                              ? snapshot.error.toString()
                              : null,
                          startIcon: Icon(CustomFont.username_icon,
                              color: Colors.colorFaded));
                    },
                  ),
                  SizedBox(height: 100),
                ],
              ),
            )),
            Styles.statefulButton(
              elevation: 0,
                stream: viewModel.userRecoveryForm.isValid,
                onClick: subscribeUiToUsernameRecovery,
                text: 'Submit',
                isLoading: _isLoading
            ),
            SizedBox(height: 16)
          ],
        ),
      ),
    );
  }
}
