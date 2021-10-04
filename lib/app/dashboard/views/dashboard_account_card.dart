
import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart' hide Colors;
import 'package:flutter/rendering.dart';
import 'package:flutter_html/shims/dart_ui_real.dart';
import 'package:flutter_svg/svg.dart';
import 'package:moniepoint_flutter/app/accounts/model/data/account_balance.dart';
import 'package:moniepoint_flutter/app/accountupdates/model/data/account_upgrade_state.dart';
import 'package:moniepoint_flutter/app/accountupdates/views/restriction_pages/account_upgrade_route_delegate.dart';
import 'package:moniepoint_flutter/app/customer/user_account.dart';
import 'package:moniepoint_flutter/app/dashboard/viewmodels/dashboard_view_model.dart';
import 'package:moniepoint_flutter/core/extensions/composite_disposable_widget.dart';
import 'package:moniepoint_flutter/core/mix_panel_analytics.dart';
import 'package:moniepoint_flutter/core/network/resource.dart';
import 'package:moniepoint_flutter/core/routes.dart';
import 'package:moniepoint_flutter/core/styles.dart';
import 'package:moniepoint_flutter/core/utils/preference_util.dart';
import 'package:moniepoint_flutter/core/views/dots_indicator.dart';
import 'package:moniepoint_flutter/core/views/expandable_page_view.dart';
import 'package:provider/provider.dart';
import 'package:share/share.dart';
import 'package:shimmer/shimmer.dart';
import 'package:moniepoint_flutter/core/colors.dart';
import 'package:moniepoint_flutter/core/utils/currency_util.dart';

///
class DashboardAccountCard extends StatelessWidget {

  DashboardAccountCard({required this.viewModel, required this.pageController});

  final DashboardViewModel viewModel;
  final PageController pageController;

