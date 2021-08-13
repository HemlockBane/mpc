
import 'package:flutter/material.dart' hide Colors;
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_svg/svg.dart';
import 'package:moniepoint_flutter/app/login/viewmodels/recovery_view_model.dart';
import 'package:moniepoint_flutter/core/bottom_sheet.dart';
import 'package:moniepoint_flutter/core/colors.dart';
import 'package:moniepoint_flutter/core/login_mode.dart';
import 'package:moniepoint_flutter/core/models/user_instance.dart';
import 'package:moniepoint_flutter/core/network/resource.dart';
import 'package:moniepoint_flutter/core/routes.dart';
import 'package:moniepoint_flutter/core/styles.dart';
import 'package:moniepoint_flutter/core/utils/dialog_util.dart';
import 'package:moniepoint_flutter/core/utils/preference_util.dart';
import 'package:provider/provider.dart';

class AddDeviceDialog extends StatefulWidget {
  late final GlobalKey<ScaffoldState> _scaffoldKey;
  late final String livelinessValidationKey;

  AddDeviceDialog(this._scaffoldKey, this.livelinessValidationKey);

  @override
  State<StatefulWidget> createState() {
    return _AddDeviceDialog();
  }
}

class _AddDeviceDialog extends State<AddDeviceDialog> {

  bool _isLoading = false;

  void _subscribeToAddDevice() {
    final viewModel = Provider.of<RecoveryViewModel>(context, listen: false);
    viewModel.registerDevice(widget.livelinessValidationKey).listen((event) {
      if(event is Loading) setState(() => _isLoading = true);
      if (event is Error<bool>) {
        setState(() => _isLoading = false);
        showError(
            widget._scaffoldKey.currentContext ?? context,
            message: event.message
        );
      }
      if(event is Success<bool>) {
        setState(() => _isLoading = false);
        Navigator.of(context).pop();
        Navigator.of(widget._scaffoldKey.currentContext ?? context)
            .popAndPushNamed(Routes.DASHBOARD);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return BottomSheets.makeAppBottomSheet2(
        curveBackgroundColor: Colors.white,
        centerImageBackgroundColor: Colors.solidGreen.withOpacity(0.1),
        contentBackgroundColor: Colors.white,
        centerBackgroundPadding: 12,
        dialogIcon: SvgPicture.asset('res/drawables/ic_circular_check_mark.svg', color: Colors.solidGreen, width: 40, height: 40,),
        content: Wrap(
          children: [
            Container(
              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
              child: Column(
                children: [
                  Text('Device Registered',
                      style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.textColorBlack)),
                  SizedBox(height: 16),
                  Container(
                    width: double.infinity,
                    padding: EdgeInsets.symmetric(horizontal: 24, vertical: 24),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(8)),
                        color: Colors.solidGreen.withOpacity(0.1)),
                    child: Text('Your device has been validated and registered successfully.',
                        maxLines: 3,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.normal,
                            color: Colors.darkBlue
                        ),
                        textAlign: TextAlign.center
                    ),
                  ),
                  SizedBox(height: 24),
                  Styles.statefulButton2(
                      isValid: true,
                      isLoading: _isLoading,
                      onClick: _subscribeToAddDevice,
                      text: 'Go to Login'
                  ),
                  SizedBox(height: 32)
                ],
              ),
            )
          ],
        )
    );
  }
}