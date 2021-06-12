import 'dart:io';
import 'dart:isolate';
import 'dart:ui';

import 'package:flutter/material.dart' hide Colors, Page;
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:moniepoint_flutter/app/accounts/model/data/account_balance.dart';
import 'package:moniepoint_flutter/app/accounts/model/data/account_transaction.dart';
import 'package:moniepoint_flutter/app/accounts/viewmodels/transaction_list_view_model.dart';
import 'package:moniepoint_flutter/app/accounts/views/transaction_history_list_item.dart';
import 'package:moniepoint_flutter/core/colors.dart';
import 'package:moniepoint_flutter/core/config/build_config.dart';
import 'package:moniepoint_flutter/core/config/service_config.dart';
import 'package:moniepoint_flutter/core/models/transaction.dart';
import 'package:moniepoint_flutter/core/models/user_instance.dart';
import 'package:moniepoint_flutter/core/paging/page_config.dart';
import 'package:moniepoint_flutter/core/paging/pager.dart';
import 'package:moniepoint_flutter/core/paging/paging_data.dart';
import 'package:moniepoint_flutter/core/paging/paging_source.dart';
import 'package:moniepoint_flutter/core/routes.dart';
import 'package:moniepoint_flutter/core/styles.dart';
import 'package:moniepoint_flutter/core/tuple.dart';
import 'package:moniepoint_flutter/core/views/filter/date_filter_dialog.dart';
import 'package:moniepoint_flutter/core/views/filter_view.dart';
import 'package:moniepoint_flutter/core/views/sessioned_widget.dart';
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import 'package:moniepoint_flutter/core/utils/currency_util.dart';
import 'package:moniepoint_flutter/core/utils/text_utils.dart';

class AccountTransactionScreen extends StatefulWidget {

  @override
  State<StatefulWidget> createState() => _AccountTransactionScreen();

}

class _AccountTransactionScreen extends State<AccountTransactionScreen> {

  ReceivePort _receivePort = ReceivePort();
  ScrollController _scrollController = ScrollController();
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey();
  bool isInFilterMode = false;
  String accountStatementFileName = "MoniepointAccountStatement.pdf";
  String? accountStatementDownloadDir;
  PagingSource<int, AccountTransaction> _pagingSource = PagingSource(localSource: (a) => Stream.value(Page([], null, null)));

  initState() {
    final viewModel = Provider.of<TransactionHistoryViewModel>(context, listen: false);
    _pagingSource = viewModel.getPagedHistoryTransaction();
    viewModel.getCustomerAccountBalance().listen((event) { });
    super.initState();

    IsolateNameServer.registerPortWithName(_receivePort.sendPort, "download_statement");
    _receivePort.listen((a) => _onDownloadStatementCallback(a as List<dynamic>));
    FlutterDownloader.registerCallback(downloadReceiptCallback);
  }

