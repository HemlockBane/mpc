import 'package:flutter/material.dart' hide Colors;
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';
import 'package:moniepoint_flutter/app/accounts/model/data/account_transaction.dart';
import 'package:moniepoint_flutter/app/accounts/viewmodels/account_transaction_detail_view_model.dart';
import 'package:moniepoint_flutter/core/colors.dart';
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


  String _getDownloadReceiptName() {
    return "AccountTransaction_Receipt_${widget.viewModel.accountName}"
        "_${DateFormat("dd_MM_yyyy_h_m_s").format(DateTime.now())}.pdf";
  }

  AccountTransaction _getTransactionForDownload() {
    final mTransaction = widget.transaction.toJson();
    mTransaction["accountNumber"] = widget.accountNumber;
    mTransaction["amount"] = widget.transaction.amount! * 100;
    mTransaction["transactionDate"] = DateTime
        .fromMillisecondsSinceEpoch(widget.transaction.transactionDate).toString();
    mTransaction["location"] = null;
    return AccountTransaction.fromJson(mTransaction);
  }

  Widget _contentView () => Wrap(
    alignment: WrapAlignment.spaceBetween,
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
      _OptionItem(
        title: "Do Again",
        iconBackgroundColor: Colors.primaryColor.withOpacity(0.1),
        icon: SvgPicture.asset("res/drawables/ic_replay_transaction.svg", color: Colors.primaryColor,),
        isVisible: true,
        onItemClick: null,
      ),
      _OptionItem(
        title: "Download",
        iconBackgroundColor: Colors.primaryColor.withOpacity(0.1),
        icon: SvgPicture.asset("res/drawables/ic_download_receipt.svg", color: Colors.primaryColor,),
        isVisible: true,
        onItemClick: () {
          DownloadUtil.downloadTransactionReceipt(
                  () => widget.viewModel.downloadTransactionReceipt(_getTransactionForDownload()),
              _getDownloadReceiptName(),
              isShare : false
          );
        },
      ),
      _OptionItem(
        title: "Share",
        iconBackgroundColor: Colors.primaryColor.withOpacity(0.1),
        icon: SvgPicture.asset("res/drawables/ic_share_receipt.svg", color: Colors.primaryColor,),
        onItemClick: () {
          DownloadUtil.downloadTransactionReceipt(
                  () => widget.viewModel.downloadTransactionReceipt(_getTransactionForDownload()),
              _getDownloadReceiptName()
          );
        },
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
  });

  final String title;
  final Color iconBackgroundColor;
  final Widget icon;
  final bool isVisible;
  final VoidCallback? onItemClick;

  @override
  Widget build(BuildContext context) {
    if(!isVisible) return SizedBox();
    return Container(
      child: Column(
        children: [
          Stack(
            children: [
             // SizedBox(
             //    width: 40,
             //    height: 40,
             //    child: CircularProgressIndicator(
             //      strokeWidth: 2,
             //      valueColor: AlwaysStoppedAnimation(Colors.colorPrimaryDark.withOpacity(0.5)),
             //      backgroundColor: Colors.grey.withOpacity(0.1),
             //    ),
             //  ),
              Container(
                width: 51,
                height: 51,
                child: Material(
                  color: Colors.transparent,
                  child: InkWell(
                    borderRadius: BorderRadius.circular(100),
                    onTap: onItemClick,
                    child: Container(
                      decoration: BoxDecoration(
                          color: iconBackgroundColor,
                          shape: BoxShape.circle
                      ),
                      padding: EdgeInsets.all(10),
                      child: icon,
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
              fontSize: 13
            ),
          )
        ],
      ),
    );
  }

}