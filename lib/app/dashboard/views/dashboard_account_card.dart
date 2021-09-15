
import 'dart:ui';

import 'package:flutter/material.dart' hide Colors;
import 'package:flutter/rendering.dart';
import 'package:flutter_svg/svg.dart';
import 'package:moniepoint_flutter/app/accounts/model/data/account_balance.dart';
import 'package:moniepoint_flutter/app/customer/user_account.dart';
import 'package:moniepoint_flutter/app/dashboard/viewmodels/dashboard_view_model.dart';
import 'package:moniepoint_flutter/core/extensions/composite_disposable_widget.dart';
import 'package:moniepoint_flutter/core/mix_panel_analytics.dart';
import 'package:moniepoint_flutter/core/models/user_instance.dart';
import 'package:moniepoint_flutter/core/network/resource.dart';
import 'package:moniepoint_flutter/core/routes.dart';
import 'package:moniepoint_flutter/core/styles.dart';
import 'package:moniepoint_flutter/core/utils/preference_util.dart';
import 'package:moniepoint_flutter/core/views/dots_indicator.dart';
import 'package:provider/provider.dart';
import 'package:share/share.dart';
import 'package:shimmer/shimmer.dart';
import 'package:moniepoint_flutter/core/colors.dart';
import 'package:moniepoint_flutter/core/utils/currency_util.dart';

///
class DashboardAccountCard extends StatelessWidget {

  DashboardAccountCard({
    required this.viewModel,
    required this.pageController
  });

  final DashboardViewModel viewModel;
  final PageController pageController;

