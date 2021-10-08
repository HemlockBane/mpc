import 'package:flutter/material.dart' hide Colors;
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';
import 'package:moniepoint_flutter/app/accounts/model/data/account_transaction.dart';
import 'package:moniepoint_flutter/app/accounts/model/data/transaction_category.dart';
import 'package:moniepoint_flutter/app/accounts/viewmodels/account_transaction_detail_view_model.dart';
import 'package:moniepoint_flutter/core/colors.dart';
import 'package:moniepoint_flutter/core/models/TransactionRequestContract.dart';
import 'package:moniepoint_flutter/core/models/transaction.dart';
import 'package:moniepoint_flutter/core/routes.dart';
import 'package:moniepoint_flutter/core/utils/dialog_util.dart';
import 'package:moniepoint_flutter/core/utils/download_util.dart';

class AccountTransactionOptions extends StatefulWidget {

  final AccountTransaction transaction;
  final AccountTransactionDetailViewModel viewModel;
  final String? accountNumber;

  AccountTransactionOptions({
    required this.transaction,
    required this.viewModel,
    required this.accountNumber
  });

  @override
  State<StatefulWidget> createState() => _AccountTransactionOptionsState();

}

class _AccountTransactionOptionsState extends State<AccountTransactionOptions> {

  bool _isDownloadingReceipt = false;
  bool _isSharingReceipt = false;

  String _getDownloadReceiptName() {
    return "AccountTransaction_Receipt_${widget.viewModel.accountName}"
        "_${DateFormat("dd_MM_yyyy_h_m_s").format(DateTime.now())}.pdf";
  }

  AccountTransaction _getTransactionForDownload() {
    final mTransaction = widget.transaction.toJson();
    mTransaction["accountNumber"] = widget.accountNumber;
    mTransaction["amount"] = widget.transaction.amount! * 100;

    mTransaction["transactionDate"] = DateTime.fromMillisecondsSinceEpoch(
        widget.transaction.transactionDate
    ).toString();

    mTransaction["location"] = null;
    return AccountTransaction.fromJson(mTransaction);
  }

  void _onDownload(bool share) async {
    try {
      await DownloadUtil.downloadTransactionReceipt(
          () => widget.viewModel.downloadTransactionReceipt(_getTransactionForDownload()),
          _getDownloadReceiptName(),
          isShare: share,
          onProgress: (_, isCompleted) {
            if (isCompleted) {
              if (!share) _isDownloadingReceipt = false;
              if (share) _isSharingReceipt = false;
              setState(() {});
            } else {
              if (!share) _isDownloadingReceipt = true;
              if (share) _isSharingReceipt = true;
              setState(() {});
            }
          }
      );
    } catch(e) {
      setState(() { _isDownloadingReceipt = false; });
      setState(() { _isSharingReceipt = false; });
      showError(
          context,
          title: "Download Receipt Failed!",
          message: "Failed downloading receipt, please try again later."
      );
    }
  }

  bool _canDownloadOrShareReceipt() {
    final transaction = widget.transaction;
    return (transaction.type == TransactionType.DEBIT || transaction.type == TransactionType.CREDIT)
        && transaction.transactionCategory != null;
  }

  void _replayTransaction() {
    final transaction = widget.transaction;
    switch(transaction.transactionCategory) {
      case TransactionCategory.TRANSFER:
        final contract = TransactionRequestContract(
            transaction: transaction, requestType: TransactionRequestContractType.REPLAY
        );
        Navigator.of(context).pushNamed(Routes.TRANSFER, arguments: contract);
        break;
      case TransactionCategory.BILL_PAYMENT:
        return;
      case TransactionCategory.AIRTIME:
        final contract = TransactionRequestContract(
            transaction: transaction, requestType: TransactionRequestContractType.REPLAY
        );
        Navigator.of(context).pushNamed(Routes.AIRTIME, arguments: contract);
        return;
      case TransactionCategory.DATA:
        return;
      case TransactionCategory.CARD_LINKING:
        return;
      case TransactionCategory.CARD_PURCHASE:
        return;
      case TransactionCategory.DEFAULT:
        return;
      default:
        return;
    }
  }

