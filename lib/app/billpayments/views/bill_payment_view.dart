
import 'package:flutter/material.dart' hide Colors, ScrollView;
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';
import 'package:moniepoint_flutter/app/accounts/model/data/account_balance.dart';
import 'package:moniepoint_flutter/app/billpayments/model/data/biller_product.dart';
import 'package:moniepoint_flutter/app/billpayments/viewmodels/bill_purchase_view_model.dart';
import 'package:moniepoint_flutter/app/billpayments/views/bill_view.dart';
import 'package:moniepoint_flutter/app/billpayments/views/dialogs/bill_pin_dialog.dart';
import 'package:moniepoint_flutter/core/amount_pill.dart';
import 'package:moniepoint_flutter/core/bottom_sheet.dart';
import 'package:moniepoint_flutter/core/colors.dart';
import 'package:moniepoint_flutter/core/constants.dart';
import 'package:moniepoint_flutter/core/models/list_item.dart';
import 'package:moniepoint_flutter/core/models/transaction_status.dart';
import 'package:moniepoint_flutter/core/network/resource.dart';
import 'package:moniepoint_flutter/core/payment_view_model.dart';
import 'package:moniepoint_flutter/core/styles.dart';
import 'package:moniepoint_flutter/core/tuple.dart';
import 'package:moniepoint_flutter/core/utils/dialog_util.dart';
import 'package:moniepoint_flutter/core/viewmodels/base_view_model.dart';
import 'package:moniepoint_flutter/core/views/payment_amount_view.dart';
import 'package:moniepoint_flutter/core/views/scroll_view.dart';
import 'package:moniepoint_flutter/core/views/transaction_account_source.dart';
import 'package:moniepoint_flutter/core/views/transaction_success_dialog.dart';
import 'package:provider/provider.dart';
import 'package:moniepoint_flutter/core/utils/text_utils.dart';
import 'package:moniepoint_flutter/core/strings.dart';
import 'package:collection/collection.dart';
import 'package:moniepoint_flutter/core/utils/currency_util.dart';


class BillPaymentScreen extends StatefulWidget {

  late final GlobalKey<ScaffoldState> _scaffoldKey;

  BillPaymentScreen(this._scaffoldKey);

  @override
  State<StatefulWidget> createState() => _BillPaymentScreen();

}

class _BillPaymentScreen extends State<BillPaymentScreen> with AutomaticKeepAliveClientMixin {

  double _amount = 0.00;
  ListDataItem<String>? _selectedAmountPill;
  final List<ListDataItem<String>> amountPills = List.generate(4, (index) => ListDataItem((5000 * (index + 1)).formatCurrencyWithoutLeadingZero));

