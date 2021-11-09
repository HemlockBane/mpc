
import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart' hide Colors, ScrollView;
import 'package:intl/intl.dart';
import 'package:moniepoint_flutter/app/airtime/model/data/airtime_purchase_type.dart';
import 'package:moniepoint_flutter/app/airtime/model/data/airtime_service_provider.dart';
import 'package:moniepoint_flutter/app/airtime/model/data/airtime_service_provider_item.dart';
import 'package:moniepoint_flutter/app/airtime/viewmodels/airtime_view_model.dart';
import 'package:moniepoint_flutter/app/airtime/views/dialogs/airtime_pin_dialog.dart';
import 'package:moniepoint_flutter/app/airtime/views/selection_combo.dart';
import 'package:moniepoint_flutter/app/managebeneficiaries/airtime/model/data/airtime_beneficiary.dart';
import 'package:moniepoint_flutter/core/views/amount_pill.dart';
import 'package:moniepoint_flutter/core/colors.dart';
import 'package:moniepoint_flutter/core/constants.dart';
import 'package:moniepoint_flutter/core/models/file_result.dart';
import 'package:moniepoint_flutter/core/models/list_item.dart';
import 'package:moniepoint_flutter/core/models/transaction_status.dart';
import 'package:moniepoint_flutter/core/network/resource.dart';
import 'package:moniepoint_flutter/core/payment_view_model.dart';
import 'package:moniepoint_flutter/core/styles.dart';
import 'package:moniepoint_flutter/core/tuple.dart';
import 'package:moniepoint_flutter/core/utils/dialog_util.dart';
import 'package:moniepoint_flutter/core/views/payment_amount_view.dart';
import 'package:moniepoint_flutter/core/views/scroll_view.dart';
import 'package:moniepoint_flutter/core/views/selection_combo_two.dart';
import 'package:moniepoint_flutter/core/views/user_account_selection_view.dart';
import 'package:moniepoint_flutter/core/views/transaction_success_dialog.dart';
import 'package:provider/provider.dart';
import 'package:moniepoint_flutter/core/extensions/text_utils.dart';
import 'package:moniepoint_flutter/core/extensions/strings.dart';
import 'package:collection/collection.dart';

import 'airtime_view.dart';

class AirtimePaymentScreen extends StatefulWidget {

  late final GlobalKey<ScaffoldState> _scaffoldKey;
  final double defaultAmount;

  AirtimePaymentScreen(
      this._scaffoldKey,
      this.defaultAmount
  );

  @override
  State<StatefulWidget> createState() => _AirtimePaymentScreen();

}

class _AirtimePaymentScreen extends State<AirtimePaymentScreen> with AutomaticKeepAliveClientMixin {

  late final AirtimeViewModel viewModel;

  ListDataItem<String>? _selectedAmountPill;

