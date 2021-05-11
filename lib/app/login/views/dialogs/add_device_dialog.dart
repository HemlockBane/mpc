
import 'package:flutter/material.dart' hide Colors;
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:moniepoint_flutter/app/login/viewmodels/recovery_view_model.dart';
import 'package:moniepoint_flutter/core/bottom_sheet.dart';
import 'package:moniepoint_flutter/core/colors.dart';
import 'package:moniepoint_flutter/core/models/user_instance.dart';
import 'package:moniepoint_flutter/core/network/resource.dart';
import 'package:moniepoint_flutter/core/routes.dart';
import 'package:moniepoint_flutter/core/styles.dart';
import 'package:provider/provider.dart';

class AddDeviceDialog extends StatefulWidget {
  late final GlobalKey<ScaffoldState> _scaffoldKey;

  AddDeviceDialog(this._scaffoldKey);

  @override
  State<StatefulWidget> createState() {
    return _AddDeviceDialog();
  }
}

class _AddDeviceDialog extends State<AddDeviceDialog> {

  bool _isLoading = false;

  void _subscribeToAddDevice() {
    final viewModel = Provider.of<RecoveryViewModel>(context, listen: false);
    viewModel.editDevice().listen((event) {
      if(event is Loading) setState(() => _isLoading = true);
      if (event is Error<bool>) {
        setState(() => _isLoading = false);
        showModalBottomSheet(
            context: widget._scaffoldKey.currentContext ?? context,
            isScrollControlled: true,
            backgroundColor: Colors.transparent,
            builder: (context) {
              return BottomSheets.displayErrorModal(context, message: event.message);
            });
      }
      if(event is Success<bool>) {
        setState(() => _isLoading = false);
        Navigator.pop(context);
        Navigator.of(widget._scaffoldKey.currentContext ?? context)
            .pop();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    bool isAddDevice = UserInstance().getUser()?.securityFlags?.addDevice ?? false;

    return BottomSheets.makeAppBottomSheet(
        curveBackgroundColor: Colors.white,
        centerImageBackgroundColor: Colors.primaryColor.withOpacity(0.1),
        contentBackgroundColor: Colors.white,
        centerImageRes: 'res/drawables/ic_edit_device.svg',
        content: Wrap(
          children: [
            Container(
              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
              child: Column(
                children: [
                  Text('Register Device',
                      style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.darkBlue)),
                  SizedBox(height: 16),
                  Container(
                    width: double.infinity,
                    padding: EdgeInsets.symmetric(horizontal: 24, vertical: 24),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(8)),
                        color: Colors.primaryColor.withOpacity(0.1)),
                    child: Text('Your account has been validated successfully. Do you want to permanently add this device to your current device(s)?',
                        maxLines: 3,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.normal,
                            color: Colors.darkBlue),
                        textAlign: TextAlign.center),
                  ),
                  SizedBox(height: 24),
                  Stack(
                    children: [
                      SizedBox(
                          width: double.infinity,
                          child: Styles.appButton(
                            onClick: _isLoading ? null :_subscribeToAddDevice,
                            text: isAddDevice ? 'Yes, add device' : 'Yes, change device',
                          )),
                      Positioned(
                          right: 16,
                          top: 16,
                          bottom: 16,
                          child: _isLoading
                              ? SpinKitThreeBounce(size: 20.0, color: Colors.white.withOpacity(0.5))
                              : SizedBox())
                    ],
                  ),
                  SizedBox(height: 32),
                  TextButton(
                      onPressed: () {
                        Navigator.pop(context);
                        Navigator.of(widget._scaffoldKey.currentContext ?? context)
                            .pop(Routes.DASHBOARD);
                      },
                      child: Text(
                        'No, one-time login',
                        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 17, color: Colors.primaryColor)
                      )
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