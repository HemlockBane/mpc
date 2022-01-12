import 'package:flutter/material.dart' hide Colors;
import 'package:moniepoint_flutter/app/usermanagement/viewmodels/change_pin_view_model.dart';
import 'package:moniepoint_flutter/core/colors.dart';
import 'package:moniepoint_flutter/core/network/resource.dart';
import 'package:moniepoint_flutter/core/styles.dart';
import 'package:moniepoint_flutter/core/utils/dialog_util.dart';
import 'package:moniepoint_flutter/core/views/pin_entry.dart';
import 'package:moniepoint_flutter/core/views/sessioned_widget.dart';
import 'package:provider/provider.dart';

///
///@author Paul Okeke
///
class ChangePinDialog extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _ChangePinDialog();
}

class _ChangePinDialog extends State<ChangePinDialog> {
  bool _isLoading = false;

  void subscribeUiToChangePin() {
    final viewModel = Provider.of<ChangePinViewModel>(context, listen: false);
    viewModel.changePin().listen((event) {
      if(event is Loading) setState(() => _isLoading = true);
      else if(event is Success) {
        setState(() => _isLoading = false);
        showSuccess(
            context,
            title: "Pin Changed",
            message: "Transaction PIN was updated successfully",
            onPrimaryClick: () {
              Navigator.of(context).pop();
            }
        );
      }
      else if(event is Error<bool>) {
        setState(() {_isLoading = false;});
        showError(
            context,
            title: "PIN Change Failed!",
            message: event.message
        );
      }
    });
  }

  Widget _changePinForm() {
    final viewModel = Provider.of<ChangePinViewModel>(context, listen: false);
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
                child: Text('Enter Current PIN',
                    textAlign: TextAlign.start,
                    style: TextStyle(
                        color: Color(0XFF4A4A4A),
                        fontWeight: FontWeight.w400, fontSize: 13
                    )),
              ),
              SizedBox(height: 8),
              StreamBuilder(
                  stream: viewModel.oldPinStream,
                  builder: (context, snapshot) {
                    return Padding(
                      padding: EdgeInsets.only(left: 20, right: 20),
                      child: PinEntry(onChange: viewModel.onOldPinChanged),
                    );
                  }),
              SizedBox(height: 24),
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
                      child: PinEntry(onChange: viewModel.onNewPinChanged),
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
                      onClick: () => subscribeUiToChangePin(),
                      text: 'Change Pin')),
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
                  "Change PIN",
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
                  "Customize your Moniepoint experience",
                  style: TextStyle(
                    color: Colors.textColorBlack.withOpacity(0.5),
                    fontWeight: FontWeight.w500,
                    fontSize: 12,
                  ),
                ),
              ),
              SizedBox(height: 21),
              _changePinForm()
            ],
          ),
        ),
      ),
    );
  }
}
