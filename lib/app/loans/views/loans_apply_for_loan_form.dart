import 'package:moniepoint_flutter/app/accountupdates/views/forms/account_update_form_view.dart';
import 'package:moniepoint_flutter/app/loans/viewmodels/loan_request_viewmodel.dart';
import 'package:flutter/material.dart' hide Colors;
import 'package:moniepoint_flutter/app/loans/views/loans_apply_confirmation_view.dart';
import 'package:moniepoint_flutter/app/loans/views/widgets/info_banner_content.dart';
import 'package:moniepoint_flutter/core/colors.dart';
import 'package:moniepoint_flutter/core/styles.dart';
import 'package:moniepoint_flutter/core/views/payment_amount_view.dart';
import 'package:moniepoint_flutter/core/views/transaction_account_source.dart';
import 'package:provider/provider.dart';
import 'package:moniepoint_flutter/core/utils/currency_util.dart';


class ApplyForLoanView extends PagedForm {
  @override
  _ApplyForLoanViewState createState() => _ApplyForLoanViewState();

  @override
  String getTitle() => "ApplyForLoanView";
}

class _ApplyForLoanViewState extends State<ApplyForLoanView>{
  late final LoanRequestViewModel _viewModel;
  bool _isSelected = true;
  double _amount = 0.00;

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

  Widget _getDivider({double? topMargin, double? bottomMargin}) => Padding(
      padding: EdgeInsets.only(top: topMargin ?? 6, bottom: bottomMargin ?? 11),
      child: Divider(
        thickness: 0.7,
        color: Color(0xff966C2E).withOpacity(0.12),
      ));

