import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart' hide Colors;
import 'package:flutter_svg/flutter_svg.dart';
import 'package:moniepoint_flutter/app/accounts/model/data/account_balance.dart';
import 'package:moniepoint_flutter/app/accounts/views/accounts_shimmer_view.dart';
import 'package:moniepoint_flutter/app/dashboard/views/dashboard_menu_item.dart';
import 'package:moniepoint_flutter/app/savings/modules/flex/model/data/flex_account_balance.dart';
import 'package:moniepoint_flutter/app/savings/modules/flex/model/data/flex_saving.dart';
import 'package:moniepoint_flutter/app/savings/modules/flex/model/data/flex_transaction.dart';
import 'package:moniepoint_flutter/app/savings/modules/flex/viewmodels/flex_savings_dashboard_view_model.dart';
import 'package:moniepoint_flutter/app/savings/modules/flex/views/flex_dashboard_balance_loading_shimmer.dart';
import 'package:moniepoint_flutter/core/colors.dart';
import 'package:moniepoint_flutter/core/network/resource.dart';
import 'package:moniepoint_flutter/core/paging/page_config.dart';
import 'package:moniepoint_flutter/core/paging/pager.dart';
import 'package:moniepoint_flutter/core/paging/paging_data.dart';
import 'package:moniepoint_flutter/core/paging/paging_source.dart';
import 'package:moniepoint_flutter/core/routes.dart';
import 'package:moniepoint_flutter/core/styles.dart';
import 'package:moniepoint_flutter/core/tuple.dart';
import 'package:moniepoint_flutter/core/utils/currency_util.dart';
import 'package:moniepoint_flutter/core/utils/list_view_util.dart';
import 'package:moniepoint_flutter/core/views/empty_list_layout_view.dart';
import 'package:moniepoint_flutter/core/views/error_layout_view.dart';
import 'package:moniepoint_flutter/core/views/sessioned_widget.dart';
import 'package:moniepoint_flutter/main.dart';
import 'package:provider/provider.dart';
import 'package:share/share.dart';

import 'flex_transaction_history_list_item.dart';

class FlexSavingsAccountDashboardView extends StatefulWidget {

  const FlexSavingsAccountDashboardView({
    Key? key,
    required this.flexSavingId,
  }) : super(key: key);

  final int flexSavingId;

  @override
  _FlexSavingsAccountDashboardViewState createState() => _FlexSavingsAccountDashboardViewState();

}

class _FlexSavingsAccountDashboardViewState extends State<FlexSavingsAccountDashboardView> with SingleTickerProviderStateMixin {

  late final FlexSavingsDashboardViewModel _viewModel;

  late final double toolBarMarginTop = 37;
  late final double maxDraggableTop = toolBarMarginTop * 4.2;

  late final AnimationController _animationController = AnimationController(
      vsync: this, duration: Duration(milliseconds: 1000)
  );

  PagingSource<int, FlexTransaction> _pagingSource = PagingSource.empty();
  Stream<Resource<FlexAccountBalance>> _balanceStream = Stream.empty();
  Future<FlexSaving?> _flexSavingFuture = Future.value(null);

  @override
  void initState() {
    _viewModel = Provider.of<FlexSavingsDashboardViewModel>(context, listen: false);
    _pagingSource = _viewModel.getPageFlexTransactions(widget.flexSavingId);
    _balanceStream = _viewModel.getFlexAccountBalance(widget.flexSavingId);
    _flexSavingFuture = _viewModel.getFlexSaving(widget.flexSavingId);

    super.initState();
    WidgetsBinding.instance?.addPostFrameCallback((timeStamp) {
      //This really isn't an important load, so we can delay it
      Future.delayed(Duration(milliseconds: 100), () => _viewModel.initialLoad(widget.flexSavingId));
    });
  }