  bool _canReplayTransaction() {
    final transaction = widget.transaction;
    switch(transaction.transactionCategory) {
      case TransactionCategory.TRANSFER:
        if(transaction.type == TransactionType.DEBIT) {
          return transaction.beneficiaryIdentifier != null
              && transaction.beneficiaryIdentifier?.isNotEmpty == true
              && transaction.beneficiaryBankCode != null
              && transaction.beneficiaryBankCode?.isNotEmpty == true
              && transaction.beneficiaryBankName != null
              && transaction.beneficiaryBankName?.isNotEmpty == true;
        }
        return false;
      case TransactionCategory.BILL_PAYMENT:
        return false;
      case TransactionCategory.AIRTIME:
        // if(transaction.type == TransactionType.DEBIT) {
        //   print("${transaction.providerIdentifier}");
        //   print("${transaction.providerName}");
        //   return transaction.providerIdentifier != null
        //       && transaction.providerIdentifier?.isNotEmpty == true
        //       && transaction.providerName != null
        //       && transaction.providerName?.isNotEmpty == true;
        // }
        return false;
      case TransactionCategory.DATA:
        return false;
      case TransactionCategory.CARD_LINKING:
        return false;
      case TransactionCategory.CARD_PURCHASE:
        return false;
      case TransactionCategory.DEFAULT:
        return false;
      default:
        return false;
    }
  }

  Widget _contentView () => Wrap(
    alignment: WrapAlignment.spaceEvenly,
    spacing: 47,
    runSpacing: 47,
    children: [
      // _OptionItem(
      //   title: "Dispute",
      //   iconBackgroundColor: Colors.red.withOpacity(0.1),
      //   icon: SvgPicture.asset("res/drawables/ic_bank_number_input.svg", color: Colors.red,),
      //   isVisible: false,
      //   onItemClick: null,
      // ),
      if(_canReplayTransaction())
        _OptionItem(
          title: "Do Again",
          iconBackgroundColor: Colors.primaryColor.withOpacity(0.1),
          isVisible: true,
          onItemClick: _isSharingReceipt || _isDownloadingReceipt ? null : _replayTransaction,
          icon: SvgPicture.asset(
              "res/drawables/ic_replay_transaction.svg",
              color: _isSharingReceipt || _isDownloadingReceipt
                  ? Colors.grey.withOpacity(0.4)
                  : Colors.primaryColor
          ),
        ),
      if(_canDownloadOrShareReceipt())
        _OptionItem(
          title: "Download",
          iconBackgroundColor: Colors.primaryColor.withOpacity(0.1),
          icon: SvgPicture.asset(
              "res/drawables/ic_download_receipt.svg",
              color: _isSharingReceipt ? Colors.grey.withOpacity(0.4) :Colors.primaryColor
          ),
          isVisible: true,
          isLoading: _isDownloadingReceipt,
          onItemClick: _isSharingReceipt ? null : () => _onDownload(false),
        ),
      if(_canDownloadOrShareReceipt())
        _OptionItem(
        title: "Share",
        iconBackgroundColor: Colors.primaryColor.withOpacity(0.1),
        isLoading: _isSharingReceipt,
        icon: SvgPicture.asset(
          "res/drawables/ic_share_receipt.svg",
          color: _isDownloadingReceipt ? Colors.grey.withOpacity(0.4) :Colors.primaryColor
          ,),
        onItemClick: _isDownloadingReceipt ? null :  () => _onDownload(true),
      ),
    ],
  );

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: Container(
        padding: EdgeInsets.only(left: 13, right: 13),
        child: _contentView(),
      ),
    );
  }

}

class _OptionItem extends StatelessWidget {

  _OptionItem({
    required this.title,
    required this.iconBackgroundColor,
    required this.icon,
    required this.onItemClick,
    this.isVisible = true,
    this.isLoading = false
  });

  final String title;
  final Color iconBackgroundColor;
  final Widget icon;
  final bool isVisible;
  final VoidCallback? onItemClick;
  final bool isLoading;

  @override
  Widget build(BuildContext context) {
    if(!isVisible) return SizedBox();
    return Container(
      child: Column(
        children: [
          Stack(
            children: [
              Container(
                width: 51,
                height: 51,
                child: Material(
                  color: Colors.transparent,
                  child: InkWell(
                    borderRadius: BorderRadius.circular(100),
                    onTap: (!isLoading) ? onItemClick : null,
                    child: Container(
                      decoration: BoxDecoration(
                          color: (onItemClick == null) ? Colors.grey.withOpacity(0.2) : iconBackgroundColor,
                          shape: BoxShape.circle
                      ),
                      padding: EdgeInsets.all(10),
                      child: (isLoading)
                          ? SpinKitThreeBounce(size: 20.0, color: Colors.primaryColor.withOpacity(0.9))
                          : icon,
                    ),
                  ),
                ),
              )
            ],
          ),
          SizedBox(height: 8),
          Text(
            title,
            style: TextStyle(
              fontWeight: FontWeight.w600,
              fontSize: 13,
              color: onItemClick == null ? Colors.grey.withOpacity(0.4) : Colors.textColorBlack
            ),
          )
        ],
      ),
    );
  }

}