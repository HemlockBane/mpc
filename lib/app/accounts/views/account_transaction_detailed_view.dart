import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart' hide Colors, ScrollView;
import 'package:intl/intl.dart';
import 'package:moniepoint_flutter/app/accounts/model/data/account_transaction.dart';
import 'package:moniepoint_flutter/app/accounts/viewmodels/account_transaction_detail_view_model.dart';
import 'package:moniepoint_flutter/core/colors.dart';
import 'package:moniepoint_flutter/core/models/transaction.dart';
import 'package:moniepoint_flutter/core/styles.dart';
import 'package:moniepoint_flutter/core/tuple.dart';
import 'package:moniepoint_flutter/core/views/scroll_view.dart';
import 'package:moniepoint_flutter/core/views/sessioned_widget.dart';
import 'package:moniepoint_flutter/core/views/transaction_options_view.dart';
import 'package:provider/provider.dart';
import 'package:moniepoint_flutter/core/utils/currency_util.dart';
import 'package:moniepoint_flutter/core/utils/text_utils.dart';

class AccountTransactionDetailedView extends StatefulWidget {

  AccountTransactionDetailedView();

  @override
  State<StatefulWidget> createState() => _AccountTransactionDetailedView();

}

class _AccountTransactionDetailedView extends State<AccountTransactionDetailedView> {

  String? _transactionReference;

