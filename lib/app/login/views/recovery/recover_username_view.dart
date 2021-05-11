import 'package:flutter/material.dart' hide ScrollView, Colors;
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
                        color: Colors.darkBlue,
                        fontSize: 22,
                        fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 8),
                  Text(
                      'Please enter the account number and phone number linked to the forgotten username.',
                      textAlign: TextAlign.start,
                      style: TextStyle(
                          color: Colors.textColorBlack,
                          fontSize: 16,
                          fontWeight: FontWeight.normal)),
                  SizedBox(height: 44),
                  StreamBuilder(
                    stream: viewModel.userRecoveryForm.accountNumberStream,
                    builder: (context, snapshot) {
                      return Styles.appEditText(
                          hint: 'Account Number',
                          inputFormats: [
                            LengthLimitingTextInputFormatter(10),
                            FilteringTextInputFormatter.digitsOnly
                          ],
                          animateHint: true,
                          onChanged: viewModel.userRecoveryForm.onAccountNumberChanged,
                          errorText: snapshot.hasError
                              ? snapshot.error.toString()
                              : null,
                          startIcon: Icon(CustomFont.bankIcon,
                              color: Colors.colorFaded));
                    },
                  ),
                  SizedBox(height: 16),
                  StreamBuilder(
                    stream: viewModel.userRecoveryForm.bvnStream,
                    builder: (context, snapshot) {
                      return Styles.appEditText(
                          hint: 'BVN',
                          inputFormats: [
                            LengthLimitingTextInputFormatter(11),
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
            StreamBuilder(
              stream: viewModel.userRecoveryForm.isValid,
              initialData: false,
              builder: (context, AsyncSnapshot<bool> snapshot) {
                return Stack(
                  children: [
                    SizedBox(
                      width: double.infinity,
                      child: Styles.appButton(
                          elevation: 0,
                          onClick:
                              (snapshot.hasData && snapshot.data == true) && !_isLoading
                                  ? subscribeUiToUsernameRecovery
                                  : null,
                          text: 'Submit'),
                    ),
                    Positioned(
                        right: 16,
                        top: 16,
                        bottom: 16,
                        child: _isLoading
                            ? SpinKitThreeBounce(
                                size: 20.0,
                                color: Colors.white.withOpacity(0.5))
                            : SizedBox())
                  ],
                );
              },
            ),
            SizedBox(height: 16)
          ],
        ),
      ),
    );
  }
}
