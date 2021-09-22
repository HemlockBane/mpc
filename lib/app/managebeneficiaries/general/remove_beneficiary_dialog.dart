import 'package:flutter/material.dart' hide Colors;
import 'package:flutter_svg/svg.dart';
import 'package:moniepoint_flutter/app/managebeneficiaries/beneficiary.dart';
import 'package:moniepoint_flutter/app/managebeneficiaries/general/remove_beneficiary_view_model.dart';
import 'package:moniepoint_flutter/app/managebeneficiaries/general/remove_beneificiary_pin_dialog.dart';
import 'package:moniepoint_flutter/core/views/bottom_sheet.dart';
import 'package:moniepoint_flutter/core/colors.dart';
import 'package:moniepoint_flutter/core/network/resource.dart';
import 'package:moniepoint_flutter/core/styles.dart';
import 'package:moniepoint_flutter/core/tuple.dart';
import 'package:moniepoint_flutter/core/extensions/text_utils.dart';
import 'package:provider/provider.dart';

enum BeneficiaryType {
  AIRTIME, BILL, TRANSFER
}

class RemoveBeneficiaryDialog extends StatefulWidget {

  final BeneficiaryType _beneficiaryType;
  final Beneficiary _beneficiary;

  RemoveBeneficiaryDialog(this._beneficiaryType, this._beneficiary);

  @override
  State<StatefulWidget> createState() => _RemoveBeneficiaryDialog();

}

class _RemoveBeneficiaryDialog extends State<RemoveBeneficiaryDialog> {

  bool _isLoading = false;
  bool _isCollapsedState = false;

  String getDialogTitle() {
    switch(widget._beneficiaryType) {
      case BeneficiaryType.AIRTIME:
        return "Airtime Beneficiary";
      case BeneficiaryType.BILL:
        return "Bill Beneficiary";
      case BeneficiaryType.TRANSFER:
        return "Transfer Beneficiary";
    }
  }

  String getDialogIcon() {
    switch(widget._beneficiaryType) {
      case BeneficiaryType.AIRTIME:
        return "res/drawables/ic_airtime_dialog.svg";
      case BeneficiaryType.BILL:
        return "res/drawables/ic_menu_bills.svg";
      case BeneficiaryType.TRANSFER:
        return "res/drawables/ic_menu_transfer.svg";
    }
  }

  void _subscribeUiToRemoveBeneficiary() async {
    final viewModel = Provider.of<RemoveBeneficiaryViewModel>(context, listen: false);
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
      viewModel.deleteBeneficiary(widget._beneficiary, pin, widget._beneficiaryType)
          .listen(_deleteBeneficiaryObserver);
    }
  }

  void _deleteBeneficiaryObserver(Resource<bool> event) {
    if(event is Loading) setState(() => _isLoading = true);
    else if(event is Success) {
      setState(() {
        _isLoading = false;
        Navigator.of(context).pop(event.data);
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
        centerImageRes: getDialogIcon(),
        centerImageHeight: 16,
        centerImageWidth: 16,
        centerBackgroundHeight: 74,
        centerBackgroundWidth: 74,
        centerBackgroundPadding: 24,
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
                    SvgPicture.asset('res/drawables/ic_beneficiary.svg'),
                    SizedBox(width: 12),
                    Text('${widget._beneficiary.getAccountName()}', style: TextStyle(color: Colors.solidDarkBlue, fontSize: 18, fontWeight: FontWeight.w600),)
                  ],
                ),
                SizedBox(height: 4),
                Text(
                  '${widget._beneficiary.getBeneficiaryProviderName()} - ${widget._beneficiary.getBeneficiaryDigits()}',
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.deepGrey, fontSize: 14, fontFamily: Styles.defaultFont),
                ).colorText({widget._beneficiary.getBeneficiaryDigits() : Tuple(Colors.deepGrey, null)}, underline: false),
                SizedBox(height: 64),
                Padding(
                    padding: EdgeInsets.only(left: 16, right: 16),
                    child: Styles.statefulButton2(
                        isValid: true,
                        isLoading: _isLoading,
                        buttonStyle: Styles.redButtonStyle2,
                        loadingColor: Colors.red,
                        onClick: _subscribeUiToRemoveBeneficiary,
                        text: "Remove Beneficiary"
                    ),
                ),
                SizedBox(height: 42),
              ],
            ),
          )
        ])));
  }
}
