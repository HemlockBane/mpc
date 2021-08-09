import 'dart:math';
import 'dart:ui';

import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/material.dart' hide Colors, Page;
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';
import 'package:moniepoint_flutter/app/accounts/model/data/account_balance.dart';
import 'package:moniepoint_flutter/app/accounts/model/data/account_transaction.dart';
import 'package:moniepoint_flutter/app/accounts/model/data/tier.dart';
import 'package:moniepoint_flutter/app/accounts/viewmodels/transaction_list_view_model.dart';
import 'package:moniepoint_flutter/app/accounts/views/accounts_shimmer_view.dart';
import 'package:moniepoint_flutter/app/accounts/views/dialogs/account_settings_dialog.dart';
import 'package:moniepoint_flutter/app/accounts/views/transaction_history_list_item.dart';
import 'package:moniepoint_flutter/app/cards/views/empty_list_layout_view.dart';
import 'package:moniepoint_flutter/app/cards/views/error_layout_view.dart';
import 'package:moniepoint_flutter/core/bottom_sheet.dart';
import 'package:moniepoint_flutter/core/colors.dart';
import 'package:moniepoint_flutter/core/models/transaction.dart';
import 'package:moniepoint_flutter/core/paging/page_config.dart';
import 'package:moniepoint_flutter/core/paging/pager.dart';
import 'package:moniepoint_flutter/core/paging/paging_data.dart';
import 'package:moniepoint_flutter/core/paging/paging_source.dart';
import 'package:moniepoint_flutter/core/routes.dart';
import 'package:moniepoint_flutter/core/styles.dart';
import 'package:moniepoint_flutter/core/tuple.dart';
import 'package:moniepoint_flutter/core/utils/download_util.dart';
import 'package:moniepoint_flutter/core/utils/list_view_util.dart';
import 'package:moniepoint_flutter/core/views/filter/date_filter_dialog.dart';
import 'package:moniepoint_flutter/core/views/filter_view.dart';
import 'package:moniepoint_flutter/core/views/sessioned_widget.dart';
import 'package:provider/provider.dart';
import 'package:moniepoint_flutter/core/utils/currency_util.dart';
import 'package:moniepoint_flutter/core/utils/text_utils.dart';

class AccountTransactionScreen extends StatefulWidget {

  final int? customerAccountId;

  AccountTransactionScreen({this.customerAccountId});

  @override
  State<StatefulWidget> createState() => _AccountTransactionScreen();

}

class _AccountTransactionScreen extends State<AccountTransactionScreen> with TickerProviderStateMixin{

  ScrollController _scrollController = ScrollController();
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey();
  bool _isDownloading = false;
  bool isInFilterMode = false;
  bool _isFilterOpened = false;
  String accountStatementFileName = "MoniepointAccountStatement.pdf";
  String? accountStatementDownloadDir;
  double yOffset = 0.0;

