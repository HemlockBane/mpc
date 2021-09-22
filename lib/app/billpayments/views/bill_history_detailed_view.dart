import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart' hide Colors, ScrollView;
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:intl/intl.dart';
import 'package:moniepoint_flutter/app/billpayments/model/data/bill_transaction.dart';
import 'package:moniepoint_flutter/app/billpayments/viewmodels/bill_history_detail_view_model.dart';
import 'package:moniepoint_flutter/core/views/bottom_sheet.dart';
import 'package:moniepoint_flutter/core/colors.dart';
import 'package:moniepoint_flutter/core/models/transaction.dart';
import 'package:moniepoint_flutter/core/styles.dart';
import 'package:moniepoint_flutter/core/tuple.dart';
import 'package:moniepoint_flutter/core/utils/download_util.dart';
import 'package:moniepoint_flutter/core/views/scroll_view.dart';
import 'package:moniepoint_flutter/core/views/sessioned_widget.dart';
import 'package:moniepoint_flutter/core/views/transaction_location_view.dart';
import 'package:moniepoint_flutter/core/views/transaction_options_view.dart';
import 'package:provider/provider.dart';
import 'package:moniepoint_flutter/core/utils/currency_util.dart';

class BillHistoryDetailedView extends StatefulWidget {

  BillHistoryDetailedView();

  @override
  State<StatefulWidget> createState() => _BillHistoryDetailedView();

}

class _BillHistoryDetailedView extends State<BillHistoryDetailedView> {

  int? _historyId;