  Widget amountWidget() {
    final viewModel = Provider.of<LoanRequestViewModel>(context, listen: false);
    viewModel.setAmount(this._amount);
    return Container(
      padding: EdgeInsets.only(left: 14, right: 14, top: 26, bottom: 12),
      decoration: BoxDecoration(
          color: Color(0xffE9ECF0),
          borderRadius: BorderRadius.all(Radius.circular(8))),
      child: Column(
        children: [
          PaymentAmountView(
            (_amount * 100).toInt(),
            (value) {
              print("on changed: ${value / 100}");
              this._amount = value / 100;
              viewModel.setAmount(_amount);
              viewModel.calculateInterestRate(_amount);
            },
            maxAmount: viewModel.selectedLoanOffer.maximumAmount?.toDouble(),
            currencyColor: Color(0xffC1C2C5).withOpacity(0.5),
            textColor: Colors.textColorBlack,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Text(
                "Max Amount",
                style: getNormalStyle(color: Color(0xffA9A5AF), fontSize: 12),
              ),
              SizedBox(width: 10),
              Text(
                  "N ${viewModel.selectedLoanOffer.maximumAmount?.toDouble()}",
                  style: getNormalStyle(color: Color(0xffA9A5AF), fontSize: 12))
            ],
          )
        ],
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    print("initState");
    _viewModel = Provider.of<LoanRequestViewModel>(context, listen: false);
    refreshAccounts();
  }


  void refreshAccounts() {
    if (_viewModel.userAccounts.length > 1)
      _viewModel.getUserAccountsBalance().listen((event) {});
    else
      _viewModel.getCustomerAccountBalance().listen((event) {});
  }


  @override
  Widget build(BuildContext context) {
    final viewModel = Provider.of<LoanRequestViewModel>(context, listen: false);
    print("build");
    print("selected loan offer in view ${viewModel.selectedLoanOffer.toJson()}");
    return SingleChildScrollView(
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 18),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Apply for Starter Loan",
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.w700),
            ),
            SizedBox(height: 33),
            Text(
              "How much would you like to borrow?",
              style: getNormalStyle(
                fontSize: 15.5,
                fontWeight: FontWeight.w500,
                color: Colors.textColorMainBlack,
              ),
            ),
            SizedBox(height: 13),
            // amountWidget(),
            TextField(),
            SizedBox(height: 32),
            Container(
              padding: EdgeInsets.fromLTRB(15, 15, 30, 17.25),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("Rate", style: getNormalStyle(fontSize: 12.5)),
                      SizedBox(height: 5),
                      Text("${viewModel.selectedLoanOffer.minInterestRate}%",
                          style: getBoldStyle(fontSize: 13.5))
                    ],
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("Tenor", style: getNormalStyle(fontSize: 12.5)),
                      SizedBox(height: 5),
                      Text("${viewModel.selectedLoanOffer.maxPeriod} days",
                          style: getBoldStyle(fontSize: 13.5))
                    ],
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("Interest", style: getNormalStyle(fontSize: 12.5)),
                      SizedBox(height: 5),
                      StreamBuilder(
                          initialData: 0.00,
                          stream: viewModel.interestStream,
                          builder: (ctx, AsyncSnapshot<double> snapshot) {
                            return Text(
                              "${snapshot.data?.formatCurrency}",
                              style: getBoldStyle(
                                fontSize: 13.5,
                              ),
                            );
                          })
                    ],
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
            SizedBox(height: 32),
            Text(
              "Select payout Account",
              style: getNormalStyle(
                fontSize: 15.5,
                fontWeight: FontWeight.w500,
                color: Colors.textColorMainBlack,
              ),
            ),
            SizedBox(height: 12),
            TransactionAccountSource(
              _viewModel,
              primaryColor: Colors.solidOrange,
              titleStyle: TextStyle(
                  fontSize: 15,
                  color: Colors.textColorBlack,
                  fontWeight: FontWeight.bold),
              checkBoxSize: Size(40, 40),
              listStyle: ListStyle.alternate,
              checkBoxPadding: EdgeInsets.all(6.0),
              checkBoxBorderColor: Color(0xffA6B6CE).withOpacity(0.95),
              isShowTrailingWhenExpanded: false,
            ),
            SizedBox(height: 16.4),
            SwitchListTile(
              contentPadding: EdgeInsets.zero,
              title: Text(
                "Use same account for repayment",
                style: getNormalStyle(
                  fontSize: 15.5,
                  fontWeight: FontWeight.w500,
                  color: Colors.textColorMainBlack,
                ),
              ),
              value: _viewModel.usePayoutAccountForRepayment,
              onChanged: (value) {
                if (!_viewModel.usePayoutAccountForRepayment) refreshAccounts();

                setState(() {
                  _viewModel.setSwitchState(value);
                });
              },
              activeColor: Colors.solidOrange,
              activeTrackColor: Color(0xffD1CFD3),
              inactiveTrackColor: Color(0xffD1CFD3),
              inactiveThumbColor: Colors.white,
            ),
            if (!_viewModel.usePayoutAccountForRepayment)
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 17),
                child: _getDivider(topMargin: 10, bottomMargin: 28),
              ),
            if (!_viewModel.usePayoutAccountForRepayment)
              Text(
                "Select repayment Account",
                style: getNormalStyle(
                  fontSize: 15.5,
                  fontWeight: FontWeight.w500,
                  color: Colors.textColorMainBlack,
                ),
              ),
            if (!_viewModel.usePayoutAccountForRepayment) SizedBox(height: 12),
            if (!_viewModel.usePayoutAccountForRepayment)
              TransactionAccountSource(
                _viewModel,
                primaryColor: Colors.solidOrange,
                titleStyle: TextStyle(
                    fontSize: 15,
                    color: Colors.textColorBlack,
                    fontWeight: FontWeight.bold),
                checkBoxSize: Size(40, 40),
                listStyle: ListStyle.alternate,
                checkBoxPadding: EdgeInsets.all(6.0),
                checkBoxBorderColor: Color(0xffA6B6CE).withOpacity(0.95),
                isShowTrailingWhenExpanded: false,
              ),
            SizedBox(height: !_isSelected ? 25 : 15),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 14, vertical: 17),
              child: InfoBannerContent(
                  rightSpace: 100,
                  subtitleWidget: RichText(
                      text: TextSpan(style: TextStyle(height: 1.4), children: [
                    TextSpan(
                        text: "By tapping ",
                        style: getNormalStyle(
                            fontSize: 12.5, color: Colors.textColorBlack)),
                    TextSpan(
                        text: "Next",
                        style: getBoldStyle(
                            fontSize: 12.5, color: Colors.textColorBlack)),
                    TextSpan(
                        text: ", you agree to the",
                        style: getNormalStyle(
                            fontSize: 12.5, color: Colors.textColorBlack)),
                    TextSpan(
                        text: " Terms and Conditions",
                        style: getBoldStyle(
                            fontSize: 12.5, color: Colors.textColorBlack))
                  ])),
                  svgPath: "res/drawables/ic_savings_warning.svg"),
              decoration: BoxDecoration(
                  color: Color(0xff244528).withOpacity(0.05),
                  borderRadius: BorderRadius.all(Radius.circular(8))),
            ),
            SizedBox(height: 50),
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
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (ctx) => LoansApplicationConfirmationView()),
                  );
                },
                text: 'Next'),
            SizedBox(height: 38 + 31.5),
          ],
        ),
      ),
    );
  }
}