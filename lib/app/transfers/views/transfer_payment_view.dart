import 'package:flutter/material.dart' hide Colors, ScrollView;
import 'package:intl/intl.dart';
import 'package:moniepoint_flutter/app/transfers/viewmodels/transfer_view_model.dart';
import 'package:moniepoint_flutter/app/transfers/views/transfer_view.dart';
import 'package:moniepoint_flutter/core/routes.dart';
import 'package:moniepoint_flutter/core/views/amount_pill.dart';
import 'package:moniepoint_flutter/core/colors.dart';
import 'package:moniepoint_flutter/core/constants.dart';
import 'package:moniepoint_flutter/core/models/list_item.dart';
import 'package:moniepoint_flutter/core/models/transaction_status.dart';
import 'package:moniepoint_flutter/core/network/resource.dart';
import 'package:moniepoint_flutter/core/payment_view_model.dart';
import 'package:moniepoint_flutter/core/styles.dart';
import 'package:moniepoint_flutter/core/tuple.dart';
import 'package:moniepoint_flutter/core/utils/dialog_util.dart';
import 'package:moniepoint_flutter/core/views/payment_amount_view.dart';
import 'package:moniepoint_flutter/core/views/scroll_view.dart';
import 'package:moniepoint_flutter/core/views/transaction_account_source.dart';
import 'package:moniepoint_flutter/core/views/transaction_success_dialog.dart';
import 'package:provider/provider.dart';
import 'package:moniepoint_flutter/core/extensions/text_utils.dart';
import 'package:moniepoint_flutter/core/extensions/strings.dart';
import 'package:collection/collection.dart';
import 'package:moniepoint_flutter/core/utils/currency_util.dart';

import 'dialogs/transfer_pin_dialog.dart';


class TransferPaymentScreen extends StatefulWidget {

  late final GlobalKey<ScaffoldState> _scaffoldKey;
  final double defaultAmount;

  TransferPaymentScreen(this._scaffoldKey, this.defaultAmount);

  @override
  State<StatefulWidget> createState() => _TransferPaymentScreen();

}

class _TransferPaymentScreen extends State<TransferPaymentScreen> with AutomaticKeepAliveClientMixin {

  double _amount = 0.00;
  ListDataItem<String>? _selectedAmountPill;
  final List<ListDataItem<String>> amountPills = List.generate(4, (index) => ListDataItem((5000 * (index + 1)).formatCurrencyWithoutLeadingZero));

  @override
  initState() {
    this._amount = widget.defaultAmount;
    final viewModel = Provider.of<TransferViewModel>(context, listen: false);

    if (viewModel.userAccounts.length > 1) {
      viewModel.getUserAccountsBalance().listen((event) {});
    } else {
      viewModel.getCustomerAccountBalance().listen((event) { });
    }

    viewModel.reset();

    super.initState();

    if(widget.defaultAmount > 0) {
      Future.delayed(Duration(milliseconds: 50), () {
        viewModel.setAmount(this._amount);
      });
    }
  }

