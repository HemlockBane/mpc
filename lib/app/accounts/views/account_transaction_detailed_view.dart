import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart' hide Colors, ScrollView;
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:intl/intl.dart';
import 'package:moniepoint_flutter/app/accounts/model/data/account_transaction.dart';
import 'package:moniepoint_flutter/app/accounts/model/data/tier.dart';
import 'package:moniepoint_flutter/app/accounts/viewmodels/account_transaction_detail_view_model.dart';
import 'package:moniepoint_flutter/app/accounts/viewmodels/transaction_list_view_model.dart';
import 'package:moniepoint_flutter/app/accounts/views/clippers/account_ticket_clipper.dart';
import 'package:moniepoint_flutter/app/accounts/views/dialogs/account_settings_dialog.dart';
import 'package:moniepoint_flutter/core/colors.dart';
import 'package:moniepoint_flutter/core/models/transaction.dart';
import 'package:moniepoint_flutter/core/routes.dart';
import 'package:moniepoint_flutter/core/styles.dart';
import 'package:moniepoint_flutter/core/tuple.dart';
import 'package:moniepoint_flutter/core/utils/dialog_util.dart';
import 'package:moniepoint_flutter/core/views/scroll_view.dart';
import 'package:moniepoint_flutter/core/views/sessioned_widget.dart';
import 'package:moniepoint_flutter/core/views/transaction_location_view.dart';
import 'package:moniepoint_flutter/core/views/transaction_options_view.dart';
import 'package:provider/provider.dart';
import 'package:moniepoint_flutter/core/utils/currency_util.dart';
import 'package:moniepoint_flutter/core/utils/text_utils.dart';

class AccountTransactionDetailedView extends StatefulWidget {
  AccountTransactionDetailedView();

  @override
  State<StatefulWidget> createState() => _AccountTransactionDetailedView();
}

