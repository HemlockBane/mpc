import 'package:flutter/material.dart' hide Colors;
import 'package:flutter_svg/flutter_svg.dart';
import 'package:moniepoint_flutter/app/accounts/model/data/account_transaction.dart';
import 'package:moniepoint_flutter/app/accounts/views/transaction_history_list_item.dart';
import 'package:moniepoint_flutter/app/loans/views/loans_apply_confirmation_view.dart';
import 'package:moniepoint_flutter/app/loans/views/loans_product_details_view.dart';
import 'package:moniepoint_flutter/app/loans/views/widgets/info_banner_content.dart';
import 'package:moniepoint_flutter/app/loans/views/widgets/loan_confirmation_account_tile.dart';
import 'package:moniepoint_flutter/core/colors.dart';
import 'package:moniepoint_flutter/core/models/ussd_configuration.dart';
import 'package:moniepoint_flutter/core/routes.dart';
import 'package:moniepoint_flutter/core/styles.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';

class LoanDetailsView extends StatefulWidget {
  const LoanDetailsView({Key? key}) : super(key: key);

  @override
  _LoanDetailsViewState createState() => _LoanDetailsViewState();
}

class _LoanDetailsViewState extends State<LoanDetailsView> {
  TextStyle getBoldStyle({
    double fontSize = 24.5,
    Color color = Colors.textColorBlack,
    FontWeight fontWeight = FontWeight.w700,
  }) =>
      TextStyle(fontWeight: fontWeight, color: color, fontSize: fontSize);

  TextStyle getNormalStyle({
    double fontSize = 11.5,
    Color color = Colors.textColorBlack,
    FontWeight fontWeight = FontWeight.w500,
  }) =>
      TextStyle(fontWeight: fontWeight, color: color, fontSize: fontSize);

