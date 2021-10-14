import 'package:flutter/material.dart' hide Colors, ScrollView, Card;
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:moniepoint_flutter/app/accounts/model/data/account_transaction.dart';
import 'package:moniepoint_flutter/app/accounts/model/data/transaction_category.dart';
import 'package:moniepoint_flutter/app/accounts/viewmodels/account_transaction_detail_view_model.dart';
import 'package:moniepoint_flutter/app/accounts/views/clippers/account_ticket_clipper.dart';
import 'package:moniepoint_flutter/app/cards/views/utils/card_view_util.dart';
import 'package:moniepoint_flutter/core/colors.dart';
import 'package:moniepoint_flutter/core/lazy.dart';
import 'package:moniepoint_flutter/core/models/transaction.dart';
import 'package:moniepoint_flutter/core/styles.dart';
import 'package:moniepoint_flutter/core/tuple.dart';
import 'package:moniepoint_flutter/core/views/scroll_view.dart';
import 'package:moniepoint_flutter/core/views/sessioned_widget.dart';
import 'package:moniepoint_flutter/core/views/transaction_location_view.dart';
import 'package:provider/provider.dart';
import 'package:moniepoint_flutter/core/utils/currency_util.dart';
import 'package:moniepoint_flutter/core/extensions/text_utils.dart';
import 'package:collection/collection.dart';

import 'account_transaction_options.dart';

///@author Paul Okeke

class AccountTransactionDetailedView extends StatefulWidget {
  AccountTransactionDetailedView();

  @override
  State<StatefulWidget> createState() => _AccountTransactionDetailedView();
}

class _AccountTransactionDetailedView extends State<AccountTransactionDetailedView> {
  String? _transactionReference;
  String? _accountNumber;

  late final AccountTransactionDetailViewModel _viewModel;

  LatLng? _transactionLocation(AccountTransaction transaction) {
    if(transaction.location != null) {
      return LatLng(
          double.tryParse(transaction.location?.latitude ?? "0.0") ?? 0.0,
          double.tryParse(transaction.location?.longitude ?? "0.0") ?? 0.0
      );
    }
    return null;
  }

  @override
  void initState() {
    _viewModel = Provider.of<AccountTransactionDetailViewModel>(context, listen: false);
    super.initState();
    _viewModel.getTiers().listen((event) {});
  }

  Widget _accountNumberView (String? accountNumber) => Text(
    "Account Number : ${accountNumber ?? _accountNumber}",
    style: TextStyle(
      fontSize: 13,
      color: Colors.textColorBlack,
    ),
  ).colorText({"${accountNumber ?? _accountNumber}": Tuple(Colors.textColorBlack, null)}, underline: false);

  TransactionDetailDisplayable _getBeneficiaryDisplayableView(AccountTransaction transaction) {
    switch(transaction.transactionCategory) {
      case TransactionCategory.TRANSFER:
        return _TransferTransactionBeneficiaryDetails(transaction: transaction);
      case TransactionCategory.BILL_PAYMENT:
        return _BillTransactionBeneficiaryDetails(transaction: transaction);
      case TransactionCategory.AIRTIME:
        return _AirtimeTransactionBeneficiaryDetails(transaction: transaction);
      case TransactionCategory.DATA:
        return _AirtimeTransactionBeneficiaryDetails(transaction: transaction);
      case TransactionCategory.CARD_LINKING:
        return _CardTransactionBeneficiaryDetails(transaction: transaction,);
      case TransactionCategory.CARD_PURCHASE:
        return _CardTransactionBeneficiaryDetails(transaction: transaction,);
      case TransactionCategory.DEFAULT:
        return _EmptyBeneficiaryDetails();
      default:
        return _EmptyBeneficiaryDetails();
    }
  }

