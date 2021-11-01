import 'package:flutter_svg/flutter_svg.dart';
import 'package:moniepoint_flutter/app/accountupdates/views/forms/account_update_form_view.dart';
import 'package:moniepoint_flutter/app/loans/models/available_short_term_loan_offer.dart';
import 'package:moniepoint_flutter/app/loans/models/short_term_loan_offer.dart';
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

final dummyAvailableOffer = {
  "offerName": "Short Term Loan Available Offer",
  "offerReference": "2D3E2D701D2A45D597753D6490A768A4",
  "maximumAmount": 50000,
  "minInterestRate": 2,
  "maxPeriod": 30,
  "penaltyString": "Sample Penalty String",
  "termsAndConditions": "www.teamapt.com/terms-and-conditions"
};


final dummyAvailableOffer2 = {
  "offerName": "Short Term Loan Available Offer 2",
  "offerReference": "2D3E2D701D2A45D597753D6490A768A5",
  "maximumAmount": 40000,
  "minInterestRate": 2.5,
  "maxPeriod": 10,
  "penaltyString": "Sample Penalty String 2",
  "termsAndConditions": "www.teamapt.com/terms-and-conditions"
};

Container _buildCard({required Widget child}) {
  return Container(
    padding: EdgeInsets.fromLTRB(16, 13, 16, 15),
    margin: EdgeInsets.symmetric(horizontal: 18),
    child: child,
    decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.all(Radius.circular(8)),
        border: Border.all(
            width: 0.7, color: Colors.loanCardShadowColor.withOpacity(0.15)),
        boxShadow: [
          BoxShadow(
              offset: Offset(0, 1),
              blurRadius: 1,
              color: Colors.loanCardShadowColor.withOpacity(0.1))
        ]),
  );
}

Widget _getDivider({double? topMargin, double? bottomMargin}) => Padding(
      padding: EdgeInsets.only(top: topMargin ?? 3, bottom: bottomMargin ?? 11),
      child: Divider(
        thickness: 1,
        color: Color(0xffF2EDE6),
      ),
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

class LoanOffersView extends PagedForm {
  @override
  _LoanOffersState createState() => _LoanOffersState();

  @override
  String getTitle() => "LoanOffers";
}

class _LoanOffersState extends State<LoanOffersView> {
  late final LoanRequestViewModel _viewModel;

  @override
  void initState() {
    _viewModel = Provider.of<LoanRequestViewModel>(context, listen: false);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final availableShortLoanOffer =
        AvailableShortTermLoanOffer.fromJson(dummyAvailableOffer);

    final availableShortLoanOffer2 =
    AvailableShortTermLoanOffer.fromJson(dummyAvailableOffer2);

    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 18),
            child: Text(
              "Loan Offers",
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.w700),
            ),
          ),
          SizedBox(height: 33),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 18),
            child: Text(
              "Available Offers for you",
              style: getBoldStyle(fontSize: 15.5),
            ),
          ),
          SizedBox(height: 14),
          _AvailableShortTermLoanOfferCard(
            viewModel: _viewModel,
            currentPagePosition: widget.position,
            loanOffer: availableShortLoanOffer,
          ),
          SizedBox(height: 9),
          _AvailableShortTermLoanOfferCard(
            viewModel: _viewModel,
            currentPagePosition: widget.position,
            loanOffer: availableShortLoanOffer2,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 1),
            child: _getDivider(topMargin: 31, bottomMargin: 25),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 18),
            child: Text(
              "Future offers",
              style: getBoldStyle(fontSize: 15.5),
            ),
          ),
          SizedBox(height: 13),
          _FutureOfferLoanCard(
              viewModel: _viewModel, currentPagePosition: widget.position),
          SizedBox(height: 100),
        ],
      ),
    );
  }
}

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
    _viewModel.setAmount(this._amount);
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
              _viewModel.setAmount(_amount);
              _viewModel.calculateInterestRate(_amount);
            },
            maxAmount: _viewModel.selectedLoanOffer.maximumAmount?.toDouble(),
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
                  "N ${_viewModel.selectedLoanOffer.maximumAmount?.toDouble()}",
                  style: getNormalStyle(color: Color(0xffA9A5AF), fontSize: 12))
            ],
          )
        ],
      ),
    );
  }

  @override
  void initState() {
    _viewModel = Provider.of<LoanRequestViewModel>(context, listen: false);
    refreshAccounts();
    super.initState();
  }

  void refreshAccounts() {
    if (_viewModel.userAccounts.length > 1)
      _viewModel.getUserAccountsBalance().listen((event) {});
    else
      _viewModel.getCustomerAccountBalance().listen((event) {});
  }



  @override
  Widget build(BuildContext context) {
    print("selected loan offer in view ${_viewModel.selectedLoanOffer.toJson()}");
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
            amountWidget(),
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
                      Text("${_viewModel.selectedLoanOffer.minInterestRate}%",
                          style: getBoldStyle(fontSize: 13.5))
                    ],
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("Tenor", style: getNormalStyle(fontSize: 12.5)),
                      SizedBox(height: 5),
                      Text("${_viewModel.selectedLoanOffer.maxPeriod} days",
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
                          stream: _viewModel.interestStream,
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

class _LoanOfferBottomDetails extends StatelessWidget {
  const _LoanOfferBottomDetails({
    Key? key,
    this.buttonText,
    this.onButtonTap,
    required this.interestRate,
    required this.tenor,
  }) : super(key: key);

  final double? interestRate;
  final int? tenor;
  final String? buttonText;
  final VoidCallback? onButtonTap;

  Widget _textButton({required String text, required VoidCallback onClick}) {
    return TextButton(
      child:
          Text(text, style: getBoldStyle(color: Colors.white, fontSize: 12.5)),
      style: TextButton.styleFrom(
          backgroundColor: Colors.solidOrange,
          padding: EdgeInsets.symmetric(horizontal: 18, vertical: 12)),
      onPressed: () {
        onClick();
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Row(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("Interest", style: getNormalStyle(fontSize: 12.5)),
                  SizedBox(height: 5),
                  Text("$interestRate%", style: getBoldStyle(fontSize: 13.5))
                ],
              ),
              SizedBox(width: 32),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("Tenor", style: getNormalStyle(fontSize: 12.5)),
                  SizedBox(height: 5),
                  Text("$tenor days", style: getBoldStyle(fontSize: 13.5))
                ],
              ),
            ],
          ),
        ),
        SizedBox(width: 31),
        if (buttonText != null && onButtonTap != null)
          _textButton(
              text: buttonText!,
              onClick: () {
                onButtonTap!();
              })
      ],
    );
  }
}

