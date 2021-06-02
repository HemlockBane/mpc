import 'package:flutter/material.dart' hide Colors;
import 'package:moniepoint_flutter/app/login/views/recovery/recovery_controller_screen.dart';
import 'package:moniepoint_flutter/core/bottom_sheet.dart';
import 'package:moniepoint_flutter/core/colors.dart';
import 'package:moniepoint_flutter/core/routes.dart';
import 'package:moniepoint_flutter/core/styles.dart';

class UnRecognizedDeviceDialog extends StatelessWidget {

  final VoidCallback _callback;

  UnRecognizedDeviceDialog(this._callback);

  @override
  Widget build(BuildContext context) {
    return BottomSheets.makeAppBottomSheet(
        curveBackgroundColor: Colors.solidYellow,
        centerImageBackgroundColor: Colors.white,
        contentBackgroundColor: Colors.solidYellow,
        centerImageRes: 'res/drawables/ic_warning.svg',
        content: Wrap(
          children: [
            Container(
              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
              child: Column(
                children: [
                  Text('Device Not Recognized',
                      style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.white)),
                  SizedBox(height: 16),
                  Container(
                    width: double.infinity,
                    padding: EdgeInsets.symmetric(horizontal: 24, vertical: 24),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(8)),
                        color: Colors.solidDarkYellow),
                    child: Text('Your login was successful, but this device is not recognized.',
                        maxLines: 3,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.normal,
                            color: Colors.white),
                        textAlign: TextAlign.center),
                  ),
                  SizedBox(height: 21),
                  SizedBox(
                      width: double.infinity,
                      child: Styles.appButton(
                          elevation: 0.5,
                          onClick: () async {
                            final r = await Navigator.of(context).pushNamed(Routes.ACCOUNT_RECOVERY, arguments: RecoveryMode.DEVICE);
                            _callback.call();
                          },
                          text: 'Register Device',
                          buttonStyle: Styles.whiteButtonStyle.copyWith(foregroundColor: MaterialStateProperty.all(Colors.solidYellow))
                      )),
                  SizedBox(height: 64)
                ],
              ),
            )
          ],
        )
    );
  }

}