  Widget balanceView(TransactionHistoryViewModel viewModel) {
    return Container(
      padding: EdgeInsets.only(top: 26, bottom: 26, left: 16, right: 16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        color: Colors.primaryColor,
        boxShadow: [
          BoxShadow(
            color: Colors.primaryColor.withOpacity(0.1),
            offset: Offset(0, 8),
            blurRadius: 4,
            spreadRadius: 0
          )
        ]
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Flexible(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Available Balance', style: TextStyle(fontSize: 13, color: Colors.colorFaded, fontWeight: FontWeight.normal),),
                  Align(
                    alignment: Alignment.centerRight,
                    child: Container(
                      padding: EdgeInsets.only(left: 9, right: 9, top: 5, bottom: 5),
                      decoration: BoxDecoration(
                          color: Colors.darkBlue.withOpacity(0.5),
                          borderRadius: BorderRadius.all(Radius.circular(16))
                      ),
                      child: Center(
                        child: Text('SAVINGS', style: TextStyle(color: Colors.white, fontSize: 12)),
                      ),
                    ),
                  )
                ],
              )
          ),
          SizedBox(height: 5),
          Flexible(
              child: StreamBuilder(
                stream: viewModel.balanceStream,
                builder: (context, AsyncSnapshot<AccountBalance?> snapShot){
                  final accountBalance = snapShot.hasData ? snapShot.data?.availableBalance?.formatCurrency ?? "--" : '--';
                  return Text(
                    accountBalance,
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 24,
                        fontWeight: FontWeight.bold
                    ),
                  );
                },
              )
          ),
          SizedBox(height: 5,),
          Flexible(
              child: StreamBuilder(
                stream: viewModel.balanceStream,
                builder: (context, AsyncSnapshot<AccountBalance?> snapShot){
                  final accountBalance = snapShot.hasData ? snapShot.data?.ledgerBalance?.formatCurrency ?? "--" : '--';
                  return Text(
                    'Ledger Balance: $accountBalance',
                    style: TextStyle(
                        color: Colors.colorFaded,
                        fontSize: 12,
                        fontFamily: Styles.defaultFont,
                        fontWeight: FontWeight.normal
                    ),
                  ).colorText({accountBalance : Tuple(Colors.white, null)}, bold: false, underline: false);
                },
              )
          ),
          SizedBox(height: 2,),
          Flexible(
            child: Row(
              children: [
                Expanded(child: Divider(color: Colors.white.withOpacity(0.2), height: 1,)),
                SizedBox(width: 6,),
                Styles.imageButton(
                    onClick: () => "",
                    color: Colors.white.withOpacity(0.2),
                    padding: EdgeInsets.symmetric(horizontal: 5.2, vertical: 4),
                    borderRadius: BorderRadius.circular(4),
                    image: SvgPicture.asset('res/drawables/ic_settings.svg', width: 20, height: 20,)
                )
              ],
            ),
          ),
          SizedBox(height: 6,),
          Flexible(
              child: Row(
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'A/C No.',
                        style: TextStyle(color: Colors.colorFaded, fontSize: 13)
                      ),

                      Text(
                        viewModel.accountNumber,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(color: Colors.white, fontSize: 14)
                      )
                    ],
                  ),
                  SizedBox(width: 32,),
                  Flexible(child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                            'Account Name',
                            style: TextStyle(color: Colors.colorFaded, fontSize: 13)
                        ),
                        Text(
                            viewModel.accountName,
                            overflow: TextOverflow.ellipsis,
                            maxLines: 1,
                            style: TextStyle(color: Colors.white, fontSize: 14)
                        )
                      ]
                  )),
                ],
              )
          )
        ],
      ),
    );
  }

  static void downloadReceiptCallback (String id, DownloadTaskStatus status, int progress) {
    final SendPort? send = IsolateNameServer.lookupPortByName('download_statement');
    send?.send([id, status, progress]);
  }

  void _onDownloadStatementCallback(List<dynamic> data) {
    final downloadTaskStatus = data[1] as DownloadTaskStatus;
    print(downloadTaskStatus);
    if(downloadTaskStatus == DownloadTaskStatus.complete) {
      // Navigator.of(context).pop();
      OpenFile.open(
          "$accountStatementDownloadDir/$accountStatementFileName", type: "application/pdf"
      );
      // Share.shareFiles(["$androidDownloadPath/${widget.successPayload.fileName}"], text: 'Receipt');
    }
    if(downloadTaskStatus == DownloadTaskStatus.running || downloadTaskStatus == DownloadTaskStatus.enqueued) {
      print("running");
    }
  }

  void _downloadStatement() async {
    final result = await showModalBottomSheet(
        isScrollControlled: true,
        backgroundColor: Colors.transparent,
        context: context,
        builder: (context) => DateFilterDialog(dialogTitle: "Download Statement",)
    );
    if(result is Tuple<int?, int?>) {
        _startDownload(result.first!, result.second!);
    }
  }

  void _startDownload(int startDate, int endDate) async {
    if(await Permission.storage.request().isGranted) {
      final viewModel = Provider.of<TransactionHistoryViewModel>(context, listen: false);
      accountStatementFileName =  "Moniepoint_${viewModel.accountName}(${DateTime.now().millisecondsSinceEpoch}).pdf";
      accountStatementDownloadDir = (Platform.isAndroid) ? "/storage/emulated/0/Download/" : (await getApplicationDocumentsDirectory()).path;
      FlutterDownloader.enqueue(
        url: "${ServiceConfig.ROOT_SERVICE}api/v1/transactions/statement/export?customerAccountId=${viewModel.customerAccountId}&fileType=PDF&startDate=$startDate&endDate=$endDate",
        savedDir: accountStatementDownloadDir!,
        showNotification: true,
        fileName: accountStatementFileName,
        headers: {
          "client-id": BuildConfig.CLIENT_ID,
          "appVersion": BuildConfig.APP_VERSION,
          "Authorization": "bearer ${UserInstance().getUser()!.accessToken}"
        },
        // show download progress in status bar (for Android)
        openFileFromNotification: true,
      );
    }
  }


  Widget filterMenu() {
    return Flexible(
        flex:0,
        child: Padding(
          padding: EdgeInsets.only(left: 24, right: 23, bottom: 7.8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              TextButton.icon(
                icon: SvgPicture.asset('res/drawables/ic_account_filter.svg'),
                onPressed: () => setState(() => isInFilterMode = true ),
                label: Text('Filter',
                  style: TextStyle(color: Colors.darkBlue, fontSize: 13, fontWeight: FontWeight.bold),
                ),
                style: ButtonStyle(
                    minimumSize: MaterialStateProperty.all(Size(40, 0)),
                    tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    overlayColor: MaterialStateProperty.all(Colors.darkBlue.withOpacity(0.2)),
                    padding: MaterialStateProperty.all(EdgeInsets.symmetric(horizontal: 12, vertical: 6.8)),
                    shape: MaterialStateProperty.all(RoundedRectangleBorder(borderRadius: BorderRadius.circular(20))),
                    backgroundColor: MaterialStateProperty.all(Colors.solidDarkBlue.withOpacity(0.05))
                ),
              ),

              TextButton.icon(
                  onPressed: _downloadStatement,
                  icon: SvgPicture.asset('res/drawables/ic_account_download.svg'),
                  label: Text(
                    'Download Statement',
                    style: TextStyle(color: Colors.primaryColor, fontSize: 13, fontWeight: FontWeight.bold),
                  ),
                  style: ButtonStyle(
                    minimumSize: MaterialStateProperty.all(Size(40, 0)),
                    tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    overlayColor: MaterialStateProperty.all(Colors.primaryColor.withOpacity(0.1)),
                    padding: MaterialStateProperty.all(EdgeInsets.only(left: 8, right: 2, top: 8, bottom: 8)),
                  )
              )
            ],
          ),
        )
    );
  }

  Widget _listContainer(TransactionHistoryViewModel viewModel, {Widget? child}) {
    return Container(
      padding: EdgeInsets.only(top: 100),
      height: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(topRight: Radius.circular(30), topLeft: Radius.circular(30)),
        boxShadow: [
          BoxShadow(
              color: Colors.primaryColor.withOpacity(0.01),
              offset: Offset(0, -1),
              blurRadius: 3,
              spreadRadius: 0
          )
        ]
      ),
      child: child,
    );
  }

  void _dateFilterDateChanged(int startDate, int endDate) {
    final viewModel = Provider.of<TransactionHistoryViewModel>(context, listen: false);
    setState(() {
      viewModel.setStartAndEndDate(startDate, endDate);
      _pagingSource = viewModel.getPagedHistoryTransaction();
    });
  }

  void _channelFilterChanged(List<TransactionChannel> channels) {
    final viewModel = Provider.of<TransactionHistoryViewModel>(context, listen: false);
    setState(() {
      viewModel.setChannels(channels);
      _pagingSource = viewModel.getPagedHistoryTransaction();
    });
  }

  void _typeFilterChanged(List<TransactionType> types) {
    final viewModel = Provider.of<TransactionHistoryViewModel>(context, listen: false);
    setState(() {
      viewModel.setTransactionTypes(types);
      _pagingSource = viewModel.getPagedHistoryTransaction();
    });
  }

  void _onCancelFilter() {
    final viewModel = Provider.of<TransactionHistoryViewModel>(context, listen: false);
    setState(() {
      isInFilterMode = false;
      viewModel.resetFilter();
      _pagingSource = viewModel.getPagedHistoryTransaction();
    });
  }

  Widget _pagingView(TransactionHistoryViewModel viewModel) {
    return Pager<int, AccountTransaction>(
        pagingConfig: PagingConfig(pageSize: 800, initialPageSize: 800),
        source: _pagingSource,
        scrollController: _scrollController,
        builder: (context, value, _) {
          return Column(
            children: [
              Visibility(
                visible: isInFilterMode,
                child: Flexible(
                  flex: 0,
                  child: FilterLayout(
                      _scaffoldKey,
                      viewModel.filterableItems,
                      dateFilterCallback: _dateFilterDateChanged,
                      typeFilterCallback: _typeFilterChanged,
                      channelFilterCallback: _channelFilterChanged,
                      onCancel: _onCancelFilter
                  ),
                ),
              ),
              Visibility(
                  visible: !isInFilterMode,
                  child: filterMenu()
                  ),
              SizedBox(height: 12,),
              Expanded(child: ListView.separated(
                controller: _scrollController,
                itemCount: value.data.length,
                separatorBuilder: (context, index) => Padding(
                    padding: EdgeInsets.only(left: 24, right: 24),
                    child: Divider(height: 1,),
                ),
                itemBuilder: (context, index) {
                  return TransactionHistoryListItem(value.data[index], index, (item, i) {
                    Navigator.of(context).pushNamed(Routes.ACCOUNT_TRANSACTIONS_DETAIL, arguments: item.transactionRef);
                  });
                },
              ))
            ],
          );
        }
    );
  }

  @override
  Widget build(BuildContext context) {
    final viewModel = Provider.of<TransactionHistoryViewModel>(context, listen: false);

    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: Color(0XFFEAF4FF),
      appBar: AppBar(
          centerTitle: false,
          titleSpacing: -12,
          iconTheme: IconThemeData(color: Colors.primaryColor),
          title: Text('Account',
              textAlign: TextAlign.start,
              style: TextStyle(
                  color: Colors.darkBlue,
                  fontFamily: Styles.defaultFont,
                  fontSize: 17
              )
          ),
          backgroundColor: Color(0XFFEAF4FF),
          elevation: 0
      ),
      body: SessionedWidget(
        context: context,
        child: Stack(
          fit: StackFit.expand,
          children: [
            Positioned(
                top: 170,
                bottom: 0,
                right: 0,
                left: 0,
                child: _listContainer(viewModel, child: _pagingView(viewModel))
            ),
            Positioned(
                right: 42,
                left: 42,
                top: 42,
                child: balanceView(viewModel)
            ),
          ],
        ),
      ),
    );
  }
  @override
  void dispose() {
    IsolateNameServer.removePortNameMapping('download_statement');
    super.dispose();
  }
}