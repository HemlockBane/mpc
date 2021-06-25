
import 'package:flutter/material.dart' hide Colors, ScrollView;
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:intl/intl.dart';
import 'package:moniepoint_flutter/app/transfers/model/data/single_transfer_transaction.dart';
import 'package:moniepoint_flutter/app/transfers/viewmodels/transfer_detail_view_model.dart';
import 'package:moniepoint_flutter/core/colors.dart';
import 'package:moniepoint_flutter/core/styles.dart';
import 'package:moniepoint_flutter/core/tuple.dart';
import 'package:moniepoint_flutter/core/views/scroll_view.dart';
import 'package:moniepoint_flutter/core/views/transaction_location_view.dart';
import 'package:moniepoint_flutter/core/views/transaction_options_view.dart';
import 'package:provider/provider.dart';
import 'package:moniepoint_flutter/core/utils/currency_util.dart';

class TransferDetailedView extends StatefulWidget {

  TransferDetailedView();

  @override
  State<StatefulWidget> createState() => _TransferDetailedView();

}

class _TransferDetailedView extends State<TransferDetailedView> {

  int? _historyId;


  LatLng? _transactionLocation(SingleTransferTransaction transaction) {
    return (transaction.transferBatch?.metaData?.location != null)
        ? LatLng(
            double.tryParse(transaction.transferBatch?.metaData?.location?.latitude ?? "0.0") ?? 0.0,
            double.tryParse(transaction.transferBatch?.metaData?.location?.longitude ?? "0.0") ?? 0.0
          )
        : null;
  }

  @override
  Widget build(BuildContext context) {
    final viewModel = Provider.of<TransferDetailViewModel>(context);
    this._historyId = ModalRoute.of(context)!.settings.arguments as int?;

    return Scaffold(
      appBar: AppBar(
          leadingWidth: 69,
          centerTitle: false,
          titleSpacing: -12,
          iconTheme: IconThemeData(color: Colors.primaryColor),
          title: Text('Transfer Details',
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
      body: ScrollView(
        child: FutureBuilder(
          future: viewModel.getSingleTransactionById(this._historyId ?? 0),
          builder: (BuildContext context, AsyncSnapshot<SingleTransferTransaction?> snapshot) {
            if(!snapshot.hasData || snapshot.data == null) return Container();
            final transaction = snapshot.data!;
            final transactionDate = DateFormat("d MMMM yyyy | h:mm a").format(DateTime.fromMillisecondsSinceEpoch(transaction.getInitiatedDate()));
            final downloadTask = Tuple(() => viewModel.downloadReceipt(transaction.batchId!),  "Transaction_Receipt_${viewModel.accountName}_${DateFormat("dd_MM_yyyy_h_m_s").format(DateTime.now())}.pdf");
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
                      child: Text(transaction.getAmount().formatCurrency, style: TextStyle(fontSize: 30, color: Colors.colorPrimaryDark, fontWeight: FontWeight.bold),),
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
                      visible: transaction.transfer?.channel?.isNotEmpty == true,
                      child: Padding(
                        padding: EdgeInsets.only(left: 24, right: 24),
                        child: Divider(height: 1, color: Colors.dashboardDivider.withOpacity(0.1),),
                      )
                  ),
                  Visibility(
                    visible: transaction.transfer?.channel?.isNotEmpty == true,
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
                                  child: Text(transaction.transfer?.channel ?? "", style: TextStyle(color: Colors.primaryColor, fontWeight: FontWeight.w600, fontSize: 13)),
                                )
                            )
                          ],
                        ),
                      )
                  )),
                  Visibility(
                    visible: transaction.transfer?.sinkAccountName?.isNotEmpty == true,
                    child: Padding(
                      padding: EdgeInsets.only(left: 24, right: 24),
                      child: Divider(height: 1, color: Colors.dashboardDivider.withOpacity(0.1),),
                    )
                  ),
                  Visibility(
                      visible: transaction.transfer?.sinkAccountName?.isNotEmpty == true,
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
                                        Text(transaction.transfer?.sinkAccountName ?? "", style: TextStyle(color: Colors.colorPrimaryDark, fontSize: 16),),
                                        Text("${transaction.transfer?.sinkAccountProviderName}   ${transaction.transfer?.sinkAccountNumber}", style: TextStyle(color: Colors.deepGrey, fontSize: 16),),
                                      ],
                                    )
                                ),
                              ],
                            ),
                          )
                      )),
                  Visibility(
                      visible: transaction.transfer?.narration?.isNotEmpty == true,
                      child: Padding(
                        padding: EdgeInsets.only(left: 24, right: 24),
                        child: Divider(height: 1, color: Colors.dashboardDivider.withOpacity(0.1),),
                      )
                  ),
                  Visibility(
                      visible: transaction.transfer?.narration?.isNotEmpty == true,
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
                                    child: Text(transaction.transfer?.narration ?? "", style: TextStyle(color: Colors.colorPrimaryDark, fontSize: 16),),
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
                  Expanded(child: TransactionOptionsView(
                    displayShareReceipt: downloadTask,
                    displayDownloadReceipt: downloadTask,
                    onItemClickListener: (title, i) =>
                        (title.contains("Replay"))
                            ? Navigator.of(context).pop(transaction)
                            : null,
                  ))
                ],
              ),
            );
          },
        ),
      ),
    );
  }

}