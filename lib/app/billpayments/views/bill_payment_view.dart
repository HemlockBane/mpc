
import 'package:flutter/material.dart' hide Colors, ScrollView;
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:moniepoint_flutter/app/billpayments/model/data/biller_product.dart';
import 'package:moniepoint_flutter/app/billpayments/viewmodels/bill_purchase_view_model.dart';
import 'package:moniepoint_flutter/app/billpayments/views/bill_view.dart';
import 'package:moniepoint_flutter/app/billpayments/views/dialogs/bill_pin_dialog.dart';
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
import 'package:moniepoint_flutter/core/views/selected_transaction_recipient_view.dart';
import 'package:moniepoint_flutter/core/views/user_account_selection_view.dart';
import 'package:moniepoint_flutter/core/views/transaction_success_page.dart';
import 'package:provider/provider.dart';
import 'package:moniepoint_flutter/core/extensions/strings.dart';
import 'package:collection/collection.dart';

import '../../../main.dart';

class BillPaymentScreen extends StatefulWidget {

  late final GlobalKey<ScaffoldState> _scaffoldKey;

  BillPaymentScreen(this._scaffoldKey);

  @override
  State<StatefulWidget> createState() => _BillPaymentScreen();

}

class _BillPaymentScreen extends State<BillPaymentScreen> with AutomaticKeepAliveClientMixin {

  late final BillPurchaseViewModel viewModel;
  ListDataItem<String>? _selectedAmountPill;

  @override
  initState() {
    this.viewModel = Provider.of<BillPurchaseViewModel>(context, listen: false);
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
      style: TextStyle(
          color: Colors.textColorMainBlack,
          fontSize: 14,
          fontWeight: FontWeight.w500
      ),
    );
  }

  Widget amountWidget() {
    final isAmountFixed = viewModel.billerProduct != null && viewModel.billerProduct?.priceFixed == true;
    final amount = viewModel.amount ?? 0;
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 14, vertical: 26),
      decoration: BoxDecoration(
          color: Color(0XFF97AAC0).withOpacity(0.15),
          borderRadius: BorderRadius.all(Radius.circular(8))
      ),
      child: PaymentAmountView((amount * 100).toInt(), (value) => viewModel.setAmount(value / 100),
        isAmountFixed: isAmountFixed,
        currencyColor: Colors.white.withOpacity(0.5),
        textColor: Colors.textColorBlack,
      ),
    );
  }

  List<Widget> generateAmountPillsWidget() {
    final pills = <Widget>[];
    viewModel.amountPills.forEachIndexed((index, element) {
      pills.add(Expanded(flex: 1, child: AmountPill(item: element, position: index, listener: (ListDataItem<String> item, position){
        setState(() {
          _selectedAmountPill?.isSelected = false;
          _selectedAmountPill = item;
          _selectedAmountPill?.isSelected = true;
          final amount = double.parse(_selectedAmountPill!.item.replaceAll(RegExp(r'[(a-z)|(A-Z)|(,₦)]'), ""));
          viewModel.setAmount(amount);
        });
      })));
      if(index != viewModel.amountPills.length -1) pills.add(SizedBox(width: 8,));
    });
    return pills;
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

          navigatorKey.currentState?.push(MaterialPageRoute(builder: (mContext) {
            return TransactionSuccessPage(payload,
                onClick: () {
                  Navigator.of(mContext).pop();
                  Navigator.of(context, rootNavigator: true)
                      .pushNamedAndRemoveUntil(BillScreen.BENEFICIARY_SCREEN, (route) => false);
                });
          }));
        } else {
          showError(
              widget._scaffoldKey.currentContext ?? context,
              title: "Bill Payment Failed",
              message: "Unable to complete transaction at this time. Please try again later."
          );
        }

    } else if(result is Error<TransactionStatus>) {
      showError(
          widget._scaffoldKey.currentContext ?? context,
          title: "Bill Payment Failed",
          message: result.message ?? ""
      );
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
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(height: 16),
        Padding(
          padding: EdgeInsets.only(left: 20),
          child: Column(
            children: [
              Text(
                viewModel.biller?.name ?? "",
                style: TextStyle(
                    fontWeight: FontWeight.w700,
                    fontSize: 24,
                    color: Colors.textColorBlack
                ),
              ),
              Text(
                viewModel.billerCategory?.name ?? "",
                style: TextStyle(
                    fontWeight: FontWeight.w500,
                    fontSize: 13,
                    color: Colors.textColorBlack.withOpacity(0.5)
                ),
              )
            ],
          ),
        ),
        Expanded(
            child: Container(
              margin: EdgeInsets.only(top: 24),
              padding: EdgeInsets.only(top: 8),
              clipBehavior: Clip.hardEdge,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(topLeft: Radius.circular(30), topRight: Radius.circular(30)),
              ),
              child: ScrollView(
                child: Container(
                  padding: EdgeInsets.only(top: 37, left: 16, right: 16),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      makeLabel('Beneficiary'),
                      SizedBox(height: 8,),
                      SelectedTransactionRecipientView(
                        recipientName: '${viewModel.beneficiary?.getAccountName()}',
                        providerName: '${viewModel.beneficiary?.getBeneficiaryProviderName()}',
                        recipientDigits: '${viewModel.beneficiary?.getBeneficiaryDigits()}',
                      ),
                      SizedBox(height: 24,),
                      makeLabel('Purchase From'),
                      SizedBox(height: 8,),
                      UserAccountSelectionView(
                        viewModel,
                        selectedUserAccount: viewModel.sourceAccount,
                        onAccountSelected: (account) => setState(() {
                          viewModel.setSourceAccount(account);
                        }),
                      ),
                      SizedBox(height: 24,),
                      makeLabel('Amount'),
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
                                text: 'Make Payment'
                            ),
                          )
                      ),
                      SizedBox(height: 32,),
                    ],
                  ),
                ),
              ),
            )
        )
      ],
    );
  }

  @override
  bool get wantKeepAlive => true;

}