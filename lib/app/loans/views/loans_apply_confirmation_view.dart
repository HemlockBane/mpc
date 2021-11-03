import 'package:flutter/material.dart' hide Colors;
import 'package:flutter_svg/flutter_svg.dart';
import 'package:moniepoint_flutter/app/loans/views/widgets/info_banner_content.dart';
import 'package:moniepoint_flutter/app/loans/views/widgets/loan_confirmation_account_tile.dart';
import 'package:moniepoint_flutter/app/loans/views/widgets/loan_confirmation_detail_tile.dart';
import 'package:moniepoint_flutter/app/loans/views/widgets/padded_divider.dart';
import 'package:moniepoint_flutter/app/savings/savings_success_view.dart';
import 'package:moniepoint_flutter/core/colors.dart';
import 'package:moniepoint_flutter/core/routes.dart';
import 'package:moniepoint_flutter/core/styles.dart';

import 'loans_advert_details_view.dart';

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
              Container(
                width: 70,
                height: 70,
                decoration: BoxDecoration(
                  color: Colors.solidOrange.withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: SvgPicture.asset(
                  'res/drawables/ic_info_italic.svg',
                  color: Colors.solidOrange,
                  width: 40,
                  height: 40,
                ),
                padding: EdgeInsets.all(15),
                margin: EdgeInsets.only(top: 10),
              ),
              SizedBox(height: 19),
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
                    LoanConfirmationDetailTile(
                        title: "Loan Amount", subtitle: "N 7,000.00"),
                    PaddedDivider(),
                    Row(
                      children: [
                        Expanded(
                          child: LoanConfirmationDetailTile(
                              title: "Interest Amount", subtitle: "N 5,000.00"),
                        ),
                        Expanded(
                          child: LoanConfirmationDetailTile(
                              title: "Interest Rate", subtitle: "0%"),
                        ),
                      ],
                    ),
                    PaddedDivider(),
                    Row(
                      children: [
                        Expanded(
                          child: LoanConfirmationDetailTile(
                              title: "Tenor", subtitle: "15 days"),
                        ),
                        Expanded(
                          child: LoanConfirmationDetailTile(
                              title: "Due Date", subtitle: "12. Jan. 2021"),
                        ),
                      ],
                    ),
                    PaddedDivider(),
                    LoanConfirmationDetailTile(
                        title: "Total Repayment", subtitle: "N 5,000.00"),
                    PaddedDivider(),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 23),
                      child: Text(
                        "Payout Account",
                        style: getNormalStyle(fontSize: 14.5),
                      ),
                    ),
                    SizedBox(height: 10),
                    ConfirmationAccountTile(
                      accountName: "Leslie Tobechukwu Isah",
                      accountNumber: "0011357716",
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
                  ],
                ),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.all(Radius.circular(8)),
                  border: Border.all(
                    width: 0.7,
                    color: Colors.loanCardShadowColor.withOpacity(0.15),
                  ),
                  boxShadow: [
                    BoxShadow(
                        offset: Offset(0, 1),
                        blurRadius: 1,
                        color: Colors.loanCardShadowColor.withOpacity(0.1)),
                  ],
                ),
              ),
              SizedBox(height: 21),
              Styles.statefulButton(
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
                          primaryText: 'Loan Request\nawaiting approval',
                          secondaryText:
                              'The loan request has been submitted for approval. Expect a decision very shortly',
                          primaryButtonText: 'Continue',
                          primaryButtonAction: () {
                            Navigator.popUntil(context, ModalRoute.withName(Routes.DASHBOARD));
                          },
                        ),
                      ),
                    );
                  },
                  text: 'Complete Loan Request'),
              SizedBox(height: 100),
            ],
          ),
        ),
      ),
    );
  }
}
