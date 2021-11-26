import 'package:collection/src/iterable_extensions.dart';
import 'package:flutter/material.dart' hide Colors, ScrollView;
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:moniepoint_flutter/app/accounts/views/account_transaction_detailed_view.dart';
import 'package:moniepoint_flutter/app/billpayments/model/data/bill_transaction.dart';
import 'package:moniepoint_flutter/app/billpayments/viewmodels/bill_history_detail_view_model.dart';
import 'package:moniepoint_flutter/app/billpayments/views/bill_history_list_item.dart';
import 'package:moniepoint_flutter/app/billpayments/views/biller_logo.dart';
import 'package:moniepoint_flutter/core/colors.dart';
import 'package:moniepoint_flutter/core/styles.dart';
import 'package:moniepoint_flutter/core/views/icon_curved_container.dart';
import 'package:moniepoint_flutter/core/views/scroll_view.dart';
import 'package:moniepoint_flutter/core/views/sessioned_widget.dart';
import 'package:provider/provider.dart';
import 'package:moniepoint_flutter/core/utils/currency_util.dart';

class BillHistoryDetailedView extends StatefulWidget {

  BillHistoryDetailedView();

  @override
  State<StatefulWidget> createState() => _BillHistoryDetailedView();

}

class _BillHistoryDetailedView extends State<BillHistoryDetailedView> {

  int? _historyId;

  List<Widget> _generateTransactionDetailsItems(BillTransaction transaction) {
    final items = [
      TransactionDetailViewItem(
        label: "Product",
        value: "${transaction.billerProductName ?? ""}",
        valueTextWeight: FontWeight.w600,
      ),
      TransactionDetailViewItem(
        label: "Amount",
        value: "${transaction.getAmount().formatCurrency}",
        valueTextWeight: FontWeight.w600,
      ),
      TransactionDetailViewItem(
        label: "${transaction.customerIdName ?? "Customer ID"}",
        value: "${transaction.customerId}",
        valueTextWeight: FontWeight.w600,
      ),
      TransactionDetailViewItem(
        label: "Transaction Date",
        value: "${transaction.transactionDateToString()}",
        valueTextWeight: FontWeight.w600,
      ),
      _BillTokenDisplayItem(transaction: transaction,)
    ];

    final padding = EdgeInsets.only(left: 16, right: 16);
    final List<Widget> viewItems = items.foldIndexed(<Widget>[], (index, previous, element) {
      if(element.shouldDisplay()) previous.add(Padding(padding: padding, child: element,));
      if(index != items.length - 1 && element.shouldDisplay()) {
        previous.add(
            Padding(
              padding: padding,
              child: Divider(height: 1, color: Colors.primaryColor.withOpacity(0.2))
            )
        );
      }
      return previous;
    });

    if(viewItems.isNotEmpty && viewItems.lastOrNull is Padding) {
      final parent = viewItems.lastOrNull as Padding;
      if(parent.child is Divider) viewItems.removeLast();
    }
    return viewItems;
  }

  @override
  Widget build(BuildContext context) {
    final viewModel = Provider.of<BillHistoryDetailViewModel>(context);
    this._historyId = ModalRoute.of(context)!.settings.arguments as int?;

    return Scaffold(
      appBar: AppBar(
          leadingWidth: 69,
          centerTitle: false,
          titleSpacing: -12,
          iconTheme: IconThemeData(color: Colors.primaryColor),
          title: Text(
              'Bill Payment Details',
              textAlign: TextAlign.start,
              style: TextStyle(
                  color: Colors.darkBlue,
                  fontFamily: Styles.defaultFont,
                  fontSize: 17
              )
          ),
          backgroundColor: Color(0XFFE8EFFA).withOpacity(0.52),
          elevation: 0
      ),
      backgroundColor: Colors.white,
      body: SessionedWidget(
          context: context,
          child: Container(
            color: Color(0XFFE8EFFA).withOpacity(0.52),
            child: ScrollView(
              child: FutureBuilder(
                future: viewModel.getSingleTransactionById(this._historyId ?? 0),
                builder: (BuildContext context, AsyncSnapshot<BillTransaction?> snapshot) {
                  if(!snapshot.hasData || snapshot.data == null) return Container();
                  final transaction = snapshot.data!;

                  return Wrap(
                    children: [
                      Container(
                        margin: EdgeInsets.only(top: 24, right: 20, left: 20, bottom: 16),
                        padding: EdgeInsets.only(top: 16),
                        decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(16)
                        ),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                SizedBox(width: 16),
                                IconCurvedContainer(
                                    backgroundColor: Colors.white,
                                    child: UUIDImage(
                                      fileStreamFn: viewModel.getFile,
                                      fileUUID: transaction.billerLogoUUID,
                                    )
                                ),
                                SizedBox(width: 15),
                                Expanded(child: Text(
                                  "${transaction.billerName}",
                                  style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.w600,
                                      color: Colors.textColorBlack
                                  ),
                                )),
                                BillHistoryListItem.transactionStatusView(transaction),
                                SizedBox(width: 16,),
                              ],
                            ),
                            SizedBox(height: 16),
                            Divider(height: 0.9, color: Colors.black.withOpacity(0.1)),
                            ..._generateTransactionDetailsItems(transaction)
                          ],
                        ),
                      )
                    ],
                  );
                },
              ),
            ),
          ),
      ),
    );
  }

}

///_BillTokenDisplayItem
///
///
///
class _BillTokenDisplayItem extends TransactionDetailDisplayable {

  _BillTokenDisplayItem({required this.transaction});

  final BillTransaction transaction;

  @override
  Widget build(BuildContext context) {
    final token = transaction.token;
    if(token == null || token.isEmpty) return SizedBox();
    return Container(
      width: double.infinity,
      margin: EdgeInsets.only(top: 19, bottom: 19),
      padding: EdgeInsets.only(left: 15, right: 15, top: 17, bottom: 8),
      decoration: BoxDecoration(
        color: Color(0XFFAFC9F6).withOpacity(0.15),
        borderRadius: BorderRadius.circular(4)
      ),
      child: Column(
        children: [
          Text(
            "Token Number",
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w500,
              color: Colors.textColorBlack
            ),
          ),
          SizedBox(height: 10,),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 26, vertical: 16),
            decoration: BoxDecoration(
                color: Color(0XFFAFC9F6).withOpacity(0.28),
                borderRadius: BorderRadius.circular(4)
            ),
            child: Text(
              "$token",
              style: TextStyle(
                color: Colors.textColorBlack,
                fontWeight: FontWeight.w700
              ),
            ),
          ),
          SizedBox(height: 6),
          TextButton.icon(
              onPressed: () {
                Clipboard.setData(ClipboardData(text: token));
                ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text("Copied to Clipboard!"))
                );
              },
              icon: SvgPicture.asset('res/drawables/ic_copy_full.svg', color: Colors.primaryColor,),
              label: Text('Copy', style: TextStyle(color: Colors.primaryColor, fontWeight: FontWeight.w500, fontSize: 15),)
          )
        ],
      ),
    );
  }

  @override
  bool shouldDisplay() {
    final token = this.transaction.token;
    return token != null && token.isNotEmpty == true;
  }

}