  void onItemClick(String routeName, int position){
    if(routeName == Routes.SAVINGS_FLEX_SETTINGS) {
      Navigator.of(context).pushNamed(
          Routes.SAVINGS_FLEX_SETUP,
          arguments: {"flexSaving": _viewModel.flexSaving}
      ).then((value) {
        setState(() {
          _pagingSource = _viewModel.getPageFlexTransactions(widget.flexSavingId);
        });
      });
      return;
    }

    navigatorKey.currentState?.pushNamed(
        routeName,
        arguments: {"flexSavingId": _viewModel.flexSaving?.id}
    ).then((value) {
      setState(() {
        _pagingSource = _viewModel.getPageFlexTransactions(widget.flexSavingId);
      });
    });
  }

  void _reloadDashboard() {
    setState(() {
      _pagingSource = _viewModel.getPageFlexTransactions(widget.flexSavingId);
      _flexSavingFuture = _viewModel.getFlexSaving(widget.flexSavingId);
    });
  }

  Widget _makeListView() {
    final screenSize = MediaQuery.of(context).size;
    final maxExtent = 1.0;
    final containerHeight = 270;
    final minExtent = 1 - (containerHeight / (screenSize.height - maxDraggableTop));

    return DraggableScrollableSheet(
        initialChildSize: minExtent,
        minChildSize: minExtent,
        maxChildSize: maxExtent,
        builder: (ctx, controller) {
          return Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.vertical(top: Radius.circular(22),),
              border: Border.all(
                  width: 1.0,
                  color: Color(0xff063A4F0D).withOpacity(0.05)
              ),
            ),
            child: Stack(
              children: [
                TransactionListPager(
                  pagingSource: _pagingSource,
                  controller: controller,
                  animationController: _animationController,
                  retry: () {
                    setState(() {
                      _pagingSource = _viewModel.getPageFlexTransactions(widget.flexSavingId);
                    });
                  }
                ),
                IgnorePointer(
                  child: Container(
                    height: 61,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.vertical(top: Radius.circular(22)),
                    ),
                  ),
                ),
                Positioned(
                    top: 26, left: 20, right: 0,
                    child: Text(
                        "Savings History",
                        style: TextStyle(
                          fontSize: 17,
                          fontWeight: FontWeight.w700,
                        )
                    )
                ),
                Positioned(
                    top: 61, left: 0, right: 0,
                    child: Divider(
                      height: 0.8,
                      thickness: 0.4,
                      color: Colors.black.withOpacity(0.1),
                    )
                )
              ],
            ),
          );
        }
    );
  }

  @override
  Widget build(BuildContext context) {
    return SessionedWidget(
      context: context,
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
            centerTitle: false,
            titleSpacing: 0,
            iconTheme: IconThemeData(color: Colors.solidGreen),
            title: Text(
                'Savings',
                textAlign: TextAlign.start,
                style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                    color: Colors.textColorBlack
                )
            ),
            backgroundColor: Color(0XFFF5F5F5).withOpacity(0.7),
            elevation: 0
        ),
        body: FutureBuilder(
            future: _flexSavingFuture,
            builder: (ctx, AsyncSnapshot<FlexSaving?> snap) {
              final FlexSaving? flexSaving = snap.data;

              if (snap.hasData == false || flexSaving == null) return Container();

              _viewModel.setFlexSaving(flexSaving);

              return Container(
                color: Color(0XFFF5F5F5).withOpacity(0.7),
                child: Stack(
                  children: [
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(height: 30),
                          Text(
                            "Flex Savings",
                            style: TextStyle(fontSize: 24, fontWeight: FontWeight.w700),
                          ),
                          SizedBox(height: 25),
                          FlexDashboardSavingsCard(
                            flexSaving: flexSaving,
                            balanceStream: _balanceStream,
                            reload: _reloadDashboard
                          ),
                          SizedBox(height: 30),
                          FlexAccountMenu(onItemClick: onItemClick)
                        ],
                      ),
                    ),
                    Positioned(
                      top: maxDraggableTop,
                      left: 0,
                      right: 0,
                      bottom: 0,
                      child: _makeListView(),
                    )
                  ],
                ),
              );
            }),
      ),
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }
}

///TransactionListPager
///
///
class TransactionListPager extends StatelessWidget {

  TransactionListPager({
    required this.pagingSource,
    required this.animationController,
    required this.controller,
    this.retry
  });

