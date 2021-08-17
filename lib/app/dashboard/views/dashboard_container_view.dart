import 'package:flutter/material.dart' hide Colors;
import 'package:flutter_html/shims/dart_ui_real.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:moniepoint_flutter/app/accounts/model/data/account_balance.dart';
import 'package:moniepoint_flutter/app/accounts/model/data/tier.dart';
import 'package:moniepoint_flutter/app/customer/customer_account.dart';
import 'package:moniepoint_flutter/app/customer/user_account.dart';
import 'package:moniepoint_flutter/app/dashboard/viewmodels/dashboard_view_model.dart';
import 'package:moniepoint_flutter/core/colors.dart';
import 'package:moniepoint_flutter/core/models/user_instance.dart';
import 'package:moniepoint_flutter/core/network/resource.dart';
import 'package:moniepoint_flutter/core/styles.dart';
import 'package:moniepoint_flutter/core/tuple.dart';
import 'package:moniepoint_flutter/core/utils/preference_util.dart';
import 'package:share/share.dart';
import 'package:shimmer/shimmer.dart';
import 'package:moniepoint_flutter/core/utils/text_utils.dart';
import 'package:moniepoint_flutter/core/utils/currency_util.dart';

class DashboardContainerView extends StatefulWidget {

  final DashboardViewModel viewModel;
  final int position;
  final UserAccount userAccount;
  final Tier? qualifiedTier;

  DashboardContainerView({
    required Key key,
    required this.viewModel,
    required this.userAccount,
    required this.position,
    this.qualifiedTier
  }):super(key: key);

  @override
  State<StatefulWidget> createState() => DashboardContainerViewState();

}

class DashboardContainerViewState extends State<DashboardContainerView> with WidgetsBindingObserver {

  Stream<Resource<AccountBalance>>? _balanceStream;
  AccountBalance? balance;
  String hideAccountBalanceKey = PreferenceUtil.HIDE_ACCOUNT_BAL;

  void loadAccountBalance() {
    final viewModel = widget.viewModel;
    viewModel.getUserAccountsBalance(useLocal: false).listen((event) { });
  }

  @override
  void initState() {
    hideAccountBalanceKey = "${widget.userAccount.customerAccount?.accountNumber}-${PreferenceUtil.HIDE_ACCOUNT_BAL}";
    _balanceStream = widget.viewModel.getCustomerAccountBalance(
        accountId: widget.userAccount.id, useLocal: false
    );
    super.initState();
  }