  @override
  initState() {
    this.viewModel = Provider.of<AirtimeViewModel>(context, listen: false);
    viewModel.setServiceProviderItem(null);
    viewModel.setSourceAccount(null);
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

  static Widget boxContainer(Widget child) {
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
                  '${beneficiary?.getBeneficiaryProviderName()} - ${beneficiary?.getBeneficiaryDigits()}',
                  textAlign: TextAlign.left,
                  style: TextStyle(color: Colors.deepGrey,
                      fontSize: 13,
                      fontFamily: Styles.defaultFont),
                ).colorText({
                  "${beneficiary?.getBeneficiaryDigits()}": Tuple(Colors.deepGrey, null)
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
    final isAmountFixed = viewModel.dataPlan != null && viewModel.dataPlan?.priceFixed == true;
    final amount = viewModel.amount ?? 0.0;
    return boxContainer(
        PaymentAmountView((amount * 100).toInt(), (value) {
          viewModel.setAmount(value / 100);
        }, isAmountFixed: isAmountFixed)
    );
  }

  List<Widget> generateAmountPillsWidget() {
    final pills = <Widget>[];
    viewModel.amountPills.forEachIndexed((index, element) {
      pills.add(Expanded(flex: 1,
          child: AmountPill(item: element, position: index, listener: (ListDataItem<String> item, position) {
            setState(() {
              _selectedAmountPill?.isSelected = false;
              _selectedAmountPill = item;
              _selectedAmountPill?.isSelected = true;
              final amount = double.parse(_selectedAmountPill!.item.replaceAll(RegExp(r'[(a-z)|(A-Z)|(,₦)]'), ""));
              viewModel.setAmount(amount / 100);
            });
          })));
      if (index != viewModel.amountPills.length - 1) pills.add(SizedBox(width: 8,));
    });
    return pills;
  }

  void subscribeUiToPin() async {
    final viewModel = Provider.of<AirtimeViewModel>(context, listen: false);
    viewModel.setPin("");
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
            isDismissible: false,
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
        showError(
            widget._scaffoldKey.currentContext ?? context,
            title: "Airtime Purchase Failed",
            message: "Unable to complete transaction at this time. Please try again later."
        );
      }
    } else if (result is Error<TransactionStatus>) {
      showError(
          widget._scaffoldKey.currentContext ?? context,
          title: "Airtime Purchase Failed",
          message: result.message ?? ""
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);

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
            SizedBox(height: viewModel.purchaseType == PurchaseType.DATA ? 8 : 0,),
            DataPlansView(
              viewModel: viewModel,
              serviceProvider: (viewModel.beneficiary as AirtimeBeneficiary).serviceProvider!,
              onItemSelected: () => setState(() {
                //TODO we can avoid rebuilding the entire tree here
              }),
            ),
            SizedBox(height: viewModel.purchaseType == PurchaseType.DATA ? 24 : 0,),
            makeLabel('Purchase From'),
            SizedBox(height: 8,),
            UserAccountSelectionView(
              viewModel,
              selectedUserAccount: viewModel.sourceAccount,
              onAccountSelected: (account) => viewModel.setSourceAccount(account),
            ),
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

///DataPlansView
///
///
///
class DataPlansView extends StatefulWidget {

  DataPlansView({
    required this.viewModel,
    required this.serviceProvider,
    required this.onItemSelected
  });

  final AirtimeViewModel viewModel;
  final AirtimeServiceProvider serviceProvider;
  final VoidCallback onItemSelected; //TODO this is inconsequential the parent should listen for changes instead

  @override
  State<StatefulWidget> createState() {
    return _DataPlanViewState(viewModel: viewModel, serviceProvider: serviceProvider);
  }

}

class _DataPlanViewState extends State<DataPlansView> {

  _DataPlanViewState({
    required this.viewModel,
    required this.serviceProvider
  });

  final AirtimeViewModel viewModel;
  final AirtimeServiceProvider serviceProvider;

  Image? _providerLogo;

  Widget getTitleIcon (AirtimeServiceProviderItem? item) {
    if(item == null) return SelectionCombo2.initialView();
    return StreamBuilder(
        stream: viewModel.getFile(serviceProvider.logoImageUUID ?? ""),
        builder: (ctx, AsyncSnapshot<Resource<FileResult>> result) {
          if (!result.hasData || result.data == null) SelectionCombo2.initialView();
          final base64 = result.data?.data;
          final base64String = base64?.base64String;
          if (base64 == null || base64String == null || base64String.isEmpty == true) {
            return SelectionCombo2.initialView();
          }
          _providerLogo = (_providerLogo == null)
              ? Image.memory(base64Decode(base64String), width: 40, height: 40,
                errorBuilder: (_, _i, _j) {
                  return SelectionCombo2.initialView();
                })
              : _providerLogo;
          return _providerLogo!;
        }
    );
  }

  @override
  Widget build(BuildContext context) {
    if(viewModel.purchaseType != PurchaseType.DATA) return SizedBox();
    return Flexible(
      flex: 0,
      fit: FlexFit.tight,
      child: StreamBuilder(
          stream: viewModel.getServiceProviderItems(serviceProvider.billerId!),
          builder: (BuildContext context, AsyncSnapshot<Resource<List<AirtimeServiceProviderItem>>> a) {
            if (!a.hasData || a.data?.data == null) return _AirtimePaymentScreen.boxContainer(Container());
            final comboItems = viewModel.dataProviderItems.map((e) =>
                ComboItem<AirtimeServiceProviderItem>(e, e.name!, isSelected: e.id == viewModel.dataPlan?.id))
                .toList();
            return SelectionCombo2<AirtimeServiceProviderItem>(
              comboItems,
              defaultTitle: "Select Data Plan",
              onItemSelected: (item, i) {
                viewModel.setServiceProviderItem(item);
                if(item != null && item.priceFixed == true && item.amount != null) {
                  viewModel.setAmount(item.amount! / 100);
                  widget.onItemSelected.call();
                }
              },
              titleIcon: getTitleIcon,
            );
          }
      ),
    );
  }
}