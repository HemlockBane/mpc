
import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart' hide Colors, ScrollView;
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';
import 'package:moniepoint_flutter/app/accounts/model/data/account_balance.dart';
import 'package:moniepoint_flutter/app/airtime/model/data/airtime_purchase_type.dart';
import 'package:moniepoint_flutter/app/airtime/model/data/airtime_service_provider_item.dart';
import 'package:moniepoint_flutter/app/airtime/viewmodels/airtime_view_model.dart';
import 'package:moniepoint_flutter/app/airtime/views/dialogs/airtime_pin_dialog.dart';
import 'package:moniepoint_flutter/app/airtime/views/selection_combo.dart';
import 'package:moniepoint_flutter/app/managebeneficiaries/airtime/model/data/airtime_beneficiary.dart';
import 'package:moniepoint_flutter/core/amount_pill.dart';
import 'package:moniepoint_flutter/core/bottom_sheet.dart';
import 'package:moniepoint_flutter/core/colors.dart';
import 'package:moniepoint_flutter/core/constants.dart';
import 'package:moniepoint_flutter/core/models/file_result.dart';
import 'package:moniepoint_flutter/core/models/list_item.dart';
import 'package:moniepoint_flutter/core/models/transaction_status.dart';
import 'package:moniepoint_flutter/core/network/resource.dart';
import 'package:moniepoint_flutter/core/payment_view_model.dart';
import 'package:moniepoint_flutter/core/styles.dart';
import 'package:moniepoint_flutter/core/tuple.dart';
import 'package:moniepoint_flutter/core/viewmodels/base_view_model.dart';
import 'package:moniepoint_flutter/core/views/payment_amount_view.dart';
import 'package:moniepoint_flutter/core/views/scroll_view.dart';
import 'package:moniepoint_flutter/core/views/selection_combo_two.dart';
import 'package:moniepoint_flutter/core/views/transaction_account_source.dart';
import 'package:moniepoint_flutter/core/views/transaction_success_dialog.dart';
import 'package:provider/provider.dart';
import 'package:moniepoint_flutter/core/utils/text_utils.dart';
import 'package:moniepoint_flutter/core/strings.dart';
import 'package:collection/collection.dart';
import 'package:moniepoint_flutter/core/utils/currency_util.dart';

import 'airtime_view.dart';



class AirtimePaymentScreen extends StatefulWidget {

  late final GlobalKey<ScaffoldState> _scaffoldKey;

  AirtimePaymentScreen(this._scaffoldKey);

  @override
  State<StatefulWidget> createState() => _AirtimePaymentScreen();

}

class _AirtimePaymentScreen extends State<AirtimePaymentScreen> with AutomaticKeepAliveClientMixin {

  double _amount = 0.00;
  ListDataItem<String>? _selectedAmountPill;
  Stream<Resource<List<AirtimeServiceProviderItem>>>? dataPlanStream;
  Image? _providerLogo;

  final List<ListDataItem<String>> amountPills = List.of([
    ListDataItem(100.formatCurrencyWithoutLeadingZero),
    ListDataItem(200.formatCurrencyWithoutLeadingZero),
    ListDataItem(500.formatCurrencyWithoutLeadingZero),
    ListDataItem(1000.formatCurrencyWithoutLeadingZero),
  ]);

  @override
  initState() {
    final viewModel = Provider.of<AirtimeViewModel>(context, listen: false);
    if(viewModel.userAccounts.length > 0)
      viewModel.getUserAccountsBalance().listen((event) { });
    else viewModel.getCustomerAccountBalance();

    viewModel.setServiceProviderItem(null);
    viewModel.setSourceAccount(null);

    this.dataPlanStream = viewModel.getServiceProviderItems(
        (viewModel.beneficiary as AirtimeBeneficiary).serviceProvider!
            .billerId!);
    super.initState();
  }

