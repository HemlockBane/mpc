import 'dart:math';
import 'dart:ui';

import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart' hide Colors, Page;
import 'package:flutter/widgets.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';
import 'package:moniepoint_flutter/app/accounts/model/data/account_transaction.dart';
import 'package:moniepoint_flutter/app/accounts/model/data/tier.dart';
import 'package:moniepoint_flutter/app/accounts/viewmodels/transaction_list_view_model.dart';
import 'package:moniepoint_flutter/app/accounts/views/account_transactions_account_card.dart';
import 'package:moniepoint_flutter/app/accounts/views/accounts_shimmer_view.dart';
import 'package:moniepoint_flutter/app/accounts/views/dialogs/account_settings_dialog.dart';
import 'package:moniepoint_flutter/app/accounts/views/transaction_history_list_item.dart';
import 'package:moniepoint_flutter/app/customer/user_account.dart';
import 'package:moniepoint_flutter/core/views/empty_list_layout_view.dart';
import 'package:moniepoint_flutter/core/views/error_layout_view.dart';
import 'package:moniepoint_flutter/core/colors.dart';
import 'package:moniepoint_flutter/core/models/transaction.dart';
import 'package:moniepoint_flutter/core/paging/page_config.dart';
import 'package:moniepoint_flutter/core/paging/pager.dart';
import 'package:moniepoint_flutter/core/paging/paging_data.dart';
import 'package:moniepoint_flutter/core/paging/paging_source.dart';
import 'package:moniepoint_flutter/core/routes.dart';
import 'package:moniepoint_flutter/core/styles.dart';
import 'package:moniepoint_flutter/core/tuple.dart';
import 'package:moniepoint_flutter/core/utils/dialog_util.dart';
import 'package:moniepoint_flutter/core/utils/download_util.dart';
import 'package:moniepoint_flutter/core/utils/list_view_util.dart';
import 'package:moniepoint_flutter/core/views/filter/date_filter_dialog.dart';
import 'package:moniepoint_flutter/core/views/filter_view.dart';
import 'package:moniepoint_flutter/core/views/sessioned_widget.dart';
import 'package:provider/provider.dart';

class AccountTransactionScreen extends StatefulWidget {
  final int? customerAccountId;
  final accountUserIdx;

  AccountTransactionScreen({this.customerAccountId, required this.accountUserIdx});

  @override
  State<StatefulWidget> createState() => _AccountTransactionScreen();
}

class _AccountTransactionScreen extends State<AccountTransactionScreen> with TickerProviderStateMixin {

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey();

  late final double toolBarMarginTop = 37;
  late final double maxDraggableTop = toolBarMarginTop * 5 + 26;
  late final TransactionHistoryViewModel _viewModel;

  bool _isDownloading = false;
  bool isInFilterMode = false;
  bool _isFilterOpened = false;
  String accountStatementFileName = "MoniepointAccountStatement.pdf";
  String? accountStatementDownloadDir;

  late final UserAccount userAccount;

  late final AnimationController _animationController =
      AnimationController(vsync: this, duration: Duration(milliseconds: 1000));
  PagingSource<int, AccountTransaction> _pagingSource = PagingSource.empty();

  initState() {
    _viewModel = Provider.of<TransactionHistoryViewModel>(context, listen: false);
    _viewModel.getCustomerAccountBalance(accountId: widget.customerAccountId)
        .listen((event) {});

    _refresh();

    userAccount = _viewModel.userAccounts[widget.accountUserIdx];

    _animationController.forward();
    _viewModel.checkAccountUpdate();
    super.initState();
  }