  List<Widget> _generateTransactionDetailsItems(AccountTransaction transaction) {
    final items = [
      _getBeneficiaryDisplayableView(transaction),
      _CardPurchaseLocationDetails(transaction: transaction),
      _TransactionDetailViewItem(
        label: "Narration",
        value: transaction.narration,
        valueTextWeight: FontWeight.w500,
      ),
      _TransactionDetailViewItem(
        label: "Transaction Date",
        value: transaction.transactionDateToString(),
        valueTextWeight: FontWeight.w600,
      ),
      _TransactionDetailViewItem(
        label: "Channel",
        value: transaction.transactionChannel,
        valueTextWeight: FontWeight.w600,
        isChannel: true,
      ),
      _TransactionDetailViewItem(
        label: "Reference",
        value: transaction.transactionRef,
        valueTextWeight: FontWeight.w400,
      ),
      _TransactionDetailViewItem(
        label: "Transaction Code",
        value: transaction.transactionCode,
        valueTextWeight: FontWeight.w400,
      ),
      TransactionLocationView(
          (transaction.location == null)
              ? null
              : _transactionLocation(transaction),
          "Transaction Location"
      )
    ];

    final List<Widget> viewItems = items.foldIndexed(<Widget>[], (index, previous, element) {
      if(element.shouldDisplay()) previous.add(element);
      if(index != items.length - 1 && element.shouldDisplay()) {
        previous.add(Divider(height: 1, color: Colors.primaryColor.withOpacity(0.2)));
      }
      return previous;
    });

    if(viewItems.isNotEmpty && viewItems.lastOrNull is Divider) {
      viewItems.removeLast();
    }
    return viewItems;
  }

  Widget _contentView(AccountTransaction transaction) {
    return Stack(
      children: [
        Positioned(
          left: 0,
          right: 0,
          top: 0,
          child: _TransactionCategoryView(transaction: transaction),
        ),
        ClipPath(
          clipper: AccountTransactionsTicketClipper(),
          child: Container(
            margin: EdgeInsets.only(
                top: transaction.transactionCategory == null
                    || transaction.transactionCategory == TransactionCategory.DEFAULT
                    ? 0
                    : 56
            ),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(topLeft: Radius.circular(16), topRight: Radius.circular(16)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _TransactionAmountView(transaction: transaction),
                SizedBox(height: 19),
                Divider(height: 1, color: Colors.primaryColor.withOpacity(0.2)),
                SizedBox(height: 17),
                Padding(
                  padding: EdgeInsets.only(left: 21, right: 21),
                  child: _accountNumberView(transaction.accountNumber),
                ),
                Container(
                  padding: EdgeInsets.only(left: 15, right: 15),
                  margin: EdgeInsets.only(top: 21, left: 18, right: 18, bottom: 44),
                  decoration: BoxDecoration(
                      color: Colors.primaryColor.withOpacity(0.05),
                      borderRadius: BorderRadius.circular(9)
                  ),
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: _generateTransactionDetailsItems(transaction)
                  ),
                )
              ],
            ),
          ),
        )
      ],
    );
  }


  @override
  Widget build(BuildContext context) {
    final arguments = ModalRoute.of(context)!.settings.arguments as Map<dynamic, dynamic>;
    this._transactionReference = arguments["transactionRef"];
    this._accountNumber = arguments["accountNumber"] ?? this._accountNumber;

    return SessionedWidget(
      context: context,
      child: Scaffold(
        appBar: AppBar(
            centerTitle: false,
            titleSpacing: -12,
            iconTheme: IconThemeData(color: Colors.primaryColor),
            title: Text('Transaction Details',
                textAlign: TextAlign.start,
                style: TextStyle(
                    color: Colors.textColorBlack,
                    fontFamily: Styles.defaultFont,
                    fontWeight: FontWeight.w700,
                    fontSize: 14
                )
            ),
            backgroundColor: Colors.transparent,
            elevation: 0
        ),
        extendBodyBehindAppBar: true,
        backgroundColor: Color(0XFFEBF2FA),
        body: FutureBuilder(
            future: _viewModel.getSingleTransactionById(this._transactionReference ?? ""),
            builder: (_, AsyncSnapshot<AccountTransaction?> snapshot) {
              if (!snapshot.hasData || snapshot.data == null) return Container();
              final transaction = snapshot.data!;
              return Container(
                padding: EdgeInsets.only(top: MediaQuery.of(context).padding.top + 65),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.only(topLeft: Radius.circular(16), topRight: Radius.circular(16)),
                  image: DecorationImage(
                    image: AssetImage("res/drawables/ic_app_bg_dark.png"),
                    fit: BoxFit.fill,
                  ),
                ),
                child: ScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(height: 2),
                      Container(
                        margin: EdgeInsets.only(left: 16, right: 16),
                        decoration: BoxDecoration(
                            boxShadow: [
                              BoxShadow(
                                  color: Color(0XFF0E4FB1).withOpacity(0.12),
                                  blurRadius: 21,
                                  offset: Offset(0, 13)
                              )
                            ]
                        ),
                        child: _contentView(transaction),
                      ),
                      SizedBox(height: 40),
                      Padding(
                        padding: EdgeInsets.only(left: 16, right: 16),
                        child: AccountTransactionOptions(
                            transaction: transaction,
                            viewModel: _viewModel,
                            accountNumber: _accountNumber
                        ),
                      ),
                      SizedBox(height: 100),
                    ],
                  ),
                ),
              );
            }
        ),
      ),
    );
  }
}