  @override
  Widget build(BuildContext context) {
    final userAccounts = viewModel.userAccounts;
    return Container(
      width: double.infinity,
      height: userAccounts.length > 1 ? 205 : 180,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(16)),
        color: Colors.transparent,
        boxShadow: [
          BoxShadow(
            offset: Offset(0, 13),
            blurRadius: 21,
            color: Color(0xff1F0E4FB1).withOpacity(0.12),
          ),
        ],
      ),
      child: Stack(
        children: [
          PageView.builder(
              pageSnapping: true,
              itemCount: userAccounts.length,
              controller: pageController,
              itemBuilder: (ctx, index) {
                return DashboardAccountItem(
                  userAccount: userAccounts[index],
                  accountIdx: index,
                );
              }
          ),
          Visibility(
            visible: userAccounts.length > 1,
            child: Positioned(
                bottom: 17,
                left: 0,
                right: 0,
                child: StreamBuilder(
                  stream: viewModel.dashboardUpdateStream,
                  builder: (ctx, a) {
                    final isPostNoDebit = UserInstance().accountStatus?.postNoDebit == true;
                    return DotIndicator(
                      controller: pageController,
                      itemCount: userAccounts.length,
                      color: isPostNoDebit ? Colors.white : Colors.primaryColor,
                    );
                  },
                )
            ),
          )
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

  DashboardAccountItem({
    required this.userAccount,
    required this.accountIdx
  });

  @override
  State<StatefulWidget> createState() {
    return DashboardAccountItemState();
  }
}

class DashboardAccountItemState extends State<DashboardAccountItem>
    with AutomaticKeepAliveClientMixin, CompositeDisposableWidget {

  late final UserAccount userAccount;
  late final int accountIdx;
  late final DashboardViewModel _viewModel;

  Stream<Resource<AccountBalance>>? _balanceStream;

  @override
  void initState() {
    this.userAccount = widget.userAccount;
    this.accountIdx = widget.accountIdx;
    this._viewModel = Provider.of<DashboardViewModel>(context, listen: false);
    _balanceStream = _viewModel.getDashboardBalance(accountId: userAccount.id);

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

  onItemTap() async {
    final isPostNoDebit = UserInstance().accountStatus?.postNoDebit == true;

    if (isPostNoDebit) {
      await Navigator.of(context).pushNamed(Routes.ACCOUNT_UPDATE);
      Future.delayed(Duration(milliseconds: 60), () {
        _viewModel.fetchAccountStatus().listen((event) {
          if(event is Success) {
            _viewModel.checkAccountUpdate();
            _viewModel.update(DashboardState.ACCOUNT_STATUS_UPDATED);
          }
        });
      });
      return;
    }

    final mixpanel = await MixpanelManager.initAsync();
    mixpanel.track("dashboard-account-clicked");
    final routeArgs = {
      "customerAccountId": userAccount.customerAccount?.id,
      "accountUserIdx": accountIdx,
    };
    await Navigator.of(context).pushNamed(Routes.ACCOUNT_TRANSACTIONS, arguments: routeArgs);
    _viewModel.update(DashboardState.REFRESHING);
  }

  _balanceContainer(AsyncSnapshot<Resource<AccountBalance?>> snapshot, bool isBlocked) => Container(
    width: double.infinity,
    margin: EdgeInsets.all(isBlocked ? 1.5 : 0),
    decoration: BoxDecoration(
      borderRadius: BorderRadius.all(Radius.circular(16)),
      color: Colors.backgroundWhite,
    ),
    child: Material(
      color: Colors.transparent,
      borderRadius: BorderRadius.all(Radius.circular(16)),
      child: InkWell(
        onTap: onItemTap,
        borderRadius: BorderRadius.all(Radius.circular(16)),
        child: Container(
          padding: EdgeInsets.only(left: 20, right: 20),
          width: double.infinity,
          child: Column(
            children: [
              SizedBox(height: isBlocked ? 16 : 42,),
              _DashboardAccountBalancePreview(
                snapshot: snapshot,
                accountNumber: "${userAccount.customerAccount?.accountNumber}",
                accountName: "${userAccount.customerAccount?.accountName}",
                viewModel: _viewModel,
              ),
            ],
          ),
        ),
      ),
    ),
  );

  @override
  Widget build(BuildContext context) {
    super.build(context);
    final isPostNoDebit = UserInstance().accountStatus?.postNoDebit == true;
    return  StreamBuilder(
        stream: _balanceStream,
        builder: (ctx, AsyncSnapshot<Resource<AccountBalance?>> snapshot) {
          return Hero(
            tag: "dashboard-balance-view-${userAccount.customerAccount?.id}",
            child: Stack(
              children: [
                if (isPostNoDebit)
                  ImageFiltered(
                    imageFilter: ImageFilter.blur(sigmaX: 2.1, sigmaY: 2.1),
                    child: _balanceContainer(snapshot, isPostNoDebit),
                  ),
                if(!isPostNoDebit) _balanceContainer(snapshot, isPostNoDebit),
                Visibility(
                  visible: !isPostNoDebit,
                  child: Align(
                      alignment: Alignment(0.0, -1.015),
                      child: _DashboardAccountType()
                  ),
                ),
                Visibility(
                    visible: isPostNoDebit,
                    child: _AccountBlockedView(
                        userAccount: userAccount,
                        onItemClick: onItemTap,
                    )
                )
              ],
            ),
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
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.zero,
      width: 197,
      height: 21,
      child: Stack(
        children: [
          SvgPicture.asset(
            "res/drawables/ic_dashboard_account_label.svg",
            width: 197,
            height: 21,
          ),
          Positioned(
              top: 0,
              bottom: 0,
              left: 0,
              right: 0,
              child: Center(
                child: Text(
                  'SAVINGS',
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 10.6,
                      fontWeight: FontWeight.w700
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
      color: Colors.textColorBlack.withOpacity(0.5)
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
              ? Text('*', style: _accountBalanceTextStyle)
              : SvgPicture.asset(
                  "res/drawables/ic_naira.svg",
                  width: 20,
                  height: 17,
                ),
          SizedBox(width: 4),
          Text('$accountBalance',
              style: _accountBalanceTextStyle.copyWith(
                  color: Colors.textColorBlack)),
        ],
      );

  _visibilityIcon(bool hideAccountBalance) => Padding(
    padding: EdgeInsets.only(right: 16),
    child: Styles.imageButton(
        padding: EdgeInsets.all(9),
        color: Colors.transparent,
        disabledColor: Colors.transparent,
        image: SvgPicture.asset(
          hideAccountBalance
              ? 'res/drawables/ic_eye_open.svg'
              : 'res/drawables/ic_eye_closed.svg',
          width: hideAccountBalance ? 10 : 16,
          height: hideAccountBalance ? 12 : 16,
          color: Color(0xffB8003382).withOpacity(0.4),
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
                  color: Colors.textColorBlack.withOpacity(0.9)
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
                          right: 8, top: 2,
                          child: _visibilityIcon(hideAccountBalance)
                      )
                    ],
                  );
                }
            )
        ),
        SizedBox(height: 16,),
        _DashboardAccountNumberView(
          accountNumber: accountNumber,
          accountName: accountName,
        )
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
          color: Colors.primaryColor.withOpacity(0.05),
          borderRadius: BorderRadius.circular(9)
      ),
      child: Row(
        children: [
          Text(
            'Account Number',
            style: Styles.textStyle(context,
                fontWeight: FontWeight.w400,
                letterSpacing: -0.2,
                fontSize: 12,
                color: Colors.textColorBlack),
          ),
          SizedBox(
            width: 7,
          ),
          Text(accountNumber,
              style: Styles.textStyle(context,
                  fontWeight: FontWeight.w700,
                  letterSpacing: -0.2,
                  fontSize: 11.3,
                  color: Colors.primaryColor
              )),
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
                  color: Color(0xffB8003382).withOpacity(0.4),
                ),
              )),
        ],
      ),
    );
  }

}

///_AccountBlockedView
///
///
///
///
class _AccountBlockedView extends StatelessWidget {
  const _AccountBlockedView({
    Key? key,
    required this.userAccount,
    required this.onItemClick,
  }) : super(key: key);