  void _displaySettingsDialog() async {
    final tiers = _viewModel.tiers;
    final qualifiedTierIndex = Tier.getQualifiedTierIndex(tiers);
    if (tiers.isEmpty) return;

    final result = await showModalBottomSheet(
        backgroundColor: Colors.transparent,
        context: context,
        builder: (mContext) => AccountSettingsDialog(tiers[qualifiedTierIndex])
    );

    if (result != null && result is String) {
      if (result == "block") {
        showInfo(context,
            title: "Warning!!!",
            message: "You will have to visit a branch to unblock your account if needed! Proceed to block?",
            primaryButtonText: "Yes, Proceed",
            onPrimaryClick: () {
              Navigator.of(context).pop();
              Navigator.of(context).pushNamed(Routes.BLOCK_ACCOUNT);
            }
        );
      }
    }
  }

  Widget filterMenu() {
    return Flexible(
        flex: 0,
        child: Padding(
          padding: EdgeInsets.only(left: 24, right: 23),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              TextButton.icon(
                icon: SvgPicture.asset('res/drawables/ic_account_filter_2.svg'),
                onPressed: () => setState(() => isInFilterMode = true),
                label: Text(
                  'Filter',
                  style: TextStyle(
                    color: Colors.primaryColor,
                    fontSize: 12.5,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                style: ButtonStyle(
                    minimumSize: MaterialStateProperty.all(Size(40, 0)),
                    tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    overlayColor: MaterialStateProperty.all(
                        Colors.darkBlue.withOpacity(0.2)),
                    padding: MaterialStateProperty.all(
                        EdgeInsets.fromLTRB(16, 7.2, 25, 7.2)),
                    shape: MaterialStateProperty.all(RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(41))),
                    backgroundColor: MaterialStateProperty.all(
                        Colors.primaryColor.withOpacity(0.2))),
              ),
              TextButton.icon(
                  onPressed:
                      (!_isDownloading) ? _downloadAccountStatement : null,
                  icon: (!_isDownloading)
                      ? SvgPicture.asset(
                          'res/drawables/ic_account_download.svg',
                          width: 8.5,
                          height: 11.5)
                      : SizedBox(
                          width: 12,
                          height: 12,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            valueColor: AlwaysStoppedAnimation(
                                Colors.solidGreen.withOpacity(0.8)),
                            backgroundColor: Colors.grey.withOpacity(0.1),
                          ),
                        ),
                  label: Text(
                    'Download Statement',
                    style: TextStyle(
                        color: (!_isDownloading)
                            ? Colors.primaryColor
                            : Colors.grey.withOpacity(0.5),
                        fontSize: 12.5,
                        fontWeight: FontWeight.w600),
                  ),
                  style: ButtonStyle(
                    minimumSize: MaterialStateProperty.all(Size(40, 0)),
                    tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    overlayColor: MaterialStateProperty.all(Colors.primaryColor.withOpacity(0.1)),
                    padding: MaterialStateProperty.all(EdgeInsets.only(left: 8, right: 2, top: 8, bottom: 8)),
                  ))
            ],
          ),
        ));
  }

  void _refresh() {
    _pagingSource = _viewModel.getPagedHistoryTransaction(
        accountId: widget.customerAccountId);
  }

  void _dateFilterDateChanged(int startDate, int endDate) {
    setState(() {
      _viewModel.setStartAndEndDate(startDate, endDate);
      _refresh();
    });
  }

  void _channelFilterChanged(List<TransactionChannel> channels) {
    setState(() {
      _viewModel.setChannels(channels);
      _refresh();
    });
  }

  void _typeFilterChanged(List<TransactionType> types) {
    setState(() {
      _viewModel.setTransactionTypes(types);
      _refresh();
    });
  }

  void _onCancelFilter() {
    setState(() {
      isInFilterMode = false;
      _isFilterOpened = false;
      _viewModel.resetFilter();
      //TODO check if what we had before and now is the same
      _refresh();
    });
  }

  void _retry() {
    setState(() {
      _refresh();
    });
  }

  Widget _mainPageContent(
      PagingData value,
      TransactionHistoryViewModel viewModel,
      bool isEmpty,
      Tuple<String, String>? error,
      ScrollController scrollController) {
    return Column(
      children: [
        Visibility(
            visible: isEmpty,
            child: Expanded(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(height: 100),
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
                  SizedBox(height: 60),
                  ErrorLayoutView(error?.first ?? "", error?.second ?? "", _retry),
                ],
              ),
            )),
        Visibility(
          visible: !isEmpty && error == null,
          child: Expanded(
              child: ListView.separated(
                padding: EdgeInsets.only(top: 70),
                controller: scrollController,
                itemCount: value.data.length,
                separatorBuilder: (context, index) => Padding(
                  padding: EdgeInsets.only(left: 24, right: 24),
                  child: Divider(
                    height: 1,
                  ),
                ),
                itemBuilder: (context, index) {
                  return TransactionHistoryListItem(value.data[index], index, (item, i) {
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

  Widget _pagingView() {
    bool showDropShadow = false;
    final screenSize = MediaQuery.of(context).size;
    final maxExtent = 1.0;
    final containerHeight = _viewModel.isAccountUpdateCompleted ? 120 : 180;
    final minExtent = 1 - (containerHeight / (screenSize.height - maxDraggableTop));

    return StatefulBuilder(builder: (ctx, setState){
      return NotificationListener<DraggableScrollableNotification>(
        onNotification: (DraggableScrollableNotification notification) {
          if(notification.extent == maxExtent){
            setState(() {
              showDropShadow = true;
            });
            return false;
          }
          if (showDropShadow && notification.extent != maxExtent){
            setState(() {
              showDropShadow = false;
            });
            return false;
          }

          return false;

        },
        child: DraggableScrollableSheet(
          initialChildSize: minExtent,
          minChildSize: minExtent,
          maxChildSize: maxExtent,
          builder: (ctx, ScrollController draggableScrollController) {
            return AnimatedContainer(
              duration: Duration(milliseconds: 200),
              // padding: EdgeInsets.only(top: 27),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.vertical(
                  top: Radius.circular(22),
                ),
                border: Border.all(
                  width: 1.0,
                  color: Color(0xff063A4F0D).withOpacity(0.05)),
                boxShadow: showDropShadow ? [
                BoxShadow(
                  blurRadius: 30,
                  offset: Offset(0, -5),
                  color: Color(0xFFC4C4C4).withOpacity(0.5),
                ),
                ] : null,
              ),
              child: Pager<int, AccountTransaction>(
                pagingConfig: PagingConfig(pageSize: 500, initialPageSize: 500),
                source: _pagingSource,
                scrollController: draggableScrollController,
                builder: (context, value, _) {
                  return ListViewUtil.handleLoadStates(
                    animationController: _animationController,
                    pagingData: value,
                    shimmer: Column(
                      children: [
                        SizedBox(height: 20),
                        AccountListShimmer(),
                      ],
                    ),
                    listCallback: (PagingData data, bool isEmpty, error) {
                      bool isAccountLiened = getAccountLienStatus();
                      return Stack(
                        children: [
                          Positioned.fill(child: _mainPageContent(value, _viewModel, isEmpty, error, draggableScrollController)),
                          IgnorePointer(
                            child: Container(
                              height: isAccountLiened ? 142 : 67,
                              decoration: BoxDecoration(
                                color: error == null ? Colors.white : Colors.transparent,
                                borderRadius: BorderRadius.vertical(
                                  top: Radius.circular(22),
                                ),
                              ),
                            ),
                          ),
                          Column(
                            children: [
                              SizedBox(height: 15),
                              Visibility(
                                visible: isInFilterMode && error == null,
                                child: Flexible(
                                    flex: 0,
                                    child: FilterLayout(
                                      _scaffoldKey,
                                      _viewModel.filterableItems,
                                      dateFilterCallback:
                                      _dateFilterDateChanged,
                                      typeFilterCallback: _typeFilterChanged,
                                      channelFilterCallback: _channelFilterChanged,
                                      onCancel: _onCancelFilter,
                                      isPreviouslyOpened: _isFilterOpened,
                                      onOpen: () {
                                        _isFilterOpened = true;
                                      },
                                    )
                                ),
                              ),
                              Visibility(
                                  visible: !isInFilterMode && error == null,
                                  child: filterMenu()
                              ),
                              SizedBox(height: 13,),
                              Visibility(
                                  visible: !isInFilterMode && error == null,
                                  child: Divider(
                                    height: 0.8,
                                    thickness: 0.4,
                                    color: Colors.black.withOpacity(0.1),
                                  )
                              ),
                            ],
                          ),
                        ],
                      );
                    });
                }));
          }),
      );
    });
  }

  bool getAccountLienStatus(){
    return false;
  }

  @override
  Widget build(BuildContext context) {
    return SessionedWidget(
      context: context,
      child: Scaffold(
        backgroundColor: Color(0XFFEBF2FA),
        body: Stack(
          children: [
            Positioned.fill(
              child: Image.asset(
                "res/drawables/ic_app_bg_dark.png",
                fit: BoxFit.fill,
              ),
            ),
            Positioned(
                top: toolBarMarginTop,
                left: 0,
                right: 0,
                child: Container(
                  margin: EdgeInsets.symmetric(horizontal: 16),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Styles.imageButton(
                            padding: EdgeInsets.all(9),
                            color: Colors.transparent,
                            borderRadius: BorderRadius.circular(30),
                            onClick: () => Navigator.of(context).pop(),
                            image: SvgPicture.asset(
                              'res/drawables/ic_back_arrow.svg',
                              fit: BoxFit.contain,
                              width: 19.5,
                              height: 19.02,
                              color: Colors.primaryColor,
                            ),
                          ),
                          SizedBox(width: 10),
                          Text(
                            "Account Details",
                            style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w700,
                                color: Colors.textColorBlack
                            ),
                          )
                        ],
                      ),
                      Styles.imageButton(
                        padding: EdgeInsets.all(9),
                        color: Colors.transparent,
                        borderRadius: BorderRadius.circular(30),
                        onClick: _displaySettingsDialog,
                        image: SvgPicture.asset(
                          'res/drawables/ic_dashboard_settings.svg',
                          fit: BoxFit.contain,
                          width: 22,
                          height: 22.56,
                          color: Colors.primaryColor,
                        ),
                      ),
                    ],
                  ),
                )
            ),
            Positioned(
                top: toolBarMarginTop * 2 + 26,
                left: 0,
                right: 0,
                child: AccountTransactionsAccountCard(
                  viewModel: _viewModel,
                  userAccount: userAccount,
                  accountBalance: userAccount.accountBalance,
                ),
            ),
            Positioned(
                top: maxDraggableTop,//max top of the drag
                left: 0,
                right: 0,
                bottom: 0,
                child: _pagingView()
            )
          ],
        ),
      )

    );
  }

  void _downloadAccountStatement() async {
    final selectedDate = await showModalBottomSheet(
        isScrollControlled: true,
        backgroundColor: Colors.transparent,
        context: context,
        builder: (mContext) => DateFilterDialog(
            dialogTitle: "Download Statement",
            dialogIcon: "res/drawables/ic_download_statement.svg"
        )
    );

    if (selectedDate != null && selectedDate is Tuple<int?, int?>) {
      try {
        final fileName = "AccountTransaction_Export_${_viewModel.accountName}_${DateFormat("dd_MM_yyyy_h_m_s").format(DateTime.now())}.pdf";
        final downloadTask = () => _viewModel.exportStatement(selectedDate.first, selectedDate.second, accountId: widget.customerAccountId);
        await DownloadUtil.downloadTransactionReceipt(downloadTask, fileName, isShare: false, onProgress: (int progress, isComplete) {
          if (!_isDownloading && !isComplete)
            setState(() {
              _isDownloading = true;
            });
          else if (_isDownloading && isComplete)
            setState(() {
              _isDownloading = false;
            });
        });
      } catch (e) {
        setState(() {
          _isDownloading = false;
        });
        FirebaseCrashlytics.instance.recordError(e, null);
        showError(
          context, title: "Statement Download Failed", message: "Failed to download account statement receipt"
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