  @override
  Widget build(BuildContext context) {
    final userAccounts = viewModel.userAccounts;
    
    return Container(
      decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(16)),
          boxShadow: [
            BoxShadow(
              offset: Offset(0, 13),
              blurRadius: 21,
              color: Color(0xff1F0E4FB1).withOpacity(0.2),
            ),
          ],
          image: DecorationImage(
              image: AssetImage("res/drawables/ic_dashboard_account_card_bg.png"),
              fit: BoxFit.cover,
              colorFilter: ColorFilter.mode(
                  Color(0XFFC4C4C4).withOpacity(0.1),
                  BlendMode.colorBurn
              )
          )
      ),
      clipBehavior: Clip.hardEdge,
      child: Stack(
        children: [
          ExpandablePageView(
            itemBuilder: (ctx, index) {
              return DashboardAccountItem(
                userAccount: userAccounts[index],
                accountIdx: index,
              );
            },
            pageSnapping: true,
            itemCount: userAccounts.length,
            controller: pageController,
          ),
          Visibility(
            visible: userAccounts.length > 1,
            child: Positioned(
              bottom: 19,
              left: 0,
              right: 0,
              child: DotIndicator(
                delay: Duration(milliseconds: 120),
                controller: pageController,
                itemCount: userAccounts.length,
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

///DashboardAccountItem
///
///
///
///
///
class DashboardAccountItem extends StatefulWidget {

  final UserAccount userAccount;
  final int accountIdx;
  final Stream<Resource<AccountBalance>>? balanceStream;
  final bool clickable;

  DashboardAccountItem({
    required this.userAccount,
    required this.accountIdx,
    this.balanceStream,
    this.clickable = true
  });

  DashboardAccountItem copyWith({Stream<Resource<AccountBalance>>? balanceStream, bool clickable = false}) {
    return DashboardAccountItem(
      userAccount: userAccount,
      accountIdx: accountIdx,
      balanceStream: balanceStream,
      clickable: clickable,
    );
  }

  @override
  State<StatefulWidget> createState() => DashboardAccountItemState();

}

class DashboardAccountItemState extends State<DashboardAccountItem>
    with AutomaticKeepAliveClientMixin, CompositeDisposableWidget {

  late final UserAccount userAccount;
  late final int accountIdx;
  late final DashboardViewModel _viewModel;

  Stream<Resource<AccountBalance>>? _balanceStream;
  Resource<AccountBalance>? _balanceData;
  AccountState accountState = AccountState.COMPLETED;

  @override
  void initState() {
    this.userAccount = widget.userAccount;
    this.accountIdx = widget.accountIdx;
    this._viewModel = Provider.of<DashboardViewModel>(context, listen: false);

    _balanceStream = widget.balanceStream ?? _viewModel.getDashboardBalance(accountId: userAccount.id);

    super.initState();
    _viewModel.dashboardUpdateStream.listen((event) {
      if(event == DashboardState.REFRESHING) {
        _balanceStream = _viewModel.getDashboardBalance(accountId: widget.userAccount.id, useLocal: false);
        if (mounted) setState(() {});
      }
      if(event == DashboardState.ACCOUNT_STATUS_UPDATED) {
        if (mounted) setState(() {});
      }
    }).disposedBy(this);
  }

  void _navigateToAccountTransactions() async {
    final routeArgs = {"userAccountId": userAccount.id};
    await Navigator.of(context).pushNamed(Routes.ACCOUNT_TRANSACTIONS, arguments: routeArgs);
    _viewModel.update(DashboardState.REFRESHING);
  }

  void _navigateToFixAccount() async {
    await AccountUpgradeRouteDelegate.navigateToAccountUpgrade(context, userAccount);
    _viewModel.update(DashboardState.REFRESHING);
  }

  onItemTap() async {

    await Navigator.of(context).pushNamed(Routes.ACCOUNT_STATUS);
    return;
    final mixpanel = await MixpanelManager.initAsync();
    mixpanel.track("dashboard-account-clicked");

    if(accountState != AccountState.COMPLETED) {
      //First determine if we are to pop the error
      final returnValue = await Navigator.of(context).push(
          AccountRestrictionRoute(
              builder: (mContext) => widget.copyWith(balanceStream: Stream.value(_balanceData!)),
              userAccount: userAccount,
              accountState: accountState
          )
      );

      //it's either going to ask us to fix it or view transactions
      if(returnValue != null && returnValue is String) {
        if(returnValue == "VIEW_TRANSACTIONS") _navigateToAccountTransactions();
        else if(returnValue == "FIX") _navigateToFixAccount();
      }
      return;
    }

    _navigateToAccountTransactions();
  }

  _balanceContainer(AsyncSnapshot<Resource<AccountBalance?>> snapshot) => Container(
    width: double.infinity,
    child: Material(
      color: Colors.transparent,
      borderRadius: BorderRadius.all(Radius.circular(16)),
      child: InkWell(
        onTap: widget.clickable ? onItemTap : null,
        borderRadius: BorderRadius.all(Radius.circular(16)),
        child: Container(
          padding: EdgeInsets.only(left: 20, right: 20),
          width: double.infinity,
          child: Column(
            children: [
              SizedBox(height: 42,),
              _DashboardAccountBalancePreview(
                snapshot: snapshot,
                accountNumber: "${userAccount.customerAccount?.accountNumber}",
                accountName: "${userAccount.customerAccount?.accountName}",
                viewModel: _viewModel,
              ),
              SizedBox(height: 16,),
              _DashboardAccountNumberView(
                accountNumber: "${userAccount.customerAccount?.accountNumber}",
                accountName: "${userAccount.customerAccount?.accountName}",
              ),
              _AccountCardErrorView(
                  userAccount: userAccount,
                  accountState: accountState,
              ),
              SizedBox(height: _viewModel.userAccounts.length > 1 ? 44 : 20),
            ],
          ),
        ),
      ),
    ),
  );

  Widget _content(AsyncSnapshot<Resource<AccountBalance>> snapshot) => Stack(
    children: [
      _balanceContainer(snapshot),
      Align(
        alignment: Alignment(0.0, -1.015),
        child: _DashboardAccountType(userAccount.customerAccount?.accountType ?? "SAVINGS")
      ),
    ],
  );

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return  StreamBuilder(
        stream: _balanceStream,
        builder: (ctx, AsyncSnapshot<Resource<AccountBalance>> snapshot) {
          _balanceData = snapshot.data;
          accountState = userAccount.getAccountState();
          return Hero(
            tag: "dashboard-balance-view-${userAccount.customerAccount?.id}",
            child: _content(snapshot),
          );
        }
    );
  }

  @override
  bool get wantKeepAlive => true;

  @override
  void dispose() {
    disposeAll();
    super.dispose();
  }

}

///_DashboardAccountType
///
///
///
///
class _DashboardAccountType extends StatelessWidget {

  _DashboardAccountType(this.accountType);

  final String accountType;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.zero,
      child: Stack(
        children: [
          SvgPicture.asset(
            "res/drawables/ic_dashboard_account_label.svg",
            height: 26,
          ),
          Positioned(
              top: 2,
              bottom: 0,
              left: 0,
              right: 0,
              child: Center(
                child: Text(
                  accountType,
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 10.6,
                      fontWeight: FontWeight.w700,
                      decoration: TextDecoration.none
                  ),
                ),
              )
          )
        ],
      ),
    );
  }
}

///_DashboardAccountBalancePreview
///
///
///
///
///
class _DashboardAccountBalancePreview extends StatelessWidget {

  final AsyncSnapshot<Resource<AccountBalance?>> snapshot;
  final ValueNotifier<int> hideAndShowNotifier = ValueNotifier(1);
  final String accountNumber;
  final String accountName;
  final DashboardViewModel viewModel;

  late final _accountBalanceTextStyle = TextStyle(
      fontSize: 23.7,
      fontWeight: FontWeight.w800,
      color: Colors.white
  );

  _DashboardAccountBalancePreview({
    required this.snapshot,
    required this.accountNumber,
    required this.accountName,
    required this.viewModel
  });

  isAccountBalanceHidden() =>
      PreferenceUtil.isAccountBalanceHidden(accountNumber);

  isErrorLoadingAccountBalance(AsyncSnapshot<dynamic> snapshot) =>
      snapshot.hasData && snapshot.data is Error;

  isLoadingAccountBalance(AsyncSnapshot<dynamic> snapshot) =>
      snapshot.hasData && snapshot.data is Loading;

  ///Determines if balance should be displayed
  _canDisplayBalance(AsyncSnapshot<dynamic> snapshot) {
    return snapshot.hasData && (!isLoadingAccountBalance(snapshot) &&
        !isErrorLoadingAccountBalance(snapshot));
  }

  String _getAccountBalance(AsyncSnapshot<Resource<AccountBalance?>> snapshot, bool hideAccountBalance) {
    if(hideAccountBalance) return "***";

    final AccountBalance? accountBalance = (snapshot.hasData
        && snapshot.data != null) ? snapshot.data!.data : null;

    return "${accountBalance?.availableBalance?.formatCurrencyWithoutSymbolAndDividing}";
  }

  _accountBalanceView(String accountBalance, bool hideAccountBalance) => Row(
        children: [
          hideAccountBalance
              ? Text('**', style: _accountBalanceTextStyle)
              : SvgPicture.asset(
                  "res/drawables/ic_naira.svg",
                  width: 20,
                  height: 17,
                  color: Colors.white,
                ),
          SizedBox(width: 4),
          Text('$accountBalance', style: _accountBalanceTextStyle),
        ],
      );

  _visibilityIcon(bool hideAccountBalance) => Padding(
    padding: EdgeInsets.only(right: 16),
    child: Styles.imageButton(
        padding: EdgeInsets.all(2),
        color: Colors.transparent,
        disabledColor: Colors.transparent,
        image: SvgPicture.asset(
          hideAccountBalance
              ? 'res/drawables/ic_eye_open.svg'
              : 'res/drawables/ic_eye_closed.svg',
          width: hideAccountBalance ? 22 : 22,
          height: hideAccountBalance ? 15 : 22,
          color: Colors.white.withOpacity(0.4),
        ),
        onClick: () {
          PreferenceUtil.saveValueForLoggedInUser(
              "$accountNumber-${PreferenceUtil.HIDE_ACCOUNT_BAL}",
              hideAccountBalance ? false : true
          );
          hideAndShowNotifier.value = hideAndShowNotifier.value + 1;
        }),
  );

  _errorView() => Container(
    child: Row(
      children: [
        Expanded(
          child: Text('We cannot get your balance right now.\nPlease try again',
              style: TextStyle(
                  fontSize: 12.5,
                  fontWeight: FontWeight.w600,
                  color: Colors.textColorBlack
              )
          ),
        ),
        TextButton(
          onPressed: () {
            viewModel.update(DashboardState.REFRESHING);
          },
          child: Text('Try Again',
              style: TextStyle(
                  fontSize: 13.5,
                  fontWeight: FontWeight.w600,
                  color: Colors.primaryColor
              )
          ),
        )
      ],
    ),
  );

  @override
  Widget build(BuildContext context) {
    final hideAccountBalance = isAccountBalanceHidden();
    final canDisplay = _canDisplayBalance(snapshot);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Visibility(
            visible: hideAccountBalance == true || canDisplay,
            child: Text(
              "Available Balance",
              style: TextStyle(
                  fontSize: 13,
                  letterSpacing: -0.2,
                  fontWeight: FontWeight.w600,
                  color: Colors.white.withOpacity(0.8)
              ),
            )),
        SizedBox(height: 4,),
        _DashboardLoadingShimmer(
            hideAccountBalance: hideAccountBalance,
            isLoading: isLoadingAccountBalance(snapshot) || snapshot.data == null
        ),
        Visibility(
            visible: isErrorLoadingAccountBalance(snapshot) && !hideAccountBalance,
            child: _errorView()
        ),
        Visibility(
            visible: hideAccountBalance == true || canDisplay,
            child: ValueListenableBuilder(
                valueListenable: hideAndShowNotifier,
                builder: (_, __, ___) {
                  final hideAccountBalance = isAccountBalanceHidden();
                  final acctBalance = _getAccountBalance(snapshot, hideAccountBalance);
                  return Stack(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          _accountBalanceView(acctBalance, hideAccountBalance),
                        ],
                      ),
                      Positioned(
                          right: 8,
                          top: 0,
                          bottom:0,
                          child: _visibilityIcon(hideAccountBalance)
                      )
                    ],
                  );
                }
            )
        ),
      ],
    );
  }
}

