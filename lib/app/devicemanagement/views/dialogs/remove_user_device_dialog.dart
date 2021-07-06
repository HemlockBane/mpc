import 'package:flutter/material.dart' hide Colors;
import 'package:flutter_svg/svg.dart';
import 'package:moniepoint_flutter/app/devicemanagement/model/data/user_device.dart';
import 'package:moniepoint_flutter/app/devicemanagement/viewmodels/user_device_view_model.dart';
import 'package:moniepoint_flutter/app/managebeneficiaries/beneficiary.dart';
import 'package:moniepoint_flutter/app/managebeneficiaries/general/remove_beneficiary_view_model.dart';
import 'package:moniepoint_flutter/app/managebeneficiaries/general/remove_beneificiary_pin_dialog.dart';
import 'package:moniepoint_flutter/core/bottom_sheet.dart';
import 'package:moniepoint_flutter/core/colors.dart';
import 'package:moniepoint_flutter/core/network/resource.dart';
import 'package:moniepoint_flutter/core/styles.dart';
import 'package:moniepoint_flutter/core/tuple.dart';
import 'package:moniepoint_flutter/core/utils/text_utils.dart';
import 'package:provider/provider.dart';


class RemoveUserDeviceDialog extends StatefulWidget {

  final UserDevice _userDevice;

  RemoveUserDeviceDialog(this._userDevice);

  @override
  State<StatefulWidget> createState() => _RemoveUserDeviceDialog();

}

class _RemoveUserDeviceDialog extends State<RemoveUserDeviceDialog> {

  bool _isLoading = false;
  bool _isCollapsedState = false;

  String getDialogTitle() {
    return "Registered Device";
  }

  Widget getDeviceIcon(String? os) {
    if (os != null && os.toLowerCase() == "android") {
      return SvgPicture.asset("res/drawables/ic_android.svg", color: Colors.primaryColor,);
    } else if (os != null && os.toLowerCase() == "ios") {
      return SvgPicture.asset("res/drawables/ic_ios.svg", color: Colors.primaryColor);
    }
    return SvgPicture.asset("res/drawables/ic_edit_device.svg", width: 20,
        height: 20,
        color: Colors.deepGrey.withOpacity(1));
  }

  void _subscribeUiToRemoveUserDevice() async {
    final viewModel = Provider.of<UserDeviceViewModel>(context, listen: false);
    setState(() {
      _isCollapsedState = true;
    });

    final pin = await showModalBottomSheet(
        backgroundColor: Colors.transparent,
        isScrollControlled: true,
        context: context,
        builder: (mContext) {
          return RemoveBeneficiaryPinDialog();
        }
    );

    setState(() {
      _isCollapsedState = false;
    });
    if(pin != null && pin is String) {
      viewModel.deleteUserDevice(widget._userDevice, pin)
          .listen(_deleteUserDeviceObserver);
    }
  }

  void _deleteUserDeviceObserver(Resource<bool> event) {
    if(event is Loading) setState(() => _isLoading = true);
    else if(event is Success) {
      setState(() {
        _isLoading = false;
        Navigator.of(context).pop(true);
        //Display SuccessDialog
      });
    }
    else if(event is Error<bool>) {
      setState(() {_isLoading = false;});
      Navigator.of(context).pop(event);
    }
  }

  @override
  Widget build(BuildContext context) {
    return BottomSheets.makeAppBottomSheet(
        height: _isCollapsedState ? 200 : null,
        curveBackgroundColor: Colors.white,
        centerImageBackgroundColor: Colors.primaryColor.withOpacity(0.1),
        contentBackgroundColor: Colors.white,
        centerImageRes: 'res/drawables/ic_edit_device.svg',
        content: SafeArea(child: Wrap(children: [
          Container(
            child: Column(
              children: [
                SizedBox(
                  height: 16,
                ),
                Center(
                  child: Text(
                      getDialogTitle(),
                      style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.w600,
                          color: Colors.colorPrimaryDark)),
                ),
                SizedBox(height: 64),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    getDeviceIcon(widget._userDevice.os),
                    SizedBox(width: 12),
                    Text('${widget._userDevice.name ?? ""}', style: TextStyle(color: Colors.solidDarkBlue, fontSize: 18, fontWeight: FontWeight.w600),)
                  ],
                ),
                SizedBox(height: 4),
                Text(
                  '${widget._userDevice.os ?? ""}',
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.deepGrey, fontSize: 14, fontFamily: Styles.defaultFont, fontWeight: FontWeight.w600),
                ),
                SizedBox(height: 64),
                Padding(
                    padding: EdgeInsets.only(left: 16, right: 16),
                    child: Styles.statefulButton2(
                        isValid: true,
                        isLoading: _isLoading,
                        buttonStyle: Styles.redButtonStyle2,
                        loadingColor: Colors.red,
                        onClick: _subscribeUiToRemoveUserDevice,
                        text: "Remove Device"
                    ),
                ),
                SizedBox(height: 42),
              ],
            ),
          )
        ])));
  }
}
