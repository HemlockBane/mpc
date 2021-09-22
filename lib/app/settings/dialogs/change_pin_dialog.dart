import 'package:flutter/material.dart' hide Colors;
import 'package:moniepoint_flutter/app/usermanagement/viewmodels/change_pin_view_model.dart';
import 'package:moniepoint_flutter/core/views/bottom_sheet.dart';
import 'package:moniepoint_flutter/core/colors.dart';
import 'package:moniepoint_flutter/core/network/resource.dart';
import 'package:moniepoint_flutter/core/styles.dart';
import 'package:moniepoint_flutter/core/views/pin_entry.dart';
import 'package:provider/provider.dart';

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
        setState(() {
          _isLoading = false;
          Navigator.of(context).pop(event.data);
        });
      }
      else if(event is Error<bool>) {
        setState(() {_isLoading = false;});
        Navigator.of(context).pop(event);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final viewModel = Provider.of<ChangePinViewModel>(context, listen: false);

    return BottomSheets.makeAppBottomSheet(
        curveBackgroundColor: Colors.white,
        centerImageBackgroundColor: Colors.primaryColor.withOpacity(0.1),
        contentBackgroundColor: Colors.white,
        centerImageRes: 'res/drawables/ic_dialog_three_dots.svg',
        centerImageHeight: 18,
        centerImageWidth: 18,
        centerBackgroundHeight: 74,
        centerBackgroundWidth: 74,
        centerBackgroundPadding: 25,
        content: Wrap(children: [
          Container(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                SizedBox(height: 16,),
                Center(
                  child: Text('Change Pin',
                      style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.w600,
                          color: Colors.colorPrimaryDark)),
                ),
                SizedBox(height: 24),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 50),
                  child: Text('Enter Current PIN',
                      textAlign: TextAlign.start,
                      style: TextStyle(
                          color: Colors.colorPrimaryDark,
                          fontWeight: FontWeight.w600, fontSize: 15)),
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
                  padding: EdgeInsets.symmetric(horizontal: 50),
                  child: Text('Enter New PIN',
                      textAlign: TextAlign.start,
                      style: TextStyle(
                          color: Colors.colorPrimaryDark,
                          fontWeight: FontWeight.w600, fontSize: 15)),
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
        ])
    );
  }
}
