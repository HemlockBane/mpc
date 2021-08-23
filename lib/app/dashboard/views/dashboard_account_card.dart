
import 'package:flutter/material.dart' hide Colors;
import 'package:flutter_svg/svg.dart';
import 'package:moniepoint_flutter/app/accounts/model/data/account_balance.dart';
import 'package:moniepoint_flutter/app/customer/customer_account.dart';
import 'package:moniepoint_flutter/app/customer/user_account.dart';
import 'package:moniepoint_flutter/app/dashboard/viewmodels/dashboard_view_model.dart';
import 'package:moniepoint_flutter/core/network/resource.dart';
import 'package:moniepoint_flutter/core/styles.dart';
import 'package:moniepoint_flutter/core/utils/preference_util.dart';
import 'package:moniepoint_flutter/core/views/dots_indicator.dart';
import 'package:share/share.dart';
import 'package:shimmer/shimmer.dart';
import 'package:moniepoint_flutter/core/colors.dart';
import 'package:moniepoint_flutter/core/utils/currency_util.dart';

///TODO refactor this code
class AccountCard extends StatefulWidget {
  const AccountCard({required this.viewModel, required this.pageController});

  final DashboardViewModel viewModel;
  final PageController pageController;

  @override
  _AccountCardState createState() => _AccountCardState();
}