  @override
  Widget build(BuildContext context) {
    final viewModel = Provider.of<AccountTransactionDetailViewModel>(context);
    this._transactionReference = ModalRoute.of(context)!.settings.arguments as String?;

    return Scaffold(
      appBar: AppBar(
          leadingWidth: 69,
          centerTitle: false,
          titleSpacing: -12,
          iconTheme: IconThemeData(color: Colors.primaryColor),
          title: Text('Transaction Details',
              textAlign: TextAlign.start,
              style: TextStyle(
                  color: Colors.darkBlue,
                  fontFamily: Styles.defaultFont,
                  fontSize: 17
              )
          ),
          backgroundColor: Colors.backgroundWhite,
          elevation: 0
      ),
      body: SessionedWidget(
          context: context,
          child: ScrollView(
            child: FutureBuilder(
              future: viewModel.getSingleTransactionById(this._transactionReference ?? ""),
              builder: (BuildContext context, AsyncSnapshot<AccountTransaction?> snapshot) {
                if(!snapshot.hasData || snapshot.data == null) return Container();
                final transaction = snapshot.data!;
                final transactionDate = DateFormat("d MMMM yyyy | h:mm a").format(DateTime.fromMillisecondsSinceEpoch(transaction.getInitiatedDate()));
                final balanceBefore = double.tryParse(transaction.runningBalance ?? "")?.formatCurrency ?? "";
                final balanceAfter = double.tryParse(transaction.balanceAfter ?? "")?.formatCurrency ?? "";

                return Container(
                  color: Colors.backgroundWhite,
                  padding: EdgeInsets.only(top: 24, bottom: 24),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: EdgeInsets.only(left: 24, right: 24),
                        child: Text('Amount', style: TextStyle(fontSize: 14, color: Colors.colorPrimaryDark),),
                      ),
                      SizedBox(height: 1),
                      Flexible(
                        child: Padding(
                          padding: EdgeInsets.only(left: 24, right: 24),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Text(
                                  transaction.getAmount().formatCurrency,
                                  style: TextStyle(
                                      fontSize: 30,
                                      color: (transaction.type == TransactionType.DEBIT) ? Colors.red : Colors.solidGreen,
                                      fontWeight: FontWeight.bold
                                  )),
                              SizedBox(width: 24,),
                              Container(
                                padding: EdgeInsets.all(4),
                                decoration: BoxDecoration(
                                    color: Color(0XFFF2F2F2),
                                    borderRadius: BorderRadius.circular(4)
                                ),
                                child: Text(
                                    describeEnum(transaction.type ?? TransactionType.UNKNOWN),
                                    style: TextStyle(
                                        color: (transaction.type == TransactionType.DEBIT) ? Colors.red : Colors.solidGreen,
                                        fontSize: 12,
                                        fontWeight: FontWeight.w600
                                    )
                                ),
                              )
                            ],
                          ),
                        ),
                      ),
                      SizedBox(height: 12),
                      Flexible(
                          child: Padding(
                            padding: EdgeInsets.only(left: 24, right: 24),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text("Balance Before: $balanceBefore",
                                    overflow: TextOverflow.ellipsis,
                                    maxLines: 1,
                                    style: TextStyle(fontSize: 12, color: Colors.colorPrimaryDark, fontWeight: FontWeight.normal)
                                ).colorText({balanceBefore: Tuple(Colors.colorPrimaryDark, null)}, underline: false),
                                SizedBox(width: 8,),
                                Text(
                                  "Balance After: $balanceAfter",
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(fontSize: 12, color: Colors.colorPrimaryDark, fontWeight: FontWeight.normal),
                                ).colorText({balanceAfter: Tuple(Colors.colorPrimaryDark, null)}, underline: false),
                              ],
                            ),
                          )
                      ),
                      SizedBox(height: 12),
                      Divider(height: 1, color: Colors.dashboardDivider.withOpacity(0.1),),
                      Flexible(
                          child: Padding(
                            padding: EdgeInsets.only(top: 20, bottom: 20, left: 24, right: 24),
                            child: Row(
                              children: [
                                Expanded(flex:1, child: Text('Trans. Date:', style: TextStyle(color: Colors.deepGrey, fontSize: 16))),
                                Expanded(flex:2,child: Text(transactionDate, style: TextStyle(color: Colors.colorPrimaryDark, fontSize: 16)))
                              ],
                            ),
                          )
                      ),
                      Visibility(
                          visible: transaction.transactionChannel != null,
                          child: Padding(
                            padding: EdgeInsets.only(left: 24, right: 24),
                            child: Divider(height: 1, color: Colors.dashboardDivider.withOpacity(0.1),),
                          )
                      ),
                      Visibility(
                          visible: transaction.transactionChannel != null,
                          child: Flexible(
                              child: Padding(
                                padding: EdgeInsets.only(top: 20, bottom: 20, left: 24, right: 24),
                                child: Row(
                                  children: [
                                    Flexible(flex:1, fit: FlexFit.tight, child: Text('Channel:', style: TextStyle(color: Colors.deepGrey, fontSize: 16))),
                                    Flexible(flex:2, fit: FlexFit.loose,
                                        child: Container(
                                          padding: EdgeInsets.all(4),
                                          decoration: BoxDecoration(
                                              color: Color(0XFFF2F2F2),
                                              borderRadius: BorderRadius.circular(4)
                                          ),
                                          child: Text(transaction.getTransactionChannelValue(), style: TextStyle(color: Colors.primaryColor, fontSize: 16)),
                                        )
                                    )
                                  ],
                                ),
                              )
                          )),
                      // Visibility(
                      //   visible: transaction.transfer?.sinkAccountName?.isNotEmpty == true,
                      //   child: Padding(
                      //     padding: EdgeInsets.only(left: 24, right: 24),
                      //     child: Divider(height: 1, color: Colors.dashboardDivider.withOpacity(0.1),),
                      //   )
                      // ),
                      // Visibility(
                      //     visible: transaction.transfer?.sinkAccountName?.isNotEmpty == true,
                      //     child: Expanded(
                      //         flex: 0,
                      //         child: Padding(
                      //           padding: EdgeInsets.only(top: 12, bottom: 12, left: 24, right: 24),
                      //           child: Row(
                      //             crossAxisAlignment: CrossAxisAlignment.center,
                      //             children: [
                      //               Expanded(
                      //                   flex: 1,
                      //                   child: Text('Recipient:', style: TextStyle(color: Colors.deepGrey, fontSize: 16),)
                      //               ),
                      //               Expanded(
                      //                   flex: 2,
                      //                   child: Column(
                      //                     crossAxisAlignment: CrossAxisAlignment.start,
                      //                     children: [
                      //                       Text(transaction.transfer?.sinkAccountName ?? "", style: TextStyle(color: Colors.colorPrimaryDark, fontSize: 16),),
                      //                       Text("${transaction.transfer?.sinkAccountProviderName}   ${transaction.transfer?.sinkAccountNumber}", style: TextStyle(color: Colors.deepGrey, fontSize: 16),),
                      //                     ],
                      //                   )
                      //               ),
                      //             ],
                      //           ),
                      //         )
                      //     )),
                      Visibility(
                          visible: transaction.transactionRef.isNotEmpty == true,
                          child: Padding(
                            padding: EdgeInsets.only(left: 24, right: 24),
                            child: Divider(height: 1, color: Colors.dashboardDivider.withOpacity(0.1),),
                          )
                      ),
                      Visibility(
                          visible: transaction.transactionRef.isNotEmpty == true,
                          child: Expanded(
                              flex: 0,
                              child: Padding(
                                padding: EdgeInsets.only(top: 20, bottom: 20, left: 24, right: 24),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Expanded(
                                        flex: 1,
                                        child: Text('Trans. Ref:', style: TextStyle(color: Colors.deepGrey, fontSize: 16),)
                                    ),
                                    Expanded(
                                      flex: 2,
                                      child: Text(transaction.transactionRef, style: TextStyle(color: Colors.colorPrimaryDark, fontSize: 16),),
                                    ),
                                  ],
                                ),
                              )
                          )),
                      Visibility(
                          visible: transaction.narration?.isNotEmpty == true,
                          child: Padding(
                            padding: EdgeInsets.only(left: 24, right: 24),
                            child: Divider(height: 1, color: Colors.dashboardDivider.withOpacity(0.1),),
                          )
                      ),
                      Visibility(
                          visible: transaction.narration?.isNotEmpty == true,
                          child: Expanded(
                              flex: 0,
                              child: Padding(
                                padding: EdgeInsets.only(top: 20, bottom: 20, left: 24, right: 24),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Expanded(
                                        flex: 1,
                                        child: Text('Narration:', style: TextStyle(color: Colors.deepGrey, fontSize: 16),)
                                    ),
                                    Expanded(
                                      flex: 2,
                                      child: Text(transaction.narration ?? "", style: TextStyle(color: Colors.colorPrimaryDark, fontSize: 16),),
                                    ),
                                  ],
                                ),
                              )
                          )),
                      // Visibility(
                      //     visible: transaction.transfer?.narration?.isNotEmpty == true,
                      //     child: Padding(
                      //       padding: EdgeInsets.only(left: 24, right: 24),
                      //       child: Divider(height: 1, color: Colors.dashboardDivider.withOpacity(0.1),),
                      //     )
                      // ),
                      SizedBox(height: 18),
                      Divider(height: 1, color: Colors.dashboardDivider.withOpacity(0.15)),
                      SizedBox(height: 24),
                      Expanded(child:  TransactionOptionsView(displayReplayTransaction: false))
                    ],
                  ),
                );
              },
            ),
          ),
      ),
    );
  }

}