///_DashboardAccountNumberView
///
///
///
///
class _DashboardAccountNumberView extends Container {

  final String accountNumber;
  final String accountName;

  _DashboardAccountNumberView({
    required this.accountNumber,
    required this.accountName
  }):super(key: Key("_DashboardAccountNumberView"));

  void _shareReceipt() {
    Share.share(
        "Moniepoint MFB\n$accountNumber\n$accountName",
        subject: 'Moniepoint MFB');
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(left: 11.11, right: 12.5, top: 5.5, bottom: 5.5),
      decoration: BoxDecoration(
          color: Colors.backgroundWhite.withOpacity(0.13),
          borderRadius: BorderRadius.circular(9)
      ),
      child: Row(
        children: [
          Text(
            'Account Number',
            style: Styles.textStyle(context,
                fontWeight: FontWeight.w600,
                letterSpacing: -0.2,
                fontSize: 13,
                color: Colors.white),
          ),
          SizedBox(
            width: 7,
          ),
          Text(accountNumber,
              style: Styles.textStyle(context,
                  fontWeight: FontWeight.w700,
                  letterSpacing: -0.2,
                  fontSize: 13,
                  color: Colors.white
              )
          ),
          Spacer(),
          Padding(
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
              )),
        ],
      ),
    );
  }

}

