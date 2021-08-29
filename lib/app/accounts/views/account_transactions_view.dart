import 'dart:math';
import 'dart:ui';

import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart' hide Colors, Page;
import 'package:flutter/widgets.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';
import 'package:moniepoint_flutter/app/accounts/model/data/account_balance.dart';
import 'package:moniepoint_flutter/app/accounts/model/data/account_transaction.dart';
import 'package:moniepoint_flutter/app/accounts/model/data/tier.dart';
import 'package:moniepoint_flutter/app/accounts/viewmodels/transaction_list_view_model.dart';
import 'package:moniepoint_flutter/app/accounts/views/accounts_shimmer_view.dart';
import 'package:moniepoint_flutter/app/accounts/views/dialogs/account_settings_dialog.dart';
import 'package:moniepoint_flutter/app/accounts/views/transaction_history_list_item.dart';
import 'package:moniepoint_flutter/app/customer/customer_account.dart';
import 'package:moniepoint_flutter/app/customer/user_account.dart';
import 'package:moniepoint_flutter/app/dashboard/viewmodels/dashboard_view_model.dart';
import 'package:moniepoint_flutter/core/extensions/composite_disposable_widget.dart';
import 'package:moniepoint_flutter/core/network/resource.dart';
import 'package:moniepoint_flutter/core/utils/preference_util.dart';
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
import 'package:moniepoint_flutter/core/utils/currency_util.dart';
import 'package:moniepoint_flutter/core/utils/text_utils.dart';
import 'package:moniepoint_flutter/core/strings.dart';
import 'package:share/share.dart';
import 'package:shimmer/shimmer.dart';

class AccountTransactionScreen extends StatefulWidget {
  final int? customerAccountId;
  final UserAccount userAccount;

  AccountTransactionScreen({this.customerAccountId, required this.userAccount});

  @override
  State<StatefulWidget> createState() => _AccountTransactionScreen();
}