  final PagingSource<int, FlexTransaction> pagingSource;
  final AnimationController animationController;
  final ScrollController controller;
  final Function()? retry;

  Widget _listCallback (PagingData value, bool isEmpty, Tuple<String, String>? error) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Visibility(
            visible: isEmpty,
            child: Expanded(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  SizedBox(height: 100),
                  EmptyLayoutView("You have no savings history yet.")
                ],
              ),
            )
        ),
        Visibility(
            visible: error != null,
            child: Expanded(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  SizedBox(height: 100),
                  ErrorLayoutView(
                    error?.first ?? "",
                    error?.second ?? "", () => retry?.call()
                  )
                ],
              ),
            )
        ),
        Visibility(
            visible: !isEmpty && error == null,
            child: Expanded(
                child: ListView.separated(
                  physics: ClampingScrollPhysics(),
                  padding: EdgeInsets.only(top: 70),
                  controller: controller,
                  itemCount: value.data.length,
                  separatorBuilder: (context, index) => Padding(
                    padding: EdgeInsets.only(left: 24, right: 24),
                    child: Divider(height: 1),
                  ),
                  itemBuilder: (context, index) {
                    return FlexTransactionHistoryListItem(value.data[index], index, (item, i) {

                    });
                  },
                )
            )
        )
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Pager<int, FlexTransaction>(
        source: pagingSource,
        pagingConfig: PagingConfig(pageSize: 500, initialPageSize: 500),
        scrollController: controller,
        builder: (ctx, value, _) {
          return ListViewUtil.handleLoadStates(
              animationController: animationController,
              pagingData: value,
              shimmer: Column(children: [SizedBox(height: 20), AccountListShimmer(),],),
              listCallback: _listCallback
          );
        }
    );
  }
}

///FlexAccountMenu
///
///
class FlexAccountMenu extends StatelessWidget {

  FlexAccountMenu({required this.onItemClick});

  final OnItemClickListener<String, int> onItemClick;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        DashboardMenuItem(
          itemName: "Withdraw",
          onItemClick: onItemClick,
          itemIcon: SvgPicture.asset(
            "res/drawables/ic_savings_flex_withdraw.svg",
            width: 33,
            height: 34,
            color: Colors.solidGreen,
          ),
          routeName: Routes.SAVINGS_FLEX_WITHDRAW,
          circleBackgroundColor: Colors.solidGreen.withOpacity(0.1),
        ),
        DashboardMenuItem(
          itemName: "Top up",
          onItemClick: onItemClick,
          itemIcon: SvgPicture.asset(
            "res/drawables/ic_savings_flex_top_up.svg",
            width: 33,
            height: 34,
            color: Colors.solidGreen,
          ),
          routeName: Routes.SAVINGS_FLEX_TOP_UP,
          circleBackgroundColor: Colors.solidGreen.withOpacity(0.1),
        ),
        DashboardMenuItem(
          itemName: "Settings",
          onItemClick: onItemClick,
          itemIcon: SvgPicture.asset(
            "res/drawables/ic_more_settings.svg",
            width: 28,
            height: 22,
            color: Colors.solidGreen,
          ),
          routeName: Routes.SAVINGS_FLEX_SETTINGS,
          circleBackgroundColor: Colors.solidGreen.withOpacity(0.1),
        ),
      ],
    );
  }

}

///FlexDashboardSavingsCard
///
///
class FlexDashboardSavingsCard extends StatefulWidget {

  FlexDashboardSavingsCard({
    Key? key,
    required this.flexSaving,
    required this.balanceStream,
    this.reload
  }) : super(key: key);

  final FlexSaving flexSaving;
  final Stream<Resource<FlexAccountBalance>> balanceStream;
  final Function()? reload;


  @override
  State<StatefulWidget> createState() => _FlexDashboardSavingCardState();

}

class _FlexDashboardSavingCardState extends State<FlexDashboardSavingsCard> {

  void _shareReceipt() {
    final flexSaving = widget.flexSaving;
    Share.share(
        "Moniepoint MFB\n${flexSaving.cbaAccountNuban}\n${flexSaving.flexSavingScheme?.name}",
        subject: 'Moniepoint MFB');
  }