  final VoidCallback onItemClick;
  final UserAccount userAccount;

  @override
  Widget build(BuildContext context) {

    final bannerTitle = "Account Restricted";
    final bannerActionText = "Remove Restriction";

    return GestureDetector(
      onTap: onItemClick,
      child: Container(
        decoration: BoxDecoration(
            color: Colors.pndRed.withOpacity(0.9),
            borderRadius: BorderRadius.circular(16)
        ),
        child: Column(
          children: [
            SizedBox(height: 20),
            Text(bannerTitle, style: TextStyle(color: Colors.white, fontSize: 12.5, fontWeight: FontWeight.w700),),
            SizedBox(height: 7),
            Expanded(
              child: Container(
                child: Stack(
                  children: [
                    Positioned(
                      left: 0, right: 0, top: 25,
                      child: Container(
                        width: double.infinity, height: 100,
                        margin: EdgeInsets.symmetric(horizontal: 20),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.all(Radius.circular(9)),
                            color: Colors.white
                        ),
                        child: Column(
                          children: [
                            SizedBox(height: 30),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text("Account Number",
                                    style: TextStyle(color: Colors.textColorBlack,
                                        fontSize: 13, fontWeight: FontWeight.w500)
                                ),
                                SizedBox(width: 7.07),
                                Text(userAccount.customerAccount?.accountNumber ?? "",
                                    style: TextStyle(color: Colors.textColorBlack,
                                        fontSize: 13, fontWeight: FontWeight.w700)
                                )

                              ],
                            ),
                            SizedBox(height: 19),
                            Text(bannerActionText,
                                style: TextStyle(color: Color(0xffE94444),
                                    fontSize: 14.5, fontWeight: FontWeight.w700)
                            )
                          ],
                        ),
                      ),
                    ),
                    Align(
                      alignment: Alignment.topCenter,
                      child: Container(
                        height: 50, width: 50,
                        child: Center(
                            child: SvgPicture.asset('res/drawables/ic_danger.svg',
                              height: 25, width: 25, color: Color(0xffE94444),
                            )
                        ),
                        decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.white,
                            boxShadow: [
                              BoxShadow(
                                offset: Offset(0, 13),
                                blurRadius: 21,
                                color: Color(0xffBB0909).withOpacity(0.2),
                              ),
                            ]
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
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
