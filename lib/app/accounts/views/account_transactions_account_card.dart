import 'package:flutter/material.dart' hide Colors;
import 'package:flutter_svg/flutter_svg.dart';
import 'package:moniepoint_flutter/app/accounts/model/data/account_balance.dart';
import 'package:moniepoint_flutter/app/accounts/model/data/tier.dart';
import 'package:moniepoint_flutter/app/accounts/viewmodels/transaction_list_view_model.dart';
import 'package:moniepoint_flutter/app/customer/customer_account.dart';
import 'package:moniepoint_flutter/app/customer/user_account.dart';
import 'package:moniepoint_flutter/core/colors.dart';
import 'package:moniepoint_flutter/core/extensions/composite_disposable_widget.dart';
import 'package:moniepoint_flutter/core/network/resource.dart';
import 'package:moniepoint_flutter/core/routes.dart';
import 'package:moniepoint_flutter/core/styles.dart';
import 'package:moniepoint_flutter/core/tuple.dart';
import 'package:share/share.dart';
import 'package:shimmer/shimmer.dart';
import 'package:moniepoint_flutter/core/utils/currency_util.dart';
import 'package:moniepoint_flutter/core/utils/text_utils.dart';
import 'package:moniepoint_flutter/core/strings.dart';

class AccountTransactionsAccountCard extends StatefulWidget {
  const AccountTransactionsAccountCard(
      {required this.viewModel, required this.userAccount});

  final TransactionHistoryViewModel viewModel;
  final UserAccount userAccount;

  @override
  _AccountTransactionsAccountCardState createState() => _AccountTransactionsAccountCardState();
}

class _AccountTransactionsAccountCardState extends State<AccountTransactionsAccountCard> {
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