  late final AnimationController _animationController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 1000)
  );
  PagingSource<int, AccountTransaction> _pagingSource = PagingSource.empty();

  initState() {
    final viewModel = Provider.of<TransactionHistoryViewModel>(context, listen: false);
    viewModel.getCustomerAccountBalance(accountId: widget.customerAccountId).listen((event) { });
    _refresh(viewModel);
    _animationController.forward();
    _scrollController.addListener(_onScroll);
    super.initState();
    viewModel.getTiers().listen((event) { });
  }

  void _displaySettingsDialog() async {
    final viewModel = Provider.of<TransactionHistoryViewModel>(context, listen: false);
    final tiers = viewModel.tiers;
    final qualifiedTierIndex = Tier.getQualifiedTierIndex(tiers);
    if(tiers.isEmpty) return;

    final result =  await showModalBottomSheet(
        backgroundColor: Colors.transparent,
        context: context,
        builder: (mContext) => AccountSettingsDialog(tiers[qualifiedTierIndex])
    );

    if(result != null && result is String) {
      if(result == "block") {
        showModalBottomSheet(
            backgroundColor: Colors.transparent,
            context: context,
            builder: (mContext) => BottomSheets.displayWarningDialog(
                'Warning!!!',
                'You will have to visit a branch to unblock your account if needed! Proceed to block?', () {
                  Navigator.of(mContext).pop();
                  Navigator.of(mContext).pushNamed(Routes.BLOCK_ACCOUNT);
                }, buttonText: 'Yes, Proceed'
            )
        );
      }
    }
  }

  Widget balanceView(TransactionHistoryViewModel viewModel, double yOffset) {
    double cardRadius = min(20, 20 - min(20, (yOffset - 1) * 0.1));
    double borderTop = min(26, 26 - min(26, (yOffset - 1) * 0.1));
    double opacityValue = min(100, 100 - min(100, (yOffset - 1) * 0.4)) / 100;

    return Container(
      padding: EdgeInsets.only(top: borderTop, bottom: 26, left: 16, right: 16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(cardRadius),
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
          SizedBox(height: 5),
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
                        fontWeight: FontWeight.normal,
                        fontFamilyFallback: ["Roboto"]
                    ),
                  ).colorText({accountBalance : Tuple(Colors.white, null)}, bold: false, underline: false);
                },
              )
          ),
          SizedBox(height: 2),
          Flexible(
            child: Opacity(
                opacity: opacityValue,
                child: Row(
                  children: [
                    Expanded(child: Divider(color: Colors.white.withOpacity(0.2), height: 1,)),
                    SizedBox(width: 6),
                    Styles.imageButton(
                        onClick: _displaySettingsDialog,
                        color: Colors.white.withOpacity(0.2),
                        padding: EdgeInsets.symmetric(horizontal: 5.2, vertical: 4),
                        borderRadius: BorderRadius.circular(4),
                        image: SvgPicture.asset('res/drawables/ic_settings.svg', width: 20, height: 20,)
                    )
                  ],
                ),
            ),
          ),
          SizedBox(height: 6),
          Flexible(
              child: Opacity(
                opacity: opacityValue,
                child: Row(
                  children: [
                    Flexible(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                                'A/C No.',
                                style: TextStyle(color: Colors.colorFaded, fontSize: 13)
                            ),
                            Text(
                                viewModel.customerAccountNumber(accountId: widget.customerAccountId),
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(color: Colors.white, fontSize: 14)
                            )
                          ],
                        )
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
                              viewModel.customerAccountName(accountId: widget.customerAccountId),
                              overflow: TextOverflow.ellipsis,
                              maxLines: 1,
                              style: TextStyle(color: Colors.white, fontSize: 14)
                          )
                        ]
                    )),
                  ],
                ),
              )
          )
        ],
      ),
    );
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
                  onPressed: (!_isDownloading) ? _downloadAccountStatement : null,
                  icon: (!_isDownloading)
                      ? SvgPicture.asset('res/drawables/ic_account_download.svg')
                      : SizedBox(
                        width: 12,
                        height: 12,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          valueColor: AlwaysStoppedAnimation(Colors.solidGreen.withOpacity(0.8)),
                          backgroundColor: Colors.grey.withOpacity(0.1),
                        ),
                      ),
                  label: Text(
                    'Download Statement',
                    style: TextStyle(
                        color: (!_isDownloading) ? Colors.primaryColor : Colors.grey.withOpacity(0.5),
                        fontSize: 13,
                        fontWeight: FontWeight.bold
                    ),
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

  Widget _listContainer(TransactionHistoryViewModel viewModel, double yOffset, {Widget? child}) {
    final double topPadding = min(100, 100 - min(76, (yOffset - 1) * 0.2));

    return Container(
      padding: EdgeInsets.only(top: topPadding),
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

  void _refresh(TransactionHistoryViewModel viewModel) {
    _pagingSource = viewModel.getPagedHistoryTransaction(accountId: widget.customerAccountId);
  }

  void _dateFilterDateChanged(int startDate, int endDate) {
    final viewModel = Provider.of<TransactionHistoryViewModel>(context, listen: false);
    setState(() {
      viewModel.setStartAndEndDate(startDate, endDate);
      _refresh(viewModel);
    });
  }

  void _channelFilterChanged(List<TransactionChannel> channels) {
    final viewModel = Provider.of<TransactionHistoryViewModel>(context, listen: false);
    setState(() {
      viewModel.setChannels(channels);
      _refresh(viewModel);
    });
  }

  void _typeFilterChanged(List<TransactionType> types) {
    final viewModel = Provider.of<TransactionHistoryViewModel>(context, listen: false);
    setState(() {
      viewModel.setTransactionTypes(types);
      _refresh(viewModel);
    });
  }

  void _onCancelFilter() {
    final viewModel = Provider.of<TransactionHistoryViewModel>(context, listen: false);
    setState(() {
      isInFilterMode = false;
      _isFilterOpened = false;
      viewModel.resetFilter();
      //TODO check if what we had before and now is the same
      _refresh(viewModel);
    });
  }

  void _retry(){
    final viewModel = Provider.of<TransactionHistoryViewModel>(context, listen: false);
    setState((){
      _refresh(viewModel);
    });
  }

  Widget _mainPageContent(PagingData value, TransactionHistoryViewModel viewModel, bool isEmpty, Tuple<String, String>? error) {
    return Column(
      children: [
        Visibility(
          visible: isInFilterMode && error == null,
          child: Flexible(
            flex: 0,
            child: FilterLayout(
              _scaffoldKey,
              viewModel.filterableItems,
              dateFilterCallback: _dateFilterDateChanged,
              typeFilterCallback: _typeFilterChanged,
              channelFilterCallback: _channelFilterChanged,
              onCancel: _onCancelFilter,
              isPreviouslyOpened: _isFilterOpened,
              onOpen: () {
                _isFilterOpened = true;
              },
            ),
          ),
        ),
        Visibility(visible: !isInFilterMode && error == null, child: filterMenu()),
        SizedBox(
          height: 12,
        ),
        Visibility(
            visible: isEmpty,
            child: Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  EmptyLayoutView(viewModel.isFilteredList()
                      ? "You have no transactions with these search criteria"
                      : "You have no transaction history yet.")
                ],
              ),
            )),
        Visibility(
            visible: error != null,
            child: Flexible(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ErrorLayoutView(error?.first ?? "", error?.second ?? "", _retry),
                  SizedBox(height: 50,)
                ],
              ),
            )
        ),
        Visibility(
          visible: !isEmpty && error == null,
          child: Expanded(child: ListView.separated(
            controller: _scrollController,
            itemCount: value.data.length,
            separatorBuilder: (context, index) => Padding(
              padding: EdgeInsets.only(left: 24, right: 24),
              child: Divider(
                height: 1,
              ),
            ),
            itemBuilder: (context, index) {
              return TransactionHistoryListItem(value.data[index], index,
                  (item, i) {
                Navigator.of(context).pushNamed(
                    Routes.ACCOUNT_TRANSACTIONS_DETAIL,
                    arguments: item.transactionRef);
              });
            },
          )),
        )
      ],
    );
  }

  Widget _pagingView(TransactionHistoryViewModel viewModel) {
    return Pager<int, AccountTransaction>(
        pagingConfig: PagingConfig(pageSize: 800, initialPageSize: 800),
        source: _pagingSource,
        scrollController: _scrollController,
        builder: (context, value, _) {
          return ListViewUtil.handleLoadStates(
              animationController:_animationController,
              pagingData: value,
              shimmer: AccountListShimmer(),
              listCallback: (PagingData data, bool isEmpty, error) {
                return _mainPageContent(value, viewModel, isEmpty, error);
              });
        }
    );
  }

  void _onScroll() {
    yOffset = _scrollController.offset;
    if(yOffset >= 0 && yOffset <= 1000) {
      setState(() {});
    }
  }

  List<Widget> _positionalWidgets(TransactionHistoryViewModel viewModel, Offset value) {
    final double listTop = min(170, 170 - min(60, (value.dy - 1) * 0.2));
    final double balanceViewSides = min(42, 42 - min(42, (value.dy - 1) * 0.2));

    final listPagePosition = Positioned(
        key: Key("list-view-0"),
        top: listTop,
        bottom: 0,
        right: 0,
        left: 0,
        child: _listContainer(viewModel, value.dy, child: _pagingView(viewModel))
    );

    final balanceContainerPosition = Positioned(
        key: Key("dashboard-balance-${widget.customerAccountId}"),
        right: balanceViewSides,
        left: balanceViewSides,
        top: balanceViewSides,
        child: Hero(
          tag: "dashboard-balance-view-${widget.customerAccountId}",
          child: balanceView(viewModel, value.dy),
        )
    );

    final _listItems = <Widget>[];
    _listItems.insert(0, (balanceViewSides != 0) ? listPagePosition : balanceContainerPosition);
    _listItems.insert(1, (balanceViewSides != 0) ? balanceContainerPosition : listPagePosition);

    return _listItems;
  }

  @override
  Widget build(BuildContext context) {
    final viewModel = Provider.of<TransactionHistoryViewModel>(context, listen: false);
    return SessionedWidget(
        context: context,
        child: TweenAnimationBuilder(
            duration: Duration(milliseconds: 430),
            tween: Tween<Offset>(begin: Offset(0, 0), end: Offset(0, yOffset)),
            builder: (mContext, Offset value, _) {

              final appBarColorTween = ColorTween(
                  begin: Colors.primaryColor,
                  end: Colors.transparent
              ).evaluate(AlwaysStoppedAnimation(min(100, 100 - min(100, (value.dy - 1) * 0.5))/100));

              final appBarIconTween = ColorTween(
                  begin: Colors.white,
                  end: Colors.primaryColor
              ).evaluate(AlwaysStoppedAnimation(min(100, 100 - min(100, (value.dy - 1) * 0.5))/100));

              final appBarTextTween = ColorTween(
                  begin: Colors.white,
                  end: Colors.darkBlue
              ).evaluate(AlwaysStoppedAnimation(min(100, 100 - min(100, (value.dy - 1) * 0.5))/100));

              return Scaffold(
                key: _scaffoldKey,
                backgroundColor: Color(0XFFEAF4FF),
                appBar: AppBar(
                    centerTitle: false,
                    titleSpacing: -12,
                    iconTheme: IconThemeData(color: appBarIconTween),
                    title: Text('Account',
                        textAlign: TextAlign.start,
                        style: TextStyle(
                            color: appBarTextTween,
                            fontFamily: Styles.defaultFont,
                            fontSize: 17
                        )
                    ),
                    backgroundColor: appBarColorTween,
                    elevation: 0
                ),
                body: SessionedWidget(
                  context: context,
                  child: Stack(
                    fit: StackFit.expand,
                    children: _positionalWidgets(viewModel, value),
                  ),
                ),
              );
            }
        ),
    );
  }

  void _downloadAccountStatement() async {
    final viewModel = Provider.of<TransactionHistoryViewModel>(context, listen: false);
    final selectedDate = await showModalBottomSheet(
        isScrollControlled: true,
        backgroundColor: Colors.transparent,
        context: context,
        builder: (mContext) => DateFilterDialog(
          dialogTitle: "Download Statement",
          dialogIcon: "res/drawables/ic_download_statement.svg"
        )
    );

    if(selectedDate != null && selectedDate is Tuple<int?, int?>) {
      try {
        final fileName = "AccountTransaction_Export_${viewModel.accountName}_${DateFormat("dd_MM_yyyy_h_m_s").format(DateTime.now())}.pdf";
        final downloadTask = () => viewModel.exportStatement(selectedDate.first, selectedDate.second, accountId: widget.customerAccountId);
        await DownloadUtil.downloadTransactionReceipt(downloadTask, fileName, isShare: false, onProgress: (int progress, isComplete) {
          if(!_isDownloading && !isComplete) setState(() { _isDownloading = true;});
          else if(_isDownloading && isComplete) setState(() { _isDownloading = false; });
        });
      } catch(e) {
        setState(() { _isDownloading = false; });
        FirebaseCrashlytics.instance.recordError(e, null);
        showModalBottomSheet(
            backgroundColor: Colors.transparent,
            context: context,
            builder: (context) => BottomSheets.displayErrorModal(
                context,
                title: "Oops",
                message: "Failed to download account statement receipt"
            )
        );
      }
    }
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }
}