class _AccountTransactionScreen extends State<AccountTransactionScreen>
    with TickerProviderStateMixin {
  ScrollController _scrollController = ScrollController();
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey();
  bool _isDownloading = false;
  bool isInFilterMode = false;
  bool _isFilterOpened = false;
  String accountStatementFileName = "MoniepointAccountStatement.pdf";
  String? accountStatementDownloadDir;
  double yOffset = 0.0;

  late final AnimationController _animationController =
      AnimationController(vsync: this, duration: Duration(milliseconds: 1000));
  PagingSource<int, AccountTransaction> _pagingSource = PagingSource.empty();

  initState() {
    final viewModel =
        Provider.of<TransactionHistoryViewModel>(context, listen: false);
    viewModel
        .getCustomerAccountBalance(accountId: widget.customerAccountId)
        .listen((event) {});
    _refresh(viewModel);
    _animationController.forward();
    _scrollController.addListener(_onScroll);
    super.initState();
    viewModel.getTiers().listen((event) {});
  }

  void _displaySettingsDialog() async {
    final viewModel =
        Provider.of<TransactionHistoryViewModel>(context, listen: false);
    final tiers = viewModel.tiers;
    final qualifiedTierIndex = Tier.getQualifiedTierIndex(tiers);
    if (tiers.isEmpty) return;

    final result = await showModalBottomSheet(
        backgroundColor: Colors.transparent,
        context: context,
        builder: (mContext) =>
            AccountSettingsDialog(tiers[qualifiedTierIndex]));

    if (result != null && result is String) {
      if (result == "block") {
        showInfo(context,
            title: "Warning!!!",
            message:
                "You will have to visit a branch to unblock your account if needed! Proceed to block?",
            primaryButtonText: "Yes, Proceed", onPrimaryClick: () {
          Navigator.of(context).pop();
          Navigator.of(context).pushNamed(Routes.BLOCK_ACCOUNT);
        });
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
                spreadRadius: 0)
          ]),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Flexible(
              child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Available Balance',
                style: TextStyle(
                    fontSize: 13,
                    color: Colors.colorFaded,
                    fontWeight: FontWeight.normal),
              ),
              Align(
                alignment: Alignment.centerRight,
                child: Container(
                  padding:
                      EdgeInsets.only(left: 9, right: 9, top: 5, bottom: 5),
                  decoration: BoxDecoration(
                      color: Colors.darkBlue.withOpacity(0.5),
                      borderRadius: BorderRadius.all(Radius.circular(16))),
                  child: Center(
                    child: Text('SAVINGS',
                        style: TextStyle(color: Colors.white, fontSize: 12)),
                  ),
                ),
              )
            ],
          )),
          SizedBox(height: 5),
          Flexible(
              child: StreamBuilder(
            stream: viewModel.balanceStream,
            builder: (context, AsyncSnapshot<AccountBalance?> snapShot) {
              final accountBalance = snapShot.hasData
                  ? snapShot.data?.availableBalance?.formatCurrency ?? "--"
                  : '--';
              return Text(
                accountBalance,
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                    fontWeight: FontWeight.bold),
              );
            },
          )),
          SizedBox(height: 5),
          Flexible(
              child: StreamBuilder(
            stream: viewModel.balanceStream,
            builder: (context, AsyncSnapshot<AccountBalance?> snapShot) {
              final accountBalance = snapShot.hasData
                  ? snapShot.data?.ledgerBalance?.formatCurrency ?? "--"
                  : '--';
              return Text(
                'Ledger Balance: $accountBalance',
                style: TextStyle(
                    color: Colors.colorFaded,
                    fontSize: 12,
                    fontFamily: Styles.defaultFont,
                    fontWeight: FontWeight.normal,
                    fontFamilyFallback: ["Roboto"]),
              ).colorText({accountBalance: Tuple(Colors.white, null)},
                  bold: false, underline: false);
            },
          )),
          SizedBox(height: 2),
          Flexible(
            child: Opacity(
              opacity: opacityValue,
              child: Row(
                children: [
                  Expanded(
                      child: Divider(
                    color: Colors.white.withOpacity(0.2),
                    height: 1,
                  )),
                  SizedBox(width: 6),
                  Styles.imageButton(
                      onClick: _displaySettingsDialog,
                      color: Colors.white.withOpacity(0.2),
                      padding:
                          EdgeInsets.symmetric(horizontal: 5.2, vertical: 4),
                      borderRadius: BorderRadius.circular(4),
                      image: SvgPicture.asset(
                        'res/drawables/ic_settings.svg',
                        width: 20,
                        height: 20,
                      ))
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
                    Text('A/C No.',
                        style:
                            TextStyle(color: Colors.colorFaded, fontSize: 13)),
                    Text(
                        viewModel.customerAccountNumber(
                            accountId: widget.customerAccountId),
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(color: Colors.white, fontSize: 14))
                  ],
                )),
                SizedBox(
                  width: 32,
                ),
                Flexible(
                    child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                      Text('Account Name',
                          style: TextStyle(
                              color: Colors.colorFaded, fontSize: 13)),
                      Text(
                          viewModel.customerAccountName(
                              accountId: widget.customerAccountId),
                          overflow: TextOverflow.ellipsis,
                          maxLines: 1,
                          style: TextStyle(color: Colors.white, fontSize: 14))
                    ])),
              ],
            ),
          ))
        ],
      ),
    );
  }

  Widget filterMenu() {
    return Flexible(
        flex: 0,
        child: Padding(
          padding: EdgeInsets.only(left: 24, right: 23, bottom: 7.8),
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
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                style: ButtonStyle(
                    minimumSize: MaterialStateProperty.all(Size(40, 0)),
                    tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    overlayColor: MaterialStateProperty.all(
                        Colors.darkBlue.withOpacity(0.2)),
                    padding: MaterialStateProperty.all(
                        EdgeInsets.symmetric(horizontal: 22, vertical: 8)),
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
                    overlayColor: MaterialStateProperty.all(
                        Colors.primaryColor.withOpacity(0.1)),
                    padding: MaterialStateProperty.all(
                        EdgeInsets.only(left: 8, right: 2, top: 8, bottom: 8)),
                  ))
            ],
          ),
        ));
  }

  Widget _listContainer(TransactionHistoryViewModel viewModel, double yOffset,
      {Widget? child}) {
    final double topPadding = min(100, 100 - min(76, (yOffset - 1) * 0.2));

    return Container(
      padding: EdgeInsets.only(top: topPadding),
      height: double.infinity,
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
              topRight: Radius.circular(30), topLeft: Radius.circular(30)),
          boxShadow: [
            BoxShadow(
                color: Colors.primaryColor.withOpacity(0.01),
                offset: Offset(0, -1),
                blurRadius: 3,
                spreadRadius: 0)
          ]),
      child: child,
    );
  }

  void _refresh(TransactionHistoryViewModel viewModel) {
    _pagingSource = viewModel.getPagedHistoryTransaction(
        accountId: widget.customerAccountId);
  }

  void _dateFilterDateChanged(int startDate, int endDate) {
    final viewModel =
        Provider.of<TransactionHistoryViewModel>(context, listen: false);
    setState(() {
      viewModel.setStartAndEndDate(startDate, endDate);
      _refresh(viewModel);
    });
  }

  void _channelFilterChanged(List<TransactionChannel> channels) {
    final viewModel =
        Provider.of<TransactionHistoryViewModel>(context, listen: false);
    setState(() {
      viewModel.setChannels(channels);
      _refresh(viewModel);
    });
  }

  void _typeFilterChanged(List<TransactionType> types) {
    final viewModel =
        Provider.of<TransactionHistoryViewModel>(context, listen: false);
    setState(() {
      viewModel.setTransactionTypes(types);
      _refresh(viewModel);
    });
  }

  void _onCancelFilter() {
    final viewModel =
        Provider.of<TransactionHistoryViewModel>(context, listen: false);
    setState(() {
      isInFilterMode = false;
      _isFilterOpened = false;
      viewModel.resetFilter();
      //TODO check if what we had before and now is the same
      _refresh(viewModel);
    });
  }

  void _retry() {
    final viewModel =
        Provider.of<TransactionHistoryViewModel>(context, listen: false);
    setState(() {
      _refresh(viewModel);
    });
  }

  Widget _mainPageContent(
      PagingData value,
      TransactionHistoryViewModel viewModel,
      bool isEmpty,
      Tuple<String, String>? error) {
    return Column(
      children: [
        // Visibility(
        //   visible: isInFilterMode && error == null,
        //   child: Flexible(
        //     flex: 0,
        //     child: FilterLayout(
        //       _scaffoldKey,
        //       viewModel.filterableItems,
        //       dateFilterCallback: _dateFilterDateChanged,
        //       typeFilterCallback: _typeFilterChanged,
        //       channelFilterCallback: _channelFilterChanged,
        //       onCancel: _onCancelFilter,
        //       isPreviouslyOpened: _isFilterOpened,
        //       onOpen: () {
        //         _isFilterOpened = true;
        //       },
        //     ),
        //   ),
        // ),
        // Visibility(
        //     visible: !isInFilterMode && error == null, child: filterMenu()),
        // SizedBox(
        //   height: 12,
        // ),
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
                  ErrorLayoutView(
                      error?.first ?? "", error?.second ?? "", _retry),
                  SizedBox(
                    height: 50,
                  )
                ],
              ),
            )),
        Visibility(
          visible: !isEmpty && error == null,
          child: Expanded(
              child: ListView.separated(
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

  Widget _pagingView(TransactionHistoryViewModel viewModel,
      ScrollController _scrollController) {
    return DraggableScrollableSheet(
        initialChildSize: 0.4,
        minChildSize: 0.4,
        maxChildSize: 0.686,
        // expand: false,
        builder: (ctx, ScrollController scrollController) {
          // pageViewController = controller;
          return Container(
              // padding: EdgeInsets.only(top: 27),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.vertical(
                  top: Radius.circular(22),
                ),
              ),
              child: Pager<int, AccountTransaction>(
                  pagingConfig:
                      PagingConfig(pageSize: 800, initialPageSize: 800),
                  source: _pagingSource,
                  scrollController: scrollController,
                  builder: (context, value, _) {
                    return ListViewUtil.handleLoadStates(
                        animationController: _animationController,
                        pagingData: value,
                        shimmer: AccountListShimmer(),
                        listCallback: (PagingData data, bool isEmpty, error) {
                          bool isAccountLiened = false;
                          return Stack(
                            children: [
                              ListView(
                                controller: scrollController,
                                children: [
                                  if (isAccountLiened) SizedBox(height: 40),
                                  if (!isEmpty && error == null)
                                    SizedBox(
                                        height: isAccountLiened ? 133 : 90),
                                  Container(
                                    height: 800,
                                    child: _mainPageContent(
                                        value, viewModel, isEmpty, error),
                                  ),
                                ],
                              ),
                              IgnorePointer(
                                ignoring: true,
                                child: Column(
                                  children: [
                                    Container(
                                      width: double.infinity,
                                      height: isAccountLiened ? 155 : 88,
                                      decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius: BorderRadius.vertical(
                                          top: Radius.circular(22),
                                        ),
                                      ),
                                    ),
                                    // SizedBox(height: 15),
                                    Divider(
                                      height: 2,
                                      color: Colors.black.withOpacity(0.15),
                                    )
                                  ],
                                ),
                              ),
                              Column(
                                children: [
                                  SizedBox(height: 27),
                                  if (isAccountLiened)
                                    Container(
                                        margin: EdgeInsets.symmetric(
                                            horizontal: 20),
                                        padding:
                                            EdgeInsets.fromLTRB(12, 12, 17, 12),
                                        decoration: BoxDecoration(
                                            color: Color(0xff2BF0AA22),
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(9))),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Row(
                                              children: [
                                                SvgPicture.asset(
                                                  'res/drawables/ic_info.svg',
                                                  color: Color(0xffF08922),
                                                ),
                                                SizedBox(width: 12),
                                                Text(
                                                  "Account Liened. Learn More",
                                                  style: TextStyle(
                                                      fontSize: 12,
                                                      color: Color(0xffF08922)),
                                                )
                                              ],
                                            ),
                                            SvgPicture.asset(
                                              'res/drawables/ic_forward_anchor.svg',
                                              color: Color(0xffF08922),
                                              height: 16.75,
                                              width: 10,
                                            )
                                          ],
                                        )),
                                  if (isAccountLiened) SizedBox(height: 18),
                                  Visibility(
                                    visible: isInFilterMode && error == null,
                                    child: Flexible(
                                      flex: 0,
                                      child: FilterLayout(
                                        _scaffoldKey,
                                        viewModel.filterableItems,
                                        dateFilterCallback:
                                            _dateFilterDateChanged,
                                        typeFilterCallback: _typeFilterChanged,
                                        channelFilterCallback:
                                            _channelFilterChanged,
                                        onCancel: _onCancelFilter,
                                        isPreviouslyOpened: _isFilterOpened,
                                        onOpen: () {
                                          _isFilterOpened = true;
                                        },
                                      ),
                                    ),
                                  ),
                                  Visibility(
                                      visible: !isInFilterMode && error == null,
                                      child: filterMenu()),
                                ],
                              )
                            ],
                          );
                        });
                  }));
        });
  }

  void _onScroll() {
    // yOffset = _scrollController.offset;
    // if (yOffset >= 0 && yOffset <= 1000) {
    //   setState(() {});
    // }
  }

  List<Widget> _positionalWidgets(
      TransactionHistoryViewModel viewModel, Offset value) {
    final double listTop = min(170, 170 - min(60, (value.dy - 1) * 0.2));
    final double balanceViewSides = min(42, 42 - min(42, (value.dy - 1) * 0.2));

    final listPagePosition = Positioned(
        key: Key("list-view-0"),
        top: listTop,
        bottom: 0,
        right: 0,
        left: 0,
        child: _listContainer(viewModel, value.dy,
            child: _pagingView(viewModel, _scrollController)));

    final balanceContainerPosition = Positioned(
        key: Key("dashboard-balance-${widget.customerAccountId}"),
        right: balanceViewSides,
        left: balanceViewSides,
        top: balanceViewSides,
        child: Hero(
          tag: "dashboard-balance-view-${widget.customerAccountId}",
          child: balanceView(viewModel, value.dy),
        ));

    final _listItems = <Widget>[];
    _listItems.insert(0,
        (balanceViewSides != 0) ? listPagePosition : balanceContainerPosition);
    _listItems.insert(1,
        (balanceViewSides != 0) ? balanceContainerPosition : listPagePosition);

    return _listItems;
  }

  @override
  Widget build(BuildContext context) {
    final viewModel =
        Provider.of<TransactionHistoryViewModel>(context, listen: false);
    return SessionedWidget(
      context: context,
      child: TweenAnimationBuilder(
          duration: Duration(milliseconds: 430),
          tween: Tween<Offset>(begin: Offset(0, 0), end: Offset(0, yOffset)),
          builder: (mContext, Offset value, _) {
            final appBarColorTween =
                ColorTween(begin: Colors.primaryColor, end: Colors.transparent)
                    .evaluate(AlwaysStoppedAnimation(
                        min(100, 100 - min(100, (value.dy - 1) * 0.5)) / 100));

            final appBarIconTween =
                ColorTween(begin: Colors.white, end: Colors.primaryColor)
                    .evaluate(AlwaysStoppedAnimation(
                        min(100, 100 - min(100, (value.dy - 1) * 0.5)) / 100));

            final appBarTextTween =
                ColorTween(begin: Colors.white, end: Colors.darkBlue).evaluate(
                    AlwaysStoppedAnimation(
                        min(100, 100 - min(100, (value.dy - 1) * 0.5)) / 100));

            return Scaffold(
              backgroundColor: Color(0XFFEBF2FA),
              body: Stack(
                children: [
                  Positioned.fill(
                    child: Image.asset(
                      "res/drawables/ic_app_bg_dark.png",
                      fit: BoxFit.fill,
                    ),
                  ),
                  Column(
                    children: [
                      SizedBox(height: 57),
                      Container(
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
                                SizedBox(
                                  width: 10,
                                ),
                                Text(
                                  "Account Details",
                                  style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w700,
                                      color: Colors.textColorBlack),
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
                      ),
                      SizedBox(height: 37),
                      AccountDetailsCard(
                        viewModel: viewModel,
                        userAccount: widget.userAccount,
                      ),
                    ],
                  ),
                  _pagingView(viewModel, _scrollController)
                ],
              ),
            );

            // return Scaffold(
            //   key: _scaffoldKey,
            //   backgroundColor: Color(0XFFEAF4FF),
            //   appBar: AppBar(
            //       centerTitle: false,
            //       titleSpacing: -12,
            //       iconTheme: IconThemeData(color: appBarIconTween),
            //       title: Text('Account',
            //           textAlign: TextAlign.start,
            //           style: TextStyle(
            //               color: appBarTextTween,
            //               fontFamily: Styles.defaultFont,
            //               fontSize: 17)),
            //       backgroundColor: appBarColorTween,
            //       elevation: 0),
            //   body: SessionedWidget(
            //     context: context,
            //     child: Stack(
            //       fit: StackFit.expand,
            //       children: _positionalWidgets(viewModel, value),
            //     ),
            //   ),
            // );
          }),
    );
  }

  void _downloadAccountStatement() async {
    final viewModel =
        Provider.of<TransactionHistoryViewModel>(context, listen: false);
    final selectedDate = await showModalBottomSheet(
        isScrollControlled: true,
        backgroundColor: Colors.transparent,
        context: context,
        builder: (mContext) => DateFilterDialog(
            dialogTitle: "Download Statement",
            dialogIcon: "res/drawables/ic_download_statement.svg"));

    if (selectedDate != null && selectedDate is Tuple<int?, int?>) {
      try {
        final fileName =
            "AccountTransaction_Export_${viewModel.accountName}_${DateFormat("dd_MM_yyyy_h_m_s").format(DateTime.now())}.pdf";
        final downloadTask = () => viewModel.exportStatement(
            selectedDate.first, selectedDate.second,
            accountId: widget.customerAccountId);
        await DownloadUtil.downloadTransactionReceipt(downloadTask, fileName,
            isShare: false, onProgress: (int progress, isComplete) {
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
        showError(context,
            title: "Oops",
            message: "Failed to download account statement receipt");
      }
    }
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }
}

class AccountDetailsCard extends StatefulWidget {
  const AccountDetailsCard(
      {required this.viewModel, required this.userAccount});

  final TransactionHistoryViewModel viewModel;
  final UserAccount userAccount;

  @override
  _AccountDetailsCardState createState() => _AccountDetailsCardState();
}

class _AccountDetailsCardState extends State<AccountDetailsCard> {
  @override
  Widget build(BuildContext context) {
    final viewModel = widget.viewModel;
    final userAccount = widget.userAccount;
    return Stack(
      children: [
        Container(
          margin: EdgeInsets.symmetric(horizontal: 19),
          constraints: BoxConstraints(maxHeight: 305),
          width: double.infinity,
          decoration: BoxDecoration(
              color: Colors.backgroundWhite,
              // color: Colors.black,
              borderRadius: BorderRadius.all(Radius.circular(16)),
              boxShadow: [
                BoxShadow(
                  offset: Offset(0, 13),
                  blurRadius: 21,
                  color: Color(0xff1F0E4FB1).withOpacity(0.12),
                ),
              ]),
          child: Column(
            children: [
              SizedBox(height: 30),
              Material(
                color: Colors.transparent,
                child: InkWell(
                  overlayColor: MaterialStateProperty.all(
                      Colors.darkLightBlue.withOpacity(0.1)),
                  onTap: () {},
                  child: AccountDetails(
                    customerAccount: userAccount.customerAccount,
                    userAccount: userAccount,
                    viewModel: viewModel,
                  ),
                ),
              ),
            ],
          ),
        ),
        Align(
          alignment: Alignment(0.0, -1.5),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SvgPicture.asset(
                "res/drawables/ic_dashboard_account_label.svg",
                width: 197,
                height: 22,
              ),
            ],
          ),
        ),
        Align(
          alignment: Alignment.topCenter,
          child: Column(
            children: [
              SizedBox(height: 6),
              Text(
                'SAVINGS',
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 10.6,
                    fontWeight: FontWeight.w700),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class AccountDetails extends StatefulWidget {
  const AccountDetails(
      {Key? key,
      required this.customerAccount,
      required this.userAccount,
      required this.viewModel})
      : super(key: key);

  final CustomerAccount? customerAccount;
  final UserAccount userAccount;
  final TransactionHistoryViewModel viewModel;

  @override
  _AccountDetailsState createState() => _AccountDetailsState();
}

class _AccountDetailsState extends State<AccountDetails>
    with CompositeDisposableWidget, WidgetsBindingObserver {
  Stream<Resource<AccountBalance>>? _balanceStream;

  @override
  void initState() {
    super.initState();
    // widget.viewModel.tranasactionListController.listen((event) {
    //   setState(() {});
    // }).disposedBy(this);
    // print("Updating  balance Stream ooo");

    _balanceStream = widget.viewModel.getCustomerAccountBalance(
        accountId: widget.userAccount.id, useLocal: false);

    widget.viewModel.checkAccountUpdate();
  }

  @override
  void didUpdateWidget(covariant AccountDetails oldWidget) {
    _balanceStream = widget.viewModel.getCustomerAccountBalance(
        accountId: widget.userAccount.id, useLocal: false);
    super.didUpdateWidget(oldWidget);
  }

  @override
  void dispose() {
    WidgetsBinding.instance?.removeObserver(this);
    super.dispose();
  }

  int getQualifiedTierIndex() {
    final tiers = widget.viewModel.tiers;
    return Tier.getQualifiedTierIndex(tiers);
  }

  @override
  Widget build(BuildContext context) {
    final customerAccount = widget.customerAccount;
    final qualifiedTierIndex = getQualifiedTierIndex();
    return Column(children: [
      Stack(
        children: [
          Container(
            padding: EdgeInsets.symmetric(horizontal: 19),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 8),
                Text(
                  "Available Balance",
                  style: TextStyle(
                      fontSize: 12.3,
                      letterSpacing: -0.2,
                      fontWeight: FontWeight.w600,
                      color: Colors.textColorBlack.withOpacity(0.9)),
                ),
                SizedBox(height: 4),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    StreamBuilder(
                        stream: _balanceStream,
                        builder: (ctx,
                            AsyncSnapshot<Resource<AccountBalance?>> snapshot) {
                          final isLoadingBalanceError =
                              snapshot.hasData && snapshot.data is Error;
                          final isLoadingBalance =
                              snapshot.hasData && snapshot.data is Loading;
                          final AccountBalance? accountBalance =
                              (snapshot.hasData && snapshot.data != null)
                                  ? snapshot.data!.data
                                  : null;

                          if (snapshot.hasData &&
                              (!isLoadingBalance && !isLoadingBalanceError)) {
                            final availableBalance =
                                "${accountBalance?.availableBalance?.formatCurrencyWithoutSymbolAndDividing}";
                            final ledgerBalance =
                                "${accountBalance?.ledgerBalance?.formatCurrencyWithoutSymbolAndDividing}";

                            return Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    SvgPicture.asset(
                                      "res/drawables/ic_naira.svg",
                                      width: 20,
                                      height: 17,
                                    ),
                                    SizedBox(width: 4),
                                    Text('$availableBalance',
                                        style: Styles.textStyle(context,
                                            fontSize: 23.5,
                                            fontWeight: FontWeight.w800,
                                            color: Colors.textColorBlack)),
                                  ],
                                ),
                                SizedBox(height: 5),
                                Text('Ledger Balance: N $ledgerBalance',
                                    style: Styles.textStyle(context,
                                        fontSize: 12,
                                        fontWeight: FontWeight.w400,
                                        color: Colors.deepGrey)),
                              ],
                            );
                          }

                          if (isLoadingBalanceError) {
                            return Padding(
                                padding: EdgeInsets.only(right: 8, bottom: 8),
                                child: Text('Error Loading balance\nTry Again',
                                        style: TextStyle(
                                            fontSize: 18,
                                            fontWeight: FontWeight.w700,
                                            color: Colors.textColorBlack))
                                    .colorText({
                                  "Try Again": Tuple(Colors.primaryColor, () {
                                    widget.viewModel.update();
                                  })
                                }));
                          }

                          return Column(
                            children: [
                              Shimmer.fromColors(
                                  period: Duration(milliseconds: 1000),
                                  child: Align(
                                      alignment: Alignment.centerLeft,
                                      child: Container(
                                        width: 90,
                                        height: 30,
                                        decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(10),
                                            color:
                                                Colors.white.withOpacity(0.3),
                                            shape: BoxShape.rectangle),
                                      )),
                                  baseColor: Colors.white.withOpacity(0.6),
                                  highlightColor:
                                      Colors.deepGrey.withOpacity(0.6)),
                              SizedBox(height: 5),
                              Shimmer.fromColors(
                                  period: Duration(milliseconds: 1000),
                                  child: Align(
                                      alignment: Alignment.centerLeft,
                                      child: Container(
                                        width: 90,
                                        height: 14,
                                        decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(10),
                                            color:
                                                Colors.white.withOpacity(0.3),
                                            shape: BoxShape.rectangle),
                                      )),
                                  baseColor: Colors.white.withOpacity(0.6),
                                  highlightColor:
                                      Colors.deepGrey.withOpacity(0.6))
                            ],
                          );
                        }),
                    // _buildVisibilityIcon()
                  ],
                ),
                SizedBox(height: 16)
              ],
            ),
          ),
          Positioned(
            top: 2,
            right: 13,
            child: SvgPicture.asset(
              "res/drawables/account_tier_bg.svg",
              height: 33,
              width: 16,
              color: getTierColor(qualifiedTierIndex).withOpacity(0.2),
            ),
          ),
          Positioned(
            top: 6,
            right: 17,
            child: Container(
              height: 24.6,
              width: 24.6,
              decoration: BoxDecoration(
                color: getTierColor(getQualifiedTierIndex()),
                shape: BoxShape.circle,
              ),
              child: Center(
                  child: text("$qualifiedTierIndex",
                      color: Colors.white, fontSize: 17)),
            ),
          ),
          Positioned(
            top: 12,
            right: 50,
            child: text("TIER",
                color: getTierColor(qualifiedTierIndex), fontSize: 9.2),
          )
        ],
      ),
      Container(
        margin: EdgeInsets.symmetric(horizontal: 19),
        decoration: BoxDecoration(
          color: Colors.primaryColor.withOpacity(0.05),
          borderRadius: BorderRadius.all(Radius.circular(9)),
        ),
        child: Column(
          children: [
            SizedBox(height: 14),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 14.5),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        label("Account Name"),
                        SizedBox(height: 4),
                        text(customerAccount?.accountName
                                ?.toLowerCase()
                                .capitalizeFirstOfEach ??
                            ""),
                        // text("Isah Leslie Williams James Amen" ?? ""),
                      ],
                    ),
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      label("Scheme"),
                      SizedBox(height: 4),
                      text(customerAccount?.schemeCode?.code ?? "")
                    ],
                  )
                ],
              ),
            ),
            SizedBox(height: 18),
            Container(
                width: double.infinity,
                child: Divider(
                  height: 1,
                  color: Colors.primaryColor.withOpacity(0.3),
                )),
            SizedBox(height: 18),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 14.5),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  label("Account Number"),
                ],
              ),
            ),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 14.5),
              margin: EdgeInsets.only(top: 4),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  text(customerAccount?.accountNumber ?? ""),
                  // text("50002347702" ?? ""),

                  if (widget.viewModel.isAccountUpdateCompleted)
                    Styles.imageButton(
                      padding: EdgeInsets.all(9),
                      color: Colors.transparent,
                      borderRadius: BorderRadius.circular(30),
                      onClick: () => Share.share(
                          "Moniepoint MFB\n${widget.customerAccount?.accountNumber}\n${widget.customerAccount?.customer?.name}",
                          subject: 'Moniepoint MFB'),
                      image: SvgPicture.asset(
                        'res/drawables/ic_share.svg',
                        fit: BoxFit.contain,
                        width: 20,
                        height: 21,
                        color: Color(0xffB8003382).withOpacity(0.4),
                      ),
                    ),
                  if (!widget.viewModel.isAccountUpdateCompleted)
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        InkWell(
                          onTap: () => Navigator.of(context)
                              .pushNamed(Routes.ACCOUNT_UPDATE),
                          child: text("Upgrade Account",
                              color: Colors.primaryColor, fontSize: 14),
                        ),
                        SizedBox(width: 2),
                        Styles.imageButton(
                            onClick: () => Navigator.of(context)
                                .pushNamed(Routes.ACCOUNT_UPDATE),
                            color: Colors.white.withOpacity(0.2),
                            padding: EdgeInsets.symmetric(
                                horizontal: 5.2, vertical: 4),
                            borderRadius: BorderRadius.circular(4),
                            image: SvgPicture.asset(
                              'res/drawables/ic_forward_anchor.svg',
                              width: 8.13,
                              height: 13.47,
                              color: Colors.primaryColor,
                            ))
                      ],
                    ),
                ],
              ),
            ),
            SizedBox(height: 17)
          ],
        ),
      ),
    ]);
  }

  Widget label(String label) {
    return Text(
      label,
      style: TextStyle(
          fontWeight: FontWeight.w400,
          fontSize: 12.8,
          color: Colors.textColorBlack),
    );
  }

  Widget text(String text, {Color? color, double? fontSize}) {
    return Text(
      text,
      overflow: TextOverflow.ellipsis,
      maxLines: 2,
      style: TextStyle(
        fontWeight: FontWeight.w600,
        fontSize: fontSize ?? 15.54,
        color: color ?? Colors.textColorBlack,
      ),
    );
  }

  Color getTierColor(int tier) {
    if (tier <= 1) return Color(0xff905E24);
    if (tier == 2) return Color(0xff8A8A8A);
    return Color(0xffCCA004);
  }

  // Widget _buildVisibilityIcon() {
  //   final bool hideAccountBalance =
  //       PreferenceUtil.getValueForLoggedInUser(hideAccountBalanceKey) ?? false;
  //
  //   return Padding(
  //     padding: EdgeInsets.only(right: 16),
  //     child: Styles.imageButton(
  //         padding: EdgeInsets.all(9),
  //         color: Colors.transparent,
  //         disabledColor: Colors.transparent,
  //         image: SvgPicture.asset(
  //           hideAccountBalance
  //               ? 'res/drawables/ic_eye_open.svg'
  //               : 'res/drawables/ic_eye_closed.svg',
  //           width: hideAccountBalance ? 10 : 16,
  //           height: hideAccountBalance ? 12 : 16,
  //           color: Color(0xffB8003382).withOpacity(0.4),
  //         ),
  //         onClick: () {
  //           PreferenceUtil.saveValueForLoggedInUser(
  //               hideAccountBalanceKey, hideAccountBalance ? false : true);
  //           setState(() {});
  //         }),
  //   );
  // }
}
