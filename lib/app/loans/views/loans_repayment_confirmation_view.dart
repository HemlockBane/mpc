import 'package:flutter/material.dart' hide Colors;
import 'package:flutter_svg/flutter_svg.dart';
import 'package:moniepoint_flutter/app/loans/models/loan_repayment_confirmation.dart';
import 'package:moniepoint_flutter/app/loans/models/short_term_loan_details.dart';
import 'package:moniepoint_flutter/app/loans/viewmodels/loan_repayment_view_model.dart';
import 'package:moniepoint_flutter/app/loans/views/widgets/info_banner_content.dart';
import 'package:moniepoint_flutter/app/loans/views/widgets/loan_confirmation_account_tile.dart';
import 'package:moniepoint_flutter/app/loans/views/widgets/loan_confirmation_detail_tile.dart';
import 'package:moniepoint_flutter/app/loans/views/widgets/padded_divider.dart';
import 'package:moniepoint_flutter/app/savings/savings_success_view.dart';
import 'package:moniepoint_flutter/core/colors.dart';
import 'package:moniepoint_flutter/core/routes.dart';
import 'package:moniepoint_flutter/core/styles.dart';
import 'package:moniepoint_flutter/core/utils/currency_util.dart';
import 'package:provider/provider.dart';


import 'loans_advert_details_view.dart';

class LoanRepaymentConfirmationView extends StatelessWidget {
  const LoanRepaymentConfirmationView({Key? key, required this.confirmation}) : super(key: key);
   final LoanRepaymentConfirmation? confirmation;


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

    final viewModel = Provider.of<LoanRepaymentViewModel>(context);

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
                "Loan Confirmation",
                style: getBoldStyle(fontSize: 23),
              ),
              SizedBox(height: 29),
              Container(
                padding: EdgeInsets.only(top: 22, bottom: 25),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    LoanConfirmationDetailTile(
                        title: "Amount to Repay", subtitle: "${confirmation?.repaymentAmount?.formatCurrency}"),
                    PaddedDivider(),
                    Row(
                      children: [
                        if (confirmation?.loanDetails?.outstandingAmount != null)
                          Expanded(
                          child: LoanConfirmationDetailTile(
                              title: "Outstanding", subtitle: "${confirmation?.loanDetails?.outstandingAmount?.formatCurrency}"),
                        ),
                        if (confirmation?.loanDetails?.loanAmount != null)
                        Expanded(
                          child: LoanConfirmationDetailTile(
                              title: "Amount Loaned", subtitle: "${confirmation?.loanDetails?.loanAmount?.formatCurrency}"),
                        ),
                      ],
                    ),
                    PaddedDivider(),
                    LoanConfirmationDetailTile(
                      title: "Interest Rate",
                      subtitle: "${confirmation?.loanDetails?.interestRate}%",
                    ),
                    PaddedDivider(),
                    if (viewModel.isValidAccount(confirmation?.loanDetails?.repaymentAccountNumber))
                      Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 23),
                      child: Text(
                        "Payout Account",
                        style: getNormalStyle(fontSize: 14.5),
                      ),
                    ),
                    if (viewModel.isValidAccount(confirmation?.loanDetails?.repaymentAccountNumber))
                      SizedBox(height: 10),
                    if (viewModel.isValidAccount(confirmation?.loanDetails?.repaymentAccountNumber))
                      ConfirmationAccountTile(
                        padding: EdgeInsets.symmetric(horizontal: 20),
                        accountName: "${viewModel.getAccountName(confirmation?.loanDetails?.repaymentAccountNumber)}",
                        accountNumber: "${viewModel.getAccountNumber(confirmation?.loanDetails?.repaymentAccountNumber)}",
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
                    bool isFullRepayment = true;

                    final primaryText = isFullRepayment
                        ? "Loan has been repaid!"
                        : "Loan has been partly repaid";
                    final secondaryText =
                        "The loan request has been submitted for approval. Expect a decision very shortly";

                    final successView = SavingsSucessView(
                      primaryText: primaryText,
                      secondaryText: secondaryText,
                      primaryButtonText: 'Continue',
                      primaryButtonAction: () {
                        Navigator.popUntil(
                            context, ModalRoute.withName(Routes.DASHBOARD));
                      },
                    );

                    Navigator.of(context).push(
                      MaterialPageRoute(builder: (ctx) => successView),
                    );
                  },
                  text: 'Complete Loan Repayment'),
              SizedBox(height: 100),
            ],
          ),
        ),
      ),
    );
  }
}
