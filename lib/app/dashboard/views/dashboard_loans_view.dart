import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart' hide Colors;
import 'package:flutter_svg/flutter_svg.dart';
import 'package:moniepoint_flutter/app/loans/views/loans_product_details_view.dart';
import 'package:moniepoint_flutter/core/colors.dart';
import 'package:moniepoint_flutter/core/styles.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';

import 'dashboard_top_menu.dart';

class LoansView extends StatelessWidget {
  const LoansView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    TextStyle getBoldStyle({
      double fontSize = 24.5,
      Color color = Colors.textColorBlack,
      FontWeight fontWeight = FontWeight.w700,
    }) =>
        TextStyle(fontWeight: fontWeight, color: color, fontSize: fontSize);

    return Scaffold(
      backgroundColor: Color(0xffF8F8F8),
      body: Container(
        padding: EdgeInsets.symmetric(horizontal: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: dashboardTopMenuHeight + 43),
            Text("Loan Product", style: getBoldStyle()),
            SizedBox(height: 30),
            Expanded(
              child: ListView(
                padding: EdgeInsets.zero,
                shrinkWrap: true,
                children: [
                  LoanProductCard(loanType: LoanType.shortTerm),
                  SizedBox(height: 23),
                  LoanProductCard(loanType: LoanType.salary),
                  SizedBox(height: 30),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}

enum LoanType { salary, shortTerm }
enum LoanState { ready, pending, active, overdue }

class LoanProductCard extends StatelessWidget {
  const LoanProductCard({Key? key, this.loanType = LoanType.shortTerm})
      : super(key: key);

  final LoanType loanType;

  Widget _getDivider() => Padding(
      padding: EdgeInsets.only(top: 9, bottom: 10),
      child: Divider(
        thickness: 0.7,
        color: Color(0xff966C2E).withOpacity(0.12),
      ));

  TextStyle getBoldStyle({
    double fontSize = 24.5,
    Color color = Colors.textColorBlack,
    FontWeight fontWeight = FontWeight.w700,
  }) =>
      TextStyle(fontWeight: fontWeight, color: color, fontSize: fontSize);

  TextStyle getNormalStyle({
    double fontSize = 11.5,
    Color color = const Color(0xffA9A5AF),
    FontWeight fontWeight = FontWeight.w400,
  }) =>
      TextStyle(fontWeight: fontWeight, color: color, fontSize: fontSize);

  Widget _buildLoanStatePill({required LoanState state}) {
    late String stateDescription;
    late Color stateColor;

    switch (state) {
      case LoanState.ready:
        stateDescription = "Ready";
        break;
      case LoanState.pending:
        stateDescription = "Pending";
        break;
      case LoanState.active:
        stateDescription = "Active";
        break;
      case LoanState.overdue:
        stateDescription = "Overdue";
        break;
    }

    switch (state) {
      case LoanState.ready:
        stateColor = Colors.deepGrey;
        break;
      case LoanState.pending:
        stateColor = Colors.solidOrange;
        break;
      case LoanState.active:
        stateColor = Colors.solidGreen;
        break;
      case LoanState.overdue:
        stateColor = Colors.red;
        break;
    }

    return Container(
      child: Text(
        stateDescription,
        style: getBoldStyle(fontSize: 10, color: stateColor),
      ),
      padding: EdgeInsets.fromLTRB(12, 5, 10, 5),
      decoration: BoxDecoration(
          color: stateColor.withOpacity(0.15),
          borderRadius: BorderRadius.all(Radius.circular(7.5))),
    );
  }

  Widget _buildShortTermLoanTopView({required LoanState state}) {
    return Row(
      children: [
        Stack(
          children: [
            Align(
              child: SvgPicture.asset("res/drawables/ic_squircle_bg.svg",
                  color: Colors.solidOrange),
            ),
            Positioned.fill(
              child: Align(
                child: Container(
                  child: SvgPicture.asset("res/drawables/ic_loan_product.svg"),
                ),
              ),
            )
          ],
        ),
        SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Text(
                "Short-term Loan",
                style: getBoldStyle(fontSize: 14.5),
              ),
              SizedBox(height: 4),
              Text('Lorem ipsum shalaye', style: getNormalStyle())
            ],
          ),
        ),
        SizedBox(width: 6),
        _buildLoanStatePill(state: state)
      ],
    );
  }

  Widget _buildReadyLoanBottomView(
      {required String text, required VoidCallback onClick}) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Row(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("Get up to", style: getNormalStyle()),
                  SizedBox(height: 5),
                  Text("N 150,000.00", style: getBoldStyle(fontSize: 16.5))
                ],
              ),
              SizedBox(width: 48),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("Min. Interest", style: getNormalStyle()),
                  SizedBox(height: 5),
                  Text("5.25%", style: getBoldStyle(fontSize: 16.5))
                ],
              ),
            ],
          ),
        ),
        SizedBox(width: 31),
        _textButton(
            text: "Apply",
            onClick: () {
              onClick();
            })
      ],
    );
  }

  Widget _textButton({required String text, required VoidCallback onClick}) {
    return TextButton(
      child: Text(text, style: getBoldStyle(color: Colors.white, fontSize: 12)),
      style: TextButton.styleFrom(backgroundColor: Colors.solidOrange),
      onPressed: () {
        onClick();
      },
    );
  }

  Widget _labelAndText({required String label, required String text}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: getNormalStyle(fontSize: 12)),
        SizedBox(height: 5),
        Text(text, style: getBoldStyle(fontSize: 13.38)),
      ],
    );
  }

  Widget _buildRunningLoanBottomView() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.fromLTRB(16, 0, 17, 0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("Outstanding", style: getNormalStyle(fontSize: 12)),
              SizedBox(height: 5),
              Text("N 50,000.00", style: getBoldStyle(fontSize: 17)),
              SizedBox(height: 10),
              Row(
                children: [
                  _labelAndText(label: "Loan Amount", text: "N 50,000.00"),
                  SizedBox(width: 48),
                  _labelAndText(label: "Due Date", text: "2nd Jan. 2022 ")
                ],
              ),
              SizedBox(height: 14.2),
            ],
          ),
        ),
        Container(
          padding: EdgeInsets.fromLTRB(16, 4.5, 21, 10),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Repayment Progress",
                      style: getNormalStyle(fontSize: 12),
                    ),
                    SizedBox(height: 10),
                    LinearPercentIndicator(
                      padding: EdgeInsets.zero,
                      percent: 0.7,
                      lineHeight: 8,
                      linearStrokeCap: LinearStrokeCap.roundAll,
                      progressColor: Colors.solidOrange,
                      backgroundColor: Color(0xffEAE6E1),
                    ),
                  ],
                ),
              ),
              SizedBox(width: 31),
              TextButton(
                child: Text(
                  "View Details",
                  style: getNormalStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 14.5,
                      color: Colors.solidOrange),
                ),
                style: TextButton.styleFrom(),
                onPressed: () {},
              ),
            ],
          ),
          decoration: BoxDecoration(
              color: Colors.solidOrange.withOpacity(0.08),
              borderRadius: BorderRadius.vertical(bottom: Radius.circular(16)),
              border: Border.all(
                  color: Color(0xffB1881E).withOpacity(0.1), width: 0.7)),
        )
      ],
    );
  }

  Widget _shortTermLoanCard(BuildContext context) {
    LoanState state = LoanState.ready;
    bool isReadyState = state == LoanState.ready;

    final onClick = () {
      Navigator.of(context)
          .push(MaterialPageRoute(builder: (ctx) => LoanProductDetailsView()));
    };

    final padding = EdgeInsets.fromLTRB(16, 15, 17, 15);
    final runningLoanPadding = EdgeInsets.fromLTRB(16, 0, 17, 0);

    return Container(
      padding: isReadyState ? padding : EdgeInsets.only(top: 15),
      child: Column(
        children: [
          Padding(
            padding: isReadyState ? EdgeInsets.zero : runningLoanPadding,
            child: _buildShortTermLoanTopView(state: state),
          ),
          _getDivider(),
          isReadyState
              ? _buildReadyLoanBottomView(text: "Apply", onClick: onClick)
              : _buildRunningLoanBottomView()
        ],
      ),
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.all(Radius.circular(16)),
          border:
              Border.all(color: Color(0xffB1881E).withOpacity(0.1), width: 0.7),
          boxShadow: [
            BoxShadow(
                offset: Offset(0, 1),
                blurRadius: 2,
                color: Color(0xff165B1D).withOpacity(0.1))
          ]),
    );
  }

  Widget _salaryLoanCard() {

    LoanState state = LoanState.ready;
    bool isReadyState = state == LoanState.ready;

    return Container(
      padding: EdgeInsets.only(bottom: 15),
      child: Column(
        children: [
          Stack(
            clipBehavior: Clip.none,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
                child: Image.asset("res/drawables/hd_image.jpg",
                    height: 110, width: double.infinity, fit: BoxFit.cover),
              ),
              Positioned(
                left: 8,
                top: 80,
                child: Image.asset("res/drawables/ic_m_salary_loan.png"),
              )
            ],
          ),
          Padding(
            padding: const EdgeInsets.only(right: 17, top: 14),
            child: Row(
              children: [
                SizedBox(width: 74),
                Expanded(
                  child: Row(
                    children: [
                      Expanded(
                          child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text("Salary Advance",
                              style: getBoldStyle(fontSize: 14)),
                          SizedBox(height: 1),
                          Text("Lorem ipsum shalaye",
                              style: getNormalStyle(fontSize: 11))
                        ],
                      )),
                      _buildLoanStatePill(state: state)
                    ],
                  ),
                )
              ],
            ),
          ),
          _getDivider(),
          Padding(
              padding: EdgeInsets.only(left: 18, right: 15),
              child: _buildReadyLoanBottomView(text: "Apply", onClick: () {}))
        ],
      ),
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.all(Radius.circular(16)),
          border:
              Border.all(color: Color(0xffB1881E).withOpacity(0.1), width: 0.7),
          boxShadow: [
            BoxShadow(
                offset: Offset(0, 1),
                blurRadius: 2,
                color: Color(0xff165B1D).withOpacity(0.1))
          ]),
    );
  }

  @override
  Widget build(BuildContext context) {
    return loanType == LoanType.shortTerm
        ? _shortTermLoanCard(context)
        : _salaryLoanCard();
  }
}

