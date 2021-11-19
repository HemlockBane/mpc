import 'package:flutter/material.dart' hide Colors;
import 'package:flutter_svg/svg.dart';
import 'package:moniepoint_flutter/app/billpayments/model/data/bill_transaction.dart';
import 'package:moniepoint_flutter/app/billpayments/views/biller_logo.dart';
import 'package:moniepoint_flutter/core/colors.dart';
import 'package:moniepoint_flutter/core/constants.dart';
import 'package:moniepoint_flutter/core/models/file_result.dart';
import 'package:moniepoint_flutter/core/network/resource.dart';
import 'package:moniepoint_flutter/core/styles.dart';
import 'package:moniepoint_flutter/core/utils/currency_util.dart';
import 'package:moniepoint_flutter/core/utils/time_ago.dart';
import 'package:moniepoint_flutter/core/views/icon_curved_container.dart';

class BillHistoryListItem extends Container {

  final BillTransaction _transaction;
  final int position;
  final OnItemClickListener<BillTransaction, int>? _onItemClickListener;
  final Stream<Resource<FileResult>> Function(String logoId) _fileStreamFn;

  BillHistoryListItem({
    required BillTransaction transaction,
    required int position,
    required onItemClickListener,
    required Stream<Resource<FileResult>> Function(String logoId) fileStreamFn
  }) : _transaction = transaction,
        position = position,
        _onItemClickListener = onItemClickListener,
        _fileStreamFn = fileStreamFn;


  Widget initialView() {
    return Container(
      width: 36,
      height: 36,
      padding: EdgeInsets.all(5),
      decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: Colors.darkBlue.withOpacity(0.09)
      ),
      child: Center(
        child: SvgPicture.asset('res/drawables/ic_list_transaction_time.svg', width: 19, height: 19,),
      ),
    );
  }

  static Widget transactionStatusView(BillTransaction transaction) {
    Color bgColor = Color(0XFF6BF003);
    Color textColor = Colors.solidGreen;
    String? transactionStatus = transaction.transactionStatus;
    String status = "";


    if(transactionStatus == Constants.APPROVED
        || transactionStatus == Constants.COMPLETED) {
      status = "SUCCESS";
      bgColor = Color(0XFF6BF003);
      textColor = Colors.solidGreen;
    } else if(transactionStatus == Constants.PENDING) {
      status = "PENDING";
      bgColor = Color(0XFFF0BC03);
      textColor = Colors.red;
    } else if(transactionStatus == Constants.FAILED) {
      status = "FAILED";
      bgColor = Color(0XFFF00303);
      textColor = Colors.solidOrange;
    }

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
          shape: BoxShape.rectangle,
          color: bgColor.withOpacity(0.14),
          borderRadius: BorderRadius.circular(4)
      ),
      child: Center(
        child: Text(
          status,
          style: TextStyle(
            fontSize: 10,
            color: textColor,
            fontWeight: FontWeight.w700
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) => Material(
    color: Colors.transparent,
    child: InkWell(
      onTap: () => _onItemClickListener?.call(_transaction, position),
      child: Container(
        padding: EdgeInsets.only(left: 16, right: 16, top: 20, bottom: 20),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            IconCurvedContainer(
                width: 50,
                height: 50,
                backgroundColor: Colors.deepGrey.withOpacity(0.1),
                padding: EdgeInsets.all(1),
                child: IconCurvedContainer(
                    backgroundColor: Colors.white,
                    child: UUIDImage(
                      fileStreamFn: _fileStreamFn,
                      fileUUID: _transaction.billerLogoUUID,
                    )
                )
            ),
            SizedBox(width: 7),
            Expanded(
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                          _transaction.getAmount().formatCurrency,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(fontSize: 17, color: Colors.textColorBlack, fontWeight: FontWeight.w800)
                      ),
                      SizedBox(height: 3),
                      Text(
                          "${_transaction.billerName ?? ""} | ${_transaction.billerProductName ?? ""}",
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(fontSize: 13, color: Colors.deepGrey, fontWeight: FontWeight.normal)
                      )
                    ]
                )
            ),
            SizedBox(width: 16),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                transactionStatusView(_transaction),
                SizedBox(height: 6),
                Text(TimeAgo.formatDuration(_transaction.transactionTime ?? 0),
                    style: TextStyle(color: Colors.deepGrey, fontSize: 13)
                )
              ],
            ),
            SizedBox(width: 2),
          ],
        ),
      ),
    ),
  );
}