  final accountStyle = TextStyle(color: Colors.white, fontSize: 12.5, fontWeight: FontWeight.w600);

  Widget _getAccountBalance(AsyncSnapshot<Resource<FlexAccountBalance>> snap) {
    if (snap.data is Loading || snap.hasData == false) {
      return FlexDashboardBalanceLoadingShimmer(isLoading: true);
    } else if (snap.data is Error<AccountBalance>) {
      return Row(
        children: [
          Text(
            "Error Loading Balance",
            style: TextStyle(
                color: Colors.textColorBlack,
                fontWeight: FontWeight.w800,
                fontSize: 16.5
            ),
          )
        ],
      );
    }

    final accountBalance = snap.data?.data?.accountBalance;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Total Savings",
          style: TextStyle(color: Colors.white.withOpacity(0.8), fontWeight: FontWeight.w600, fontSize: 12.5),
        ),
        SizedBox(height: 4),
        Text(
          "${accountBalance?.availableBalance?.formatCurrency ?? "--"}",
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.w800, fontSize: 23.5),
        ),
      ],
    );
  }

  Widget _shareButton() => Padding(
      padding: EdgeInsets.only(right: 10),
      child: Styles.imageButton(
        padding: EdgeInsets.all(9),
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(30),
        onClick: _shareReceipt,
        image: SvgPicture.asset(
          'res/drawables/ic_share.svg',
          fit: BoxFit.contain,
          width: 20,
          height: 21,
          color: Colors.white.withOpacity(0.31),
        ),
      )
  );

  Widget _pendingSetUpView() {
    final flexSaving = widget.flexSaving;
    if(flexSaving.configCreated == true) return SizedBox.shrink();
    return Container(
      margin: EdgeInsets.only(left: 16, right: 16, top: 16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(9),
      ),
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(9),
        child: InkWell(
          onTap: () {
            Navigator.pushNamed(
                context,
                Routes.SAVINGS_FLEX_SETUP,
                arguments: {"flexSaving": flexSaving}
            ).then((value) {
              widget.reload?.call();
            });
          },
          borderRadius: BorderRadius.circular(9),
          child: Container(
            padding: EdgeInsets.only(left: 13, right: 13, top: 10, bottom: 10),
            decoration: BoxDecoration(
              color: Color(0XFF058729).withOpacity(0.47),
              borderRadius: BorderRadius.circular(9),
            ),
            child: Row(
              children: [
                SvgPicture.asset("res/drawables/ic_pending_setup.svg",),
                SizedBox(width: 9,),
                Text(
                  "Complete your setup",
                  style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: Colors.white
                  ),
                ),
                Spacer(),
                SvgPicture.asset("res/drawables/ic_forward_anchor.svg", color: Colors.white,)
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final flexSaving = widget.flexSaving;
    return Container(
      padding: EdgeInsets.only(top: 21, bottom: 14),
      decoration: BoxDecoration(
          color: Colors.solidGreen,
          borderRadius: BorderRadius.all(Radius.circular(16)),
          boxShadow: [
            BoxShadow(
                offset: Offset(0, 13),
                blurRadius: 21,
                color: Color(0xff0EB11E).withOpacity(0.3)
            )
          ]
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 20.0),
            child: StreamBuilder(
                stream: widget.balanceStream,
                builder: (ctx, AsyncSnapshot<Resource<FlexAccountBalance>> snap) {
                  return _getAccountBalance(snap);
                }
            ),
          ),
          _pendingSetUpView(),
          Padding(
            padding: const EdgeInsets.only(top: 8, bottom: 2),
            child: Divider(color: Colors.white.withOpacity(0.5)),
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 20.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Text("Account Number", style: accountStyle),
                    SizedBox(width: 4),
                    Text(
                      flexSaving.cbaAccountNuban ?? "",
                      style: accountStyle.copyWith(fontWeight: FontWeight.w700),
                    )
                  ],
                ),
                _shareButton(),
              ],
            ),
          )
        ],
      ),
    );
  }
}