///_TransactionAmountView
///
///
///
class _TransactionAmountView extends StatelessWidget {

  _TransactionAmountView({
    required this.transaction
  });

  final AccountTransaction transaction;

  Widget _contentView() {
    final balanceBefore = double.tryParse(transaction.balanceBefore ?? "")?.formatCurrency ?? "";
    final balanceAfter = double.tryParse(transaction.balanceAfter ?? "")?.formatCurrency ?? "";
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Amount",
          style: TextStyle(
              fontWeight: FontWeight.w600,
              fontSize: 13
          ),
        ),
        SizedBox(height: 2,),
        Row(
          children: [
            SvgPicture.asset(
              "res/drawables/ic_naira.svg",
              width: 20,
              height: 17,
            ),
            SizedBox(width: 4),
            Flexible(child: Text(
              transaction.getAmount().formatCurrencyWithoutSymbolAndDividing,
              style: TextStyle(
                fontSize: 23.8,
                fontWeight: FontWeight.w800,
                color: Colors.textColorBlack,
              ),
            ))
          ],
        ),
        SizedBox(height: 13,),
        Text(
            "Balance Before : $balanceBefore",
            style: TextStyle(
                color: Colors.textColorBlack,
                fontSize: 13,
                fontWeight: FontWeight.w400
            )
        ).colorText({"$balanceBefore": Tuple(Colors.textColorBlack, null)}, underline: false),
        SizedBox(height: 7),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
                "Balance After : $balanceAfter",
                style: TextStyle(
                    color: Colors.textColorBlack,
                    fontSize: 13,
                    fontWeight: FontWeight.w400
                )
            ).colorText({"$balanceAfter": Tuple(Colors.textColorBlack, null)}, underline: false),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 8.4, vertical: 2.5),
              decoration: BoxDecoration(
                  color: (transaction.type == TransactionType.CREDIT)
                      ? Colors.solidGreen.withOpacity(0.25)
                      : Color(0xff24F00303),
                  borderRadius: BorderRadius.circular(4)),
              child: Text(
                transaction.transactionTypeToString(),
                style: TextStyle(
                    fontSize: 11.2,
                    color: (transaction.type == TransactionType.CREDIT)
                        ? Colors.solidGreen
                        : Colors.red,
                    fontWeight: FontWeight.bold
                ),
              ),
            )
          ],
        )
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: EdgeInsets.only(top: 19,left: 21, right: 21),
        child: _contentView(),
    );
  }

}

///_TransactionCategoryView
///
///
///
class _TransactionCategoryView extends StatelessWidget {

  _TransactionCategoryView({required this.transaction});

  final AccountTransaction transaction;

  final Map<TransactionCategory, Color> _headerCategoryToColor = {
    TransactionCategory.AIRTIME : Color(0XFFFDEAD5),
    TransactionCategory.DATA : Color(0XFFFDEAD5),
    TransactionCategory.BILL_PAYMENT : Color(0XFFECDFF9),
    TransactionCategory.TRANSFER : Color(0XFFCFE2FD),
    TransactionCategory.CARD_PURCHASE : Color(0XFFCFF2F7),
    TransactionCategory.CARD_LINKING : Color(0XFFCFF2F7),
  };

  final Map<TransactionCategory, Color> _titleCategoryToColor = {
    TransactionCategory.AIRTIME : Color(0XFFF08922),
    TransactionCategory.DATA : Color(0XFFF08922),
    TransactionCategory.BILL_PAYMENT : Color(0XFF9B51E0),
    TransactionCategory.TRANSFER : Colors.primaryColor,
    TransactionCategory.CARD_PURCHASE : Color(0XFF00B6D4),
    TransactionCategory.CARD_LINKING : Color(0XFF00B6D4),
  };

