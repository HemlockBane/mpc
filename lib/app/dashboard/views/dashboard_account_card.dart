
import 'package:flutter/material.dart' hide Colors;
import 'package:flutter/rendering.dart';
import 'package:flutter_svg/svg.dart';
import 'package:mixpanel_flutter/mixpanel_flutter.dart';
import 'package:moniepoint_flutter/app/accounts/model/data/account_balance.dart';
import 'package:moniepoint_flutter/app/customer/customer_account.dart';
import 'package:moniepoint_flutter/app/customer/user_account.dart';
import 'package:moniepoint_flutter/app/dashboard/viewmodels/dashboard_view_model.dart';
import 'package:moniepoint_flutter/core/extensions/composite_disposable_widget.dart';
import 'package:moniepoint_flutter/core/mix_panel_analytics.dart';
import 'package:moniepoint_flutter/core/models/user_instance.dart';
import 'package:moniepoint_flutter/core/network/resource.dart';
import 'package:moniepoint_flutter/core/routes.dart';
import 'package:moniepoint_flutter/core/styles.dart';
import 'package:moniepoint_flutter/core/tuple.dart';
import 'package:moniepoint_flutter/core/utils/preference_util.dart';
import 'package:moniepoint_flutter/core/views/dots_indicator.dart';
import 'package:provider/provider.dart';
import 'package:share/share.dart';
import 'package:shimmer/shimmer.dart';
import 'package:moniepoint_flutter/core/colors.dart';
import 'package:moniepoint_flutter/core/utils/currency_util.dart';
import 'package:moniepoint_flutter/core/utils/text_utils.dart';

