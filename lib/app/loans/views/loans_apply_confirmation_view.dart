import 'package:flutter/material.dart' hide Colors;
import 'package:flutter_svg/flutter_svg.dart';
import 'package:moniepoint_flutter/app/savings/savings_success_view.dart';
import 'package:moniepoint_flutter/core/colors.dart';
import 'package:moniepoint_flutter/core/extensions/strings.dart';
import 'package:moniepoint_flutter/core/routes.dart';
import 'package:moniepoint_flutter/core/styles.dart';
import 'package:moniepoint_flutter/core/extensions/text_utils.dart';

import 'loans_product_details_view.dart';

class LoansApplicationConfirmationView extends StatelessWidget {
  const LoansApplicationConfirmationView({Key? key}) : super(key: key);

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

  Widget _getDivider({double? topMargin, double? bottomMargin}) => Padding(
      padding: EdgeInsets.only(top: topMargin ?? 6, bottom: bottomMargin ?? 11),
      child: Divider(
        thickness: 0.7,
        color: Color(0xff966C2E).withOpacity(0.12),
      ));

  Widget _tile({required String title, required String subtitle}) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 23),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: getNormalStyle(fontSize: 14.5)),
          SizedBox(height: 5),
          Text(subtitle, style: getBoldStyle(fontSize: 19.5))
        ],
      ),
    );
  }

  Widget getAccountCardIcon(String name) {
    final color = Colors.solidOrange;
    return Stack(
      clipBehavior: Clip.none,
      children: [
        SvgPicture.asset(
          "res/drawables/ic_m_bg.svg",
          fit: BoxFit.cover,
          height: 45,
          width: 45,
          color: color.withOpacity(0.11),
        ),
        Container(
          height: 45,
          width: 45,
          child: Material(
            borderRadius: BorderRadius.circular(17),
            color: Colors.transparent,
            child: InkWell(
              borderRadius: BorderRadius.circular(17),
              overlayColor: MaterialStateProperty.all(color.withOpacity(0.1)),
              highlightColor: color.withOpacity(0.05),
              // onTap: () => _onItemClicked(context, beneficiary),
              child: Center(
                child: Text(
                  name.abbreviate(2, true, includeMidDot: false),
                  style: TextStyle(
                      fontSize: 16, fontWeight: FontWeight.w700, color: color),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget accountTile() {
    return Container(
      padding: EdgeInsets.fromLTRB(11.87, 14.25, 0, 14.17),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.all(Radius.circular(8)),
        border: Border.all(
          width: 0.7,
          color: Color(0xff4A7BC7).withOpacity(0.15),
        ),
        boxShadow: [
          BoxShadow(
              offset: Offset(0, 1),
              blurRadius: 1,
              color: Color(0xff0649AF).withOpacity(0.06)),
        ],
      ),
      child: Row(
        children: [
          Flexible(
              child: getAccountCardIcon("Leslie Tobechukwu Isah"), flex: 0),
          SizedBox(width: 17),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("Leslie Tobechukwu Isah",
                    style: getBoldStyle(fontSize: 14.5)),
                SizedBox(height: 1),
                Text(
                  "0011357716",
                  style: getNormalStyle(fontSize: 12.5),
                )
              ],
            ),
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: false,
        titleSpacing: 0,
        iconTheme: IconThemeData(color: Colors.solidOrange),
        title: Text(
          'Loans',
          textAlign: TextAlign.start,
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w700,
            color: Colors.textColorBlack,
          ),
        ),
        backgroundColor: Colors.backgroundWhite,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 21.34),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 35),
              Text(
                "Confirmation",
                style: getBoldStyle(fontSize: 23),
              ),
              SizedBox(height: 29),
              Container(
                padding: EdgeInsets.only(top: 22, bottom: 25),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _tile(title: "Loan Amount", subtitle: "N 7,000.00"),
                    _getDivider(),
                    Row(
                      children: [
                        Expanded(
                          child: _tile(
                              title: "Interest Amount", subtitle: "N 5,000.00"),
                        ),
                        Expanded(
                          child: _tile(title: "Interest Rate", subtitle: "0%"),
                        ),
                      ],
                    ),
                    _getDivider(),
                    Row(
                      children: [
                        Expanded(
                          child: _tile(title: "Tenor", subtitle: "15 days"),
                        ),
                        Expanded(
                          child: _tile(
                              title: "Due Date", subtitle: "12. Jan. 2021"),
                        ),
                      ],
                    ),
                    _getDivider(),
                    _tile(title: "Total Repayment", subtitle: "N 5,000.00"),
                    _getDivider(),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 23),
                      child: Text(
                        "Payout Account",
                        style: getNormalStyle(fontSize: 14.5),
                      ),
                    ),
                    SizedBox(height: 10),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 23.0),
                      child: accountTile(),
                    ),
                    SizedBox(height: 22),
                    Container(
                      padding:
                          EdgeInsets.symmetric(horizontal: 14, vertical: 17),
                      margin: const EdgeInsets.symmetric(horizontal: 13),
                      child: InfoBannerContent(
                        rightSpace: 16,
                        title: "Penalty",
                        subtitle: "A fee of x Naira will be added to the total "
                            "outstanding balance for each day the repayment is late",
                        svgPath: "res/drawables/ic_savings_warning.svg",
                      ),
                      decoration: BoxDecoration(
                          color: Color(0xff244528).withOpacity(0.05),
                          borderRadius: BorderRadius.all(Radius.circular(8))),
                    ),
                    SizedBox(height: 21),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
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
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (ctx) => SavingsSucessView(
                                  primaryText:
                                      'Loan Request\nawaiting approval',
                                  secondaryText:
                                      'The loan request has been submitted for approval. Expect a decision very shortly',
                                  primaryButtonText: 'Continue',
                                  primaryButtonAction: () {
                                    Navigator.popUntil(context,
                                        ModalRoute.withName(Routes.DASHBOARD));
                                  },
                                ),
                              ),
                            );
                          },
                          text: 'Complete Loan Request'),
                    )
                  ],
                ),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.all(Radius.circular(8)),
                  border: Border.all(
                    width: 0.7,
                    color: Color(0xff4A7BC7).withOpacity(0.15),
                  ),
                  boxShadow: [
                    BoxShadow(
                        offset: Offset(0, 1),
                        blurRadius: 1,
                        color: Color(0xff0649AF).withOpacity(0.06)),
                  ],
                ),
              ),
              SizedBox(height: 100),
            ],
          ),
        ),
      ),
    );
  }
}