  late final Map<TransactionCategory, Lazy<Widget>> _categoryToIcon = {
    TransactionCategory.AIRTIME : lazy(() => SvgPicture.asset(
      "res/drawables/ic_dashboard_airtime_2.svg",
      color: _titleCategoryToColor[TransactionCategory.AIRTIME],
    )),
    TransactionCategory.DATA : lazy(() => SvgPicture.asset(
      "res/drawables/ic_dashboard_airtime_2.svg",
      color: _titleCategoryToColor[TransactionCategory.DATA],
    )),
    TransactionCategory.BILL_PAYMENT : lazy(() => SvgPicture.asset(
      "res/drawables/ic_dashboard_bills_2.svg",
      color: _titleCategoryToColor[TransactionCategory.BILL_PAYMENT],
    )),
    TransactionCategory.TRANSFER : lazy(() => SvgPicture.asset(
      "res/drawables/ic_transfer_receipt.svg",
      color: _titleCategoryToColor[TransactionCategory.TRANSFER],
    )),
    TransactionCategory.CARD_PURCHASE : lazy(() => SvgPicture.asset(
      "res/drawables/ic_dashboard_manage_cards.svg",
      color: _titleCategoryToColor[TransactionCategory.CARD_PURCHASE],
    )),
    TransactionCategory.CARD_LINKING : lazy(() => SvgPicture.asset(
      "res/drawables/ic_dashboard_manage_cards.svg",
      color: _titleCategoryToColor[TransactionCategory.CARD_LINKING],
    )),
  };

  String _getTransactionCategoryName() {
    if(transaction.transactionCategory == null) return "Transaction";
    switch(transaction.transactionCategory) {
      case TransactionCategory.TRANSFER:
        return "TRANSFER";
      case TransactionCategory.BILL_PAYMENT:
        return "BILL PAYMENT";
      case TransactionCategory.AIRTIME:
        return "AIRTIME";
      case TransactionCategory.DATA:
        return "DATA";
      case TransactionCategory.CARD_LINKING:
        return "CARD ISSUANCE";
      case TransactionCategory.CARD_PURCHASE:
        return "CARD PURCHASE";
      case TransactionCategory.DEFAULT:
        return "";
      default:
        return "";
    }
  }

  @override
  Widget build(BuildContext context) {
    if(transaction.transactionCategory == null
        || transaction.transactionCategory == TransactionCategory.DEFAULT) {
      return SizedBox();
    }
    return Container(
      padding: EdgeInsets.only(left: 22, right: 22, top: 18, bottom: 40),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.only(topLeft: Radius.circular(16), topRight: Radius.circular(16)),
        color: _headerCategoryToColor[transaction.transactionCategory]
      ),
      child: Row(
        children: [
          _categoryToIcon[transaction.transactionCategory]?.value ?? SizedBox(),
          SizedBox(width: 13,),
          Text(
              _getTransactionCategoryName().toUpperCase(),
              style: TextStyle(
                color: _titleCategoryToColor[transaction.transactionCategory],
                fontWeight: FontWeight.w600,
                fontSize: 12
              ),
          )
        ],
      ),
    );
  }
}

///_TransactionDetailViewItem
///
///
///
class _TransactionDetailViewItem extends TransactionDetailDisplayable {

  _TransactionDetailViewItem({
    required this.label,
    required this.value,
    this.valueTextWeight,
    this.isChannel = false
  });

  final String label;
  final String? value;
  final FontWeight? valueTextWeight;
  final bool isChannel;

  Widget _channelContainer() => Container(
    padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
    decoration: BoxDecoration(
        color: Colors.primaryColor.withOpacity(0.17),
        borderRadius: BorderRadius.circular(4)
    ),
    child: Text(
      value ?? "",
      style: TextStyle(
          fontSize: 11.3,
          color: Colors.primaryColor,
          fontWeight: FontWeight.bold),
    ),
  );

