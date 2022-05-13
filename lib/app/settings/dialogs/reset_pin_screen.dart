import 'package:flutter/material.dart' hide Colors;
import 'package:moniepoint_flutter/app/usermanagement/model/data/reset_pin_response.dart';
import 'package:moniepoint_flutter/app/usermanagement/viewmodels/reset_pin_view_model.dart';
import 'package:moniepoint_flutter/core/colors.dart';
import 'package:moniepoint_flutter/core/utils/dialog_util.dart';
import 'package:provider/provider.dart';

import '../../../core/network/resource.dart';
import '../../../core/styles.dart';
import '../../../core/views/pin_entry.dart';
import '../../../core/views/sessioned_widget.dart';

class ResetPinScreen extends StatefulWidget {

  @override
  State<StatefulWidget> createState() => _ResetPinScreenState();

}

class _ResetPinScreenState extends State<ResetPinScreen> {

  _ResetPinScreenState();

  bool _isLoading = false;

  void subscribeUiToResetPin() {
    final viewModel = Provider.of<ResetPinViewModel>(context, listen: false);
    viewModel.resetPin().listen((event) {
      if(event is Loading) setState(() => _isLoading = true);
      else if(event is Success) {
        setState(() => _isLoading = false);
        showSuccess(
            context,
            title: "Pin Reset",
            message: "Transaction PIN was reset successfully",
            onPrimaryClick: () {
              Navigator.of(context).pop();
            }
        );
      }
      else if(event is Error<ResetPINResponse?>) {
        setState(() {_isLoading = false;});
        showError(
            context,
            title: "PIN Reset Failed!",
            message: event.message
        );
      }
    });
  }

  Widget _resetPinForm() {
    final viewModel = Provider.of<ResetPinViewModel>(context, listen: false);
    return Expanded(
        child: Container(
          width: double.infinity,
          height: double.infinity,
          padding: EdgeInsets.only(top: 6),
          decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(30), topRight: Radius.circular(30)
              )
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 21),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 19),
                child: Text('Enter New PIN',
                    textAlign: TextAlign.start,
                    style: TextStyle(
                        color: Color(0XFF4A4A4A),
                        fontWeight: FontWeight.w400, fontSize: 13
                    )),
              ),
              SizedBox(height: 8),
              StreamBuilder(
                  stream: viewModel.newPinStream,
                  builder: (context, snapshot) {
                    return Padding(
                      padding: EdgeInsets.only(left: 20, right: 20, bottom: MediaQuery.of(context).viewInsets.bottom * 0.6),
                      child: PinEntry(onChange: viewModel.onPinChanged),
                    );
                  }),
              SizedBox(height: 32),
              Spacer(),
              Container(
                  padding: EdgeInsets.only(left: 16, right: 16),
                  width: double.infinity,
                  child: Styles.statefulButton(
                      stream: viewModel.isValid,
                      elevation: 0.5,
                      isLoading: _isLoading,
                      onClick: () => subscribeUiToResetPin(),
                      text: 'Reset Pin')),
              SizedBox(height: 42)
            ],
          ),
        )
    );
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      extendBodyBehindAppBar: true,
      appBar: AppBar(
          centerTitle: false,
          titleSpacing: 0,
          iconTheme: IconThemeData(color: Colors.primaryColor),
          title: Text('Settings',
              textAlign: TextAlign.start,
              style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                  color: Colors.textColorBlack
              )
          ),
          backgroundColor: Colors.backgroundWhite.withOpacity(0.05),
          elevation: 0
      ),
      body: SessionedWidget(
        context: context,
        child: Container(
          padding: EdgeInsets.only(top: 120),
          decoration: BoxDecoration(
              color: Colors.backgroundWhite,
              image: DecorationImage(
                  fit: BoxFit.cover,
                  image: AssetImage("res/drawables/ic_app_new_bg.png")
              )
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Padding(
                padding: EdgeInsets.only(left: 16),
                child: Text(
                  "Reset PIN",
                  style: TextStyle(
                      color: Colors.textColorBlack,
                      fontSize: 24,
                      fontWeight: FontWeight.w700
                  ),
                ),
              ),
              SizedBox(height: 2),
              Padding(
                padding: EdgeInsets.only(left: 16),
                child: Text(
                  "Reset your transaction pin",
                  style: TextStyle(
                    color: Colors.textColorBlack.withOpacity(0.5),
                    fontWeight: FontWeight.w500,
                    fontSize: 12,
                  ),
                ),
              ),
              SizedBox(height: 21),
              _resetPinForm()
            ],
          ),
        ),
      ),
    );
  }
}