  Widget initialView(PaymentViewModel viewModel) {
    return Container(
      width: 37.3,
      height: 37.3,
      padding: EdgeInsets.all(4),
      decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: Colors.darkBlue.withOpacity(0.1)
      ),
      child: Center(
        child: Text(
            viewModel.beneficiary?.getAccountName().abbreviate(2, true) ?? "",
            textAlign: TextAlign.center,
            style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.solidDarkBlue,
                fontSize: 13
            )
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

  Widget boxContainer(Widget child) {
    return Container(
      padding: EdgeInsets.only(left: 16, right: 24, top: 12, bottom: 12),
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: Color(0XFF0B3175).withOpacity(0.1),
              width: 0.8,
              style: BorderStyle.solid),
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

  String displayableBeneficiaryName(PaymentViewModel viewModel) {
    String? accountName = viewModel.beneficiary?.getAccountName();
    if (accountName == null || accountName.isEmpty) {
      return viewModel.beneficiary?.getBeneficiaryDigits() ?? "";
    }
    return viewModel.beneficiary?.getAccountName() ?? "";
  }

  Widget transferRecipient(PaymentViewModel viewModel) {
    final beneficiary = viewModel.beneficiary;
    return boxContainer(Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Flexible(flex: 0, child: initialView(viewModel)),
        SizedBox(width: 17,),
        Expanded(
            flex: 1,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  displayableBeneficiaryName(viewModel),
                  overflow: TextOverflow.ellipsis,
                  maxLines: 1,
                  style: TextStyle(fontSize: 15,
                      color: Colors.solidDarkBlue,
                      fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 1,),
                Text(
                  '${beneficiary?.getBeneficiaryProviderName()} - ${beneficiary
                      ?.getBeneficiaryDigits()}',
                  textAlign: TextAlign.left,
                  style: TextStyle(color: Colors.deepGrey,
                      fontSize: 13,
                      fontFamily: Styles.defaultFont),
                ).colorText({
                  "${beneficiary?.getBeneficiaryDigits()}": Tuple(
                      Colors.deepGrey, null)
                }, underline: false)
              ],
            )
        ),
        Expanded(
            flex: 0,
            child: TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text('Change',
                style: TextStyle(color: Colors.solidOrange,
                    fontSize: 14,
                    fontWeight: FontWeight.bold),
              ),
              style: ButtonStyle(
                  minimumSize: MaterialStateProperty.all(Size(40, 0)),
                  tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  overlayColor: MaterialStateProperty.all(
                      Colors.solidOrange.withOpacity(0.2)),
                  padding: MaterialStateProperty.all(
                      EdgeInsets.symmetric(horizontal: 8, vertical: 7)),
                  shape: MaterialStateProperty.all(RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10))),
                  backgroundColor: MaterialStateProperty.all(
                      Colors.solidOrange.withOpacity(0.2))
              ),
            )
        )
      ],
    ));
  }

  Widget dataPlans(AirtimeViewModel viewModel) {
    final beneficiary = viewModel.beneficiary as AirtimeBeneficiary;
    return Flexible(
        flex: 0,
        fit: FlexFit.tight,
        child: StreamBuilder(
            stream: dataPlanStream,
            builder: (BuildContext context,
                AsyncSnapshot<Resource<List<AirtimeServiceProviderItem>>> a) {
              if (!a.hasData || a.data?.data == null)
                return boxContainer(Container());
              final comboItems = viewModel.dataProviderItems.map((e) =>
                  ComboItem<AirtimeServiceProviderItem>(
                      e, e.name!, isSelected: e.id == viewModel.dataPlan?.id))
                  .toList();
              return SelectionCombo2<AirtimeServiceProviderItem>(
                comboItems,
                defaultTitle: "Select Data Plan",
                onItemSelected: (item, i) =>
                    setState(() => viewModel.setServiceProviderItem(item)),
                titleIcon: StreamBuilder(
                    stream: viewModel.getFile(
                        beneficiary.serviceProvider!.logoImageUUID ?? ""),
                    builder: (ctx, AsyncSnapshot<Resource<FileResult>> result) {
                      if (!result.hasData ||
                          result.data == null) SelectionCombo2.initialView();
                      final base64 = result.data?.data;
                      final base64String = base64?.base64String;
                      if (base64 == null || base64String == null ||
                          base64String.isEmpty == true)
                        return SelectionCombo2.initialView();
                      _providerLogo = (_providerLogo == null)
                          ? Image.memory(base64Decode(base64String), width: 40,
                          height: 40,
                          errorBuilder: (_, _i, _j) {
                            return SelectionCombo2.initialView();
                          })
                          : _providerLogo;
                      return _providerLogo!;
                    }
                ),
              );
            }
        )
    );
    // return Flexible(
    //     flex: 0,
    //     fit: FlexFit.tight,
    //     child: StreamBuilder(
    //         stream: dataPlanStream,
    //         builder: (BuildContext context, AsyncSnapshot<Resource<List<AirtimeServiceProviderItem>>> a) {
    //           if(!a.hasData || a.data?.data == null) return boxContainer(Container());
    //           print('re-mapping list');
    //           final comboItems = a.data!.data!.map((e) => ComboItem<AirtimeServiceProviderItem>(e, e.name!)).toList();
    //           return SelectionCombo<AirtimeServiceProviderItem>(comboItems, (item, i){
    //               setState(() {
    //                 this._amount = 0;
    //                 print('Called');
    //                 viewModel.setServiceProviderItem(item);
    //               });
    //           });
    //     }
    // ));
  }

  Widget transferSource(BaseViewModel viewModel) {
    return boxContainer(Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Flexible(
            flex: 0,
            child: Container(
              width: 37,
              height: 37,
              padding: EdgeInsets.all(6),
              decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.darkBlue.withOpacity(0.1)
              ),
              child: Center(
                child: SvgPicture.asset(
                  'res/drawables/ic_bank.svg', color: Colors.primaryColor,),
              ),
            )
        ),
        SizedBox(width: 17,),
        Expanded(
            flex: 1,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '${viewModel.accountName}',
                  overflow: TextOverflow.ellipsis,
                  maxLines: 1,
                  style: TextStyle(fontSize: 15,
                      color: Colors.solidDarkBlue,
                      fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 1,),
                StreamBuilder(
                    initialData: null,
                    stream: viewModel.balanceStream,
                    builder: (context, AsyncSnapshot<AccountBalance?> a) {
                      final balance = (a.hasData) ? a.data?.availableBalance
                          ?.formatCurrency : "--";
                      return Text(
                        'Balance - $balance',
                        textAlign: TextAlign.left,
                        style: TextStyle(color: Colors.deepGrey,
                            fontSize: 13,
                            fontFamily: Styles.defaultFont,
                            fontFamilyFallback: ["Roboto"]),)
                          .colorText({"$balance": Tuple(Colors.deepGrey, null)},
                          underline: false);
                    })
              ],
            )
        ),
        SizedBox(width: 17,),
        Expanded(
            flex: 0,
            child: SvgPicture.asset(
                'res/drawables/ic_check_mark_round.svg',
                width: 26,
                height: 26
            )
        )
      ],
    ));
  }


  Widget amountWidget() {
    final viewModel = Provider.of<AirtimeViewModel>(context, listen: false);
    final isAmountFixed = viewModel.dataPlan != null &&
        viewModel.dataPlan?.priceFixed == true;
    this._amount =
    isAmountFixed ? (viewModel.dataPlan?.amount ?? 0) / 100 : this._amount;
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
      pills.add(Expanded(flex: 1,
          child: AmountPill(
              element, index, (ListDataItem<String> item, position) {
            setState(() {
              _selectedAmountPill?.isSelected = false;
              _selectedAmountPill = item;
              _selectedAmountPill?.isSelected = true;
              this._amount = double.parse(_selectedAmountPill!.item.replaceAll(
                  RegExp(r'[(a-z)|(A-Z)|(,₦)]'), ""));
            });
          })));
      if (index != amountPills.length - 1) pills.add(SizedBox(width: 8,));
    });
    return pills;
  }

  void _displayPaymentError(String message) {
    showModalBottomSheet(
        backgroundColor: Colors.transparent,
        context: widget._scaffoldKey.currentContext ?? context,
        builder: (context) => BottomSheets.displayErrorModal(
            context, title: "Oops", message: message));
  }

  void subscribeUiToPin() async {
    final viewModel = Provider.of<AirtimeViewModel>(context, listen: false);
    dynamic result = await showModalBottomSheet(
        context: widget._scaffoldKey.currentContext ?? context,
        isScrollControlled: true,
        backgroundColor: Colors.transparent,
        builder: (context) =>
            ChangeNotifierProvider.value(
              value: viewModel,
              child: AirtimePinDialog(),
            ));

    if (result is TransactionStatus) {
      final isSuccessful = result.operationStatus == Constants.APPROVED
          || result.operationStatus == Constants.COMPLETED
          || result.operationStatus == Constants.PENDING
          || result.operationStatus == Constants.SUCCESSFUL;

      if (isSuccessful) {
        final batchId = (viewModel.purchaseType == PurchaseType.DATA) ? result
            .customerDataTopUpId : result.customerAirtimeId;

        final payload = SuccessPayload("Airtime Purchase Successful",
            "Your ${describeEnum(viewModel.purchaseType)
                .toLowerCase()} purchase was successful",
            fileName: "Airtime_Receipt_${viewModel.accountName}_${DateFormat(
                "dd MM yyyy").format(DateTime.now())}.pdf",
            downloadTask: (batchId != null &&
                result.operationStatus != Constants.PENDING &&
                viewModel.purchaseType == PurchaseType.AIRTIME)
                ? () => viewModel.downloadReceipt(batchId)
                : null
        );

        showModalBottomSheet(
            context: widget._scaffoldKey.currentContext ?? context,
            isScrollControlled: true,
            backgroundColor: Colors.transparent,
            builder: (mContext) =>
                TransactionSuccessDialog(
                    payload, onClick: () {
                  Navigator.of(mContext).pop();
                  Navigator.of(context).pushNamedAndRemoveUntil(
                      AirtimeScreen.BENEFICIARY_SCREEN, (route) => false);
                })
        );
      } else {
        _displayPaymentError(result.message ??
            "Unable to complete transaction at this time. Please try again later.");
      }
    } else if (result is Error<TransactionStatus>) {
      _displayPaymentError(result.message ?? "");
    }
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    final viewModel = Provider.of<AirtimeViewModel>(context, listen: false);

    return ScrollView(
      child: Container(
        padding: EdgeInsets.only(top: 37, left: 16, right: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            makeLabel('Airtime/Data Recipient'),
            SizedBox(height: 8,),
            transferRecipient(viewModel),
            SizedBox(height: 24,),
            Visibility(
              visible: viewModel.purchaseType == PurchaseType.DATA,
              child: makeLabel('Select Plan'),
            ),
            SizedBox(
              height: viewModel.purchaseType == PurchaseType.DATA ? 8 : 0,),
            Visibility(
              visible: viewModel.purchaseType == PurchaseType.DATA,
              child: dataPlans(viewModel),
            ),
            SizedBox(
              height: viewModel.purchaseType == PurchaseType.DATA ? 24 : 0,),
            makeLabel('Purchase From'),
            SizedBox(height: 8,),
            TransactionAccountSource(viewModel),
            SizedBox(height: 24,),
            makeLabel('How much would you like to purchase? '),
            SizedBox(height: 8,),
            amountWidget(),
            SizedBox(height: 16,),
            Visibility(
                visible: viewModel.purchaseType != PurchaseType.DATA &&
                    viewModel.dataPlan?.priceFixed != true,
                child: Expanded(flex: 0, child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: generateAmountPillsWidget()
                ))
            ),
            SizedBox(height: 16,),
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
            SizedBox(height: 32,),
          ],
        ),
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;

  @override
  void dispose() {
    super.dispose();
  }
}