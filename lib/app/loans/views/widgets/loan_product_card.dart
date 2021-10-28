import 'package:flutter/material.dart' hide Colors;
import 'package:flutter_svg/flutter_svg.dart';
import 'package:moniepoint_flutter/app/loans/views/loans_loan_details_view.dart';
import 'package:moniepoint_flutter/app/loans/views/loans_product_details_view.dart';
import 'package:moniepoint_flutter/app/loans/views/widgets/padded_divider.dart';
import 'package:moniepoint_flutter/core/colors.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';

enum LoanType { salary, shortTerm }
enum LoanState { ready, pending, active, overdue }

class LoanProductCard extends StatelessWidget {
  const LoanProductCard({Key? key, this.loanType = LoanType.shortTerm})
      : super(key: key);

  final LoanType loanType;

  Widget _getDivider() => PaddedDivider(
        top: 9,
        bottom: 10,
        dividerColor: Color(0xff966C2E).withOpacity(0.12),
      );

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

  String getLoanStateDescription(LoanState state) {
    switch (state) {
      case LoanState.ready:
        return "Ready";
      case LoanState.pending:
        return "Pending";
      case LoanState.active:
        return "Active";
      case LoanState.overdue:
        return "Overdue";
    }
  }

  Color getLoanStateColor(LoanState state) {
    switch (state) {
      case LoanState.ready:
        return Colors.deepGrey;
      case LoanState.pending:
        return Colors.solidOrange;
      case LoanState.active:
        return Colors.solidGreen;
      case LoanState.overdue:
        return Colors.red;
    }
  }

  Widget _buildLoanStatePill({required LoanState state}) {
    final String stateDescription = getLoanStateDescription(state);
    final Color stateColor = getLoanStateColor(state);
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

  Widget _buildPendingOrRunningLoanBottomView({required VoidCallback onClick}) {
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
                onPressed: () {
                  onClick();
                },
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
    LoanState state = LoanState.active;
    bool isReadyState = state == LoanState.ready;

    final onClickApply = () {
      Navigator.of(context)
          .push(MaterialPageRoute(builder: (ctx) => LoanProductDetailsView()));
    };

    final onClickView = () {
      Navigator.of(context)
          .push(MaterialPageRoute(builder: (ctx) => LoanDetailsView()));
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
              ? _buildReadyLoanBottomView(text: "Apply", onClick: onClickApply)
              : _buildPendingOrRunningLoanBottomView(onClick: onClickView)
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

  Widget _salaryLoanCard(BuildContext context) {
    LoanState state = LoanState.ready;
    bool isReadyState = state == LoanState.ready;

    final onClickApply = () {
      Navigator.of(context)
        .push(MaterialPageRoute(builder: (ctx) => LoanProductDetailsView()));
    };


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
                        ),
                      ),
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
              child: _buildReadyLoanBottomView(text: "Apply", onClick: () {
                onClickApply();
              }))
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
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return loanType == LoanType.shortTerm
        ? _shortTermLoanCard(context)
        : _salaryLoanCard(context);
  }
}