///_AccountCardErrorView
///
///
///
///
///
class _AccountCardErrorView extends StatefulWidget {

  _AccountCardErrorView({
    required this.userAccount,
    required this.accountState,
    this.margin = const EdgeInsets.only(top: 14)
  });

  final UserAccount userAccount;
  final EdgeInsets margin;
  final AccountState accountState;

  @override
  State<StatefulWidget> createState() => _AccountCardErrorState();
}

class _AccountCardErrorState extends State<_AccountCardErrorView> with SingleTickerProviderStateMixin {
  late final AnimationController _controller = AnimationController(
    duration: const Duration(milliseconds: 500),
    vsync: this,
  );

  late final Animation<Offset> _offsetAnimation = Tween<Offset>(
    begin: Offset.zero,
    end: const Offset(1.5, 0.0),
  ).animate(CurvedAnimation(
    parent: _controller,
    curve: Curves.elasticIn,
  ));

  String title = "";
  Widget icon = SvgPicture.asset("res/drawables/ic_danger_info.svg");

  bool hasError() {
    final accountState = widget.accountState;

    if(accountState == AccountState.BLOCKED) {
      title = "Account Blocked!";
      icon = SvgPicture.asset("res/drawables/ic_danger_info.svg");
      return true;
    }

    if(accountState == AccountState.PND) {
      title = "Account Restricted!";
      icon = SvgPicture.asset("res/drawables/ic_danger_info.svg");
      return true;
    }

    if (accountState == AccountState.REQUIRE_DOCS) {
      title = "Re-upload Document";
      icon = SvgPicture.asset("res/drawables/ic_danger_info_white.svg");
      return true;
    }

    if(accountState == AccountState.PENDING_VERIFICATION) {
      title = "Upgrade in Progress...";
      icon = Container(
        padding: EdgeInsets.all(2),
        decoration: BoxDecoration(shape: BoxShape.circle, color: Colors.solidGreen),
        child: SvgPicture.asset("res/drawables/ic_account_upgrade_progress.svg", width: 17, height: 18,),
      );
      return true;
    }

    if(accountState == AccountState.IN_COMPLETE) {
      title = "Upgrade Account";
      icon = Container(
        padding: EdgeInsets.all(2),
        decoration: BoxDecoration(shape: BoxShape.circle, color: Colors.solidGreen),
        child: SvgPicture.asset("res/drawables/ic_upload.svg", width: 17, height: 18,color: Colors.white),
      );
      return true;
    }

    return false;
  }

