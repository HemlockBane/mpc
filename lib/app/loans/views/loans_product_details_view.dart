import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart' hide Colors;
import 'package:flutter_svg/flutter_svg.dart';
import 'package:moniepoint_flutter/app/loans/views/loans_loan_application_view.dart';
import 'package:moniepoint_flutter/app/loans/views/widgets/info_banner_content.dart';
import 'package:moniepoint_flutter/app/loans/views/widgets/interest_rate_banner.dart';
import 'package:moniepoint_flutter/core/colors.dart';
import 'package:moniepoint_flutter/core/styles.dart';
import 'package:moniepoint_flutter/core/views/custom_check_box.dart';

const double toolBarMarginTop = 37;
const double maxDraggableTop = toolBarMarginTop * 5 + 26;
const String loremIpsum =
    "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua";

class LoanProductDetailsView extends StatelessWidget {
  const LoanProductDetailsView({Key? key}) : super(key: key);

  TextStyle getBoldStyle(
          {double fontSize = 32.5,
          Color color = Colors.textColorBlack,
          FontWeight fontWeight = FontWeight.w700}) =>
      TextStyle(fontWeight: fontWeight, fontSize: fontSize, color: color);

  TextStyle getNormalStyle(
          {double fontSize = 32.5,
          Color color = Colors.white,
          FontWeight fontWeight = FontWeight.w400}) =>
      TextStyle(fontWeight: fontWeight, fontSize: fontSize, color: color);

  Widget getSuccessContent() {
    return Container(
      padding: EdgeInsets.only(top: 19, bottom: 22, left: 21, right: 21),
      decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.19),
          borderRadius: BorderRadius.all(Radius.circular(8.0))),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            "Your Flex Savings Acc. No.",
            style: getNormalStyle(fontSize: 14),
          ),
          SizedBox(height: 3),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "0011357716",
                style: getBoldStyle(fontSize: 24, color: Colors.white),
              ),
              Row(
                children: [
                  SvgPicture.asset("res/drawables/ic_copy_2.svg"),
                  SizedBox(width: 7),
                  Text(
                    "Copy",
                    style: getNormalStyle(fontSize: 15),
                  )
                ],
              )
            ],
          )
        ],
      ),
    );
  }

  Widget _content(context) {
    final screenSize = MediaQuery.of(context).size;
    final maxExtent = 0.81;
    final containerHeight = 1;
    final minExtent = 0.63;
    // TODO: Ask @Paul to explain this minExtent to me
    // final minExtent = 1 - (containerHeight / (screenSize.height - maxDraggableTop));
    return DraggableScrollableSheet(
        maxChildSize: maxExtent,
        minChildSize: minExtent,
        initialChildSize: minExtent,
        builder: (ctx, ScrollController draggableScrollController) {
          return Container(
            padding: EdgeInsets.only(top: 21, left: 23, right: 23),
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
            child: ListView(
              controller: draggableScrollController,
              padding: EdgeInsets.zero,
              children: [
                Text(
                  "Short-term \nLoans",
                  style: getBoldStyle(),
                ),
                SizedBox(height: 16),
                Text(loremIpsum,
                    style: TextStyle(
                        fontWeight: FontWeight.w400,
                        fontSize: 14.5,
                        height: 1.5,
                        color: Colors.textColorBlack)),
                SizedBox(height: 24),
                InterestRateBanner(
                  title: "as low as",
                  interestRate: "10.25",
                  subtitle: "interest rate",
                ),
                SizedBox(height: 24),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 14, vertical: 17),
                  child: InfoBannerContent(
                      title: "Penalty",
                      subtitle:
                          "2% penalty on the interest for premature/unplanned withdrawals",
                      svgPath: "res/drawables/ic_savings_warning.svg"),
                  decoration: BoxDecoration(
                      color: Color(0xff244528).withOpacity(0.05),
                      borderRadius: BorderRadius.all(Radius.circular(8))),
                ),
                SizedBox(height: 38),
                Container(
                  padding: EdgeInsets.only(left: 18, top: 21, bottom: 14),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Eligibilty Check',
                        style: getBoldStyle(fontSize: 17),
                      ),
                      SizedBox(height: 13),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SvgPicture.asset(
                              "res/drawables/ic_check_mark_round_alt.svg",
                              height: 25.83,
                              width: 25.83),
                          SizedBox(width: 11),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                RichText(
                                  text: TextSpan(children: [
                                    TextSpan(
                                      text: 'You’re eligible to take a loan of',
                                      style: getNormalStyle(
                                              fontSize: 15,
                                              color: Colors.textColorBlack)
                                          .copyWith(height: 1.3),
                                    ),
                                    TextSpan(
                                      text: '\nN 500,000.00',
                                      style: getBoldStyle(
                                          fontSize: 15,
                                          color: Colors.textColorBlack),
                                    ),
                                    TextSpan(
                                      text: ' from us. Apply now',
                                      style: getNormalStyle(
                                          fontSize: 15,
                                          color: Colors.textColorBlack),
                                    )
                                  ]),
                                ),
                                SizedBox(height: 5),
                              ],
                            ),
                          ),
                          SizedBox(width: 30),
                        ],
                      )
                    ],
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.all(Radius.circular(16)),
                    border: Border.all(color: Color(0xff1A1C9328), width: 0.7),
                    boxShadow: [
                      BoxShadow(
                        offset: Offset(0, 1),
                        blurRadius: 2,
                        color: Colors.loanCardShadowColor.withOpacity(0.1),
                      )
                    ],
                  ),
                ),
                SizedBox(height: 38),
                Styles.statefulButton(
                  buttonStyle: Styles.primaryButtonStyle.copyWith(
                      backgroundColor:
                          MaterialStateProperty.all(Colors.solidOrange),
                      textStyle: MaterialStateProperty.all(getBoldStyle(
                          fontWeight: FontWeight.w500,
                          fontSize: 16,
                          color: Colors.white))),
                  stream: Stream.value(true),
                  onClick: () {
                    Navigator.of(context).push(
                        MaterialPageRoute(builder: (ctx) => LoanApplicationView()));
                  },
                  text: 'View Loan Offers',
                ),
                SizedBox(height: 38 + 31.5),
              ],
            ),
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.peach,
      body: Stack(
        children: [
          Positioned(
            top: toolBarMarginTop + 10,
            left: 0,
            right: 0,
            child: Container(
              margin: EdgeInsets.symmetric(horizontal: 16),
              child: Row(
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
                      color: Colors.textColorBlack,
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
          ),
          Positioned(
            top: 43,
            right: 0,
            child: Image.asset('res/drawables/savings_flex_bg.png'),
          ),
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            bottom: 0,
            child: _content(context),
          )
        ],
      ),
    );
  }
}