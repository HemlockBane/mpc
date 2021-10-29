import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart' hide Colors;
import 'package:flutter_svg/svg.dart';
import 'package:moniepoint_flutter/app/accounts/model/data/account_transaction.dart';
import 'package:moniepoint_flutter/core/colors.dart';
import 'package:moniepoint_flutter/core/models/transaction.dart';
import 'package:moniepoint_flutter/core/styles.dart';
import 'package:moniepoint_flutter/core/utils/currency_util.dart';
import 'package:moniepoint_flutter/core/utils/time_ago.dart';

class TransactionHistoryListItem extends Container {

  final AccountTransaction _transaction;
  final int position;
  final OnItemClickListener<AccountTransaction, int>? _onItemClickListener;
  final Color? pillColor;

  TransactionHistoryListItem(this._transaction, this.position, this._onItemClickListener, {this.pillColor});


  static Widget initialView(TransactionType type) {
    final imageName = (type == TransactionType.CREDIT) ? "ic_transaction_credit.svg" : "ic_transaction_debit.svg";
    return Container(
      width: 40,
      height: 40,
      padding: EdgeInsets.all(5),
      decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: (type == TransactionType.CREDIT)
              ? Colors.solidGreen.withOpacity(0.1)
              : Colors.red.withOpacity(0.1)
      ),
      child: Center(
        child: SvgPicture.asset('res/drawables/$imageName', width: 19, height: 19,),
      ),
    );
  }


  String getArithmeticSign(AccountTransaction trans){
    return trans.type == TransactionType.CREDIT ? "+" : "-";
  }

  Widget getChannelPill(){
    final color = pillColor ?? Colors.primaryColor;
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 7, vertical: 3),
      decoration: BoxDecoration(
        color: color.withOpacity(0.15),
        borderRadius: BorderRadius.circular(4)
      ),
      child: Text(
        _transaction.transactionChannel ?? "",
        style: TextStyle(fontSize: 9.3, color: color, fontWeight: FontWeight.bold),),
    );
  }

  @override
  Widget build(BuildContext context) => Material(
    color: Colors.transparent,
    child: InkWell(
      onTap: () => _onItemClickListener?.call(_transaction, position),
      highlightColor: Colors.grey.withOpacity(0.02),
      overlayColor: MaterialStateProperty.all(Colors.primaryColor.withOpacity(0.05)),
      child: Container(
        padding: EdgeInsets.only(left:24, right:24, top: 24, bottom: 24),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            initialView(_transaction.type ?? TransactionType.UNKNOWN),
            SizedBox(width: 14),
            Expanded(
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                         "${getArithmeticSign(_transaction)}${_transaction.getAmount().formatCurrency}",
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                              fontSize: 17,
                              color: Colors.darkBlue,
                              fontWeight: FontWeight.w800,
                          )
                      ),
                      SizedBox(height: 7),
                      Text(
                          "${_transaction.narration}",
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(fontSize: 10, color: Colors.deepGrey, fontWeight: FontWeight.normal)
                      )
                    ]
                )),
            SizedBox(width: 16),
            Flexible(
                flex: 0,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Visibility(
                        visible: _transaction.transactionChannel != null,
                      // visible: true,
                        child: getChannelPill()
                    ),
                    SizedBox(height: 10),
                    Text(TimeAgo.formatDuration(_transaction.getInitiatedDate()),
                        style: TextStyle(
                            color: Colors.deepGrey, fontSize: 10
                        ))
                  ],
                )
            ),
            SizedBox(width: 2),
          ],
        ),
      ),
    ),
  );
}