  Widget initialView(PaymentViewModel viewModel) {
    return Container(
      width: 37,
      height: 37,
      padding: EdgeInsets.all(6),
      decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: Colors.darkBlue.withOpacity(0.1)
      ),
      child: Center(
        child: Text(
            viewModel.beneficiary?.getAccountName().abbreviate(2, true) ?? "",
            textAlign: TextAlign.center,
            style: TextStyle(fontWeight: FontWeight.bold, color: Colors.solidDarkBlue, fontSize: 13)
        ),
      ),
    );
  }

  Widget makeLabel(String label) {
    return Text(
      label,
      style: TextStyle(color: Colors.deepGrey, fontSize: 14),
    );
  }

  //TODO make this function an accessible widget that is re-usable
  Widget boxContainer(Widget child) {
    return Container(
      padding: EdgeInsets.only(left: 16, right: 24, top: 12, bottom: 12),
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: Color(0XFF0B3175).withOpacity(0.1), width: 0.8, style: BorderStyle.solid),
          boxShadow: [
            BoxShadow(
                color: Color(0XFF0B3175).withOpacity(0.1),
                offset: Offset(0, 1),
                blurRadius: 1.2
            )
          ]
      ),
      child: child,
    );
  }

  Widget transferRecipient(PaymentViewModel viewModel) {
    final beneficiary = viewModel.beneficiary;
    return boxContainer(Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Flexible(flex:0, child: initialView(viewModel)),
            SizedBox(width: 17,),
            Expanded(
                flex: 1,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '${viewModel.beneficiary?.getAccountName()}',
                      overflow: TextOverflow.ellipsis,
                      maxLines: 1,
                      style: TextStyle(fontSize: 15, color: Colors.solidDarkBlue, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 1,),
                    Text(
                      '${beneficiary?.getBeneficiaryProviderName()} - ${beneficiary?.getBeneficiaryDigits()}',
                      textAlign: TextAlign.left,
                      style: TextStyle(color: Colors.deepGrey, fontSize: 13, fontFamily: Styles.defaultFont),
                    ).colorText({"${beneficiary?.getBeneficiaryDigits()}" : Tuple(Colors.deepGrey, null)}, underline: false)
                  ],
                )
            ),
            Expanded(
                flex: 0,
                child: TextButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: Text('Change',
                    style: TextStyle(color: Colors.solidOrange, fontSize: 14, fontWeight: FontWeight.bold),
                  ),
                  style: ButtonStyle(
                      minimumSize: MaterialStateProperty.all(Size(40, 0)),
                      tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      overlayColor: MaterialStateProperty.all(Colors.solidOrange.withOpacity(0.2)),
                      padding: MaterialStateProperty.all(EdgeInsets.symmetric(horizontal: 8, vertical: 7)),
                      shape: MaterialStateProperty.all(RoundedRectangleBorder(borderRadius: BorderRadius.circular(10))),
                      backgroundColor: MaterialStateProperty.all(Colors.solidOrange.withOpacity(0.2))
                  ),
                )
            )
          ],
        ));
  }

  Widget amountWidget() {
    final viewModel = Provider.of<TransferViewModel>(context, listen: false);
    print("Amount Widget with amount ${this._amount}");
    viewModel.setAmount(this._amount);
    return boxContainer(
      PaymentAmountView((_amount * 100).toInt(), (value) {
        this._amount = value / 100;
        viewModel.setAmount(this._amount);
      })
    );
  }

  List<Widget> generateAmountPillsWidget() {
    final pills = <Widget>[];
    amountPills.forEachIndexed((index, element) {
      pills.add(Expanded(flex: 1, child: AmountPill(element, index, (ListDataItem<String> item, position){
        setState(() {
          _selectedAmountPill?.isSelected = false;
          _selectedAmountPill = item;
          _selectedAmountPill?.isSelected = true;
          this._amount = double.parse(_selectedAmountPill!.item.replaceAll(RegExp(r'[(a-z)|(A-Z)|(,₦)]'), ""));
        });
      })));
      if(index != amountPills.length -1) pills.add(SizedBox(width: 8,));
    });
    return pills;
  }

  void subscribeUiToPin() async {
    final viewModel = Provider.of<TransferViewModel>(context, listen: false);
    viewModel.setPin("");
    dynamic result = await showModalBottomSheet(
        context: widget._scaffoldKey.currentContext ?? context,
        isScrollControlled: true,
        isDismissible: false,
        backgroundColor: Colors.transparent,
        builder: (context) => ChangeNotifierProvider.value(
          value: viewModel,
          child: TransferPinDialog(),
        ));

    if(result is TransactionStatus) {
        final isSuccessful = result.operationStatus == Constants.APPROVED
            || result.operationStatus == Constants.COMPLETED
            || result.operationStatus == Constants.PENDING
            || result.operationStatus == Constants.SUCCESSFUL;

        if(isSuccessful) {

          final payload = SuccessPayload(
              "Transfer Successful",
              "Your transfer was successful",
              fileName: "Transaction_Receipt_${viewModel.accountName}_${DateFormat("dd_MM_yyyy_h_m_s").format(DateTime.now())}.pdf",
              downloadTask: (result.transferBatchId != null && result.operationStatus != Constants.PENDING)
                  ? () => viewModel.downloadReceipt(result.transferBatchId!)
                  : null
          );

          showModalBottomSheet(
              context: widget._scaffoldKey.currentContext ?? context,
              isScrollControlled: true,
              enableDrag: false,
              isDismissible: false,
              backgroundColor: Colors.transparent,
              builder: (mContext) => TransactionSuccessDialog(
                payload, onClick: () {
                  Navigator.of(mContext).pop();
                  Navigator.of(context, rootNavigator: true)
                      .pushNamedAndRemoveUntil(Routes.DASHBOARD,  (route) => false, arguments: {});
                })
          );
        } else {
          showError(
              widget._scaffoldKey.currentContext ?? context,
              title: "Transfer Failed!",
              message: "Unable to complete transaction at this time. Please try again later."
          );
        }
    } else if(result is Error<TransactionStatus>) {
      showError(
          widget._scaffoldKey.currentContext ?? context,
          title: "Transfer Failed!",
          message: result.message
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    final viewModel = Provider.of<TransferViewModel>(context, listen: false);

    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: ScrollView(
        child: Container(
          color: Colors.backgroundWhite,
          padding: EdgeInsets.only(top: 37, left: 16, right: 16, bottom: 32),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              makeLabel('Transfer Recipient'),
              SizedBox(height: 8,),
              transferRecipient(viewModel),
              SizedBox(height: 24,),
              makeLabel('Transfer From'),
              SizedBox(height: 8,),
              TransactionAccountSource(viewModel),
              SizedBox(height: 24,),
              makeLabel('How much would you like to send ? '),
              SizedBox(height: 8,),
              amountWidget(),
              SizedBox(height: 16,),
              Expanded(flex:0,child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: generateAmountPillsWidget()
              )),
              SizedBox(height: 24,),
              makeLabel('Enter Narration'),
              SizedBox(height: 8,),
              Expanded(
                  flex: 0,
                  child: Styles.appEditText(
                      hint: 'Not more than 50 Characters',
                      animateHint: false,
                      hintSize: 13,
                      textInputAction: TextInputAction.done,
                      inputType: TextInputType.multiline,
                      maxLength: 50,
                      maxLines: null,
                      minLines: 3,
                      onChanged: (v) => viewModel.setNarration(v)
                  )
              ),
              SizedBox(height: 16),
              // Spacer(),
              Expanded(
                  flex: 1,
                  child: Align(
                    alignment: Alignment.bottomCenter,
                    child: Styles.statefulButton(
                        stream: viewModel.isValid,
                        onClick: subscribeUiToPin,
                        text: 'Continue'
                    ),
                  )
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;

}