class _AccountCardState extends State<AccountCard> {
  @override
  Widget build(BuildContext context) {
    final viewModel = widget.viewModel;
    final pageController = widget.pageController;
    final accounts = viewModel.customer?.customerAccountUsers?.length ?? 0;
    return Stack(
      children: [
        Column(
          children: [
            SizedBox(height: 0.8),
            Container(
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
                  SizedBox(
                    height: 132,
                    child: PageView.builder(
                        itemCount:
                        viewModel.customer?.customerAccountUsers?.length ?? 0,
                        controller: pageController,
                        itemBuilder: (ctx, idx) {
                          final userAccount = viewModel.userAccounts[idx];
                          final customerAccount = userAccount.customerAccount;

                          return AccountDetails(
                            customerAccount: customerAccount,
                            userAccount: userAccount,
                            viewModel: viewModel,
                          );
                        }),
                  ),
                  if (accounts > 1)
                    SizedBox(height: 19),
                  if (accounts > 1)
                    DotIndicator(
                        controller: pageController,
                        itemCount:
                        viewModel.customer?.customerAccountUsers?.length ?? 0),
                  SizedBox(height: 22)
                ],
              ),
            ),
          ],
        ),
        Align(
        alignment: Alignment(0.0, -1.5),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SvgPicture.asset(
                  "res/drawables/ic_dashboard_account_label.svg", width: 197, height: 22,),
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
  final DashboardViewModel viewModel;

  @override
  _AccountDetailsState createState() => _AccountDetailsState();
}

class _AccountDetailsState extends State<AccountDetails>
    with WidgetsBindingObserver {
  String hideAccountBalanceKey = PreferenceUtil.HIDE_ACCOUNT_BAL;
  Stream<Resource<AccountBalance>>? _balanceStream;

  @override
  void initState() {
    hideAccountBalanceKey =
    "${widget.customerAccount?.accountNumber}-${PreferenceUtil.HIDE_ACCOUNT_BAL}";
    _balanceStream = _balanceStream ??
        widget.viewModel.getCustomerAccountBalance(
            accountId: widget.userAccount.id, useLocal: false);

    super.initState();
  }

  @override
  void didUpdateWidget(covariant AccountDetails oldWidget) {
    _balanceStream = widget.viewModel.getCustomerAccountBalance(
        accountId: widget.userAccount.id, useLocal: false
    );
    super.didUpdateWidget(oldWidget);
  }

  @override
  void dispose() {
    WidgetsBinding.instance?.removeObserver(this);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
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
                  style: Styles.textStyle(context,
                      fontSize: 12.3,letterSpacing: -0.2,
                      fontWeight: FontWeight.w600,
                      color: Colors.textColorBlack.withOpacity(0.9)),
                ),
                SizedBox(height: 4),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    StreamBuilder(
                        stream: _balanceStream,
                        builder: (ctx, AsyncSnapshot<Resource<AccountBalance?>> snapshot) {
                          final bool hideAccountBalance = PreferenceUtil.getValueForLoggedInUser(hideAccountBalanceKey) ?? false;
                          final isLoadingBalanceError = snapshot.hasData && snapshot.data is Error;
                          final isLoadingBalance = snapshot.hasData && snapshot.data is Loading;
                          final AccountBalance? accountBalance = (snapshot.hasData && snapshot.data != null)
                              ? snapshot.data!.data
                              : null;

                          if (snapshot.hasData && (!isLoadingBalance && !isLoadingBalanceError)) {
                            final balance = hideAccountBalance
                                ? "* ***"
                                : "${accountBalance?.availableBalance?.formatCurrencyWithoutSymbolAndDividing}";

                            return Row(
                              children: [
                                SvgPicture.asset("res/drawables/ic_naira.svg", width: 20, height: 17,),
                                SizedBox(width: 4),
                                Text('$balance',
                                    style: Styles.textStyle(context,
                                        fontSize: 23.5,
                                        fontWeight: FontWeight.w800,
                                        color: Colors.textColorBlack)),
                              ],
                            );
                          }

                          if (isLoadingBalanceError && !hideAccountBalance) {
                            return Padding(
                                padding: EdgeInsets.only(right: 8, bottom: 8),
                                child: Text('Error Loading balance',
                                    style: TextStyle(
                                        fontSize: 23,
                                        fontWeight: FontWeight.w800,
                                        color: Colors.textColorBlack)));
                          }

                          if (hideAccountBalance) {
                            return Text('* ***',
                                style: TextStyle(
                                    fontSize: 23,
                                    fontWeight: FontWeight.w800,
                                    color: Colors.textColorBlack));
                          }

                          return Shimmer.fromColors(
                              period: Duration(milliseconds: 1000),
                              child: Align(
                                  alignment: Alignment.centerLeft,
                                  child: Container(
                                    width: 90,
                                    height: 30,
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(10),
                                        color: Colors.white.withOpacity(0.3),
                                        shape: BoxShape.rectangle),
                                  )),
                              baseColor: Colors.white.withOpacity(0.6),
                              highlightColor: Colors.deepGrey.withOpacity(0.6));
                        }),
                    // _buildVisibilityIcon()
                  ],
                ),
                SizedBox(height: 16)
              ],
            ),
          ),
          Positioned(
            top: 23, right: 13,
            child: _buildVisibilityIcon()
            )
        ],
      ),
      Container(
        margin: EdgeInsets.symmetric(horizontal: 19),
        padding: EdgeInsets.fromLTRB(11, 6, 0, 6),
        decoration: BoxDecoration(
          color: Color(0xff0361F0).withOpacity(0.04),
          borderRadius: BorderRadius.all(Radius.circular(9)),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Text(
                  'Account Number',
                  style: Styles.textStyle(context,
                      fontWeight: FontWeight.w400,letterSpacing: -0.2,
                      fontSize: 12,
                      color: Colors.textColorBlack),
                ),
                SizedBox(
                  width: 7,
                ),
                Text(widget.customerAccount?.accountNumber ?? "",
                    style: Styles.textStyle(context,
                        fontWeight: FontWeight.w700,letterSpacing: -0.2,
                        fontSize: 11.3,
                        color: Colors.primaryColor))
              ],
            ),
            Padding(
              padding: EdgeInsets.only(right: 10),
              child: Styles.imageButton(
                  padding: EdgeInsets.all(8),
                  color: Colors.transparent,
                  borderRadius: BorderRadius.circular(30),
                  onClick: () => Share.share(
                      widget.customerAccount?.accountNumber ?? "",
                      subject: 'Moniepoint'),
                  image: SvgPicture.asset(
                    'res/drawables/ic_share.svg',
                    fit: BoxFit.contain,
                    width: 20,
                    height: 21,
                    color: Color(0xffB8003382).withOpacity(0.4),
                  )),
            )
          ],
        ),
      ),
    ]);
  }

  Widget _buildVisibilityIcon() {
    final bool hideAccountBalance =
        PreferenceUtil.getValueForLoggedInUser(hideAccountBalanceKey) ?? false;

    return Padding(
      padding: EdgeInsets.only(right: 16),
      child: Styles.imageButton(
          padding: EdgeInsets.all(8),
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
                hideAccountBalanceKey, hideAccountBalance ? false : true);
            setState(() {});
          }),
    );
  }
}