  Widget _mainButton() => Container(
    margin: widget.margin,
    decoration: BoxDecoration(
        color: Color(0XFF003AA4).withOpacity(0.47),
        borderRadius: BorderRadius.circular(9)
    ),
    child: Material(
      borderRadius: BorderRadius.circular(9),
      color: Colors.transparent,
      child: InkWell(
          borderRadius: BorderRadius.circular(9),
          onTap: null,
        child: Container(
          padding: EdgeInsets.only(left: 13, right: 13, top: 9, bottom: 9),
          child: Row(
            children: [
              icon,
              SizedBox(width: 9,),
              Text(
                title,
                style: TextStyle(
                  fontSize: 12.5,
                  color: Colors.white,
                  fontWeight: FontWeight.w600
                ),
              ),
              Spacer(),
              SvgPicture.asset("res/drawables/ic_forward_anchor.svg", color: Colors.white,),
            ],
          ),
        ),
      ),
    ),
  );

  @override
  Widget build(BuildContext context) {
    if(!hasError()) return SizedBox();
    return SlideTransition(
        position: _offsetAnimation,
        child: _mainButton(),
    );
  }

}


///_DashboardLoadingShimmer
///
///
///
///
class _DashboardLoadingShimmer extends StatelessWidget {

  final bool hideAccountBalance;
  final bool isLoading;

  _DashboardLoadingShimmer({
    required this.hideAccountBalance,
    required this.isLoading
  });

  @override
  Widget build(BuildContext context) {
    if((hideAccountBalance && isLoading) || !isLoading) return SizedBox();
    return Column(
      children: [
        Shimmer.fromColors(
          period: Duration(milliseconds: 1000),
          child: Align(
            alignment: Alignment.centerLeft,
            child: Container(
              width: 90,
              height: 10,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: Colors.white.withOpacity(0.3),
                shape: BoxShape.rectangle),
            )),
          baseColor: Colors.white.withOpacity(0.6),
          highlightColor: Colors.deepGrey.withOpacity(0.6)
        ),
        SizedBox(height: 4),
        Shimmer.fromColors(
          period: Duration(milliseconds: 1000),
          child: Align(
            alignment: Alignment.centerLeft,
            child: Container(
              width: 90,
              height: 32,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: Colors.white.withOpacity(0.3),
                shape: BoxShape.rectangle),
            )),
          baseColor: Colors.white.withOpacity(0.6),
          highlightColor: Colors.deepGrey.withOpacity(0.6)
        )
    ]);
  }
}

///AccountRestrictionRoute
///
///
///
///
class AccountRestrictionRoute<T> extends PopupRoute<T> {

  AccountRestrictionRoute({
    required this.builder,
    required this.userAccount,
    required this.accountState
  });

  final WidgetBuilder builder;
  final UserAccount userAccount;
  final AccountState accountState;