class _FutureOfferLoanCard extends StatelessWidget {
  const _FutureOfferLoanCard({
    Key? key,
    required this.viewModel,
    required this.currentPagePosition,
  }) : super(key: key);

  final LoanRequestViewModel viewModel;
  final int currentPagePosition;

  @override
  Widget build(BuildContext context) {
    return _buildCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              SvgPicture.asset(
                "res/drawables/ic_border_line.svg",
                color: Color(0xff656CCF2),
              ),
              SizedBox(width: 14),
              Text(
                "Boss Loan",
                style: getBoldStyle(fontSize: 14.5),
              )
            ],
          ),
          _getDivider(),
          Text("Max Amount Eligible", style: getNormalStyle(fontSize: 12.5)),
          SizedBox(height: 4),
          Text("N 50,000.00", style: getBoldStyle(fontSize: 17)),
          SizedBox(height: 17),
          _LoanOfferBottomDetails(
            tenor: 14,
            interestRate: 7.51,
          ),
          SizedBox(height: 17),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 14, vertical: 17),
            child: InfoBannerContent(
                title: "Eligibility",
                subtitle:
                    "Take more than two starter loans to be eligible for this loan",
                svgPath: "res/drawables/ic_savings_warning.svg"),
            decoration: BoxDecoration(
                color: Color(0xff244528).withOpacity(0.05),
                borderRadius: BorderRadius.all(Radius.circular(8))),
          ),
        ],
      ),
    );
  }
}

class _AvailableShortTermLoanOfferCard extends StatelessWidget {
  const _AvailableShortTermLoanOfferCard({
    Key? key,
    required this.viewModel,
    required this.currentPagePosition,
    required this.loanOffer,
  }) : super(key: key);

  final LoanRequestViewModel viewModel;
  final int currentPagePosition;
  final AvailableShortTermLoanOffer loanOffer;

  @override
  Widget build(BuildContext context) {
    return _buildCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              SvgPicture.asset("res/drawables/ic_border_line.svg"),
              SizedBox(width: 14),
              Text(
                loanOffer.offerName ?? "",
                style: getBoldStyle(fontSize: 14.5),
              )
            ],
          ),
          _getDivider(),
          Text("Max Amount Eligible", style: getNormalStyle(fontSize: 12.5)),
          SizedBox(height: 4),
          Text("${loanOffer.maximumAmount?.formatCurrency}",
              style: getBoldStyle(fontSize: 17)),
          SizedBox(height: 17),
          _LoanOfferBottomDetails(
            buttonText: "Apply for offer",
            onButtonTap: () {
              viewModel.setSelectedLoanOffer(loanOffer);
              viewModel.moveToNext(currentPagePosition);
            },
            tenor: loanOffer.maxPeriod,
            interestRate: loanOffer.minInterestRate,
          )
        ],
      ),
    );
  }
}