///TODO refactor this code
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
      height: 200,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(16)),
        color: Colors.backgroundWhite,
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
                bottom: 16,
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
  final postNoDebitColor = Color(0xffE14E4F).withOpacity(0.9);

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

  @override
  Widget build(BuildContext context) {
    super.build(context);
    final isPostNoDebit = UserInstance().accountStatus?.postNoDebit == true;
    // print(UserInstance().accountStatus?.toJson());
    // final isPostNoDebit = false;

    print("isPostNoDebit: $isPostNoDebit}");
    return  Hero(
      tag: "dashboard-balance-view-${userAccount.customerAccount?.id}",
      child: Stack(
        children: [
          Container(
            width: double.infinity,
            foregroundDecoration: isPostNoDebit
                ? BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(16)),
                    color: postNoDebitColor)
                : null,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(16)),
                color: Colors.backgroundWhite,
            ),
            child: Material(
              color: Colors.transparent,
              borderRadius: BorderRadius.all(Radius.circular(16)),
              child: InkWell(
                onTap: onItemTap(isPostNoDebit),
                borderRadius: BorderRadius.all(Radius.circular(16)),
                child: Container(
                  padding: EdgeInsets.only(left: 20, right: 20),
                  width: double.infinity,
                  child: Column(
                    children: [
                      // _DashboardAccountType(),
                      SizedBox(height: 42,),
                      _DashboardAccountBalancePreview(
                        balanceStream: _balanceStream,
                        accountNumber: "${userAccount.customerAccount?.accountNumber}",
                        accountName: "${userAccount.customerAccount?.accountName}",
                        viewModel: _viewModel,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          Visibility(
            visible: !isPostNoDebit,
            child: Align(
              alignment: Alignment(0.0, -1.015),
              child: _DashboardAccountType()
            ),
          ),
          //PND View
          IgnorePointer(
            ignoring: true,
            child: Visibility(
              visible: isPostNoDebit,
                child: _AccountBlockedView(userAccount: userAccount)
            ),
          )
        ],
      ),
    );
  }


  onItemTap(bool isPostNoDebit) => () async{
    if (isPostNoDebit) {
      // When pnd
      Navigator.of(context).pushNamed(Routes.ACCOUNT_UPDATE);
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

  };

  @override
  bool get wantKeepAlive => true;

  @override
  void dispose() {
    disposeAll();
    super.dispose();
  }

}

class _AccountBlockedView extends StatelessWidget {
  const _AccountBlockedView({
    Key? key,
    required this.userAccount,
  }) : super(key: key);

  final UserAccount userAccount;

  @override
  Widget build(BuildContext context) {
    return Container(
      // color: Colors.black,
      child: Column(
        children: [
          SizedBox(height: 20),
          Text("Account Blocked", style: TextStyle(color: Colors.white, fontSize: 12.5, fontWeight: FontWeight.w700),),
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
                          Text("Unblock Account",
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
    );
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

  final Stream<Resource<AccountBalance>>? balanceStream;
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
    required this.balanceStream,
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

  String _getAccountBalance(AsyncSnapshot<Resource<AccountBalance>> snapshot, bool hideAccountBalance) {
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
    return StreamBuilder(
        stream: balanceStream,
        builder: (ctx, AsyncSnapshot<Resource<AccountBalance>> snapshot) {
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
                  isLoading: isLoadingAccountBalance(snapshot)
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
        });
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

// class AccountCard extends StatefulWidget {
//   const AccountCard({required this.viewModel,
//     required this.pageController});
//
//   final DashboardViewModel viewModel;
//   final PageController pageController;
//
//   @override
//   _AccountCardState createState() => _AccountCardState();
// }
//
// class _AccountCardState extends State<AccountCard> {
//
//   AccountBalance? accountBalance;
//
//   @override
//   Widget build(BuildContext context) {
//     final viewModel = widget.viewModel;
//     final pageController = widget.pageController;
//     final accounts = viewModel.customer?.customerAccountUsers?.length ?? 0;
//     return Stack(
//       children: [
//         Column(
//           children: [
//             SizedBox(height: 0.8),
//             Container(
//               width: double.infinity,
//               decoration: BoxDecoration(
//                   color: Colors.backgroundWhite,
//                   // color: Colors.black,
//                   borderRadius: BorderRadius.all(Radius.circular(16)),
//                   boxShadow: [
//                     BoxShadow(
//                       offset: Offset(0, 13),
//                       blurRadius: 21,
//                       color: Color(0xff1F0E4FB1).withOpacity(0.12),
//                     ),
//                   ]),
//               child: Column(
//                 children: [
//                   SizedBox(height: 30),
//                   SizedBox(
//                     height: 130,
//                     child: PageView.builder(
//                         itemCount:
//                         viewModel.customer?.customerAccountUsers?.length ?? 0,
//                         controller: pageController,
//                         itemBuilder: (ctx, idx) {
//                           final userAccount = viewModel.userAccounts[idx];
//                           final customerAccount = userAccount.customerAccount;
//
//                           return Material(
//                             color: Colors.transparent,
//                             child: InkWell(
//                               overlayColor: MaterialStateProperty.all(Colors.darkLightBlue.withOpacity(0.1)),
//                               onTap: () async{
//                                final mixpanel = await MixpanelManager.initAsync();
//                                 mixpanel.track("dashboard-account-clicked");
//                                 final routeArgs = {
//                                   "customerAccountId": userAccount.customerAccount?.id,
//                                   "accountUserIdx": idx,
//                                 };
//                                 Navigator.of(context).pushNamed(Routes.ACCOUNT_TRANSACTIONS,
//                                   arguments: routeArgs ).then((_) => widget.viewModel.update());
//                               },
//                               child: Hero(
//                                 tag: "dashboard-balance-view-${userAccount.customerAccount?.id}",
//                                 child: AccountDetails(
//                                   customerAccount: customerAccount,
//                                   userAccount: userAccount,
//                                   viewModel: viewModel,
//                                   onBalanceLoaded: (balance){
//                                     accountBalance = balance;
//                                   },
//                                 ),
//                               ),
//                             ),
//                           );
//                         }),
//                   ),
//                   if (accounts > 1)
//                     SizedBox(height: 19),
//                   if (accounts > 1)
//                     DotIndicator(
//                         controller: pageController,
//                         itemCount:
//                         viewModel.customer?.customerAccountUsers?.length ?? 0),
//                   SizedBox(height: 11)
//                 ],
//               ),
//             ),
//           ],
//         ),
//         Align(
//         alignment: Alignment(0.0, -1.5),
//           child: Row(
//             mainAxisAlignment: MainAxisAlignment.center,
//             children: [
//               SvgPicture.asset(
//                   "res/drawables/ic_dashboard_account_label.svg", width: 197, height: 22,),
//             ],
//           ),
//         ),
//         Align(
//           alignment: Alignment.topCenter,
//           child: Column(
//             children: [
//               SizedBox(height: 6),
//               Text(
//                 'SAVINGS',
//                 style: TextStyle(
//                     color: Colors.white,
//                     fontSize: 10.6,
//                     fontWeight: FontWeight.w700),
//               ),
//             ],
//           ),
//         ),
//       ],
//     );
//   }
// }
//
// class AccountDetails extends StatefulWidget {
//   const AccountDetails(
//       {Key? key,
//         required this.customerAccount,
//         required this.userAccount,
//         required this.viewModel, required this.onBalanceLoaded})
//       : super(key: key);
//
//   final CustomerAccount? customerAccount;
//   final UserAccount userAccount;
//   final DashboardViewModel viewModel;
//   final void Function(AccountBalance?) onBalanceLoaded;
//
//   @override
//   _AccountDetailsState createState() => _AccountDetailsState();
// }
//
// class _AccountDetailsState extends State<AccountDetails> with CompositeDisposableWidget, WidgetsBindingObserver {
//   String hideAccountBalanceKey = PreferenceUtil.HIDE_ACCOUNT_BAL;
//   Stream<Resource<AccountBalance>>? _balanceStream;
//
//   @override
//   void initState() {
//     print("Reload Init State");
//     hideAccountBalanceKey = "${widget.customerAccount?.accountNumber}-${PreferenceUtil.HIDE_ACCOUNT_BAL}";
//     _balanceStream = widget.viewModel.getCustomerAccountBalance(accountId: widget.userAccount.id, useLocal: false);
//     super.initState();
//
//     widget.viewModel.dashboardUpdateStream.listen((event) {
//       _balanceStream = widget.viewModel.getCustomerAccountBalance(accountId: widget.userAccount.id, useLocal: false);
//       setState(() {});
//     }).disposedBy(this);
//
//     widget.viewModel.refreshStartStream.listen((event) {
//       _balanceStream = widget.viewModel.getCustomerAccountBalance(accountId: widget.userAccount.id, useLocal: false);
//       setState(() {});
//       widget.viewModel.finishRefresh();
//     }).disposedBy(this);
//   }
//
//
//   @override
//   void didUpdateWidget(covariant AccountDetails oldWidget) {
//     super.didUpdateWidget(oldWidget);
//   }
//
//   @override
//   void dispose() {
//     disposeAll();
//     WidgetsBinding.instance?.removeObserver(this);
//     super.dispose();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         Container(
//           padding: EdgeInsets.only(left: 19),
//           child: StreamBuilder(
//             stream: _balanceStream,
//             builder: (ctx, AsyncSnapshot<Resource<AccountBalance?>> snapshot){
//               final bool hideAccountBalance = PreferenceUtil.getValueForLoggedInUser(hideAccountBalanceKey) ?? false;
//               final isLoadingBalanceError = snapshot.hasData && snapshot.data is Error;
//               final isLoadingBalance = snapshot.hasData && snapshot.data is Loading;
//               final AccountBalance? accountBalance = (snapshot.hasData && snapshot.data != null)
//                   ? snapshot.data!.data
//                   : null;
//
//               return Stack(
//                 children: [
//                   Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       SizedBox(height: 8),
//                       if (snapshot.hasData && (!isLoadingBalance && !isLoadingBalanceError))
//                         Text(
//                           "Available Balance",
//                           style: TextStyle(
//                               fontSize: 12.3,letterSpacing: -0.2,
//                               fontWeight: FontWeight.w600,
//                               color: Colors.textColorBlack.withOpacity(0.9)
//                           ),
//                         ),
//                       if (snapshot.hasData && (!isLoadingBalance && !isLoadingBalanceError))
//                         SizedBox(height: 4),
//                       getChild(
//                         snapshot: snapshot,
//                         accountBalance: accountBalance,
//                         hideAccountBalance: hideAccountBalance,
//                         isLoadingBalance: isLoadingBalance,
//                         isLoadingBalanceError: isLoadingBalanceError
//                       ),
//                       SizedBox(height: 16),
//                     ],
//                   ),
//                   if (snapshot.hasData && (!isLoadingBalance && !isLoadingBalanceError))
//                     Positioned(
//                       top: 23, right: 14,
//                       child: _buildVisibilityIcon()
//                     )
//                 ],
//               );
//
//             },
//           ),
//         ),
//       Container(
//         margin: EdgeInsets.symmetric(horizontal: 19),
//         padding: EdgeInsets.fromLTRB(11, 6, 0, 6),
//         decoration: BoxDecoration(
//           color: Color(0xff0361F0).withOpacity(0.04),
//           borderRadius: BorderRadius.all(Radius.circular(9)),
//         ),
//         child: Row(
//           mainAxisAlignment: MainAxisAlignment.spaceBetween,
//           children: [
//             Row(
//               children: [
//                 Text(
//                   'Account Number',
//                   style: Styles.textStyle(context,
//                       fontWeight: FontWeight.w400,letterSpacing: -0.2,
//                       fontSize: 12,
//                       color: Colors.textColorBlack),
//                 ),
//                 SizedBox(
//                   width: 7,
//                 ),
//                 Text(widget.customerAccount?.accountNumber ?? "",
//                     style: Styles.textStyle(context,
//                         fontWeight: FontWeight.w700,letterSpacing: -0.2,
//                         fontSize: 11.3,
//                         color: Colors.primaryColor))
//               ],
//             ),
//             Padding(
//               padding: EdgeInsets.only(right: 10),
//               child: Styles.imageButton(
//                   padding: EdgeInsets.all(9),
//                   color: Colors.transparent,
//                   borderRadius: BorderRadius.circular(30),
//                   onClick: () => Share.share(
//                       "Moniepoint MFB\n${widget.customerAccount?.accountNumber}\n${widget.customerAccount?.customer?.name}",
//                       subject: 'Moniepoint MFB'
//                   ),
//                   image: SvgPicture.asset(
//                     'res/drawables/ic_share.svg',
//                     fit: BoxFit.contain,
//                     width: 20,
//                     height: 21,
//                     color: Color(0xffB8003382).withOpacity(0.4),
//                   ),
//               ),
//             )
//           ],
//         ),
//       ),
//     ]);
//   }
//
//   Widget _buildVisibilityIcon() {
//     final bool hideAccountBalance =
//         PreferenceUtil.getValueForLoggedInUser(hideAccountBalanceKey) ?? false;
//
//     return Padding(
//       padding: EdgeInsets.only(right: 16),
//       child: Styles.imageButton(
//           padding: EdgeInsets.all(9),
//           color: Colors.transparent,
//           disabledColor: Colors.transparent,
//           image: SvgPicture.asset(
//             hideAccountBalance
//                 ? 'res/drawables/ic_eye_open.svg'
//                 : 'res/drawables/ic_eye_closed.svg',
//             width: hideAccountBalance ? 10 : 16,
//             height: hideAccountBalance ? 12 : 16,
//             color: Color(0xffB8003382).withOpacity(0.4),
//           ),
//           onClick: () {
//             PreferenceUtil.saveValueForLoggedInUser(
//                 hideAccountBalanceKey, hideAccountBalance ? false : true
//             );
//             setState(() {});
//           }),
//     );
//   }
//
//   Widget getChild({required AsyncSnapshot<Resource<AccountBalance?>> snapshot,
//     required bool hideAccountBalance, required bool isLoadingBalanceError,
//     required bool isLoadingBalance, required AccountBalance? accountBalance}){
//     if (snapshot.hasData && (!isLoadingBalance && !isLoadingBalanceError)) {
//       final balance = hideAccountBalance
//         ? "***"
//         : "${accountBalance?.availableBalance?.formatCurrencyWithoutSymbolAndDividing}";
//       widget.onBalanceLoaded(accountBalance);
//
//       return Row(
//         children: [
//           hideAccountBalance
//             ? Text('*',
//                 style: Styles.textStyle(context,
//                 fontSize: 23.5,
//                 fontWeight: FontWeight.w800,
//                 color: Colors.textColorBlack.withOpacity(0.5))
//               )
//             : SvgPicture.asset("res/drawables/ic_naira.svg", width: 20, height: 17,),
//           SizedBox(width: 4),
//           Text('$balance',
//             style: Styles.textStyle(context,
//               fontSize: 23.5,
//               fontWeight: FontWeight.w800,
//               color: Colors.textColorBlack)),
//         ],
//       );
//     }
//
//     if (isLoadingBalanceError && !hideAccountBalance) {
//       return Container(
//         padding: EdgeInsets.only(right: 19),
//         child: Row(
//           children: [
//             Expanded(
//               child: Text('We cannot get your balance right now.\nPlease try again',
//                 style: TextStyle(
//                   fontSize: 12.5,
//                   fontWeight: FontWeight.w600,
//                   color: Colors.textColorBlack
//                 )
//               ),
//             ),
//             TextButton(
//               onPressed: () {
//                 widget.viewModel.update();
//               },
//               child: Text('Try Again',
//                 style: TextStyle(
//                   fontSize: 13.5,
//                   fontWeight: FontWeight.w600,
//                   color: Colors.primaryColor
//                 )
//               ),
//             )
//           ],
//         ),
//       );
//     }
//
//     if (hideAccountBalance) {
//       return Row(
//         children: [
//           Text('*',
//             style: Styles.textStyle(context,
//               fontSize: 23.5,
//               fontWeight: FontWeight.w800,
//               color: Colors.textColorBlack.withOpacity(0.5))),
//           SizedBox(width: 4),
//           Text('***',
//             style: TextStyle(
//               fontSize: 23.5,
//               fontWeight: FontWeight.w800,
//               color: Colors.textColorBlack)),
//         ],
//       );
//     }
//
//     return Column(
//       children: [
//         Shimmer.fromColors(
//           period: Duration(milliseconds: 1000),
//           child: Align(
//             alignment: Alignment.centerLeft,
//             child: Container(
//               width: 90,
//               height: 10,
//               decoration: BoxDecoration(
//                 borderRadius: BorderRadius.circular(10),
//                 color: Colors.white.withOpacity(0.3),
//                 shape: BoxShape.rectangle),
//             )),
//           baseColor: Colors.white.withOpacity(0.6),
//           highlightColor: Colors.deepGrey.withOpacity(0.6)
//         ),
//         SizedBox(height: 4),
//         Shimmer.fromColors(
//           period: Duration(milliseconds: 1000),
//           child: Align(
//             alignment: Alignment.centerLeft,
//             child: Container(
//               width: 90,
//               height: 32,
//               decoration: BoxDecoration(
//                 borderRadius: BorderRadius.circular(10),
//                 color: Colors.white.withOpacity(0.3),
//                 shape: BoxShape.rectangle),
//             )),
//           baseColor: Colors.white.withOpacity(0.6),
//           highlightColor: Colors.deepGrey.withOpacity(0.6)
//         ),
//       ],
//     );
//   }
//
// }