  Widget _displayAccountBalance () {
    return StreamBuilder(
        stream: _balanceStream,
        builder: (BuildContext ctx, AsyncSnapshot<Resource<AccountBalance?>> snapshot) {
          final bool hideAccountBalance = PreferenceUtil.getValueForLoggedInUser(hideAccountBalanceKey) ?? false;
          final isLoadingBalanceError = snapshot.hasData && snapshot.data is Error;
          final isLoadingBalance = snapshot.hasData && snapshot.data is Loading;
          final AccountBalance? accountBalance = (snapshot.hasData && snapshot.data != null) ? snapshot.data!.data : null;

          if(snapshot.hasData && (!isLoadingBalance && !isLoadingBalanceError)) {
            final balance = hideAccountBalance ? "* ***" : "N ${accountBalance?.availableBalance?.formatCurrencyWithoutSymbolAndDividing}";
            final coloredPrefix = hideAccountBalance ? "* " : "N";
            return Text("$balance",
                textAlign: TextAlign.start,
                style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white, fontSize: 28, fontFamily: Styles.defaultFont)
            ).colorText({coloredPrefix: Tuple(Colors.white.withOpacity(0.3), null)}, underline: false);
          }
          if(isLoadingBalanceError && !hideAccountBalance) {
            return Padding(
                padding: EdgeInsets.only(right: 8, bottom: 8),
                child: Text("Error loading balance\nplease, try again",
                    textAlign: TextAlign.start,
                    style: TextStyle(fontWeight: FontWeight.bold, color: Colors.darkBlue, fontSize: 21, fontFamily: Styles.defaultFont)
                ).colorText({"try again": Tuple(Colors.white, loadAccountBalance)}, underline: false)
            );
          }
          if(hideAccountBalance) {
            return Text("* ***",
                textAlign: TextAlign.start,
                style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white, fontSize: 28, fontFamily: Styles.defaultFont)
            ).colorText({"* ": Tuple(Colors.white.withOpacity(0.5), null)}, underline: false);
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
                    shape: BoxShape.rectangle
                ),
              )),
              baseColor: Colors.white.withOpacity(0.6),
              highlightColor: Colors.deepGrey.withOpacity(0.6)
          );
        });
  }

  Widget _getCardGradientBackground() {
    if (UserInstance().accountStatus?.postNoDebit != true) {
      return Positioned(
          left: 0,
          right: 0,
          bottom: 0,
          top: 0,
          child: ClipRRect(
            borderRadius: BorderRadius.all(Radius.circular(16)),
            clipBehavior: Clip.antiAlias,
            child: Container(
                color: Color(0XFF186cf3),
                child: SvgPicture.asset(
                  'res/drawables/ic_dashboard_card_gradient.svg',
                  fit: BoxFit.cover,
                )),
          ));
    }
    return Positioned(
        left: 0,
        right: 0,
        bottom: 0,
        top: 0,
        child: ClipRRect(
          borderRadius: BorderRadius.all(Radius.circular(16)),
          clipBehavior: Clip.antiAlias,
          child: Container(
              color: Colors.deepGrey
          ),
        ),
    );
  }

  Widget _cardOptions(CustomerAccount? customerAccount) {
    return Expanded(
        child: Align(
          alignment: FractionalOffset.bottomCenter,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              (UserInstance().accountStatus?.postNoDebit == true)
                  ? SizedBox()
                  : SvgPicture.asset('res/drawables/ic_moniepoint_cube.svg', width: 36, height: 36),
              SizedBox(width: UserInstance().accountStatus?.postNoDebit == true ? 4 : 8),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text('Moniepoint Acc. No:', style: TextStyle(color: Colors.white.withOpacity(0.5), fontSize: 13)),
                  Text(customerAccount?.accountNumber ?? "",
                      textAlign: TextAlign.start,
                      style: TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.w400, fontFamily: Styles.ocraExtended)
                  ),
                ],
              ),
              Spacer(),
              Padding(
                padding: EdgeInsets.only(right: 16),
                child: Styles.imageButton(
                    padding: EdgeInsets.all(8),
                    color: Colors.transparent,
                    borderRadius: BorderRadius.circular(30),
                    onClick: () => Share.share(
                        "Moniepoint MFB\n${customerAccount?.accountNumber}\n${customerAccount?.customer?.name}",
                        subject: 'Moniepoint MFB'
                    ),
                    image: SvgPicture.asset(
                      'res/drawables/ic_share.svg',
                      fit: BoxFit.contain,
                      width: 18,
                      height: 18,
                    )
                ),
              )
            ],
          ),
        )
    );
  }

  List<Widget> _cardDetails(){
    final bool hideAccountBalance = PreferenceUtil.getValueForLoggedInUser(hideAccountBalanceKey) ?? false;
    return [
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(
            padding: EdgeInsets.only(left: 9, right: 9, top: 5, bottom: 5),
            decoration: BoxDecoration(
                color: Colors.darkBlue.withOpacity(0.5),
                borderRadius: BorderRadius.all(Radius.circular(16))
            ),
            child: Center(
              child: Text('SAVINGS', style: TextStyle(color: Colors.white, fontSize: 12)),
            ),
          ),
          Padding(
            padding: EdgeInsets.only(right: 24),
            child: Styles.imageButton(
                padding: EdgeInsets.only(
                    left: 4,
                    right: 4,
                    top: hideAccountBalance ? 6 : 4,
                    bottom: hideAccountBalance ? 6 : 4
                ),
                color: Colors.white.withOpacity(hideAccountBalance ? 0.25 : 0.75),
                image: SvgPicture.asset(
                  hideAccountBalance
                      ? 'res/drawables/ic_eye_open.svg'
                      : 'res/drawables/ic_eye_closed.svg',
                  width: hideAccountBalance ? 10 : 16,
                  height: hideAccountBalance ? 12 : 16,
                ),
                onClick: () {
                  PreferenceUtil.saveValueForLoggedInUser(hideAccountBalanceKey, hideAccountBalance ? false : true);
                  setState(() {});
                }
            ),
          )
        ],
      ),
      SizedBox(height: 12,),
      //Amount
      _displayAccountBalance(),
      SizedBox(height: 12,),
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            "${widget.qualifiedTier?.name?.replaceAll("Moniepoint Customers ", "").toUpperCase() ?? "--"}",
            style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 14, color: Colors.white
            ),),
          SizedBox(width: 8,),
          Expanded(child: Divider(color: Colors.white.withOpacity(0.21), height: 1, thickness: 0.8,))
        ],
      )
    ];
  }

  Widget _pndAccount(CustomerAccount? customerAccount) {
    return Stack(
      children: [
        _getCardGradientBackground(),
        Container(
          padding: EdgeInsets.only(left: 16, right: 0, top: 32, bottom: 32),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(16)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              ..._cardDetails(),
              _cardOptions(customerAccount)
            ],
          ),
        ),
        ClipRRect(
          borderRadius: BorderRadius.all(Radius.circular(16)),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 5.0, sigmaY: 4.5),
            child: Container(
              width: double.infinity,
              height: 280.0,
              decoration: new BoxDecoration(
                color: Color(0XFF282828).withOpacity(0.63),
                borderRadius: BorderRadius.all(Radius.circular(16)),
              ),
              child: Center(
                child: Stack(
                  children: [
                    Container(
                      width: double.infinity,
                      margin: EdgeInsets.only(left: 24, right: 24, top: 42.5),
                      padding: EdgeInsets.only(left: 16, right: 16, bottom: 16, top: 36),
                      decoration: new BoxDecoration(
                        color: Colors.red.withOpacity(0.9),
                        borderRadius: BorderRadius.all(Radius.circular(9)),
                      ),
                      child: Text(
                        'Account Restricted',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 16
                        ),),
                    ),
                    Positioned(
                        left: 0,
                        right: 0,
                        top: 20,
                        child: Container(
                          width: 45,
                          height: 45,
                          padding: EdgeInsets.only(left: 14, right: 14, bottom: 10, top: 10),
                          decoration: new BoxDecoration(
                            color: Colors.white,
                            shape: BoxShape.circle
                          ),
                          child: SvgPicture.asset('res/drawables/ic_pnd_lock.svg', color:Colors.red),
                        )
                    )
                  ],
                ),
              ),
            ),
          ),
        )
      ],
    );
  }

  Widget _displayNormal(CustomerAccount? customerAccount) {
    return Stack(
      children: [
        _getCardGradientBackground(),
        Container(
          padding: EdgeInsets.only(left: 16, right: 0, top: 32, bottom: 32),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(16)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              ..._cardDetails(),
              _cardOptions(customerAccount)
            ],
          ),
        )
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final customerAccount = widget.userAccount.customerAccount;
    if (UserInstance().accountStatus?.postNoDebit == true) {
      return _pndAccount(customerAccount);
    } else {
      return _displayNormal(customerAccount);
    }
  }

  @override
  void didUpdateWidget(covariant DashboardContainerView oldWidget) {
    super.didUpdateWidget(oldWidget);
    print("Balance stream is null ${_balanceStream == null}");
    _balanceStream = widget.viewModel.getCustomerAccountBalance(
        accountId: widget.userAccount.id, useLocal: false
    );
  }

  @override
  void dispose() {
    WidgetsBinding.instance?.removeObserver(this);
    super.dispose();
  }
}