class LoansComingSoonView extends StatelessWidget {
  const LoansComingSoonView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height; // - bottomAppBarHeight;
    final width = MediaQuery.of(context).size.width;
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16),
      width: MediaQuery.of(context).size.width,
      color: Color(0XFFFAF5EB),
      child: Container(
        height: height,
        margin: EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(height: dashboardTopMenuHeight),
            Expanded(
                child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                LayoutBuilder(
                  builder: (ctx, constraints) {
                    return Stack(
                      overflow: Overflow.visible,
                      children: [
                        Container(
                          padding: EdgeInsets.symmetric(horizontal: 24),
                          decoration: BoxDecoration(
                              color: Color(0xFFF08922).withOpacity(0.1),
                              borderRadius:
                                  BorderRadius.all(Radius.circular(17.8)),
                              boxShadow: [
                                BoxShadow(
                                    color: Color(0xff1F0E4FB).withOpacity(0.12),
                                    offset: Offset(0, 1.12),
                                    blurRadius: 2.23)
                              ]),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              SizedBox(height: 90),
                              Text(
                                'Quick Cash?\nLook no further',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    color: Color(0xFFF08922),
                                    fontWeight: FontWeight.w700,
                                    fontSize: 19.5),
                              ),
                              SizedBox(
                                height: 11,
                              ),
                              Text(
                                'Get a loan in under 5 minutes with\nMoniepoint',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  color: Colors.textColorBlack,
                                  fontWeight: FontWeight.w500,
                                  fontSize: 14,
                                ),
                              ),
                              SizedBox(
                                height: 11,
                              ),
                              Container(
                                padding: EdgeInsets.symmetric(
                                    horizontal: 45, vertical: 10),
                                decoration: BoxDecoration(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(4.0)),
                                  color: Color(0xff7A6A57).withOpacity(0.31),
                                ),
                                child: Text("Coming Soon",
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                        color: Color(0xff8C7E69),
                                        fontSize: 16,
                                        fontWeight: FontWeight.w500)),
                              ),
                              SizedBox(
                                height: 30,
                              ),
                            ],
                          ),
                        ),
                        Positioned(
                          top: -49,
                          left: 0,
                          right: 27,
                          child: Container(
                            child: Image.asset(
                              "res/drawables/ic_loans_calendar.png",
                              height: 165,
                              width: 165,
                            ),
                          ),
                        )
                      ],
                    );
                  },
                ),
              ],
            )),
          ],
        ),
      ),
    );
  }
}