  @override
  Widget build(BuildContext context) {
    if(value == null) return SizedBox();
    return Container(
      padding: EdgeInsets.only(top: 17, bottom: 17),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: TextStyle(
              color: Colors.textColorBlack.withOpacity(0.8),
              fontSize: 12.95
            ),
          ),
          SizedBox(height: this.isChannel ? 6 : 3),
          if(this.isChannel) _channelContainer(),
          if(!this.isChannel)
            Text(
              value!,
              style: TextStyle(
                  color: Colors.textColorBlack,
                  fontSize: 14.54,
                  fontWeight: valueTextWeight ?? FontWeight.w400
              ),
            )
        ],
      ),
    );
  }

  @override
  bool shouldDisplay() {
    return value != null || value?.isNotEmpty == true;
  }
}

///_AirtimeTransactionBeneficiaryDetails
///
///
///
class _TransferTransactionBeneficiaryDetails extends TransactionDetailDisplayable {

  _TransferTransactionBeneficiaryDetails({
    required this.transaction
  });

  final AccountTransaction transaction;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(top: 17, bottom: 17),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text((transaction.type == TransactionType.CREDIT) ? "Sender" : "Beneficiary",
            style: TextStyle(
                color: Colors.textColorBlack.withOpacity(0.8),
                fontSize: 12.95
            ),
          ),
          SizedBox(height: 3,),
          Text(
            (transaction.type == TransactionType.CREDIT)
                ? "${transaction.senderName}"
                : "${transaction.beneficiaryName}",
            style: TextStyle(
                color: Colors.textColorBlack,
                fontSize: 14.54,
                fontWeight: FontWeight.w600
            ),
          ),
          SizedBox(height: 3,),
          Row(
            children: [
              Text(
                (transaction.type == TransactionType.CREDIT)
                    ? "${transaction.senderBankName} ${transaction.senderIdentifier}"
                    : "${transaction.beneficiaryBankName} ${transaction.beneficiaryIdentifier}",
                style: TextStyle(
                  fontSize: 11.54,
                  fontWeight: FontWeight.w500,
                  color: Colors.textColorBlack.withOpacity(0.5)
                ),
              )
            ],
          ),
        ],
      ),
    );
  }

  @override
  bool shouldDisplay() {
    if(transaction.type == TransactionType.CREDIT) {
      return transaction.senderName != null
          && transaction.senderName?.isNotEmpty == true;
    } else {
      return transaction.beneficiaryName != null
          && transaction.beneficiaryName?.isNotEmpty == true;
    }
  }

}


///_BillTransactionBeneficiaryDetails
///
///
///
class _BillTransactionBeneficiaryDetails extends TransactionDetailDisplayable {

  _BillTransactionBeneficiaryDetails({
    required this.transaction
  });

  final AccountTransaction transaction;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(top: 17, bottom: 17),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Beneficiary",
            style: TextStyle(
                color: Colors.textColorBlack.withOpacity(0.8),
                fontSize: 12.95
            ),
          ),
          SizedBox(height: 3,),
          Text(
            transaction.beneficiaryName ?? "",
            style: TextStyle(
                color: Colors.textColorBlack,
                fontSize: 14.54,
                fontWeight: FontWeight.w600
            ),
          ),
          SizedBox(height: 29),
          Text(
            "Customer ID",
            style: TextStyle(
                color: Colors.textColorBlack.withOpacity(0.8),
                fontSize: 12.95
            ),
          ),
          SizedBox(height: 3),
          Text(
            transaction.beneficiaryIdentifier ?? "",
            style: TextStyle(
                color: Colors.textColorBlack,
                fontSize: 14.54,
                fontWeight: FontWeight.w600
            ),
          ),
          SizedBox(height: 24),
          Row(
            children: [
              // SvgPicture.asset("res/drawables/"),
              Text(
                transaction.providerName ?? "",
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  color: Colors.textColorBlack
                ),
              ),
            ],
          )
        ],
      ),
    );
  }

  @override
  bool shouldDisplay() {
    return transaction.beneficiaryName != null
        && transaction.beneficiaryName?.isNotEmpty == true;
  }

}

///_AirtimeTransactionBeneficiaryDetails
///
///
///
class _AirtimeTransactionBeneficiaryDetails extends TransactionDetailDisplayable {

  _AirtimeTransactionBeneficiaryDetails({
    required this.transaction
  });