  LatLng? _transactionLocation(BillTransaction transaction) {
    print(transaction.institutionBill?.metaData?.location);
    return (transaction.institutionBill?.metaData?.location != null)
        ? LatLng(double.tryParse(
        transaction.institutionBill?.metaData?.location?.latitude ?? "0.0") ?? 0.0,
        double.tryParse(transaction.institutionBill?.metaData?.location?.longitude ?? "0.0") ?? 0.0
    )
        : null;
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
          title: Text('Bill Transaction Details',
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
              future: viewModel.getSingleTransactionById(this._historyId ?? 0),
              builder: (BuildContext context, AsyncSnapshot<BillTransaction?> snapshot) {
                if(!snapshot.hasData || snapshot.data == null) return Container();
                final transaction = snapshot.data!;
                final transactionDate = DateFormat("d MMMM yyyy | h:mm a").format(DateTime.fromMillisecondsSinceEpoch(transaction.getInitiatedDate()));
                final downloadTask = Tuple(() => viewModel.downloadReceipt(transaction.batchId),  "BillTransaction_Receipt_${viewModel.accountName}_${DateFormat("dd_MM_yyyy_h_m_s").format(DateTime.now())}.pdf");
                final transactionLocation = _transactionLocation(transaction);

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
                              Text(transaction.getAmount().formatCurrency, style: TextStyle(fontSize: 30, color: Colors.colorPrimaryDark, fontWeight: FontWeight.bold),),
                              SizedBox(width: 24,),
                              Container(
                                padding: EdgeInsets.all(4),
                                decoration: BoxDecoration(
                                    color: Color(0XFFF2F2F2),
                                    borderRadius: BorderRadius.circular(4)
                                ),
                                child: Text(
                                    describeEnum(transaction.getPaymentType()),
                                    style: TextStyle(
                                        color: (transaction.getType() == TransactionType.DEBIT) ? Colors.red : Colors.solidGreen,
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
                          visible: transaction.bill?.channel?.isNotEmpty == true,
                          child: Padding(
                            padding: EdgeInsets.only(left: 24, right: 24),
                            child: Divider(height: 1, color: Colors.dashboardDivider.withOpacity(0.1),),
                          )
                      ),
                      Visibility(
                          visible: transaction.bill?.channel?.isNotEmpty == true,
                          child: Flexible(
                              child: Padding(
                                padding: EdgeInsets.only(top: 20, bottom: 20, left: 24, right: 24),
                                child: Row(
                                  children: [
                                    Flexible(flex:1, fit: FlexFit.tight, child: Text('Channel:', style: TextStyle(color: Colors.deepGrey, fontSize: 16))),
                                    Flexible(
                                        flex:2,
                                        fit: FlexFit.loose,
                                        child: Container(
                                          padding: EdgeInsets.all(4),
                                          decoration: BoxDecoration(
                                              color: Color(0XFFF2F2F2),
                                              borderRadius: BorderRadius.circular(4)
                                          ),
                                          child: Text(transaction.bill?.channel ?? "", style: TextStyle(color: Colors.primaryColor,fontWeight: FontWeight.w600, fontSize: 13)),
                                        )
                                    )
                                  ],
                                ),
                              )
                          )),
                      Visibility(
                          visible: transaction.getSinkAccountName().isNotEmpty == true,
                          child: Padding(
                            padding: EdgeInsets.only(left: 24, right: 24),
                            child: Divider(height: 1, color: Colors.dashboardDivider.withOpacity(0.1),),
                          )
                      ),
                      Visibility(
                          visible: transaction.getSinkAccountName().isNotEmpty == true,
                          child: Expanded(
                              flex: 0,
                              child: Padding(
                                padding: EdgeInsets.only(top: 12, bottom: 12, left: 24, right: 24),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Expanded(
                                        flex: 1,
                                        child: Text('Recipient:', style: TextStyle(color: Colors.deepGrey, fontSize: 16),)
                                    ),
                                    Expanded(
                                        flex: 2,
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Text(transaction.getSinkAccountName(), style: TextStyle(color: Colors.colorPrimaryDark, fontSize: 16),),
                                            Text("${transaction.bill?.billProduct?.name} ${transaction.getSinkAccountNumber()}", style: TextStyle(color: Colors.deepGrey, fontSize: 16),),
                                          ],
                                        )
                                    ),
                                  ],
                                ),
                              )
                          )
                      ),
                      Visibility(
                          visible: transaction.institutionBill?.token?.isNotEmpty == true,
                          child: Padding(
                            padding: EdgeInsets.only(left: 24, right: 24),
                            child: Divider(height: 1, color: Colors.dashboardDivider.withOpacity(0.1),),
                          )
                      ),
                      Visibility(
                          visible: transaction.institutionBill?.token?.isNotEmpty == true,
                          child: Expanded(
                              flex: 0,
                              child: Padding(
                                padding: EdgeInsets.only(top: 12, bottom: 12, left: 24, right: 24),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Expanded(
                                        flex: 1,
                                        child: Text('Token:', style: TextStyle(color: Colors.deepGrey, fontSize: 16),)
                                    ),
                                    Expanded(
                                        flex: 2,
                                        child: Row(
                                          crossAxisAlignment: CrossAxisAlignment.center,
                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text(transaction.institutionBill?.token ?? "", style: TextStyle(color: Colors.colorPrimaryDark, fontSize: 16),),
                                            Container(
                                              decoration: BoxDecoration(
                                                borderRadius: BorderRadius.circular(4),
                                                color: Colors.solidOrange.withOpacity(0.12)
                                              ),
                                              child: Material(
                                                color: Colors.transparent,
                                                child: InkWell(
                                                  highlightColor: Colors.solidOrange.withOpacity(0.1),
                                                  overlayColor: MaterialStateProperty.all(Colors.solidOrange.withOpacity(0.2)),
                                                  borderRadius: BorderRadius.circular(4),
                                                  onTap: () => Clipboard.setData(ClipboardData(text: transaction.institutionBill?.token ?? "")),
                                                  child: Container(
                                                    padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                                                    child: Column(
                                                      children: [
                                                        SvgPicture.asset('res/drawables/ic_copy.svg', color: Colors.solidOrange,),
                                                        SizedBox(height: 2,),
                                                        Text('Copy', style: TextStyle(color: Colors.solidOrange, fontWeight: FontWeight.w600, fontSize: 12),)
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ],
                                        )
                                    ),
                                  ],
                                ),
                              )
                          )
                      ),
                      Visibility(
                          visible: transactionLocation != null,
                          child: Padding(
                            padding: EdgeInsets.only(left: 24, right: 24),
                            child: Divider(height: 1, color: Colors.dashboardDivider.withOpacity(0.1),),
                          )
                      ),
                      Visibility(
                        visible: transactionLocation != null,
                        child: Expanded(
                          flex: 0,
                          child: Padding(
                            padding: EdgeInsets.only(top: 20, bottom: 20, left: 24, right: 24),
                            child: TransactionLocationView(transactionLocation, transaction.getInitiatorName()),
                          ),
                        ),
                      ),
                      SizedBox(height: 18),
                      Divider(height: 1, color: Colors.dashboardDivider.withOpacity(0.15)),
                      SizedBox(height: 24),
                      Expanded(child:  TransactionOptionsView(
                        displayShareReceipt: downloadTask,
                        displayDownloadReceipt: downloadTask,
                        displayReplayTransaction: false,
                      ))
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