  @override
  Color? get barrierColor => Colors.black.withOpacity(0.7);

  @override
  bool get barrierDismissible => true;

  @override
  String? get barrierLabel => "test";

  @override
  Widget buildPage(BuildContext context, Animation<double> animation,
      Animation<double> secondaryAnimation) {
    return _AccountRestrictionPage(
      child: Builder(builder: builder),
      userAccount: userAccount,
      accountState: accountState,
    );
  }

  @override
  Duration get transitionDuration => Duration(milliseconds: 400);

}

class _AccountRestrictionPage extends StatelessWidget {

  const _AccountRestrictionPage({
    Key? key,
    required this.child,
    required this.userAccount,
    required this.accountState
  }):super(key: key);

  final Widget child;

  final UserAccount userAccount;

  final AccountState accountState;

  String _getPageTitle() {
    if(accountState == AccountState.BLOCKED) {
      return "Account Blocked";
    }else if(accountState == AccountState.PND) {
      return "Account Restricted";
    }
    else if(accountState == AccountState.REQUIRE_DOCS) {
      return "Re-upload Documents";
    }
    else if(accountState == AccountState.PENDING_VERIFICATION) {
      return "Upgrade in progress";
    }
    else if(accountState == AccountState.IN_COMPLETE) {
      return "Upgrade Account";
    }
    return "";
  }

  Widget _popUpWindowHeader() => Container(
    padding: EdgeInsets.only(left: 24, right: 24, top: 20, bottom: 17),
    width: double.infinity,
    decoration: BoxDecoration(
      color: Colors.red.withOpacity(0.2),
      borderRadius: BorderRadius.only(
        topLeft: Radius.circular(16),
        topRight: Radius.circular(16),
      ),
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          _getPageTitle(),
          style: TextStyle(
              color: Colors.red,
              fontSize: 17,
              fontWeight: FontWeight.bold,
              decoration: TextDecoration.none
          ),
        ),
        SizedBox(height: 4),
        Text(
          "Upgrade your savings account to enjoy higher limits",
          style: TextStyle(
              fontSize: 13,
              color: Colors.textColorBlack,
              fontWeight: FontWeight.w400,
              decoration: TextDecoration.none
          ),
        )
      ],
    ),
  );

  Widget _popUpWindow(BuildContext context) => Column(
    children: [
      _popUpWindowHeader(),
      SizedBox(height: 21),
      Padding(
        padding: EdgeInsets.only(left: 24, right: 24),
        child: SizedBox(
          width: double.infinity,
          child: Styles.appButton(
              elevation: 0.3,
              onClick: () => Navigator.of(context).pop("FIX"),
              text: "Fix This"
          ),
        ),
      ),
      SizedBox(height: 10),
      TextButton(
          onPressed: () async {
            Navigator.of(context).pop("VIEW_TRANSACTIONS");
          },
          child: Text(
            "View Transactions",
            style: TextStyle(color: Colors.primaryColor),
          )
      )
    ],
  );

  @override
  Widget build(BuildContext context) {
    return Wrap(
      children: [
        Stack(
          children: [
            Container(
              margin: EdgeInsets.only(top: 105, left: 16,right: 16),
              width: double.infinity,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(16)),
                  boxShadow: [
                    BoxShadow(
                      offset: Offset(0, 13),
                      blurRadius: 21,
                      color: Color(0xff1F0E4FB1).withOpacity(0.2),
                    ),
                  ],
                  image: DecorationImage(
                      image: AssetImage("res/drawables/ic_dashboard_account_card_bg.png"),
                      fit: BoxFit.cover,
                      colorFilter: ColorFilter.mode(
                          Color(0XFFC4C4C4).withOpacity(0.1),
                          BlendMode.colorBurn
                      )
                  )
              ),
              child: child,
            ),
            Positioned(
                top: 324,
                left: 0,
                right: 0,
                child: SvgPicture.asset(
                    "res/drawables/ic_triangle.svg",
                    color: Color(0XFFf6d6d8)
                )
            ),
            Container(
              padding: EdgeInsets.only(bottom: 22),
              margin: EdgeInsets.only(left: 37, right: 37, top: 335),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16),
                  color: Colors.white
              ),
              child: _popUpWindow(context),
            )
          ],
        )
      ],
    );
  }

}