  Widget _columnTile(
          {required String text1,
          TextStyle? text1Style,
          TextStyle? text2Style,
          required String text2}) =>
      Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            text1,
            style: text1Style ??
                getBoldStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 12.5,
                    color: Colors.white),
          ),
          SizedBox(height: 3),
          Text(
            text2,
            style: text2Style ??
                getBoldStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 16.5,
                    color: Colors.white),
          )
        ],
      );

  Widget _loanDetailsContent(ScrollController draggableScrollController) {
    return Container(
      child: ListView(
        controller: draggableScrollController,
        padding: EdgeInsets.zero,
        shrinkWrap: true,
        children: [
          SizedBox(height: 26),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 14, vertical: 17),
            margin: EdgeInsets.symmetric(horizontal: 23),
            child: InfoBannerContent(
                rightSpace: 40,
                title: "Penalty",
                subtitle:
                    "A fee of x Naira will be added to the total outstanding balance for each day "
                    "the repayment is late",
                svgPath: "res/drawables/ic_savings_warning.svg"),
            decoration: BoxDecoration(
                color: Color(0xff244528).withOpacity(0.05),
                borderRadius: BorderRadius.all(Radius.circular(8))),
          ),
          SizedBox(height: 26),
          Container(
            padding: EdgeInsets.only(left: 40, right: 30),
            child: Row(
              children: [
                Expanded(
                  flex: 2,
                  child: _columnTile(
                      text1: "Total Repayment",
                      text1Style:
                          getNormalStyle(color: Colors.grey, fontSize: 11.5),
                      text2: "N 50,000.00",
                      text2Style: getBoldStyle(
                          color: Colors.textColorBlack, fontSize: 16.5)),
                ),
                Spacer(flex: 1),
                Expanded(
                  flex: 2,
                  child: _columnTile(
                      text1: "Amount Paid",
                      text1Style:
                          getNormalStyle(color: Colors.grey, fontSize: 12.5),
                      text2: "N 50,000.00",
                      text2Style: getBoldStyle(
                          color: Colors.textColorBlack, fontSize: 16.5)),
                )
              ],
            ),
          ),
          SizedBox(height: 26),
          Container(
            padding: EdgeInsets.only(left: 40, right: 30),
            child: Row(
              children: [
                Expanded(
                  flex: 2,
                  child: _columnTile(
                      text1: "Interest Amount",
                      text1Style:
                          getNormalStyle(color: Colors.grey, fontSize: 11.5),
                      text2: "N 50,000.00",
                      text2Style: getBoldStyle(
                          color: Colors.textColorBlack, fontSize: 16.5)),
                ),
                Spacer(flex: 1),
                Expanded(
                  flex: 2,
                  child: _columnTile(
                      text1: "Interest Rate",
                      text1Style:
                          getNormalStyle(color: Colors.grey, fontSize: 12.5),
                      text2: "4 %",
                      text2Style: getBoldStyle(
                          color: Colors.textColorBlack, fontSize: 16.5)),
                )
              ],
            ),
          ),
          SizedBox(height: 26),
          Container(
            padding: EdgeInsets.only(left: 40, right: 30),
            child: Row(
              children: [
                Expanded(
                  flex: 2,
                  child: _columnTile(
                      text1: "Disbursement Date",
                      text1Style:
                          getNormalStyle(color: Colors.grey, fontSize: 11.5),
                      text2: "2nd Jan. 2022",
                      text2Style: getBoldStyle(
                          color: Colors.textColorBlack, fontSize: 16.5)),
                ),
                Spacer(flex: 1),
                Expanded(
                  flex: 2,
                  child: _columnTile(
                      text1: "Tenor",
                      text1Style:
                          getNormalStyle(color: Colors.grey, fontSize: 12.5),
                      text2: "15 days",
                      text2Style: getBoldStyle(
                          color: Colors.textColorBlack, fontSize: 16.5)),
                )
              ],
            ),
          ),
          SizedBox(height: 24),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 23),
            child: Text(
              "Payout Account",
              style: getNormalStyle(fontSize: 14.5),
            ),
          ),
          SizedBox(height: 12),
          ConfirmationAccountTile(
            padding: EdgeInsets.symmetric(horizontal: 20),
            accountName: "Leslie Tobechukwu Isah",
            accountNumber: "0011357716",
          ),
          SizedBox(height: 20),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 23),
            child: Text(
              "Repayment Account",
              style: getNormalStyle(fontSize: 14.5),
            ),
          ),
          SizedBox(height: 12),
          ConfirmationAccountTile(
            padding: EdgeInsets.symmetric(horizontal: 20),
            accountName: "Leslie Tobechukwu Isah",
            accountNumber: "0011357716",
          ),
          SizedBox(height: 200)
        ],
      ),
    );
  }

  Widget _transactionHistoryContent(ScrollController draggableScrollController) {
    return Container(
      child: ListView.separated(
        controller: draggableScrollController,
        separatorBuilder: (BuildContext context, int index) => Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15),
          child: const Divider(height: 0.9, color: Color(0xffE0E2E4),),
        ),
          itemCount: data.length,
          itemBuilder: (ctx, idx) {
            final transaction = data[idx];
            
            if (idx == data.length - 1) return Padding(
              padding: EdgeInsets.only(bottom: 200),
              child: TransactionHistoryListItem(
                  transaction, idx, (t, idx) {},
                  pillColor: Colors.solidOrange,
                ),
            );
            
            return TransactionHistoryListItem(
              transaction, idx, (t, idx) {},
              pillColor: Colors.solidOrange,
            );
          }),
    );
  }

  Widget _content(context) {
    final screenSize = MediaQuery.of(context).size;
    // final minExtent = 1 - (containerHeight / (screenSize.height - maxDraggableTop));
    final containerHeight = 1;

    final maxExtent = 0.65;
    final minExtent = 0.48;



    return DraggableScrollableSheet(
      maxChildSize: maxExtent,
      minChildSize: minExtent,
      initialChildSize: minExtent,
      builder: (ctx, ScrollController draggableScrollController){
        return DefaultTabController(
          length: 2,
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.vertical(
                top: Radius.circular(22),
              ),
              border: Border.all(
                width: 1.0,
                color: Color(0xff063A4F0D).withOpacity(0.05),
              ),
            ),
            child: Container(
              child: Column(
                children: [
                  SizedBox(height: 8),
                  Container(
                    child: TabBar(
                      indicatorColor: Colors.solidOrange,
                      labelColor: Colors.solidOrange,
                      unselectedLabelColor: Colors.textColorBlack,
                      labelStyle: getBoldStyle(
                        fontSize: 13.5,
                        color: Colors.solidOrange,
                        fontWeight: FontWeight.w600),
                      unselectedLabelStyle: getBoldStyle(
                        fontSize: 13.5,
                        color: Colors.textColorBlack,
                        fontWeight: FontWeight.w600),
                      indicatorWeight: 5,
                      tabs: [
                        Tab(child: Text("Loan Details")),
                        Tab(child: Text("Transaction History"))
                      ],
                    ),
                    decoration: BoxDecoration(color: Colors.white, boxShadow: [
                      BoxShadow(
                        offset: Offset(0, 7),
                        blurRadius: 15,
                        spreadRadius: -8,
                        color: Color(0xff503D19).withOpacity(0.24))
                    ]),
                  ),
                  Expanded(
                    child: TabBarView(
                      children: [
                        _loanDetailsContent(draggableScrollController),
                        _transactionHistoryContent(draggableScrollController)
                      ],
                    ),
                  )
                ],
              ),
            ),
          ),
        );
      });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.peach,
      body: SafeArea(
        child: Stack(
          children: [
            Container(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  SizedBox(height: toolBarMarginTop + 10),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 17.45),
                    child: Row(
                      children: [
                        Styles.imageButton(
                          padding: EdgeInsets.only(top: 9, right: 9, bottom: 9),
                          color: Colors.transparent,
                          borderRadius: BorderRadius.circular(30),
                          onClick: () => Navigator.of(context).pop(),
                          image: SvgPicture.asset(
                            'res/drawables/ic_back_arrow.svg',
                            fit: BoxFit.contain,
                            width: 19.5,
                            height: 19.02,
                            color: Colors.solidOrange,
                          ),
                        ),
                        SizedBox(width: 10),
                        Text(
                          "Loans",
                          style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w700,
                              color: Colors.textColorBlack),
                        )
                      ],
                    ),
                  ),
                  SizedBox(height: 25),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 17.45),
                    child: Text(
                      "Loan Details",
                      style: getBoldStyle(fontSize: 23),
                    ),
                  ),
                  SizedBox(height: 14),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 17.45),
                    child: Stack(
                      children: [
                        Container(
                          padding: EdgeInsets.only(top: 21, left: 21),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Loan Amount",
                                style: getBoldStyle(
                                    fontWeight: FontWeight.w600,
                                    fontSize: 12.5,
                                    color: Colors.white),
                              ),
                              SizedBox(height: 4),
                              Text(
                                "N 200,394.00",
                                style: getBoldStyle(
                                    fontWeight: FontWeight.w800,
                                    fontSize: 23.5,
                                    color: Colors.white),
                              ),
                              SizedBox(height: 20),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  _columnTile(
                                      text1: "Due Date",
                                      text2: "2nd Jan. 2022"),
                                  SizedBox(width: 40),
                                  _columnTile(
                                      text1: "Outstanding",
                                      text2: "N 150,000,000.00"),
                                  SizedBox(width: 21)
                                ],
                              ),
                              SizedBox(height: 70),
                            ],
                          ),
                          decoration: BoxDecoration(
                            color: Color(0xffDE6F01),
                            borderRadius: BorderRadius.all(
                              Radius.circular(22),
                            ),
                            border: Border.all(
                              width: 1.0,
                              color: Color(0xff063A4F0D).withOpacity(0.05),
                            ),
                          ),
                        ),
                        Positioned(
                            left: 0,
                            right: 0,
                            bottom: 0,
                            child: Container(
                              color: Color(0xffC3690E),
                              height: 45,
                              child: Center(
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 15.0),
                                  child: LinearPercentIndicator(
                                    percent: 0.5,
                                    lineHeight: 8,
                                    backgroundColor:
                                        Color(0xff954A00).withOpacity(0.3),
                                    progressColor: Colors.white,
                                  ),
                                ),
                              ),
                            ))
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Positioned(
              bottom: 0, top: 0, right: 0, left: 0,
              child: _content(context)
            ),
            Positioned(
              bottom: 0,
              right: 0,
              left: 0,
              child: Container(
                padding: EdgeInsets.fromLTRB(20, 16, 20, 25),
                child: Styles.statefulButton(
                    buttonStyle: Styles.primaryButtonStyle.copyWith(
                      backgroundColor:
                          MaterialStateProperty.all(Colors.solidOrange),
                      textStyle: MaterialStateProperty.all(
                        getBoldStyle(
                            fontWeight: FontWeight.w500,
                            fontSize: 16,
                            color: Colors.white),
                      ),
                    ),
                    stream: Stream.value(true),
                    onClick: () {
                      Navigator.pushNamed(context, Routes.LOAN_REPAYMENT);
                    },
                    text: 'Make Repayment'),
                decoration: BoxDecoration(color: Colors.white, boxShadow: [
                  BoxShadow(
                      offset: Offset(0, -9),
                      blurRadius: 21,
                      spreadRadius: 0,
                      color: Colors.loanCardShadowColor.withOpacity(0.1))
                ]),
              ),
            )
          ],
        ),
      ),
    );
  }
}

final mockJson = {
  "accountNumber": null,
  "narration": 'narr_950515950515210908132963_credit',
  "amount": 140.0,
  "type": "CREDIT",
  "transactionDate": "2021-09-08T13:29:41.000+0100",
  "runningBalance": "53070.00",
  "currencyCode": "566",
  "transactionChannel": "POS",
  "balanceBefore": "52930.00",
  "balanceAfter": "53070.00",
  "balanceUpdated": true,
  "transactionRef": 'MPC-ITR-TRF-212908132941GlukCC76dSMZ_credit',
  "transactionCode": null,
  "transactionCategory": "DEFAULT",
  "beneficiaryIdentifier": null,
  "beneficiaryName": null,
  "beneficiaryBankName": null,
  "beneficiaryBankCode": null,
  "senderIdentifier": null,
  "senderName": null,
  "senderBankName": null,
  "senderBankCode": null,
  "providerIdentifier": null,
  "providerName": null,
  "transactionIdentifier": null,
  "merchantLocation": null,
  "cardScheme": null,
  "maskedPan": null,
  "terminalId": null,
  "location": null,
  "disputable": false
};

final data =
    List.generate(20, (index) => AccountTransaction.fromJson(mockJson));
