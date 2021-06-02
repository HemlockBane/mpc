import 'package:flutter/material.dart' hide Colors;
import 'package:flutter_svg/svg.dart';
import 'package:moniepoint_flutter/app/airtime/model/data/airtime_transaction.dart';
import 'package:moniepoint_flutter/app/billpayments/model/data/bill_transaction.dart';
import 'package:moniepoint_flutter/app/transfers/model/data/single_transfer_transaction.dart';
import 'package:moniepoint_flutter/core/colors.dart';
import 'package:moniepoint_flutter/core/styles.dart';
import 'package:moniepoint_flutter/core/utils/currency_util.dart';
import 'package:moniepoint_flutter/core/utils/time_ago.dart';

class AirtimeHistoryListItem extends Container {

  final AirtimeTransaction _transaction;
  final int position;
  final OnItemClickListener<AirtimeTransaction, int>? _onItemClickListener;

  AirtimeHistoryListItem(this._transaction, this.position, this._onItemClickListener);


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
            initialView(),
            SizedBox(width: 16),
            Expanded(
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                          _transaction.getAmount().formatCurrency,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(fontSize: 17, color: Colors.solidDarkBlue, fontWeight: FontWeight.bold)
                      ),
                      SizedBox(height: 1),
                      Text(
                          "${_transaction.getComment()}",
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(fontSize: 13, color: Colors.deepGrey, fontWeight: FontWeight.normal)
                      )
                    ]
                )),
            SizedBox(width: 16),
            Text(TimeAgo.formatDuration(_transaction.creationTimeStamp ?? 0),
              style: TextStyle(
                  color: Colors.deepGrey, fontSize: 13
              )),
            SizedBox(width: 2),
          ],
        ),
      ),
    ),
  );
}