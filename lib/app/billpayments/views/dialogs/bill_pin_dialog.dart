import 'package:flutter/material.dart' hide Colors;
import 'package:moniepoint_flutter/app/billpayments/viewmodels/bill_purchase_view_model.dart';
import 'package:moniepoint_flutter/core/views/bottom_sheet.dart';
import 'package:moniepoint_flutter/core/colors.dart';
import 'package:moniepoint_flutter/core/models/transaction_status.dart';
import 'package:moniepoint_flutter/core/network/resource.dart';
import 'package:moniepoint_flutter/core/payment_view_model.dart';
import 'package:moniepoint_flutter/core/styles.dart';
import 'package:moniepoint_flutter/core/views/pin_entry.dart';
import 'package:moniepoint_flutter/core/views/transaction_pin_dialog.dart';
import 'package:provider/provider.dart';
import 'package:moniepoint_flutter/core/utils/currency_util.dart';

class BillPinDialog extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _BillPinDialog();
}

class _BillPinDialog extends TransactionPinDialogState<BillPinDialog> {

  bool _isLoading = false;

  bool _isPinValid(BillPurchaseViewModel viewModel) {
    return viewModel.pin.isNotEmpty == true && viewModel.pin.length == 4;
  }

  @override
  Widget build(BuildContext context) {
    final viewModel = Provider.of<BillPurchaseViewModel>(context, listen: false);
    final hasName = viewModel.beneficiary?.getAccountName().isNotEmpty == true;
    final beneficiaryName = hasName ? '- ${viewModel.beneficiary?.getAccountName()}' : "";
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
      content: Wrap(
        children: [
          Container(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 22),
                Center(
                  child: Text('Confirm Purchase',
                      style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.w600,
                          color: Colors.solidDarkBlue)),
                ),
                SizedBox(height: 24),
                Container(
                  color: Colors.colorPrimaryDark.withOpacity(0.05),
                  padding: EdgeInsets.all(18),
                  child: Column(
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Flexible(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text('Amount', style: TextStyle(color: Colors.solidDarkBlue, fontSize: 15)),
                                  SizedBox(height: 2,),
                                  Text(
                                      viewModel.amount!.formatCurrency,
                                      style: TextStyle(
                                          color: Colors.solidDarkBlue,
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold
                                      )
                                  ),
                                  SizedBox(height: 14,),
                                ],
                              )
                          ),
                          SizedBox(width: 4,),
                          Flexible(child: Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Text('Bill Product', style: TextStyle(color: Colors.solidDarkBlue, fontSize: 15)),
                              SizedBox(height: 2),
                              Container(
                                padding: EdgeInsets.symmetric(vertical: 1, horizontal: 0),
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(5),
                                    color: Colors.transparent
                                ),
                                child: Center(
                                  child: Text(
                                      "${viewModel.billerProduct?.name}",
                                      overflow: TextOverflow.ellipsis,
                                      style: TextStyle(
                                          color: Colors.solidDarkBlue,
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold
                                      )
                                  ),
                                ),
                              ),
                            ],
                          )),
                        ],
                      ),
                      Row(
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('Beneficiary', style: TextStyle(color: Colors.solidDarkBlue, fontSize: 15)),
                              SizedBox(height: 2,),
                              Text(
                                  "${viewModel.beneficiary!.getBeneficiaryDigits()} $beneficiaryName",
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                      color: Colors.solidDarkBlue,
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold
                                  )
                              ),
                            ],
                          )
                        ],
                      )
                    ],
                  ),
                ),
                SizedBox(height: 30),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 30),
                  child: Text('Enter Transaction PIN',
                      textAlign: TextAlign.start,
                      style: TextStyle(
                          color: Colors.deepGrey,
                          fontWeight: FontWeight.w600, fontSize: 15)),
                ),
                SizedBox(height: 8),
                Padding(
                  padding: EdgeInsets.only(left: 30, right: 30, bottom: MediaQuery.of(context).viewInsets.bottom * 0.7),
                  child: PinEntry(onChange: (value) {
                    setState(() {
                      viewModel.setPin(value);
                    });
                  }),
                ),
                SizedBox(height: 47),
                Container(
                    padding: EdgeInsets.only(left: 16, right: 16),
                    width: double.infinity,
                    child: Styles.statefulButton2(
                        elevation: _isPinValid(viewModel) ? 0.5 : 0,
                        isLoading: _isLoading,
                        isValid: _isPinValid(viewModel),
                        onClick: () => requestLocationAndSubscribe(),
                        text: 'Continue')),
                SizedBox(height: 42)
              ],
            ),
          )
        ],
      )
    );
  }

  @override
  PaymentViewModel getViewModel() {
    return Provider.of<BillPurchaseViewModel>(context, listen: false);
  }

  @override
  void subscribeUiToPayment() {
    final viewModel = Provider.of<BillPurchaseViewModel>(context, listen: false);
    viewModel.makePayment().listen((event) {
      if(event is Loading) setState(() => _isLoading = true);
      else if(event is Success) {
        setState(() {_isLoading = false;});
        Navigator.of(context).pop(event.data);
      }
      else if(event is Error<TransactionStatus>) {
        setState(() {_isLoading = false;});
        Navigator.of(context).pop(event);
      }
    });
  }

}