class _AccountTransactionDetailedView
    extends State<AccountTransactionDetailedView> {
  String? _transactionReference;



  LatLng? _transactionLocation(AccountTransaction transaction) {
    print(transaction.metaData?.location);
    return (transaction.metaData?.location != null)
        ? LatLng(
            double.tryParse(
                    transaction.metaData?.location?.latitude ?? "0.0") ??
                0.0,
            double.tryParse(
                    transaction.metaData?.location?.longitude ?? "0.0") ??
                0.0)
        : null;
  }


  void _displaySettingsDialog() async {
    final viewModel = Provider.of<AccountTransactionDetailViewModel>(context, listen: false);
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


  @override
  void initState() {
   final viewModel =
        Provider.of<AccountTransactionDetailViewModel>(context, listen: false);
    super.initState();
    viewModel.getTiers().listen((event) {});
  }

  @override
  Widget build(BuildContext context) {
    final viewModel = Provider.of<AccountTransactionDetailViewModel>(context);
    this._transactionReference =
        ModalRoute.of(context)!.settings.arguments as String?;

    return Scaffold(
      backgroundColor: Color(0XFFEBF2FA),
      body: SessionedWidget(
        context: context,
        child: Stack(
          children: [
            Positioned.fill(
              child: Image.asset(
                "res/drawables/ic_app_bg_dark.png",
                fit: BoxFit.fill,
              ),
            ),
            ScrollView(
              child: FutureBuilder(
                future: viewModel
                    .getSingleTransactionById(this._transactionReference ?? ""),
                builder: (BuildContext context,
                    AsyncSnapshot<AccountTransaction?> snapshot) {
                  if (!snapshot.hasData || snapshot.data == null)
                    return Container();
                  final transaction = snapshot.data!;
                  final transactionDate = DateFormat("d MMM. yy | h:mm a")
                      .format(DateTime.fromMillisecondsSinceEpoch(
                          transaction.getInitiatedDate()));
                  final balanceBefore =
                      double.tryParse(transaction.balanceBefore ?? "")
                              ?.formatCurrency ??
                          "";
                  final balanceAfter =
                      double.tryParse(transaction.balanceAfter ?? "")
                              ?.formatCurrency ??
                          "";
                  final downloadTask = Tuple(
                      () => viewModel.downloadTransactionReceipt(transaction),
                      "AccountTransaction_Receipt_${viewModel.accountName}_${DateFormat("dd_MM_yyyy_h_m_s").format(DateTime.now())}.pdf");
                  final transactionLocation = _transactionLocation(transaction);
                  final transactionType =
                      transaction.type == TransactionType.CREDIT
                          ? "CREDIT"
                          : "DEBIT";

                  return Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(height: 37),
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
                                  "Transaction Details",
                                  style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w700,
                                      color: Colors.textColorBlack),
                                )
                              ],
                            ),
                            // Styles.imageButton(
                            //   padding: EdgeInsets.all(9),
                            //   color: Colors.transparent,
                            //   borderRadius: BorderRadius.circular(30),
                            //   onClick: _displaySettingsDialog,
                            //   image: SvgPicture.asset(
                            //     'res/drawables/ic_dashboard_settings.svg',
                            //     fit: BoxFit.contain,
                            //     width: 22,
                            //     height: 22.56,
                            //     color: Colors.primaryColor,
                            //   ),
                            // ),
                          ],
                        ),
                      ),
                      SizedBox(height: 30),
                      Stack(
                        children: [
                          IgnorePointer(
                            ignoring: true,
                            child: Container(
                              margin: EdgeInsets.symmetric(horizontal: 19),
                              padding: EdgeInsets.symmetric(horizontal: 19),
                              width: double.infinity,
                              decoration: BoxDecoration(
                                color: Colors.transparent,
                                // color: Colors.black,
                                borderRadius: BorderRadius.all(Radius.circular(16)),
                                boxShadow: [
                                  BoxShadow(
                                    offset: Offset(0, 13),
                                    blurRadius: 21,
                                    color: Color(0xff0E4FB1).withOpacity(0.13),
                                  ),
                                ]

                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  SizedBox(height: 24),
                                  Text(
                                    "Amount",
                                    style: TextStyle(
                                      fontSize: 12.3,
                                      letterSpacing: -0.2,
                                      fontWeight: FontWeight.w600,
                                      color:
                                      Colors.textColorBlack.withOpacity(0.9)),
                                  ),
                                  SizedBox(
                                    height: 7,
                                  ),
                                  Row(children: [
                                    SvgPicture.asset(
                                      "res/drawables/ic_naira.svg",
                                      width: 20,
                                      height: 17,
                                    ),
                                    SizedBox(width: 4),
                                    Text(
                                      transaction
                                        .getAmount()
                                        .formatCurrencyWithoutSymbolAndDividing,
                                      style: TextStyle(
                                        fontSize: 23.5,
                                        fontWeight: FontWeight.w800,
                                        color: Colors.textColorBlack,
                                      ),
                                    ),
                                  ]),
                                  Row(
                                    crossAxisAlignment: CrossAxisAlignment.end,
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text('Balance before: $balanceBefore',
                                        style: TextStyle(
                                          fontSize: 12,
                                          fontWeight: FontWeight.w400,
                                          color: Colors.textColorBlack)),
                                      Container(
                                        padding: EdgeInsets.symmetric(
                                          horizontal: 8.4, vertical: 2.5),
                                        decoration: BoxDecoration(
                                          color: (transaction.type ==
                                            TransactionType.CREDIT)
                                            ? Colors.solidGreen.withOpacity(0.25)
                                            : Color(0xff24F00303),
                                          borderRadius: BorderRadius.circular(4)),
                                        child: Text(
                                          transactionType,
                                          style: TextStyle(
                                            fontSize: 11.2,
                                            color: (transaction.type ==
                                              TransactionType.CREDIT)
                                              ? Colors.solidGreen
                                              : Colors.red,
                                            fontWeight: FontWeight.bold),
                                        ),
                                      )
                                    ],
                                  ),
                                  SizedBox(height: 17),
                                  Container(
                                    width: double.infinity,
                                    padding: EdgeInsets.symmetric(horizontal: 15),
                                    decoration: BoxDecoration(
                                      color: Colors.primaryColor.withOpacity(0.05),
                                      borderRadius:
                                      BorderRadius.all(Radius.circular(9)),
                                    ),
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        SizedBox(height: 17),
                                        _label('Transaction Date'),
                                        SizedBox(height: 3),
                                        _text(transactionDate),
                                        SizedBox(height: 18),
                                        Container(
                                          width: double.infinity,
                                          child: Divider(
                                            height: 2,
                                            color: Colors.primaryColor
                                              .withOpacity(0.3),
                                          )),
                                        if (transaction.channel != null)
                                          SizedBox(height: 14),
                                        if (transaction.channel != null)
                                          _label("Channel"),
                                        if (transaction.channel != null)
                                          SizedBox(height: 5),
                                        if (transaction.channel != null)
                                          Container(
                                            padding: EdgeInsets.symmetric(
                                              horizontal: 8, vertical: 4),
                                            decoration: BoxDecoration(
                                              color: Colors.primaryColor
                                                .withOpacity(0.17),
                                              borderRadius:
                                              BorderRadius.circular(4)),
                                            child: Text(
                                              transaction.channel ?? "",
                                              style: TextStyle(
                                                fontSize: 11.3,
                                                color: Colors.primaryColor,
                                                fontWeight: FontWeight.bold),
                                            ),
                                          ),
                                        if (transaction.channel != null)
                                          SizedBox(height: 18),
                                        if (transaction.channel != null)
                                          Container(
                                            width: double.infinity,
                                            child: Divider(
                                              height: 2,
                                              color: Colors.primaryColor
                                                .withOpacity(0.3),
                                            )),
                                        if (transaction.metaData != null && transaction.metaData?.recipient != null)
                                          SizedBox(height: 14),
                                        if (transaction.metaData != null && transaction.metaData?.recipient != null)
                                          _label("Recipient"),
                                        if (transaction.metaData != null && transaction.metaData?.recipient != null)
                                          SizedBox(height: 3),
                                        if (transaction.metaData != null && transaction.metaData?.recipient != null)
                                          _text(transaction.metaData?.recipient?.name ?? ""),
                                        if (transaction.metaData != null && transaction.metaData?.recipient != null)
                                          SizedBox(height: 3),
                                        if (transaction.metaData != null && transaction.metaData?.recipient != null)
                                          Row(
                                            children: [
                                              _text(transaction.metaData?.recipient?.bankName ?? "",
                                                fontSize: 11.3,
                                                color: Colors.deepGrey),
                                              SizedBox(width: 6),
                                              _text(transaction.metaData?.recipient?.accountNumber ?? "",
                                                fontSize: 11.3,
                                                color: Colors.deepGrey)
                                            ],
                                          ),
                                        if (transaction.metaData != null && transaction.metaData?.recipient != null)
                                          SizedBox(height: 18),
                                        if (transaction.metaData != null && transaction.metaData?.recipient != null)
                                          Container(
                                            width: double.infinity,
                                            child: Divider(
                                              height: 2,
                                              color: Colors.primaryColor
                                                .withOpacity(0.3),
                                            )),
                                        SizedBox(height: 14),
                                        if (transaction.narration != null &&
                                          transaction.narration!.isNotEmpty)
                                          _label('Narration'),
                                        if (transaction.narration != null &&
                                          transaction.narration!.isNotEmpty)
                                          SizedBox(height: 3),
                                        if (transaction.narration != null &&
                                          transaction.narration!.isNotEmpty)
                                          _text(transaction.narration ?? ""),
                                        SizedBox(height: 18),
                                        if (transactionLocation != null)
                                          Container(
                                            width: double.infinity,
                                            child: Divider(
                                              height: 2,
                                              color: Colors.primaryColor
                                                .withOpacity(0.3),
                                            )),
                                        if (transactionLocation != null)
                                          SizedBox(height: 14),
                                        if (transactionLocation != null)
                                          _label("Location"),
                                        if (transactionLocation != null)
                                          SizedBox(height: 12),
                                        if (transactionLocation != null)
                                          TransactionLocationView(
                                            transactionLocation,
                                            transaction.getInitiatorName()),
                                      ],
                                    ),
                                  ),
                                  SizedBox(height: 51)
                                ],
                              ),
                            ),
                          ),
                          ClipPath(
                            clipper: AccountTransactionsTicketClipper(),
                            child: Container(
                              margin: EdgeInsets.symmetric(horizontal: 19),
                              padding: EdgeInsets.symmetric(horizontal: 19),
                              width: double.infinity,
                              decoration: BoxDecoration(
                                  color: Colors.backgroundWhite,
                                  // color: Colors.black,
                                  borderRadius: BorderRadius.all(Radius.circular(16)),
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  SizedBox(height: 24),
                                  Text(
                                    "Amount",
                                    style: TextStyle(
                                        fontSize: 12.3,
                                        letterSpacing: -0.2,
                                        fontWeight: FontWeight.w600,
                                        color:
                                            Colors.textColorBlack.withOpacity(0.9)),
                                  ),
                                  SizedBox(
                                    height: 7,
                                  ),
                                  Row(children: [
                                    SvgPicture.asset(
                                      "res/drawables/ic_naira.svg",
                                      width: 20,
                                      height: 17,
                                    ),
                                    SizedBox(width: 4),
                                    Text(
                                      transaction
                                          .getAmount()
                                          .formatCurrencyWithoutSymbolAndDividing,
                                      style: TextStyle(
                                        fontSize: 23.5,
                                        fontWeight: FontWeight.w800,
                                        color: Colors.textColorBlack,
                                      ),
                                    ),
                                  ]),
                                  Row(
                                    crossAxisAlignment: CrossAxisAlignment.end,
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text('Balance before: $balanceBefore',
                                          style: TextStyle(
                                              fontSize: 12,
                                              fontWeight: FontWeight.w400,
                                              color: Colors.textColorBlack)),
                                      Container(
                                        padding: EdgeInsets.symmetric(
                                            horizontal: 8.4, vertical: 2.5),
                                        decoration: BoxDecoration(
                                            color: (transaction.type ==
                                                    TransactionType.CREDIT)
                                                ? Colors.solidGreen.withOpacity(0.25)
                                                : Color(0xff24F00303),
                                            borderRadius: BorderRadius.circular(4)),
                                        child: Text(
                                          transactionType,
                                          style: TextStyle(
                                              fontSize: 11.2,
                                              color: (transaction.type ==
                                                      TransactionType.CREDIT)
                                                  ? Colors.solidGreen
                                                  : Colors.red,
                                              fontWeight: FontWeight.bold),
                                        ),
                                      )
                                    ],
                                  ),
                                  SizedBox(height: 17),
                                  Container(
                                    width: double.infinity,
                                    padding: EdgeInsets.symmetric(horizontal: 15),
                                    decoration: BoxDecoration(
                                      color: Colors.primaryColor.withOpacity(0.05),
                                      borderRadius:
                                          BorderRadius.all(Radius.circular(9)),
                                    ),
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        SizedBox(height: 17),
                                        _label('Transaction Date'),
                                        SizedBox(height: 3),
                                        _text(transactionDate),
                                        SizedBox(height: 18),
                                        Container(
                                            width: double.infinity,
                                            child: Divider(
                                              height: 2,
                                              color: Colors.primaryColor
                                                  .withOpacity(0.3),
                                            )),
                                        if (transaction.channel != null)
                                          SizedBox(height: 14),
                                        if (transaction.channel != null)
                                          _label("Channel"),
                                        if (transaction.channel != null)
                                          SizedBox(height: 5),
                                        if (transaction.channel != null)
                                          Container(
                                            padding: EdgeInsets.symmetric(
                                                horizontal: 8, vertical: 4),
                                            decoration: BoxDecoration(
                                                color: Colors.primaryColor
                                                    .withOpacity(0.17),
                                                borderRadius:
                                                    BorderRadius.circular(4)),
                                            child: Text(
                                              transaction.channel ?? "",
                                              style: TextStyle(
                                                  fontSize: 11.3,
                                                  color: Colors.primaryColor,
                                                  fontWeight: FontWeight.bold),
                                            ),
                                          ),
                                        if (transaction.channel != null)
                                          SizedBox(height: 18),
                                        if (transaction.channel != null)
                                          Container(
                                              width: double.infinity,
                                              child: Divider(
                                                height: 2,
                                                color: Colors.primaryColor
                                                    .withOpacity(0.3),
                                              )),
                                        if (transaction.metaData != null && transaction.metaData?.recipient != null)
                                          SizedBox(height: 14),
                                        if (transaction.metaData != null && transaction.metaData?.recipient != null)
                                          _label("Recipient"),
                                        if (transaction.metaData != null && transaction.metaData?.recipient != null)
                                          SizedBox(height: 3),
                                        if (transaction.metaData != null && transaction.metaData?.recipient != null)
                                          _text(transaction.metaData?.recipient?.name ?? ""),
                                        if (transaction.metaData != null && transaction.metaData?.recipient != null)
                                          SizedBox(height: 3),
                                        if (transaction.metaData != null && transaction.metaData?.recipient != null)
                                          Row(
                                            children: [
                                              _text(transaction.metaData?.recipient?.bankName ?? "",
                                                  fontSize: 11.3,
                                                  color: Colors.deepGrey),
                                              SizedBox(width: 6),
                                              _text(transaction.metaData?.recipient?.accountNumber ?? "",
                                                  fontSize: 11.3,
                                                  color: Colors.deepGrey)
                                            ],
                                          ),
                                      if (transaction.metaData != null && transaction.metaData?.recipient != null)
                                        SizedBox(height: 18),
                                      if (transaction.metaData != null && transaction.metaData?.recipient != null)
                                        Container(
                                            width: double.infinity,
                                            child: Divider(
                                              height: 2,
                                              color: Colors.primaryColor
                                                  .withOpacity(0.3),
                                            )),
                                        SizedBox(height: 14),
                                        if (transaction.narration != null &&
                                            transaction.narration!.isNotEmpty)
                                          _label('Narration'),
                                        if (transaction.narration != null &&
                                            transaction.narration!.isNotEmpty)
                                          SizedBox(height: 3),
                                        if (transaction.narration != null &&
                                            transaction.narration!.isNotEmpty)
                                          _text(transaction.narration ?? ""),
                                        SizedBox(height: 18),
                                        if (transactionLocation != null)
                                          Container(
                                              width: double.infinity,
                                              child: Divider(
                                                height: 2,
                                                color: Colors.primaryColor
                                                    .withOpacity(0.3),
                                              )),
                                        if (transactionLocation != null)
                                          SizedBox(height: 14),
                                        if (transactionLocation != null)
                                          _label("Location"),
                                        if (transactionLocation != null)
                                          SizedBox(height: 12),
                                        if (transactionLocation != null)
                                          TransactionLocationView(
                                              transactionLocation,
                                              transaction.getInitiatorName()),
                                      ],
                                    ),
                                  ),
                                  SizedBox(height: 51)
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 54),
                      Visibility(
                          visible: transaction.metaData != null &&
                              transaction.metaData?.transactionType != null &&
                              transaction.type == TransactionType.DEBIT,
                          child: Expanded(
                              child: TransactionOptionsView(
                            displayReplayTransaction: false,
                            displayDownloadReceipt: transaction.metaData !=
                                        null &&
                                    transaction.type == TransactionType.DEBIT
                                ? downloadTask
                                : null,
                            displayShareReceipt: transaction.metaData != null &&
                                    transaction.type == TransactionType.DEBIT
                                ? downloadTask
                                : null,
                          )))
                    ],
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Text _label(String label) {
    return Text(
      label,
      style: TextStyle(
          fontSize: 12.7,
          fontWeight: FontWeight.w400,
          color: Colors.textColorBlack.withOpacity(0.8)),
    );
  }

  Text _text(String text, {Color? color, double? fontSize}) {
    return Text(
      text,
      style: TextStyle(
          fontSize: fontSize ?? 14.5,
          fontWeight: FontWeight.w600,
          color: color ?? Colors.textColorBlack),
    );
  }
}