  final AccountTransaction transaction;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(top: 17, bottom: 17),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Beneficiary",
            style: TextStyle(
                color: Colors.textColorBlack.withOpacity(0.8),
                fontSize: 12.95
            ),
          ),
          SizedBox(height: 3,),
          Text(
            transaction.beneficiaryName ?? "",
            style: TextStyle(
                color: Colors.textColorBlack,
                fontSize: 14.54,
                fontWeight: FontWeight.w600
            ),
          ),
          SizedBox(height: 18,),
          Text(
            "Phone Number",
            style: TextStyle(
                color: Colors.textColorBlack.withOpacity(0.8),
                fontSize: 12.95
            ),
          ),
          SizedBox(height: 3,),
          Text(
            transaction.beneficiaryIdentifier ?? "",
            style: TextStyle(
                color: Colors.textColorBlack,
                fontSize: 14.54,
                fontWeight: FontWeight.w600
            ),
          ),
          SizedBox(height: 24,),
          Row(
            children: [
              // SvgPicture.asset("res/drawables/"),
              Text(
                transaction.providerName ?? "",
                style: TextStyle(
                    fontWeight: FontWeight.w600,
                    color: Colors.textColorBlack
                ),
              ),
            ],
          )
        ],
      ),
    );
  }

  @override
  bool shouldDisplay() {
    return true;
  }

}

///_AirtimeTransactionBeneficiaryDetails
///
///
///
class _CardTransactionBeneficiaryDetails extends TransactionDetailDisplayable {

  _CardTransactionBeneficiaryDetails({
    required this.transaction
  });

  final AccountTransaction transaction;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(top: 17, bottom: 17),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Card Number",
            style: TextStyle(
                color: Colors.textColorBlack.withOpacity(0.8),
                fontSize: 12.95
            ),
          ),
          SizedBox(height: 3,),
          Text(
            transaction.maskedPan ?? "",
            style: TextStyle(
                color: Colors.textColorBlack,
                fontSize: 14.54,
                fontFamily: Styles.ocraExtended,
                fontWeight: FontWeight.w600
            ),
          ),
          SizedBox(height: 28,),
          Row(
            children: [
              CardViewUtil.getCardBrandFromScheme(transaction.cardScheme ?? ""),
              SizedBox(width: 13),
              Text(
                  CardViewUtil.getCardName(transaction.maskedPan ?? ""),
                style: TextStyle(
                    fontWeight: FontWeight.w600,
                    color: Colors.textColorBlack
                ),
              )
            ],
          ),
          SizedBox(height: 6,),
        ],
      ),
    );
  }

  @override
  bool shouldDisplay() {
    return true;
  }

}

///_BillTransactionBeneficiaryDetails
///
///
///
class _CardPurchaseLocationDetails extends TransactionDetailDisplayable {

  _CardPurchaseLocationDetails({
    required this.transaction
  });

  final AccountTransaction transaction;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(top: 17, bottom: 17),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Terminal ID",
            style: TextStyle(
                color: Colors.textColorBlack.withOpacity(0.8),
                fontSize: 12.95
            ),
          ),
          SizedBox(height: 3,),
          Text(
            transaction.terminalID ?? "",
            style: TextStyle(
                color: Colors.textColorBlack,
                fontSize: 14.54,
                fontWeight: FontWeight.w500
            ),
          ),
          SizedBox(height: 19),
          Text(
            "Merchant Location",
            style: TextStyle(
                color: Colors.textColorBlack.withOpacity(0.8),
                fontSize: 12.95
            ),
          ),
          SizedBox(height: 3),
          Text(
            transaction.merchantLocation ?? "",
            style: TextStyle(
                color: Colors.textColorBlack,
                fontSize: 14.54,
                fontWeight: FontWeight.w500
            ),
          ),
        ],
      ),
    );
  }

  @override
  bool shouldDisplay() {
    return
      transaction.transactionCategory == TransactionCategory.CARD_PURCHASE
          && transaction.terminalID != null
          && transaction.terminalID?.isNotEmpty == true
          && transaction.merchantLocation != null
          && transaction.merchantLocation?.isNotEmpty == true;
  }

}


class _EmptyBeneficiaryDetails extends TransactionDetailDisplayable {

  @override
  Widget build(BuildContext context) {
    return SizedBox();
  }

  @override
  bool shouldDisplay() => false;

}

abstract class TransactionDetailDisplayable extends StatelessWidget {
  bool shouldDisplay();
}