  @override
  initState() {
    final viewModel = Provider.of<BillPurchaseViewModel>(context, listen: false);

    if(viewModel.userAccounts.length > 1)
      viewModel.getUserAccountsBalance().listen((event) { });
    else
      viewModel.getCustomerAccountBalance().listen((event) { });

    super.initState();
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

  Widget boxContainer(Widget child)  {
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
    final viewModel = Provider.of<BillPurchaseViewModel>(context, listen: false);
    final isAmountFixed = viewModel.billerProduct != null && viewModel.billerProduct?.priceFixed == true;
    this._amount = isAmountFixed ? (viewModel.billerProduct?.amount ?? 0) / 100 : this._amount;
    viewModel.setAmount(this._amount);
    return boxContainer(
      PaymentAmountView((_amount * 100).toInt(), (value) {
        this._amount = value / 100;
        viewModel.setAmount(this._amount);
      }, isAmountFixed: isAmountFixed)
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

  void _displayPaymentError(String message) {
    showError(widget._scaffoldKey.currentContext ?? context, message: message);
  }

  void subscribeUiToPin() async {
    final viewModel = Provider.of<BillPurchaseViewModel>(context, listen: false);
    dynamic result = await showModalBottomSheet(
        context: widget._scaffoldKey.currentContext ?? context,
        isScrollControlled: true,
        backgroundColor: Colors.transparent,
        builder: (context) => ChangeNotifierProvider.value(
          value: viewModel,
          child: BillPinDialog(),
        ));

    if(result is TransactionStatus) {
        final isSuccessful = result.operationStatus == Constants.APPROVED
            || result.operationStatus == Constants.COMPLETED
            || result.operationStatus == Constants.PENDING
            || result.operationStatus == Constants.SUCCESSFUL;

        if(isSuccessful) {
          final payload = SuccessPayload("Payment Successful",
              "Your payment was successful",
              token: result.token,
              fileName: "Bill_Receipt_${viewModel.accountName}_${DateFormat("dd MM yyyy").format(DateTime.now())}.pdf",
              downloadTask: (result.customerBillId != null && result.operationStatus != Constants.PENDING)
                  ? () => viewModel.downloadReceipt(result.customerBillId!)
                  : null
          );

          showModalBottomSheet(
              context: widget._scaffoldKey.currentContext ?? context,
              isScrollControlled: true,
              backgroundColor: Colors.transparent,
              builder: (mContext) => TransactionSuccessDialog(
                  payload, onClick: () {
                Navigator.of(mContext).pop();
                Navigator.of(context).pushNamedAndRemoveUntil(BillScreen.BENEFICIARY_SCREEN, (route) => false);
              })
          );
        } else {
          _displayPaymentError(result.message ?? "Unable to complete transaction at this time. Please try again later.");
        }

    } else if(result is Error<TransactionStatus>) {
      _displayPaymentError(result.message ?? "");
    }
  }

  List<Widget> _buildAdditionalFields(BillPurchaseViewModel viewModel) {
    List<InputField> fieldList = [];
    final additionalFields = viewModel.billerProduct?.additionalFieldsMap;
    if(additionalFields == null) return [];

    additionalFields.forEach((key, value) {
      value.key = key;
      value.fieldLabel = key.split(RegExp(r"(?=(?!^)[A-Z])")).map((e) => e.capitalizeFirstOfEach).join(" ");
      if(!value.required) value.fieldLabel = "${value.fieldLabel} (Optional)";
      fieldList.add(value);
    });

    fieldList = fieldList.whereNot((element) => element.key == "amount")
        .sortedByCompare((element) => element.required, (a, b) {
          if(a == true && b == false) return 1;
          if(a == false && b == true) return -1;
          return 0;
    }).toList();

    return fieldList.map((e) {
      final List<TextInputFormatter> inputFormatter = []..add(
          ((e.dataType == "NUMBER"))
              ? FilteringTextInputFormatter.digitsOnly
              : FilteringTextInputFormatter.singleLineFormatter);

      String? _previousError = viewModel.getFieldErrorForKey(e.key ?? "");

      return Container(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            makeLabel(e.fieldLabel ?? ""),
            SizedBox(height: 8),
            StreamBuilder(
                stream: viewModel.fieldErrorStream,
                builder: (mContext, AsyncSnapshot<Tuple<String, String?>> snapshot) {
                  //if the error event emitted belongs to this input we simply assign it to
                  //_previousError variable for the current scope of the field
                  //this will enable us keep track and maintain error for a particular key
                  if(snapshot.hasError) {
                    final error = snapshot.error as Tuple<String, String?>;
                    _previousError = (error.first == e.key) ? error.second : _previousError;
                  }
                  return Styles.appEditText(
                      errorText: (_previousError != null && _previousError?.isEmpty == true) ? null : _previousError,
                      maxLength: e.maximumLength?.toInt() ?? null,
                      inputFormats: inputFormatter,
                      textInputAction: TextInputAction.done,
                      animateHint: false,
                      hint: e.fieldLabel,
                      maxLines: 1,
                      fontSize: 13.4,
                      inputType: (e.dataType == "NUMBER") ? TextInputType.numberWithOptions() : TextInputType.text,
                      onChanged: (value) => _onAdditionalFieldInputChange(viewModel, e, value)
                  );
                }
            )
          ],
        ),
      );
    }).foldIndexed(<Widget>[], (index, List<Widget> previous, element) {
      previous.add(element);
      if(index < fieldList.length - 1) previous.add(SizedBox(height: 16,));
      return previous;
    }).toList();
  }

  void _onAdditionalFieldInputChange(BillPurchaseViewModel viewModel, InputField field, String? value) {
    viewModel.setAdditionalFieldData(field.key!, value ?? "");
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    final viewModel = Provider.of<BillPurchaseViewModel>(context, listen: false);
    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: ScrollView(
        child: Container(
          color: Colors.backgroundWhite,
          padding: EdgeInsets.only(top: 37, left: 16, right: 16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              makeLabel('Bill Payment Recipient'),
              SizedBox(height: 8,),
              transferRecipient(viewModel),
              SizedBox(height: 24,),
              makeLabel('Purchase From'),
              SizedBox(height: 8,),
              TransactionAccountSource(viewModel),
              SizedBox(height: 24,),
              makeLabel('How much would you like to purchase? '),
              SizedBox(height: 8,),
              amountWidget(),
              SizedBox(height: viewModel.billerProduct?.priceFixed == true ? 0 : 16,),
              Visibility(
                  visible: viewModel.billerProduct?.priceFixed != true,
                  child: Expanded(flex:0,child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: generateAmountPillsWidget()
                  ))
              ),
              SizedBox(height: 24),
              ..._buildAdditionalFields(viewModel),
              SizedBox(height: 16),
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
              SizedBox(height: 32,),
            ],
          ),
        ),
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;

}